CREATE PROCEDURE [audit].[Log_StartOfApplication]
	@ApplicationName VARCHAR (255)
AS

DECLARE		@ErrMsg VARCHAR(255)
,			@AppID	INT;

BEGIN TRY

	SET NOCOUNT ON;

	SET @AppID =	(	
					SELECT	ApplicationID
					FROM	cfg.Applications
					WHERE	ApplicationName = @ApplicationName
					);

	IF (@AppID IS NULL)
	BEGIN
		SET @ErrMsg = 'Cannot find ApplicationName ' + COALESCE(@ApplicationName, '<NULL>');
		RAISERROR(@ErrMsg, 16, 1);
		RETURN	-1;
	END

	INSERT INTO	[audit].SSISAppInstance
				(	ApplicationID
				,	StartDateTime
				,	[Status]
				)
	OUTPUT		inserted.AppInstanceID
	VALUES		(	@AppID
				,	GETUTCDATE()
				,	'Running'
				);

END TRY

BEGIN CATCH
	THROW;
END CATCH