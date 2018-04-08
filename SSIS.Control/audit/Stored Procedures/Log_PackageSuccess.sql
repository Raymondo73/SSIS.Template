CREATE PROCEDURE [audit].[Log_PackageSuccess]
@PkgInstanceID INT
AS

BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[audit].SSISPkgInstance
	SET		EndDateTime		= GETUTCDATE()
	,		[Status]		= 'Success'
	WHERE	PkgInstanceID	= @PkgInstanceID;

END TRY

BEGIN CATCH
	THROW;
END CATCH