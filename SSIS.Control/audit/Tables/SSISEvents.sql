CREATE TABLE [audit].[SSISEvents] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [AppInstanceID]    INT           NOT NULL,
    [PkgInstanceID]    INT           NOT NULL,
    [EventDateTime]    DATETIME      NOT NULL,
    [EventDescription] VARCHAR (MAX) NULL,
    [SourceName]       VARCHAR (255) NULL,
    CONSTRAINT [PK_SSISEvents] PRIMARY KEY CLUSTERED ([ID] ASC)
);