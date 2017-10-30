CREATE TABLE [cfg].[SourceTables] (
    [TableId]			INT				IDENTITY (1, 1) NOT NULL,
    [DatabaseName]		NVARCHAR (100)	NOT NULL,
    [SchemaName]		NVARCHAR (20)	NOT NULL,
    [TableName]			NVARCHAR (100)	NOT NULL,
    [ProjectID]			INT				NULL, 
	LargeTable			BIT				NOT NULL DEFAULT(0),
    PRIMARY KEY CLUSTERED ([TableId] ASC), 
    CONSTRAINT [FK_SourceTables_Projects] FOREIGN KEY (ProjectID) REFERENCES cfg.Projects(ProjectID),
);