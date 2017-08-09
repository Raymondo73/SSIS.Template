CREATE PROCEDURE [cfg].[Add_SSISApplicationProject]
	@ApplicationID	INT
,	@ProjectID		INT
,	@ExecutionOrder INT = 10

AS

SET NOCOUNT ON;

BEGIN TRY

	IF NOT EXISTS	(	SELECT	ApplicationID
						,		ProjectId
						FROM	cfg.ApplicationProjects
						WHERE	ApplicationId	= @ApplicationId
						AND		ProjectId		= @ProjectID
					)
		INSERT INTO	cfg.ApplicationProjects
					(	ApplicationID
					,	ProjectId
					,	ExecutionOrder
					)
		VALUES		(	@ApplicationID
					,	@ProjectID
					,	@ExecutionOrder
					);
END TRY

BEGIN CATCH
	THROW;
END CATCH