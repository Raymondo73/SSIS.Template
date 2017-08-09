WITH sourcetables AS 
(
--StagingDb related tables (being added to StagingDb and will provide the link to JNT data)
SELECT 'sdtStaging' AS DatabaseName, 'online' AS SchemaName, 'tblApplication' AS TableName 
UNION
SELECT 'sdtStaging' AS DatabaseName, 'online' AS SchemaName, 'tblApplicationCustomer' AS TableName
)
MERGE	cfg.SourceTables	AS target
USING	sourcetables		AS Source	ON	Target.Databasename = source.databasename
										AND Target.schemaname	= source.schemaname
										AND Target.tablename	= source.tablename
WHEN NOT MATCHED THEN
INSERT	(	tablename
		,	databasename
		,	schemaname
		)
VALUES	(	source.tablename
		,	source.databasename
		,	source.schemaname
		)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE;