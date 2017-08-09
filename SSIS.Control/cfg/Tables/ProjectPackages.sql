CREATE TABLE [cfg].[ProjectPackages] (
    [ProjectPackageID] INT      IDENTITY (1, 1) NOT NULL,
    [ProjectId]        INT      NOT NULL,
    [PackageID]        INT      NOT NULL,
    [ExecutionOrder]   INT      NULL,
    [ExecType1]        CHAR (1) NULL,
    [ExecType2]        CHAR (2) NULL,
    [ExecutionStream]  INT      NULL,
    [Disabled]         BIT      NULL,
    CONSTRAINT [PK_ProjPackages] PRIMARY KEY CLUSTERED ([ProjectPackageID] ASC),
    CONSTRAINT [FK_ProjectPackages_Packages] FOREIGN KEY ([PackageID]) REFERENCES [cfg].[Packages] ([PackageID]),
    CONSTRAINT [FK_ProjectPackages_Projects] FOREIGN KEY ([ProjectId]) REFERENCES [cfg].[Projects] ([ProjectId])
);