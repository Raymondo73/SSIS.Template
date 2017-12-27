/*
User query to obtain list of tables from the server

SELECT	'SELECT ' + DB_NAME() + ' AS DatabaseName, ' + s.[name] + ' ' + ' AS SchemaName, ' +  t.[name] + ' ' + ' AS TableName , @PjectID AS ProjectID, 0 AS LargeTable'
FROM	sys.tables		t
JOIN	sys.schemas		s	ON s.schema_id	= t.schema_id
--JOIN	sys.triggers	tr	ON tr.parent_id	= t.object_id
WHERE	s.[name] = 'cfg'

Above example also returns dbo tables with triggers.  Adjust as seen fit
Repeat merge below for each project
*/

-- /////////////// JNT Landing /////////////////////////////////////////
DECLARE @PName		VARCHAR(100) = 'JNT Landing'
,		@PjectID	INT;

SELECT	@PjectID = ProjectID
FROM	cfg.Projects
WHERE	ProjectName = @PName;

WITH sourcetables AS 
(
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'JourneyStatusTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'PostCodeRegions' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'Postcodes' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'PostCodeSectors' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RebateToPayPerPoundTable_acls' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RegionAreaTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RegionTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RPT_CashSheets' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'SectionTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblAgentRelativeType' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblCustomerPaymentPerformance' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblCustomerRisk' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblCustomerRiskStatus' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransactionTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransactionTypeTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransferHistoryTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'UserTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'WriteOffTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransactionTable' AS TableName, @PjectID AS ProjectID, 1 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementDefinitionTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementDefinitionTable_acls' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementDefinitionTableExtra' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementPaymentMethodTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementStatusTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AreaTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'BranchTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'BranchType' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CollectorTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CustomerDetailsTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CustomerPrevAddress' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CustomerTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'DivisionTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_AL_BankTransactions' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_AL_BranchPayslips' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_CreditCardPaymentTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_CustomerAddressTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_PayrollCollectorLinkHistoryTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_PayrollCollectorLinkTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_PayrollTable' AS TableName, @PjectID AS ProjectID, 0 AS LargeTable 
)
MERGE	cfg.SourceTables	AS target
USING	sourcetables		AS Source	ON	Target.Databasename = source.databasename
										AND Target.schemaname	= source.schemaname
										AND Target.tablename	= source.tablename
										AND	Target.ProjectID	= @PjectID
										AND	Target.LargeTable	= source.LargeTable
WHEN NOT MATCHED THEN
INSERT	(	tablename
		,	databasename
		,	schemaname
		,	ProjectID
		,	LargeTable
		)
VALUES	(	source.tablename
		,	source.databasename
		,	source.schemaname
		,	source.ProjectID
		,	source.LargeTable
		)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE;

-- //// JNT Landing /////////////////////////////////////////