CREATE PROCEDURE [cfg].[Get_SSISApplicationBatches] 
/******************************************************
	Author:			Raymond F. Betts
	Date:			03 August 2017
	Description:	Select From
						etl.ProjectPackages		
						etl.Packages			
						etl.ApplicationProjects 
						etl.Applications		
******************************************************/	
@ApplicationName VARCHAR (255)

AS

BEGIN TRY
	SET NOCOUNT ON;

	SELECT DISTINCT ap.ExecutionOrder		As ExecutionBatch
	FROM			cfg.ProjectPackages		ap
	JOIN			cfg.Packages			p	ON p.PackageID			= ap.PackageID
	JOIN			cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	JOIN			cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE			ApplicationName					= @ApplicationName
	AND				ISNULL(ap.[Disabled], 'False')	!= 'True'
	ORDER BY		ap.ExecutionOrder;

END TRY

BEGIN CATCH
	THROW;
END CATCH