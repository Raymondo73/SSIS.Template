CREATE PROCEDURE [cfg].[Get_ChangeTrackingID]
/******************************************************
	Author:			Raymond F. Betts
	Date:			03 August 2017
	Description:	Select From
						etl.TableChangeTracking	
						etl.Packages					
******************************************************/
	@PackageName VARCHAR(200)

AS

BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ChangeTrackingID INT;

	SELECT	@ChangeTrackingID = c.ChangeTrackingID
	FROM	cfg.TableChangeTracking	c 
	JOIN	cfg.Packages			p ON c.PackageId = p.PackageID  
	WHERE	p.PackageName = @PackageName;

	SELECT ISNULL(@ChangeTrackingID, -1) AS ChangeTrackingID;

END TRY

BEGIN CATCH
	THROW;
END CATCH
