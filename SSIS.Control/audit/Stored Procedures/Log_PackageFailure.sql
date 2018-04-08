CREATE PROCEDURE [audit].[Log_PackageFailure]
@PkgInstanceID INT

AS

BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[audit].SSISPkgInstance
	SET		EndDateTime		= GETUTCDATE()
	,		[Status]		= 'Failed'
	WHERE	PkgInstanceID	= @PkgInstanceID;

 END TRY

BEGIN CATCH
	THROW;
END CATCH