CREATE PROCEDURE [cfg].[Get_SSISApplication]
	@ApplicationName	VARCHAR (255)
,	@ExecutionType		INT

AS

BEGIN TRY
	SET NOCOUNT ON;

	SELECT		p.PackageName As PackagePath
	,			ap.ExecutionOrder
	,			p.PackageName
	,			CONVERT(CHAR(1), CASE WHEN @ExecutionType = 1 THEN ExecType1 ELSE ExecType2 END) AS ExecutionType
	FROM		cfg.ProjectPackages		ap
	Join		cfg.Packages			p	ON p.PackageID			= ap.PackageID
	Join		cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	Join		cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE		ApplicationName					= @ApplicationName
	AND			ISNULL(ap.[Disabled], 'False')	!= 'True'
	ORDER BY	a.ExecutionOrder
	,			ap.ExecutionOrder;

END TRY

BEGIN CATCH
	THROW;
END CATCH