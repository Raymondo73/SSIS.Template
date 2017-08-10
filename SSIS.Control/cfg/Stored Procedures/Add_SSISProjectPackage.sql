CREATE PROCEDURE [cfg].[Add_SSISProjectPackage]
	@ProjectID			INT
,	@PackageID			INT
,	@ExecutionOrder		INT		= 10
,	@ExecutionType1		CHAR(1) = 'I'
,	@ExecutionType2		CHAR(1) = 'I'
,	@ExecutionStream	INT		= 1
,	@Disabled			BIT		= 0
AS

BEGIN TRY
	SET NOCOUNT ON;

		MERGE	cfg.ProjectPackages	Dest
	USING	(	SELECT	@ProjectID			AS ProjectID
				,		@PackageID			AS PackageID
				,		@ExecutionOrder		AS ExecutionOrder
				,		@ExecutionType1		AS ExecutionType1
				,		@ExecutionType2		AS ExecutionType2
				,		@ExecutionStream	AS ExecutionStream
				,		@Disabled			AS [Disabled]
			) Source	ON	Dest.ProjectID = Source.ProjectID
						AND	Dest.PackageID = Source.PackageID
	WHEN NOT MATCHED THEN
	INSERT	(	ProjectID
			,	PackageID
			,	ExecutionOrder
			,	ExecType1
			,	ExecType2
			,	ExecutionStream
			,	[Disabled]
			)
	VALUES	(
				Source.ProjectID
			,	Source.PackageID
			,	Source.ExecutionOrder
			,	Source.ExecutionType1
			,	Source.ExecutionType2
			,	Source.ExecutionStream
			,	Source.[Disabled]
			)
	WHEN MATCHED THEN
	UPDATE
	SET		ExecutionOrder		= Source.ExecutionOrder
	,		ExecType1			= Source.ExecutionType1
	,		ExecType2			= Source.ExecutionType2
	,		ExecutionStream		= Source.ExecutionStream
	,		[Disabled]			= Source.[Disabled];
END TRY

BEGIN CATCH
	THROW;
END CATCH