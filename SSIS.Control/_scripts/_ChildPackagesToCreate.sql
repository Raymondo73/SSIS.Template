DECLARE @AppId				INT = 0
,		@ProjectId			INT = 0
,		@PackageId			INT = 0
,		@ExecutionOrder		INT = 0
,		@AppName			VARCHAR(256) = 'Satsuma Staging BPS'
,		@ProjectName		VARCHAR(256) = 'Satsuma Staging BPS';

-- Set up core entries for Application and Project
EXEC cfg.Add_SSISApplication @AppName, @AppId OUTPUT;

EXEC cfg.Add_SSISProject @ProjectName, @ProjectId OUTPUT;

EXEC cfg.Add_SSISApplicationProject	@AppId,	@ProjectId,	10;

/*
	@PackageName		VARCHAR (255)
,	@SourceTable		VARCHAR (255)
,	@LandingTable		VARCHAR (255)
,	@DestinationTable	VARCHAR (255)
,	@SelectProcedure	VARCHAR (255)
,	@MergeProcedure		VARCHAR (255)
*/


-- add child packages with execution order and streams
SET @ExecutionOrder += 10;
EXEC @PackageId = cfg.Add_SSISPackage 'EDA_TENANT1.ADDRESS.dtsx', 'EDA_TENANT1.ADDRESS', 'Landing.ADDRESS', 'EDA_TENANT1.ADDRESS', 'etl.Select_EDA_TENANT1_ADDRESS_ByCTID', 'etl.Merge_EDA_TENANT1_Address';	
EXEC cfg.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 1;

SET @ExecutionOrder += 10;
EXEC @PackageId = cfg.Add_SSISPackage 'EDA_TENANT1.BSB_7_1_SPA.dtsx', 'EDA_TENANT1.BSB_7_1_SPA', 'Landing.BSB_7_1_SPA', 'EDA_TENANT1.BSB_7_1_SPA', 'etl.Select_EDA_TENANT1_ BSB_7_1_SPA_By_CTID', 'etl.Merge_EDA_TENANT1_BSB_7_1_SPA';	
EXEC cfg.Add_SSISProjectPackage @ProjectId, @PackageId, @ExecutionOrder, 'I', 'F', 2;
