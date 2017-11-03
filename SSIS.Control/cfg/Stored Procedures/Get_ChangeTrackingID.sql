CREATE PROCEDURE [cfg].[Get_ChangeTrackingID]
/******************************************************
	Author:			Raymond F. Betts
	Date:			03 August 2017
	Description:	Select From
						cfg.Packages					
******************************************************/
	@PackageName VARCHAR(200)

AS

BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ChangeTrackingID INT;

	SELECT	@ChangeTrackingID = LastChangeTrackingID
	FROM	cfg.Packages		
	WHERE	PackageName = @PackageName;

	SELECT ISNULL(@ChangeTrackingID, -1) AS ChangeTrackingID;

END TRY

BEGIN CATCH
	THROW;
END CATCH
