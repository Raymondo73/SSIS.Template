-- Insert JNT Change Tracking tables

SET IDENTITY_INSERT cfg.TableChangeTracking ON;

WITH CTE AS	
(
	SELECT *
	FROM	(
			SELECT 1, 'BPS', 'EDA_TENANT1', 'ADDRESS', 0, GETDATE(), PackageId FROM cfg.Packages WHERE PackageName = 'EDA_TENANT1.ADDRESS.dtsx'
			
			UNION
			
			SELECT 2, 'BPS', 'EDA_TENANT1', 'BSB_7_1_SPA', 0, GETDATE(), PackageId FROM cfg.Packages WHERE PackageName = 'EDA_TENANT1.BSB_7_1_SPA.dtsx'
			) AS ctTable
	(TableChangeTrackingID, DatabaseName, SchemaName, TableName, ChangeTrackingID, LastUpdated, PackageId)
	)
MERGE	cfg.TableChangeTracking	dest
USING	CTE						source ON dest.TableChangeTrackingID = source.TableChangeTrackingID
WHEN MATCHED
THEN 
UPDATE	
SET		DatabaseName		= source.DatabaseName
,		SchemaName			= source.SchemaName
,		TableName			= source.TableName
,		ChangeTrackingID	= source.ChangeTrackingID
,		LastUpdated			= source.LastUpdated
,		PackageId			= source.PackageId
WHEN NOT MATCHED
THEN
INSERT
		(	TableChangeTrackingID
		,	DatabaseName
		,	SchemaName
		,	TableName
		,	ChangeTrackingID
		,	LastUpdated
		,	PackageId
		)
VALUES	(	source.TableChangeTrackingID
		,	source.DataBaseName
		,	source.SchemaName
		,	source.TableName
		,	source.ChangeTrackingID
		,	source.LastUpdated
		,	source.PackageId
		)
WHEN NOT MATCHED BY SOURCE 
THEN DELETE;

SET IDENTITY_INSERT cfg.TableChangeTracking OFF;

GO