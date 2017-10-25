/*
Below sets up core SSIS config details.  Repeat for each Application / Project

*/

DECLARE @PrjName			VARCHAR(200)	
,		@ProjectId			INT				= 0
,		@PackageId			INT				= 0
,		@ExecutionOrder		INT				= 0
,		@RowCount			SMALLINT		= 1
,		@PackageName		VARCHAR(200)
,		@SourceTable		VARCHAR(200)
,		@LandingTable		VARCHAR(200)
,		@DestinationTable	VARCHAR(200)
,		@SelectProc			VARCHAR(200)
,		@MergeProc			VARCHAR(200)
,		@Schema				VARCHAR(200)
,		@Table				VARCHAR(200)
,		@TableID			INT
,		@MaxRows			INT				= 10000
,		@BufferSize			INT				= 10485760;

-- JNT Landing ////////////////////////////////////////////////////

/*
Helper for add_SSISPackage
	@PackageName		VARCHAR (255)
,	@SourceTable		VARCHAR (255)
,	@LandingTable		VARCHAR (255)
,	@DestinationTable	VARCHAR (255)
,	@SelectProcedure	VARCHAR (255)
,	@MergeProcedure		VARCHAR (255)
*/

SET @PrjName = 'JNT Landing';

SELECT	@ProjectId = ProjectId
FROM	cfg.Projects
WHERE	ProjectName = @PrjName;

-- add child packages with execution order and streams
SELECT	TOP 1	@Schema		= SchemaName
,				@Table		= TableName
,				@TableID	= TableId
FROM			cfg.SourceTables
WHERE			ProjectID = @ProjectId
ORDER BY		TableId;


WHILE @RowCount != 0
BEGIN

	SELECT	@PackageName		= @Schema + '.' + @Table + '.dtsx'
	,		@SourceTable		= @Schema + '.' + @Table
	,		@LandingTable		= 'work.' + @Table
	,		@DestinationTable	= 'Landing.' + @Table
	,		@SelectProc			= 'ssis.Select_' + @Schema + '_' + @Table + '_ByCTID'		-- NB schema and proc needs to exist on source db or create sql in data flow source i.e. change this
	,		@MergeProc			= 'work.Merge_' + @Schema + '_' + @Table;

	/*
	TODO
	Work out a way to:
		Streams on ProjectPackage
		Buffer and MaxRows on Project
	*/

	SET @ExecutionOrder += 10;
	EXEC @PackageId = cfg.Add_SSISPackage @PackageName, @SourceTable, @LandingTable, @DestinationTable, @SelectProc, @MergeProc, @MaxRows, @BufferSize;	
	EXEC cfg.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 1;		-- NB adjust streams post load when parallel v serial is known

	SELECT	TOP 1	@Schema		= SchemaName
	,				@Table		= TableName
	,				@TableID	= TableId
	FROM			cfg.SourceTables
	WHERE			ProjectID	= @ProjectId
	AND				TableId		> @TableID
	ORDER BY		TableId;

	SET @RowCount = @@ROWCOUNT;

END

-- reset
SELECT	@RowCount	= 1
,		@ProjectId	= 0
,		@PrjName	= '';
-- /// JNT Landing End ////////////////////////////////////////////////////////////////////////////////