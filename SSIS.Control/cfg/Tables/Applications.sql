CREATE TABLE [cfg].[Applications] (
    [ApplicationID]   INT           IDENTITY (1, 1) NOT NULL,
    [ApplicationName] VARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED ([ApplicationID] ASC),
    CONSTRAINT [U_Applications_ApplicationName] UNIQUE NONCLUSTERED ([ApplicationName] ASC)
);