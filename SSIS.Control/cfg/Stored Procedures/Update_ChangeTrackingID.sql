CREATE PROCEDURE [cfg].[Update_ChangeTrackingID]
/******************************************************
	Author:			Raymond F. Betts
	Date:			03 August 2017
	Description:	Update change tracking ID and date of change					
******************************************************/
	@PackageName		VARCHAR(200)
,	@ChangeTrackingID	INT

AS

BEGIN TRY
	SET NOCOUNT ON;

	UPDATE	c
	SET		LastChangeTrackingID	= @ChangeTrackingID
	,		LastChangeTrackUpdated	= GETUTCDATE()
	FROM	cfg.Packages	c;

END TRY

BEGIN CATCH
	THROW;
END CATCH