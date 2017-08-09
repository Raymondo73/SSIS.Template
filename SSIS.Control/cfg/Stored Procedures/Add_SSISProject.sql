CREATE PROCEDURE [cfg].[Add_SSISProject]
	@ProjectName	VARCHAR (255)
,	@ProjectID		INT				OUTPUT

AS

SET NOCOUNT ON

BEGIN TRY
	DECLARE @tbl TABLE (ProjectID INT);
  
	IF NOT EXISTS	(	SELECT	ProjectName
						FROM	cfg.Projects
						WHERE	ProjectName = @ProjectName
					)
	BEGIN
		INSERT INTO cfg.Projects
					(ProjectName)
		OUTPUT		inserted.ProjectID 
		INTO		@tbl
		VALUES		(@ProjectName);
	END
	
	ELSE
	BEGIN
		INSERT INTO @tbl
					(ProjectID)
		SELECT		ProjectID
		FROM		cfg.Projects
		WHERE		ProjectName = @ProjectName;
	END

	SELECT @ProjectID = ProjectID FROM @tbl;
END TRY

BEGIN CATCH
	THROW;
END CATCH