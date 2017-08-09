CREATE PROCEDURE [audit].[Log_StartOfPackage]
	@AppInstanceID	INT
,	@PackagePath	VARCHAR (255)
AS

DECLARE @ErrMsg		VARCHAR(255)
,		@PkgID		INT;

BEGIN TRY
	SET NOCOUNT ON;

	SET @PkgID =	(	
					SELECT	MAX(PackageID)
					FROM	cfg.Packages
					WHERE	PackageName = @PackagePath
					);

	IF @PkgID IS NULL
	BEGIN
		SET @ErrMsg = 'Cannot find PackagePath ' + COALESCE(@PackagePath, '');
		RAISERROR(@ErrMsg, 16, 1);
		RETURN -1;
	END

	INSERT INTO [audit].SSISPkgInstance
				(	AppInstanceID
				,	PackageID
				,	StartDateTime
				,	[Status]
				)
	OUTPUT		inserted.PkgInstanceID
	VALUES		(	@AppInstanceID
				,	@PkgID
				,	GETDATE()
				,	'Running'
				);
END TRY

BEGIN CATCH
	THROW;
END CATCH