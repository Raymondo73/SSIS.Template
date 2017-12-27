CREATE PROC [audit].[Get_ExecutionEventsByPackage] 
	@AppInstanceId	INT
,	@PackageID		INT 

AS
BEGIN TRY
	SET NOCOUNT ON;
	
	SELECT		pk.PackageName
	,			ev.* 
	FROM		[audit].SSISEvents		ev
	JOIN		[audit].SSISPkgInstance	pi ON ev.PkgInstanceID	= pi.PkgInstanceID
	JOIN		cfg.packages			pk ON pk.PackageID		= pi.PackageID
	WHERE		ev.AppInstanceID	= @AppInstanceId
	AND			pk.PackageID		= @PackageID
	ORDER BY	ev.EventDateTime;

END TRY

BEGIN CATCH
	THROW;
END CATCH