/* Insert lists of SSIS package connections that will be used in the BIML automation */

DECLARE @Connections TABLE
(		
		DBConnectionID		INT	IDENTITY(1, 1)	NOT NULL
,		ConnectionName		VARCHAR(255)		NOT NULL
,		ServerName			VARCHAR(255)		NOT NULL
,		DatabaseName		VARCHAR(255)		NOT NULL
,		Provider			VARCHAR(255)		NOT NULL
,		Timeout				SMALLINT			NOT NULL
,		DefaultConnection	BIT					NOT NULL
,		ControlConnection	BIT					NOT NULL
,		ProjectID			INT					NOT NULL
,		PRIMARY KEY CLUSTERED (DBConnectionID ASC)                     
)

DECLARE @PID INT

-- /// JNT Landing /////////////////////////////////////////////////////////////
SELECT	@PID = ProjectID
FROM	cfg.Projects
WHERE	ProjectName = 'JNT Landing';

INSERT	@Connections
VALUES	(N'SSISControl', N'LocalHost', N'SSISControl', N'SQLOLEDB', 0, 0, 1, @PID)
,		(N'JNTSource', N'LocalHost', N'JNTDatabase', N'SQLOLEDB', 0, 0, 0, @PID)
,		(N'JNTLanding', N'LocalHost', N'JNTLanding', N'SQLOLEDB', 0, 0, 0, @PID);
-- /// JNT Landing /////////////////////////////////////////////////////////////



MERGE	cfg.DBConnection	AS t
USING	(
			SELECT		TOP 100 PERCENT *
			FROM		@Connections
			ORDER BY	DBConnectionID
		)	AS s
ON		s.DBConnectionID		= t.DBConnectionID
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