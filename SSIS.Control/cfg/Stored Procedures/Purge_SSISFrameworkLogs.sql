CREATE PROCEDURE [cfg].[Purge_SSISFrameworkLogs]
(
	@DaysToKeep INT = 30
,	@BlockSize	INT = 500000
)
AS
BEGIN 

	SET XACT_ABORT ON;
	SET NOCOUNT ON; 

	DECLARE @RowsAffected	INT = 1
	,		@CutOff			DATETIME;

	SELECT @CutOff = DATEADD(DD, -@DaysToKeep, GETDATE());

	WHILE @RowsAffected > 0 
	BEGIN 

		BEGIN TRAN; 

		SELECT @RowsAffected = 0;

		DELETE	TOP(@BlockSize) 
		FROM	[audit].[SSISEvents]
		WHERE	[EventDateTime] < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[audit].[SSISErrors]
		WHERE	[ErrorDateTime] < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[audit].[SSISLookupFailures]
		WHERE	[DateOccured]  < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[audit].[SSISPkgInstance]
		WHERE	EndDateTime < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[audit].[SSISAppInstance]
		WHERE	EndDateTime < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		COMMIT TRAN;

	END

END