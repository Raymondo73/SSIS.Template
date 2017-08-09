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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [cfg]...';


GO
CREATE SCHEMA [cfg]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [log]...';


GO
CREATE SCHEMA [log]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [cfg].[Projects]...';


GO
CREATE TABLE [cfg].[Projects] (
    [ProjectId]   INT           IDENTITY (1, 1) NOT NULL,
    [ProjectName] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ProjectId] ASC)
);


GO
PRINT N'Creating [cfg].[ProjectPackages]...';


GO
CREATE TABLE [cfg].[ProjectPackages] (
    [ProjectPackageID] INT      IDENTITY (1, 1) NOT NULL,
    [ProjectId]        INT      NOT NULL,
    [PackageID]        INT      NOT NULL,
    [ExecutionOrder]   INT      NULL,
    [ExecType1]        CHAR (1) NULL,
    [ExecType2]        CHAR (2) NULL,
    [ExecutionStream]  INT      NULL,
    [Disabled]         BIT      NULL,
    CONSTRAINT [PK_ProjPackages] PRIMARY KEY CLUSTERED ([ProjectPackageID] ASC)
);


GO
PRINT N'Creating [cfg].[Packages]...';


GO
CREATE TABLE [cfg].[Packages] (
    [PackageID]        INT           IDENTITY (1, 1) NOT NULL,
    [PackageName]      VARCHAR (255) NOT NULL,
    [PackagePath]      VARCHAR (300) NULL,
    [SourceTable]      VARCHAR (255) NULL,
    [LandingTable]     VARCHAR (255) NULL,
    [DestinationTable] VARCHAR (255) NULL,
    [SelectProcedure]  VARCHAR (255) NULL,
    [MergeProcedure]   VARCHAR (255) NULL,
    CONSTRAINT [PK_Packages] PRIMARY KEY CLUSTERED ([PackageID] ASC)
);


GO
PRINT N'Creating [cfg].[Applications]...';


GO
CREATE TABLE [cfg].[Applications] (
    [ApplicationID]   INT           IDENTITY (1, 1) NOT NULL,
    [ApplicationName] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED ([ApplicationID] ASC),
    CONSTRAINT [U_Applications_ApplicationName] UNIQUE NONCLUSTERED ([ApplicationName] ASC)
);


GO
PRINT N'Creating [cfg].[ApplicationProjects]...';


GO
CREATE TABLE [cfg].[ApplicationProjects] (
    [ApplicationProjectID] INT IDENTITY (1, 1) NOT NULL,
    [ApplicationId]        INT NOT NULL,
    [ProjectId]            INT NOT NULL,
    [ExecutionOrder]       INT NULL,
    PRIMARY KEY CLUSTERED ([ApplicationProjectID] ASC)
);


GO
PRINT N'Creating [cfg].[SourceTables]...';


GO
CREATE TABLE [cfg].[SourceTables] (
    [TableId]         INT            IDENTITY (1, 1) NOT NULL,
    [DatabaseName]    NVARCHAR (100) NOT NULL,
    [SchemaName]      NVARCHAR (20)  NOT NULL,
    [TableName]       NVARCHAR (100) NOT NULL,
    [LoadTolerancePC] SMALLINT       NOT NULL,
    [AutoCreate]      BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([TableId] ASC)
);


GO
PRINT N'Creating [cfg].[TableChangeTracking]...';


GO
CREATE TABLE [cfg].[TableChangeTracking] (
    [TableChangeTrackingID] INT           IDENTITY (1, 1) NOT NULL,
    [DatabaseName]          VARCHAR (100) NULL,
    [SchemaName]            VARCHAR (20)  NULL,
    [TableName]             VARCHAR (500) NULL,
    [ChangeTrackingID]      INT           NULL,
    [LastUpdated]           DATETIME      NULL,
    [PackageId]             INT           NULL,
    PRIMARY KEY CLUSTERED ([TableChangeTrackingID] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'Creating [log].[SSISPkgInstance]...';


GO
CREATE TABLE [log].[SSISPkgInstance] (
    [PkgInstanceID] INT          IDENTITY (1, 1) NOT NULL,
    [AppInstanceID] INT          NOT NULL,
    [PackageID]     INT          NOT NULL,
    [StartDateTime] DATETIME     NOT NULL,
    [EndDateTime]   DATETIME     NULL,
    [Status]        VARCHAR (12) NULL,
    CONSTRAINT [PK_SSISPkgInstance] PRIMARY KEY CLUSTERED ([PkgInstanceID] ASC)
);


GO
PRINT N'Creating [log].[SSISLookupFailures]...';


GO
CREATE TABLE [log].[SSISLookupFailures] (
    [PackageName] NVARCHAR (100) NULL,
    [TaskName]    NVARCHAR (100) NULL,
    [TableName]   NVARCHAR (100) NULL,
    [KeyValue]    NVARCHAR (100) NULL,
    [DateOccured] DATETIME       NULL
);


GO
PRINT N'Creating [log].[SSISEvents]...';


GO
CREATE TABLE [log].[SSISEvents] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [AppInstanceID]    INT           NOT NULL,
    [PkgInstanceID]    INT           NOT NULL,
    [EventDateTime]    DATETIME      NOT NULL,
    [EventDescription] VARCHAR (MAX) NULL,
    [SourceName]       VARCHAR (255) NULL,
    CONSTRAINT [PK_SSISEvents] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Creating [log].[SSISErrors]...';


GO
CREATE TABLE [log].[SSISErrors] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [AppInstanceID]    INT           NOT NULL,
    [PkgInstanceID]    INT           NOT NULL,
    [ErrorDateTime]    DATETIME      NOT NULL,
    [ErrorDescription] VARCHAR (MAX) NULL,
    [SourceName]       VARCHAR (255) NULL,
    CONSTRAINT [PK_SSISErrors] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Creating [log].[SSISAppInstance]...';


GO
CREATE TABLE [log].[SSISAppInstance] (
    [AppInstanceID] INT          IDENTITY (1, 1) NOT NULL,
    [ApplicationID] INT          NOT NULL,
    [StartDateTime] DATETIME     NOT NULL,
    [EndDateTime]   DATETIME     NULL,
    [Status]        VARCHAR (12) NULL,
    CONSTRAINT [PK_SSISAppInstance] PRIMARY KEY CLUSTERED ([AppInstanceID] ASC)
);


GO
PRINT N'Creating [cfg].[DF_LoadTolerancePC]...';


GO
ALTER TABLE [cfg].[SourceTables]
    ADD CONSTRAINT [DF_LoadTolerancePC] DEFAULT 0 FOR [LoadTolerancePC];


GO
PRINT N'Creating unnamed constraint on [cfg].[SourceTables]...';


GO
ALTER TABLE [cfg].[SourceTables]
    ADD DEFAULT ((1)) FOR [AutoCreate];


GO
PRINT N'Creating unnamed constraint on [cfg].[TableChangeTracking]...';


GO
ALTER TABLE [cfg].[TableChangeTracking]
    ADD DEFAULT (getdate()) FOR [LastUpdated];


GO
PRINT N'Creating [cfg].[FK_ProjectPackages_Packages]...';


GO
ALTER TABLE [cfg].[ProjectPackages]
    ADD CONSTRAINT [FK_ProjectPackages_Packages] FOREIGN KEY ([PackageID]) REFERENCES [cfg].[Packages] ([PackageID]);


GO
PRINT N'Creating [cfg].[FK_ProjectPackages_Projects]...';


GO
ALTER TABLE [cfg].[ProjectPackages]
    ADD CONSTRAINT [FK_ProjectPackages_Projects] FOREIGN KEY ([ProjectId]) REFERENCES [cfg].[Projects] ([ProjectId]);


GO
PRINT N'Creating [cfg].[FK_ApplicationProjects_Applications]...';


GO
ALTER TABLE [cfg].[ApplicationProjects]
    ADD CONSTRAINT [FK_ApplicationProjects_Applications] FOREIGN KEY ([ApplicationId]) REFERENCES [cfg].[Applications] ([ApplicationID]);


GO
PRINT N'Creating [cfg].[FK_ApplicationProjects_Projects]...';


GO
ALTER TABLE [cfg].[ApplicationProjects]
    ADD CONSTRAINT [FK_ApplicationProjects_Projects] FOREIGN KEY ([ProjectId]) REFERENCES [cfg].[Projects] ([ProjectId]);


GO
PRINT N'Creating [cfg].[FK_TableChangeTracking_Package]...';


GO
ALTER TABLE [cfg].[TableChangeTracking]
    ADD CONSTRAINT [FK_TableChangeTracking_Package] FOREIGN KEY ([PackageId]) REFERENCES [cfg].[Packages] ([PackageID]);


GO
PRINT N'Creating [log].[FK_logSSISAppInstance_cfgApplication_ApplicationID]...';


GO
ALTER TABLE [log].[SSISAppInstance]
    ADD CONSTRAINT [FK_logSSISAppInstance_cfgApplication_ApplicationID] FOREIGN KEY ([ApplicationID]) REFERENCES [cfg].[Applications] ([ApplicationID]);


GO
PRINT N'Creating [cfg].[Get_SSISPackagesByStream]...';


GO
CREATE PROCEDURE [cfg].[Get_SSISPackagesByStream]
	@ApplicationName	VARCHAR (255)
,	@ExecutionType		INT
,	@ExecutionBatch		INT
,	@ExecutionStream	INT
AS

BEGIN TRY
	SET NOCOUNT ON;
	
	SELECT	p.PackageName AS PackagePath
	,		p.PackageName
	,		CONVERT(CHAR(1), CASE WHEN @ExecutionType = 1 THEN ExecType1 ELSE ExecType2 END) AS ExecutionType
	,		p.SourceTable
	,		p.LandingTable
	,		p.DestinationTable
	,		p.SelectProcedure
	,		p.MergeProcedure
	FROM	cfg.ProjectPackages		ap
	JOIN	cfg.Packages			p	ON p.PackageID			= ap.PackageID
	JOIN	cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	JOIN	cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE	ApplicationName					= @ApplicationName
	AND		ap.ExecutionOrder				= @ExecutionBatch
	AND		ap.ExecutionStream				= @ExecutionStream
	AND		ISNULL(ap.[Disabled], 'False')	!= 'True';

	-- [cfg].[GetSSISPackagesByStream] 'J2DW', 2, 100, 1

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [cfg].[Get_SSISNoOfStreamsForBatch]...';


GO
CREATE PROCEDURE [cfg].[Get_SSISNoOfStreamsForBatch] 
	@ApplicationName	VARCHAR (255)
,	@ExecutionBatch		INT
AS
BEGIN TRY

	SET NOCOUNT ON;

	SELECT	MAX(ISNULL(ExecutionStream, 1))		AS NoOfStreamsForBatch
	FROM	cfg.ProjectPackages		ap
	JOIN	cfg.Packages			p	ON p.PackageID			= ap.PackageID
	JOIN	cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	JOIN	cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE	ApplicationName					= @ApplicationName
	AND		ap.ExecutionOrder				= @ExecutionBatch
	AND		ISNULL(ap.[Disabled],'False')	!= 'True';

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [cfg].[Get_SSISApplication]...';


GO
CREATE PROCEDURE [cfg].[Get_SSISApplication]
	@ApplicationName	VARCHAR (255)
,	@ExecutionType		INT

AS

BEGIN TRY
	SET NOCOUNT ON;

	SELECT		p.PackageName As PackagePath
	,			ap.ExecutionOrder
	,			p.PackageName
	,			CONVERT(CHAR(1), CASE WHEN @ExecutionType = 1 THEN ExecType1 ELSE ExecType2 END) AS ExecutionType
	FROM		cfg.ProjectPackages		ap
	Join		cfg.Packages			p	ON p.PackageID			= ap.PackageID
	Join		cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	Join		cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE		ApplicationName					= @ApplicationName
	AND			ISNULL(ap.[Disabled], 'False')	!= 'True'
	ORDER BY	a.ExecutionOrder
	,			ap.ExecutionOrder;

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [cfg].[AddSSISProjectPackage]...';


GO
CREATE PROCEDURE [cfg].[AddSSISProjectPackage]
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
PRINT N'Creating [cfg].[AddSSISProject]...';


GO
CREATE PROCEDURE [cfg].[AddSSISProject]
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
PRINT N'Creating [cfg].[Add_SSISPackage]...';


GO
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
GO
PRINT N'Creating [cfg].[Add_SSISApplicationProject]...';


GO
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
GO
PRINT N'Creating [cfg].[Add_SSISApplication]...';


GO
CREATE PROCEDURE [cfg].[Add_SSISApplication]
	@ApplicationName	VARCHAR (255)
,	@AppID				INT				OUTPUT
AS

SET NOCOUNT ON;

BEGIN TRY
	DECLARE @tbl TABLE (AppID INT);
  
	IF NOT EXISTS	(	SELECT	ApplicationName
					FROM	cfg.Applications
					WHERE	ApplicationName = @ApplicationName
				)
	BEGIN
		INSERT INTO cfg.Applications
					(ApplicationName)
		OUTPUT		inserted.ApplicationID 
		INTO		@tbl
		VALUES		(@ApplicationName);
	END
	
	ELSE
	BEGIN
		INSERT INTO @tbl
					(AppID)
		SELECT		ApplicationID
		FROM		cfg.Applications
		WHERE		ApplicationName = @ApplicationName;
	END

	SELECT	@AppID = AppID 
	FROM	@tbl;
END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [cfg].[Get_SSISApplicationBatches]...';


GO
CREATE PROCEDURE [cfg].[Get_SSISApplicationBatches] 
/******************************************************
	Author:			Raymond F. Betts
	Date:			03 August 2017
	Description:	Select From
						etl.ProjectPackages		
						etl.Packages			
						etl.ApplicationProjects 
						etl.Applications		
******************************************************/	
@ApplicationName VARCHAR (255)

AS

BEGIN TRY
	SET NOCOUNT ON;

	SELECT DISTINCT ap.ExecutionOrder		As ExecutionBatch
	FROM			cfg.ProjectPackages		ap
	JOIN			cfg.Packages			p	ON p.PackageID			= ap.PackageID
	JOIN			cfg.ApplicationProjects a	ON a.ProjectID			= ap.ProjectID
	JOIN			cfg.Applications		app ON app.ApplicationId	= a.ApplicationID
	WHERE			ApplicationName					= @ApplicationName
	AND				ISNULL(ap.[Disabled], 'False')	!= 'True'
	ORDER BY		ap.ExecutionOrder;

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [cfg].[Get_ChangeTrackingID]...';


GO
CREATE PROCEDURE [cfg].[Get_ChangeTrackingID]
/******************************************************
	Author:			Raymond F. Betts
	Date:			03 August 2017
	Description:	Select From
						etl.TableChangeTracking	
						etl.Packages					
******************************************************/
	@PackageName VARCHAR(200)

AS

BEGIN TRY
	SET NOCOUNT ON;
	
	DECLARE @ChangeTrackingID INT;

	SELECT	@ChangeTrackingID = c.ChangeTrackingID
	FROM	cfg.TableChangeTracking	c 
	JOIN	cfg.Packages			p ON c.PackageId = p.PackageID  
	WHERE	p.PackageName = @PackageName;

	SELECT ISNULL(@ChangeTrackingID, -1) AS ChangeTrackingID;

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogStartOfPackage]...';


GO
CREATE PROCEDURE [log].[LogStartOfPackage]
	@AppInstanceID	INT
,	@PackagePath	VARCHAR (255)
AS

DECLARE @ErrMsg		VARCHAR(255)
,		@PkgID		INT;

BEGIN TRY
	SET NOCOUNT ON;

	SET @PkgID =	(	
					SELECT	MAX(PackageID)
					FROM	cfg.Packages
					WHERE	PackageName = @PackagePath
					);

	IF @PkgID IS NULL
	BEGIN
		SET @ErrMsg = 'Cannot find PackagePath ' + COALESCE(@PackagePath, '');
		RAISERROR(@ErrMsg, 16, 1);
		RETURN -1;
	END

	INSERT INTO [log].SSISPkgInstance
				(	AppInstanceID
				,	PackageID
				,	StartDateTime
				,	[Status]
				)
	OUTPUT		inserted.PkgInstanceID
	VALUES		(	@AppInstanceID
				,	@PkgID
				,	GETDATE()
				,	'Running'
				);
END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogStartOfApplication]...';


GO
CREATE PROCEDURE [log].[LogStartOfApplication]
	@ApplicationName VARCHAR (255)
AS

DECLARE		@ErrMsg VARCHAR(255)
,			@AppID	INT;

BEGIN TRY

	SET NOCOUNT ON;

	SET @AppID =	(	
					SELECT	ApplicationID
					FROM	cfg.Applications
					WHERE	ApplicationName = @ApplicationName
					);

	IF (@AppID IS NULL)
	BEGIN
		SET @ErrMsg = 'Cannot find ApplicationName ' + COALESCE(@ApplicationName, '<NULL>');
		RAISERROR(@ErrMsg, 16, 1);
		RETURN	-1;
	END

	INSERT INTO	[log].SSISAppInstance
				(	ApplicationID
				,	StartDateTime
				,	[Status]
				)
	OUTPUT		inserted.AppInstanceID
	VALUES		(	@AppID
				,	GETDATE()
				,	'Running'
				);

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogPackageSuccess]...';


GO
CREATE PROCEDURE [log].[LogPackageSuccess]
@PkgInstanceID INT
AS

BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[log].SSISPkgInstance
	SET		EndDateTime		= GETDATE()
	,		[Status]		= 'Success'
	WHERE	PkgInstanceID	= @PkgInstanceID;

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogPackageFailure]...';


GO
CREATE PROCEDURE [log].[LogPackageFailure]
@PkgInstanceID INT

AS

BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[log].SSISPkgInstance
	SET		EndDateTime		= GETDATE()
	,		[Status]		= 'Failed'
	WHERE	PkgInstanceID	= @PkgInstanceID;

 END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogEvent]...';


GO
CREATE PROCEDURE [log].[LogEvent]
	@AppInstanceID		INT
,	@PkgInstanceID		INT
,	@SourceName			VARCHAR (255)
,	@EventDescription	VARCHAR (MAX)
AS

BEGIN TRY
	SET NOCOUNT ON;

	INSERT INTO	[log].SSISEvents
				(	AppInstanceID
				,	PkgInstanceID
				,	SourceName
				,	EventDescription
				,	EventDateTime
				)
	VALUES		(	@AppInstanceID 
				,	@PkgInstanceID 
				,	@SourceName 
				,	@EventDescription
				,	GETDATE()
				);
END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogError]...';


GO
CREATE PROCEDURE [log].[LogError]
	@AppInstanceID		INT
,	@PkgInstanceID		INT
,	@SourceName			VARCHAR(255)
,	@ErrorDescription	VARCHAR(MAX)
AS

BEGIN TRY
	SET NOCOUNT ON;

	INSERT INTO [log].SSISErrors
				(	AppInstanceID
				,	PkgInstanceID
				,	SourceName
				,	ErrorDescription
				,	ErrorDatetime
				)
	VALUES		(	@AppInstanceID 
				,	@PkgInstanceID 
				,	@SourceName 
				,	@ErrorDescription
				,	GETDATE()
				);
END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogApplicationSuccess]...';


GO
CREATE PROCEDURE [log].[LogApplicationSuccess]
	@AppInstanceID INT

AS

BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[log].SSISAppInstance
	SET		EndDateTime		= GETDATE()
	,		[Status]		= 'Success'
	WHERE	AppInstanceID	= @AppInstanceID;

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[LogApplicationFailure]...';


GO
CREATE PROCEDURE [log].[LogApplicationFailure]
	@AppInstanceID INT
AS
BEGIN TRY

	SET NOCOUNT ON;

	UPDATE	[log].SSISAppInstance
	SET		EndDateTime		= GETDATE()
	,		[STATUS]		= 'Failed'
	WHERE	AppInstanceID	= @AppInstanceID;
END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [log].[GetExecutionErrors]...';


GO
CREATE PROC [log].[GetExecutionErrors] 
	@AppInstanceId INT 

AS
BEGIN TRY
	SET NOCOUNT ON;
	
	SELECT  pk.PackageName
	,		ev.* 
	FROM	[log].SSISErrors		ev
	JOIN	[log].SSISPkgInstance	pi ON ev.PkgInstanceID	= pi.PkgInstanceID
	JOIN	cfg.packages			pk ON pk.PackageID		= pi.PackageID
	WHERE	ev.AppInstanceID = @AppInstanceId;

END TRY

BEGIN CATCH
	THROW;
END CATCH
GO
PRINT N'Creating [dbo].[Purge_SSISFrameworkLogs]...';


GO
CREATE PROCEDURE [dbo].[Purge_SSISFrameworkLogs]
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
		FROM	[log].[SSISEvents]
		WHERE	[EventDateTime] < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[log].[SSISErrors]
		WHERE	[ErrorDateTime] < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[log].[SSISLookupFailures]
		WHERE	[DateOccured]  < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[log].[SSISPkgInstance]
		WHERE	EndDateTime < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		DELETE	TOP(@BlockSize) 
		FROM	[log].[SSISAppInstance]
		WHERE	EndDateTime < @CutOff;
		SELECT	@RowsAffected = @RowsAffected + @@ROWCOUNT;

		COMMIT TRAN;

	END

END
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
EXEC etl.Add_SSISApplication @AppName, @AppId OUTPUT;

EXEC etl.Add_SSISProject @ProjectName, @ProjectId OUTPUT;

EXEC etl.Add_SSISApplicationProject	@AppId,	@ProjectId,	10;

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
EXEC @PackageId = etl.Add_SSISPackage 'EDA_TENANT1.ADDRESS.dtsx', 'EDA_TENANT1.ADDRESS', 'Landing.ADDRESS', 'EDA_TENANT1.ADDRESS', 'etl.Select_EDA_TENANT1_ADDRESS_ByCTID', 'etl.Merge_EDA_TENANT1_Address';	
EXEC etl.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 1;

SET @ExecutionOrder += 10;
EXEC @PackageId = etl.Add_SSISPackage 'EDA_TENANT1.BSB_7_1_SPA.dtsx', 'EDA_TENANT1.BSB_7_1_SPA', 'Landing.BSB_7_1_SPA', 'EDA_TENANT1.BSB_7_1_SPA', 'etl.Select_EDA_TENANT1_ BSB_7_1_SPA_By_CTID', 'etl.Merge_EDA_TENANT1_BSB_7_1_SPA';	
EXEC etl.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 2;

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
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
