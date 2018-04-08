CREATE PROCEDURE [audit].[Log_Event]
	@AppInstanceID		INT
,	@PkgInstanceID		INT
,	@SourceName			VARCHAR (255)
,	@EventDescription	VARCHAR (MAX)
AS

BEGIN TRY
	SET NOCOUNT ON;

	INSERT INTO	[audit].SSISEvents
				(	AppInstanceID
				,	PkgInstanceID
				,	SourceName
				,	EventDescription
				,	EventDateTime
				)
	VALUES		(	@AppInstanceID 
				,	@PkgInstanceID 
				,	@SourceName 
				,	@EventDescription
				,	GETUTCDATE()
				);
END TRY

BEGIN CATCH
	THROW;
END CATCH