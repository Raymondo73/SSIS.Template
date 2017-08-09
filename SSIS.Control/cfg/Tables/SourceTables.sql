CREATE TABLE [cfg].[SourceTables] (
    [TableId]      INT            IDENTITY (1, 1) NOT NULL,
    [DatabaseName] NVARCHAR (100) NOT NULL,
    [SchemaName]   NVARCHAR (20)  NOT NULL,
    [TableName]    NVARCHAR (100) NOT NULL,
    [LoadTolerancePC] smallint not null constraint DF_LoadTolerancePC default 0,
    [AutoCreate]   BIT            DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([TableId] ASC)
);