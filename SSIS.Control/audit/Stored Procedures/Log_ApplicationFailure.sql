﻿CREATE PROCEDURE [audit].[Log_ApplicationFailure]
	@AppInstanceID INT
AS
BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[audit].SSISAppInstance
	SET		EndDateTime		= GETDATE()
	,		[STATUS]		= 'Failed'
	WHERE	AppInstanceID	= @AppInstanceID;
END TRY

BEGIN CATCH
	THROW;
END CATCH