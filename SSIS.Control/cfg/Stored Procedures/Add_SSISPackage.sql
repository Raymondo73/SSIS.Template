CREATE PROCEDURE [cfg].[Add_SSISPackage]
	@PackageName		VARCHAR (255)
,	@SourceTable		VARCHAR (255)
,	@LandingTable		VARCHAR (255)
,	@DestinationTable	VARCHAR (255)
,	@SelectProcedure	VARCHAR (255)
,	@MergeProcedure		VARCHAR (255)

AS

BEGIN TRY
	DECLARE @PkgID INT; 

	SET NOCOUNT ON;
   
	-- Insert
	WITH Package AS
	(
		SELECT	@PackageName		AS PackageName
		,		@SourceTable		AS SourceTable
		,		@LandingTable		AS LandingTable
		,		@DestinationTable	AS DestinationTable
		,		@SelectProcedure	AS SelectProcedure
		,		@MergeProcedure		AS MergeProcedure
	)
	INSERT INTO	cfg.Packages
					(	PackageName
					,	SourceTable
					,	LandingTable
					,	DestinationTable
					,	SelectProcedure
					,	MergeProcedure
					)
	SELECT		p1.PackageName
	,			p1.SourceTable
	,			p1.LandingTable
	,			p1.DestinationTable
	,			p1.SelectProcedure
	,			p1.MergeProcedure
	FROM		Package			p1
	LEFT JOIN	cfg.Packages	p2	ON p1.PackageName = p2.PackageName
	WHERE		p2.PackageID IS NULL;


	-- Update
	WITH Package AS
	(
		SELECT	@PackageName		AS PackageName
		,		@SourceTable		AS SourceTable
		,		@LandingTable		AS LandingTable
		,		@DestinationTable	AS DestinationTable
		,		@SelectProcedure	AS SelectProcedure
		,		@MergeProcedure		AS MergeProcedure
	)
	UPDATE	p1
	SET		PackageName			= p2.PackageName
	,		SourceTable			= p2.SourceTable
	,		LandingTable		= p2.LandingTable
	,		DestinationTable	= p2.DestinationTable
	,		SelectProcedure		= p2.SelectProcedure
	,		MergeProcedure		= p2.MergeProcedure
	FROM	cfg.Packages	p1
	JOIN	Package			p2	ON p1.PackageName = p2.PackageName;

	-- Return
	SELECT		@PkgId = PackageID
	FROM		cfg.Packages
	WHERE		PackageName		= @PackageName;
	
	RETURN @PkgId;

END TRY

BEGIN CATCH
	THROW;
END CATCH