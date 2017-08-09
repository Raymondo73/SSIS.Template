CREATE TABLE [cfg].[Projects] (
    [ProjectId]   INT           IDENTITY (1, 1) NOT NULL,
    [ProjectName] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ProjectId] ASC)
);