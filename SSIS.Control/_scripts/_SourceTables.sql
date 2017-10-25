/*
User query to obtain list of tables from the server

SELECT	DB_NAME()		AS DatabaseName
,		s.[name]		AS SchemaName
,		t.[name]		AS TableName
FROM	sys.tables		t
JOIN	sys.schemas		s	ON s.schema_id	= t.schema_id
JOIN	sys.triggers	tr	ON tr.parent_id	= t.object_id
WHERE	s.[name] = 'dbo'

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
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'JourneyStatusTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'PostCodeRegions' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'Postcodes' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'PostCodeSectors' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RebateToPayPerPoundTable_acls' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RegionAreaTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RegionTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'RPT_CashSheets' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'SectionTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblAgentRelativeType' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblCustomerPaymentPerformance' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblCustomerRisk' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'tblCustomerRiskStatus' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransactionTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransactionTypeTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransferHistoryTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'UserTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'WriteOffTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'TransactionTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementDefinitionTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementDefinitionTable_acls' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementDefinitionTableExtra' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementPaymentMethodTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementStatusTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AgreementTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'AreaTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'BranchTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'BranchType' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CollectorTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CustomerDetailsTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CustomerPrevAddress' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'CustomerTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'DivisionTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_AL_BankTransactions' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_AL_BranchPayslips' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_CreditCardPaymentTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_CustomerAddressTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_PayrollCollectorLinkHistoryTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_PayrollCollectorLinkTable' AS TableName, @PjectID as ProjectID 
UNION
SELECT 'JNTDatabase' AS DatabaseName, 'dbo' AS SchemaName, 'IDM_PayrollTable' AS TableName, @PjectID as ProjectID 
)
MERGE	cfg.SourceTables	AS target
USING	sourcetables		AS Source	ON	Target.Databasename = source.databasename
										AND Target.schemaname	= source.schemaname
										AND Target.tablename	= source.tablename
										AND	Target.ProjectID	= @PjectID
WHEN NOT MATCHED THEN
INSERT	(	tablename
		,	databasename
		,	schemaname
		,	ProjectID
		)
VALUES	(	source.tablename
		,	source.databasename
		,	source.schemaname
		,	source.ProjectID
		)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE;

-- //// JNT Landing /////////////////////////////////////////