CREATE TABLE [cfg].[ApplicationProjects] (
    [ApplicationProjectID] INT IDENTITY (1, 1) NOT NULL,
    [ApplicationId]        INT NOT NULL,
    [ProjectId]            INT NOT NULL,
    [ExecutionOrder]       INT NULL,
    PRIMARY KEY CLUSTERED ([ApplicationProjectID] ASC),
    CONSTRAINT [FK_ApplicationProjects_Applications] FOREIGN KEY ([ApplicationId]) REFERENCES [cfg].[Applications] ([ApplicationID]),
    CONSTRAINT [FK_ApplicationProjects_Projects] FOREIGN KEY ([ProjectId]) REFERENCES [cfg].[Projects] ([ProjectId])
);