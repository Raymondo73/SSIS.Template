/* Insert lists of SSIS package connections that will be used in the BIML automation */

DECLARE @Connections TABLE
(		
		DBConnectionID		INT	IDENTITY(1, 1)	NOT NULL
,		ConnectionName		VARCHAR(255)		NOT NULL
,		ServerName			VARCHAR(255)		NOT NULL
,		DatabaseName		VARCHAR(255)		NOT NULL
,		[Provider]			VARCHAR(255)		NOT NULL
,		[Timeout]			SMALLINT			NOT NULL
,		DefaultConnection	BIT					NOT NULL
,		ControlConnection	BIT					NOT NULL
,		ProjectID			INT					NOT NULL
,		PRIMARY KEY CLUSTERED (DBConnectionID ASC)                     
)

DECLARE @ProID			INT
,		@ProjCount		INT = 1
,		@SrcDB			VARCHAR(100)
,		@LandDB			VARCHAR(100);

SELECT TOP 1	@ProId		= ProjectId
,				@SrcDB		= DatabaseName
,				@LandDB		= LandingDatabaseName
FROM			cfg.SourceTables
ORDER BY		ProjectId;

WHILE @ProjCount != 0
BEGIN

	INSERT	@Connections
	VALUES	(N'SSISControl', N'LocalHost', N'SSISControl', N'SQLNCLI11.1', 0, 0, 1, @ProID)
	,		(N'Source', N'LocalHost', @SrcDB, N'SQLNCLI11.1', 0, 0, 0, @ProID)
	,		(N'Destination', N'LocalHost', @LandDB, N'SQLNCLI11.1', 0, 0, 0, @ProID);

	SELECT TOP 1	@ProId		= ProjectId
	,				@SrcDB		= DatabaseName
,					@LandDB		= LandingDatabaseName
	FROM			cfg.SourceTables
	WHERE			ProjectId			> @ProjectId
	AND				DatabaseName		!=	@SrcDB
	AND				LandingDatabaseName	!= @LandDB
	ORDER BY		ProjectId;

	SET @ProjCount = @@ROWCOUNT;

END

MERGE	cfg.DBConnection	AS t
USING	(
		SELECT		TOP 100 PERCENT *
		FROM		@Connections
		ORDER BY	DBConnectionID
		)	AS s
ON		s.DBConnectionID	= t.DBConnectionID
AND		s.ProjectID			= t.ProjectID	
WHEN MATCHED	
THEN UPDATE
SET		t.ConnectionName	= s.ConnectionName
,		t.ServerName		= s.ServerName
,		t.DatabaseName		= s.DatabaseName
,		t.[Provider]		= s.[Provider]
,		t.[Timeout]			= s.[Timeout]
,		t.DefaultConnection	= s.DefaultConnection
,		t.ControlConnection	= s.ControlConnection
,		t.ProjectID			= s.ProjectID
WHEN NOT MATCHED
THEN INSERT (	ConnectionName
			,	ServerName
			,	DatabaseName
			,	[Provider]
			,	[Timeout]
			,	DefaultConnection
			,	ControlConnection
			,	ProjectID
			)
VALUES		(	s.ConnectionName
			,	s.ServerName
			,	s.DatabaseName
			,	s.[Provider]
			,	s.[Timeout]
			,	s.DefaultConnection
			,	s.ControlConnection
			,	s.ProjectID
			)
WHEN NOT MATCHED BY SOURCE
THEN DELETE;
