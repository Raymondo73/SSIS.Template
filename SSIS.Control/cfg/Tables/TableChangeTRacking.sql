CREATE TABLE [cfg].[TableChangeTracking]
(
	[TableChangeTrackingID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [varchar](100) NULL,
	[SchemaName] [varchar](20) NULL,
	[TableName] [varchar](500) NULL,
	[ChangeTrackingID] [int] NULL,
	[LastUpdated] [datetime] NULL DEFAULT (getdate()),
	[PackageId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TableChangeTrackingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO;

ALTER TABLE [cfg].[TableChangeTracking]  WITH NOCHECK ADD  CONSTRAINT [FK_TableChangeTracking_Package] FOREIGN KEY([PackageId])
REFERENCES [cfg].[Packages] ([PackageID])
GO

ALTER TABLE [cfg].[TableChangeTracking] CHECK CONSTRAINT [FK_TableChangeTracking_Package]
GO