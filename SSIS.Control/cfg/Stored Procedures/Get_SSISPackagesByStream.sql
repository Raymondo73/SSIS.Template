CREATE PROCEDURE [cfg].[Get_SSISPackagesByStream]
	@ApplicationName	VARCHAR (255)
,	@ExecutionType		INT
,	@ExecutionBatch		INT
,	@ExecutionStream	INT
AS

BEGIN TRY
	SET NOCOUNT ON;
	
	SELECT	p.PackageName AS PackagePath
	,		p.PackageName
	,		CONVERT(CHAR(1), CASE WHEN @ExecutionType = 1 THEN ExecType1 ELSE ExecType2 END) AS ExecutionType
	,		p.SourceTable
	,		p.LandingTable
	,		p.DestinationTable
	,		p.SelectProcedure
	,		p.MergeProcedure
	FROM	cfg.ProjectPackages		ap
	JOIN	cfg.Packages			p	ON p.PackageID			= ap.PackageID
	JOIN	cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	JOIN	cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE	ApplicationName					= @ApplicationName
	AND		ap.ExecutionOrder				= @ExecutionBatch
	AND		ap.ExecutionStream				= @ExecutionStream
	AND		ISNULL(ap.[Disabled], 'False')	!= 'True';

	-- [cfg].[GetSSISPackagesByStream] 'J2DW', 2, 100, 1

END TRY

BEGIN CATCH
	THROW;
END CATCH