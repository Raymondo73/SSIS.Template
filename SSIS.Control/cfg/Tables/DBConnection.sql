CREATE TABLE [cfg].[DBConnection]
(
		[DBConnectionID]	INT			IDENTITY(1, 1) NOT NULL
,		[ConnectionName]	VARCHAR(50) NULL
,		[ServerName]		VARCHAR(50) NULL
,		[DatabaseName]		VARCHAR(50) NULL
,		[Provider]			VARCHAR(50) CONSTRAINT [DF_Connection_Provider] DEFAULT ('SQLOLEDB') NULL
,		[Timeout]			SMALLINT	CONSTRAINT [DF_Connection_Timeout] DEFAULT ((0)) NULL
,		[DefaultConnection] BIT			CONSTRAINT [DF_Connection_DefualtConnection] DEFAULT ((0)) NULL
,		[ControlConnection] BIT			CONSTRAINT [DF_Connection_ControlConnection] DEFAULT ((0)) NULL
,		[ConnectionString]	AS (((((((('Data Source=' + [ServerName]) + ';Initial Catalog=') + [DatabaseName]) + ';Provider=') + [Provider]) + ';Integrated Security=SSPI;Connect Timeout=') + CAST([Timeout] AS CHAR(3))) + ';Auto Translate=False;')
,		[ProjectID]			INT
,		CONSTRAINT [PK_Connection_ConnectionID] PRIMARY KEY CLUSTERED
		(
				[DBConnectionID] ASC
		)
,		CONSTRAINT [FK_DBConnection_Projects] FOREIGN KEY (ProjectID) REFERENCES cfg.Projects(ProjectID)
);
