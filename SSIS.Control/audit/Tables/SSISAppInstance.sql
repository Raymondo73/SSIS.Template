CREATE TABLE [audit].[SSISAppInstance] (
    [AppInstanceID] INT          IDENTITY (1, 1) NOT NULL,
    [ApplicationID] INT          NOT NULL,
    [StartDateTime] DATETIME     NOT NULL,
    [EndDateTime]   DATETIME     NULL,
    [Status]        VARCHAR (12) NULL,
    CONSTRAINT [PK_SSISAppInstance] PRIMARY KEY CLUSTERED ([AppInstanceID] ASC),
    CONSTRAINT [FK_logSSISAppInstance_cfgApplication_ApplicationID] FOREIGN KEY ([ApplicationID]) REFERENCES [cfg].[Applications] ([ApplicationID])
);