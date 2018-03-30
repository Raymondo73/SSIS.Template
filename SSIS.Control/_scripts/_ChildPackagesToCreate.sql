/*
Below sets up core SSIS config details.  Repeat for each Application / Project

*/

DECLARE @PrjName			VARCHAR(200)	
,		@ProjectId			INT				= 0
,		@PackageId			INT				= 0
,		@ExecutionOrder		INT				= 0
,		@RowCount			SMALLINT		= 1
,		@PackageName		VARCHAR(255)
,		@SourceTable		VARCHAR(255)
,		@LandingTable		VARCHAR(255)
,		@DestinationTable	VARCHAR(255)
,		@SelectProc			VARCHAR(MAX)
,		@ChangeTrkProc		VARCHAR(255)
,		@MergeProc			VARCHAR(255)
,		@Schema				VARCHAR(200)
,		@Table				VARCHAR(200)
,		@TableID			INT
,		@MaxRows			INT				= 100000		-- 100k rows
,		@BufferSize			INT				= 60485760		-- 60MB
,		@BatchSize			INT				= 10000
,		@MaxInsertCommit	INT				= 0
,		@ProjectCount		INT				= 1;


/*
Helper for add_SSISPackage
	@PackageName		VARCHAR (255)
,	@SourceTable		VARCHAR (255)
,	@LandingTable		VARCHAR (255)
,	@DestinationTable	VARCHAR (255)
,	@SelectProcedure	VARCHAR (255)
,	@MergeProcedure		VARCHAR (255)
*/

SELECT TOP 1	@ProjectId = ProjectId
FROM			cfg.Projects
ORDER BY		ProjectId;


WHILE @ProjectCount != 0
BEGIN

	-- add child packages with execution order and streams
	SELECT	TOP 1	@Schema		= SchemaName
	,				@Table		= TableName
	,				@TableID	= TableId
	FROM			cfg.SourceTables
	WHERE			ProjectID = @ProjectId
	ORDER BY		TableId;

	WHILE @RowCount != 0
	BEGIN

		SELECT	@PackageName		= @Schema + '_' + @Table + '.dtsx'
		,		@SourceTable		= @Schema + '.' + @Table
		,		@LandingTable		= 'work.' + @Table
		,		@DestinationTable	= 'Landing.' + @Table
		,		@SelectProc			= 'ssis.Select_' + @Schema + @Table + '_ByCTID'		-- NB schema and proc needs to exist on source db or create sql in data flow source i.e. change this
		,		@MergeProc			= 'work.Merge' + '_' + @Table
		,		@ChangeTrkProc		= 'ssis.Select_' + @Schema + @Table + '_ChangeTrackingPKRange';

		/*
		TODO
		Work "Maybe" out a way to:
			Streams on ProjectPackage
			Buffer and MaxRows on Project
		*/
		SET @ExecutionOrder += 10;
		EXEC @PackageId = cfg.Add_SSISPackage		@PackageName
												,	@SourceTable
												,	@LandingTable
												,	@DestinationTable
												,	@SelectProc
												,	@MergeProc
												,	@ChangeTrkProc
												,	@MaxRows
												,	@BufferSize
												,	@BatchSize
												,	@MaxInsertCommit;	

		EXEC cfg.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 1;		-- NB adjust streams post load when parallel v serial is known

		SELECT	TOP 1	@Schema		= SchemaName
		,				@Table		= TableName
		,				@TableID	= TableId
		FROM			cfg.SourceTables
		WHERE			ProjectID	= @ProjectId
		AND				TableId		> @TableID
		ORDER BY		TableId;

		SET @RowCount = @@ROWCOUNT;

	END -- end setting up a package (loop)

	-- reset
	SELECT	@RowCount		= 1
	,		@PrjName		= ''
	,		@ProjectCount	= 1;

	SELECT	TOP 1	@ProjectId = ProjectId
	FROM			cfg.Projects
	WHERE			ProjectId > @ProjectId
	ORDER BY		ProjectId;

	SET @ProjectCount = @@ROWCOUNT;
END -- end setting up a project (loop)