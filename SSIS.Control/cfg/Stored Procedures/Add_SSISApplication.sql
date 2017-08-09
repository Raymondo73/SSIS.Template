CREATE PROCEDURE [cfg].[Add_SSISApplication]
	@ApplicationName	VARCHAR (255)
,	@AppID				INT				OUTPUT
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @tbl TABLE (AppID INT);
  
	IF NOT EXISTS	(	SELECT	ApplicationName
					FROM	cfg.Applications
					WHERE	ApplicationName = @ApplicationName
				)
	BEGIN
		INSERT INTO cfg.Applications
					(ApplicationName)
		OUTPUT		inserted.ApplicationID 
		INTO		@tbl
		VALUES		(@ApplicationName);
	END
	
	ELSE
	BEGIN
		INSERT INTO @tbl
					(AppID)
		SELECT		ApplicationID
		FROM		cfg.Applications
		WHERE		ApplicationName = @ApplicationName;
	END

	SELECT	@AppID = AppID 
	FROM	@tbl;
END TRY

BEGIN CATCH
	THROW;
END CATCH