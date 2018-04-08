CREATE TABLE [audit].[SSISPkgInstance] (
    [PkgInstanceID] INT				IDENTITY (1, 1) NOT NULL,
    [AppInstanceID] INT				NOT NULL,
    [PackageID]     INT				NOT NULL,
    [StartDateTime] DATETIME		NOT NULL	DEFAULT GETUTCDATE(),
    [EndDateTime]   DATETIME		NULL,
    [Status]        VARCHAR (12)	NULL,
	LandCount		INT				NULL,
	UpdateCount		INT				NULL,
	InsertCount		INT				NULL,
	DeleteCount		INT				NULL,
    CONSTRAINT [PK_SSISPkgInstance] PRIMARY KEY CLUSTERED ([PkgInstanceID] ASC)
);