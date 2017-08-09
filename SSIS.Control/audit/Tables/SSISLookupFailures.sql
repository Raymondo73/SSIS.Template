CREATE TABLE [audit].[SSISLookupFailures] (
    [PackageName] NVARCHAR (100) NULL,
    [TaskName]    NVARCHAR (100) NULL,
    [TableName]   NVARCHAR (100) NULL,
    [KeyValue]    NVARCHAR (100) NULL,
    [DateOccured] DATETIME       NULL
);