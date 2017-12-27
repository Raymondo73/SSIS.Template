CREATE TABLE [cfg].[Packages] (
	[PackageID] [int] IDENTITY(1,1) NOT NULL,
	[PackageName] [varchar](255) NOT NULL,
	[PackagePath] [varchar](300) NULL,
	[SourceTable] [varchar](255) NULL,
	[LandingTable] [varchar](255) NULL,
	[DestinationTable] [varchar](255) NULL,
	[SelectProcedure] [varchar](MAX) NULL,
	[MergeProcedure] [varchar](255) NULL,
    [DefaultBufferMaxRows] INT NULL DEFAULT(10000), 
    [DefaultBufferSize] INT NULL DEFAULT(10485760), 
	[BatchSize] INT NOT NULL DEFAULT(10000),
	[MaximumInsertCommitSize] INT NOT NULL DEFAULT(0),
    [LastChangeTrackingID] INT NULL DEFAULT -1, 
    [LastChangeTrackUpdated] SMALLDATETIME NULL, 
    CONSTRAINT [PK_Packages] PRIMARY KEY CLUSTERED ([PackageID] ASC)
);