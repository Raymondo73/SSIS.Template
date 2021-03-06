﻿CREATE PROC [audit].[Get_ExecutionErrors] 
	@AppInstanceId INT 

AS
BEGIN TRY
	SET NOCOUNT ON;
	
	SELECT		pk.PackageName
	,			ev.* 
	FROM		[audit].SSISErrors		ev
	JOIN		[audit].SSISPkgInstance	pi ON ev.PkgInstanceID	= pi.PkgInstanceID
	JOIN		cfg.packages			pk ON pk.PackageID		= pi.PackageID
	WHERE		ev.AppInstanceID = @AppInstanceId
	ORDER BY	ev.ErrorDateTime;

END TRY

BEGIN CATCH
	THROW;
END CATCH