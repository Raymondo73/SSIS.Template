CREATE PROCEDURE [audit].[Log_Error]
	@AppInstanceID		INT
,	@PkgInstanceID		INT
,	@SourceName			VARCHAR(255)
,	@ErrorDescription	VARCHAR(MAX)
AS

BEGIN TRY
	SET NOCOUNT ON;

	INSERT INTO [audit].SSISErrors
				(	AppInstanceID
				,	PkgInstanceID
				,	SourceName
				,	ErrorDescription
				,	ErrorDatetime
				)
	VALUES		(	@AppInstanceID 
				,	@PkgInstanceID 
				,	@SourceName 
				,	@ErrorDescription
				,	GETUTCDATE()
				);
END TRY

BEGIN CATCH
	THROW;
END CATCH