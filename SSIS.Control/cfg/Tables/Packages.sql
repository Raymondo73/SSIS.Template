CREATE TABLE [cfg].[Packages] (
	[PackageID] [int] IDENTITY(1,1) NOT NULL,
	[PackageName] [varchar](255) NOT NULL,
	[PackagePath] [varchar](300) NULL,
	[SourceTable] [varchar](255) NULL,
	[LandingTable] [varchar](255) NULL,
	[DestinationTable] [varchar](255) NULL,
	[SelectProcedure] [varchar](255) NULL,
	[MergeProcedure] [varchar](255) NULL,
    CONSTRAINT [PK_Packages] PRIMARY KEY CLUSTERED ([PackageID] ASC)
);