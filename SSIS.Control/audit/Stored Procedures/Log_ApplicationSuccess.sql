﻿CREATE PROCEDURE [audit].[Log_ApplicationSuccess]
	@AppInstanceID INT

AS

BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[audit].SSISAppInstance
	SET		EndDateTime		= GETUTCDATE()
	,		[Status]		= 'Success'
	WHERE	AppInstanceID	= @AppInstanceID;

END TRY

BEGIN CATCH
	THROW;
END CATCH