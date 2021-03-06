﻿CREATE PROCEDURE [cfg].[Add_SSISPackage]
	@PackageName				VARCHAR (255)
,	@SourceTable				VARCHAR (MAX)
,	@LandingTable				VARCHAR (255)
,	@DestinationTable			VARCHAR (255)
,	@SelectProcedure			VARCHAR (MAX)
,	@MergeProcedure				VARCHAR (255)
,	@ChangeTrackingProcedure	VARCHAR (255)
,	@MaxRows					INT				= 10000
,	@BufferSize					INT				= 10485760
,	@BatchSize					INT				= 10000
,	@MaxInsertCommitSize		INT				= 0

AS

BEGIN TRY
	DECLARE @PkgID INT; 

	SET NOCOUNT ON;
   
	-- Insert
	WITH Package AS
	(
		SELECT	@PackageName				AS PackageName
		,		@SourceTable				AS SourceTable
		,		@LandingTable				AS LandingTable
		,		@DestinationTable			AS DestinationTable
		,		@SelectProcedure			AS SelectProcedure
		,		@MergeProcedure				AS MergeProcedure
		,		@ChangeTrackingProcedure	AS ChangeTrackingProcedure
		,		@MaxRows					AS MaxRows
		,		@BufferSize					AS BufferSize
		,		@BatchSize					AS [BatchSize]
		,		@MaxInsertCommitSize		AS MaxInsertCommitSize
	)
	INSERT INTO	cfg.Packages
					(	PackageName
					,	SourceTable
					,	LandingTable
					,	DestinationTable
					,	SelectProcedure
					,	MergeProcedure
					,	ChangeTrackingProcedure
					,	DefaultBufferMaxRows
					,	DefaultBufferSize
					,	[BatchSize]
					,	MaximumInsertCommitSize
					,	LastChangeTrackingID
					)
	SELECT		p1.PackageName
	,			p1.SourceTable
	,			p1.LandingTable
	,			p1.DestinationTable
	,			p1.SelectProcedure
	,			p1.MergeProcedure
	,			p1.ChangeTrackingProcedure
	,			p1.MaxRows
	,			p1.BufferSize
	,			p1.[BatchSize]
	,			p1.MaxInsertCommitSize
	,			-1
	FROM		Package			p1
	LEFT JOIN	cfg.Packages	p2	ON p1.PackageName = p2.PackageName
	WHERE		p2.PackageID IS NULL;


	-- Update
	WITH Package AS
	(
		SELECT	@PackageName				AS PackageName
		,		@SourceTable				AS SourceTable
		,		@LandingTable				AS LandingTable
		,		@DestinationTable			AS DestinationTable
		,		@SelectProcedure			AS SelectProcedure
		,		@MergeProcedure				AS MergeProcedure
		,		@ChangeTrackingProcedure	AS ChangeTrackingProcedure
		,		@MaxRows					AS MaxRows
		,		@BufferSize					AS BufferSize
		,		@BatchSize					AS [BatchSize]
		,		@MaxInsertCommitSize		AS MaxInsertCommitSize
	)
	UPDATE	p1
	SET		PackageName				= p2.PackageName
	,		SourceTable				= p2.SourceTable
	,		LandingTable			= p2.LandingTable
	,		DestinationTable		= p2.DestinationTable
	,		SelectProcedure			= p2.SelectProcedure
	,		MergeProcedure			= p2.MergeProcedure
	,		ChangeTrackingProcedure	= p2.ChangeTrackingProcedure
	,		DefaultBufferMaxRows	= p2.MaxRows
	,		DefaultBufferSize		= p2.BufferSize
	,		[BatchSize]				= p2.[BatchSize]
	,		MaximumInsertCommitSize	= p2.MaxInsertCommitSize
	FROM	cfg.Packages	p1
	JOIN	Package			p2	ON p1.PackageName = p2.PackageName;

	-- Return
	SELECT		@PkgId = PackageID
	FROM		cfg.Packages
	WHERE		PackageName	= @PackageName;
	
	RETURN @PkgId;

END TRY

BEGIN CATCH
	THROW;
END CATCH