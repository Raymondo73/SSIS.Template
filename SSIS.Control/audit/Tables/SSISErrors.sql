CREATE TABLE [audit].[SSISErrors] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [AppInstanceID]    INT           NOT NULL,
    [PkgInstanceID]    INT           NOT NULL,
    [ErrorDateTime]    DATETIME      NOT NULL,
    [ErrorDescription] VARCHAR (MAX) NULL,
    [SourceName]       VARCHAR (255) NULL,
    CONSTRAINT [PK_SSISErrors] PRIMARY KEY CLUSTERED ([ID] ASC)
);