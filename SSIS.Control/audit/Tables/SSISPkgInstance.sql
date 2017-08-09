CREATE TABLE [audit].[SSISPkgInstance] (
    [PkgInstanceID] INT          IDENTITY (1, 1) NOT NULL,
    [AppInstanceID] INT          NOT NULL,
    [PackageID]     INT          NOT NULL,
    [StartDateTime] DATETIME     NOT NULL,
    [EndDateTime]   DATETIME     NULL,
    [Status]        VARCHAR (12) NULL,
    CONSTRAINT [PK_SSISPkgInstance] PRIMARY KEY CLUSTERED ([PkgInstanceID] ASC)
);