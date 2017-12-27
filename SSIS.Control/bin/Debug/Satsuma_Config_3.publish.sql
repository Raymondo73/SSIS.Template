﻿/*
Deployment script for SSIS.Control

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SSIS.Control"
:setvar DefaultFilePrefix "SSIS.Control"
:setvar DefaultDataPath "D:\SQL2014\Data\Data\"
:setvar DefaultLogPath "D:\SQL2014\Data\Logs\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating [cfg].[Add_SSISProject]...';


GO
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
GO
PRINT N'Creating [cfg].[Add_SSISProjectPackage]...';


GO
CREATE PROCEDURE [cfg].[Add_SSISProjectPackage]
	@ProjectID			INT
,	@PackageID			INT
,	@ExecutionOrder		INT		= 10
,	@ExecutionType1		CHAR(1) = 'I'
,	@ExecutionType2		CHAR(1) = 'I'
,	@ExecutionStream	INT		= 1
,	@Disabled			BIT		= 0
AS

BEGIN TRY
	SET NOCOUNT ON;

		MERGE	cfg.ProjectPackages	Dest
	USING	(	SELECT	@ProjectID			AS ProjectID
				,		@PackageID			AS PackageID
				,		@ExecutionOrder		AS ExecutionOrder
				,		@ExecutionType1		AS ExecutionType1
				,		@ExecutionType2		AS ExecutionType2
				,		@ExecutionStream	AS ExecutionStream
				,		@Disabled			AS [Disabled]
			) Source	ON	Dest.ProjectID = Source.ProjectID
						AND	Dest.PackageID = Source.PackageID
	WHEN NOT MATCHED THEN
	INSERT	(	ProjectID
			,	PackageID
			,	ExecutionOrder
			,	ExecType1
			,	ExecType2
			,	ExecutionStream
			,	[Disabled]
			)
	VALUES	(
				Source.ProjectID
			,	Source.PackageID
			,	Source.ExecutionOrder
			,	Source.ExecutionType1
			,	Source.ExecutionType2
			,	Source.ExecutionStream
			,	Source.[Disabled]
			)
	WHEN MATCHED THEN
	UPDATE
	SET		ExecutionOrder		= Source.ExecutionOrder
	,		ExecType1			= Source.ExecutionType1
	,		ExecType2			= Source.ExecutionType2
	,		ExecutionStream		= Source.ExecutionStream
	,		[Disabled]			= Source.[Disabled];
END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

DECLARE @AppId				INT = 0
,		@ProjectId			INT = 0
,		@PackageId			INT = 0
,		@ExecutionOrder		INT = 0
,		@AppName			VARCHAR(256) = 'Satsuma Staging BPS'
,		@ProjectName		VARCHAR(256) = 'Satsuma Staging BPS';

-- Set up core entries for Application and Project
EXEC cfg.Add_SSISApplication @AppName, @AppId OUTPUT;

EXEC cfg.Add_SSISProject @ProjectName, @ProjectId OUTPUT;

EXEC cfg.Add_SSISApplicationProject	@AppId,	@ProjectId,	10;

/*
	@PackageName		VARCHAR (255)
,	@SourceTable		VARCHAR (255)
,	@LandingTable		VARCHAR (255)
,	@DestinationTable	VARCHAR (255)
,	@SelectProcedure	VARCHAR (255)
,	@MergeProcedure		VARCHAR (255)
*/


-- add child packages with execution order and streams
SET @ExecutionOrder += 10;
EXEC @PackageId = cfg.Add_SSISPackage 'EDA_TENANT1.ADDRESS.dtsx', 'EDA_TENANT1.ADDRESS', 'Landing.ADDRESS', 'EDA_TENANT1.ADDRESS', 'etl.Select_EDA_TENANT1_ADDRESS_ByCTID', 'etl.Merge_EDA_TENANT1_Address';	
EXEC cfg.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 1;

SET @ExecutionOrder += 10;
EXEC @PackageId = cfg.Add_SSISPackage 'EDA_TENANT1.BSB_7_1_SPA.dtsx', 'EDA_TENANT1.BSB_7_1_SPA', 'Landing.BSB_7_1_SPA', 'EDA_TENANT1.BSB_7_1_SPA', 'etl.Select_EDA_TENANT1_ BSB_7_1_SPA_By_CTID', 'etl.Merge_EDA_TENANT1_BSB_7_1_SPA';	
EXEC cfg.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 2;

-- Insert JNT Change Tracking tables

SET IDENTITY_INSERT etl.TableChangeTracking ON;

WITH CTE AS	
(
	SELECT *
	FROM	(
			SELECT 1, 'BPS', 'EDA_TENANT1', 'ADDRESS', 0, GETDATE(), PackageId FROM etl.Packages WHERE PackageName = 'EDA_TENANT1.ADDRESS.dtsx'
			
			UNION
			
			SELECT 2, 'BPS', 'EDA_TENANT1', 'BSB_7_1_SPA', 0, GETDATE(), PackageId FROM etl.Packages WHERE PackageName = 'EDA_TENANT1.BSB_7_1_SPA.dtsx'
			) AS ctTable
	(TableChangeTrackingID, DatabaseName, SchemaName, TableName, ChangeTrackingID, LastUpdated, PackageId)
	)
MERGE	etl.TableChangeTracking	dest
USING	CTE						source ON dest.TableChangeTrackingID = source.TableChangeTrackingID
WHEN MATCHED
THEN 
UPDATE	
SET		DatabaseName		= source.DatabaseName
,		SchemaName			= source.SchemaName
,		TableName			= source.TableName
,		ChangeTrackingID	= source.ChangeTrackingID
,		LastUpdated			= source.LastUpdated
,		PackageId			= source.PackageId
WHEN NOT MATCHED
THEN
INSERT
		(	TableChangeTrackingID
		,	DatabaseName
		,	SchemaName
		,	TableName
		,	ChangeTrackingID
		,	LastUpdated
		,	PackageId
		)
VALUES	(	source.TableChangeTrackingID
		,	source.DataBaseName
		,	source.SchemaName
		,	source.TableName
		,	source.ChangeTrackingID
		,	source.LastUpdated
		,	source.PackageId
		)
WHEN NOT MATCHED BY SOURCE 
THEN DELETE;

SET IDENTITY_INSERT etl.TableChangeTracking OFF;

GO
WITH sourcetables AS 
(
--StagingDb related tables (being added to StagingDb and will provide the link to JNT data)
SELECT 'sdtStaging' AS DatabaseName, 'online' AS SchemaName, 'tblApplication' AS TableName 
UNION
SELECT 'sdtStaging' AS DatabaseName, 'online' AS SchemaName, 'tblApplicationCustomer' AS TableName
)
MERGE	cfg.SourceTables	AS target
USING	sourcetables		AS Source	ON	Target.Databasename = source.databasename
										AND Target.schemaname	= source.schemaname
										AND Target.tablename	= source.tablename
WHEN NOT MATCHED THEN
INSERT	(	tablename
		,	databasename
		,	schemaname
		)
VALUES	(	source.tablename
		,	source.databasename
		,	source.schemaname
		)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE;
GO

GO
PRINT N'Update complete.';


GO
