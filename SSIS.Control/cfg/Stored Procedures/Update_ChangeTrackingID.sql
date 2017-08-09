CREATE PROCEDURE [cfg].[Update_ChangeTrackingID]
/******************************************************
	Author:			Raymond F. Betts
	Date:			03 August 2017
	Description:	Select From
						cfg.TableChangeTracking	
						cfg.Packages					
******************************************************/
	@PackageName		VARCHAR(200)
,	@ChangeTrackingID	INT

AS

BEGIN TRY
	SET NOCOUNT ON;

	WITH Package AS
	(
		SELECT	PackageID
		FROM	cfg.Packages
		WHERE	PackageName = @PackageName
	)
	UPDATE	c
	SET		ChangeTrackingID	= @ChangeTrackingID
	,		LastUpdated			= GETUTCDATE()
	FROM	cfg.TableChangeTracking c
	JOIN	Package					p ON p.PackageID = c.PackageId;

END TRY

BEGIN CATCH
	THROW;
END CATCH