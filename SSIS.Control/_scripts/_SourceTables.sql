WITH sourcetables AS 
(
--StagingDb related tables (being added to StagingDb and will provide the link to JNT data)
SELECT 'BPS' AS DatabaseName, 'EDA_TENANT1' AS SchemaName, 'ADDRESS' AS TableName 
UNION
SELECT 'BPS' AS DatabaseName, 'EDA_TENANT1' AS SchemaName, 'EDA_TENANT1.BSB_7_1_SPA' AS TableName
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