CREATE PROCEDURE [cfg].[Get_SSISNoOfStreamsForBatch] 
	@ApplicationName	VARCHAR (255)
,	@ExecutionBatch		INT
AS
BEGIN TRY

	SET NOCOUNT ON;

	SELECT	MAX(ISNULL(ExecutionStream, 1))		AS NoOfStreamsForBatch
	FROM	cfg.ProjectPackages		ap
	JOIN	cfg.Packages			p	ON p.PackageID			= ap.PackageID
	JOIN	cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	JOIN	cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE	ApplicationName					= @ApplicationName
	AND		ap.ExecutionOrder				= @ExecutionBatch
	AND		ISNULL(ap.[Disabled],'False')	!= 'True';

END TRY

BEGIN CATCH
	THROW;
END CATCH