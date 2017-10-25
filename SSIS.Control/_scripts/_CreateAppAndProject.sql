/*
Below sets up core SSIS config details.  Repeat for each Application / Project

*/

DECLARE @AppId		INT				= 0
,		@ProjId		INT				= 0
,		@AppName	VARCHAR(256)	= 'JNT Landing'
,		@ProjName	VARCHAR(256)	= 'JNT Landing';

-- JNT Landing ////////////////////////////////////////////////////
-- Set up core entries for Application and Project
EXEC cfg.Add_SSISApplication		@AppName, @AppId OUTPUT;
EXEC cfg.Add_SSISProject			@ProjName, @ProjId OUTPUT;
EXEC cfg.Add_SSISApplicationProject	@AppId,	@ProjId, 10;		-- NB change last param if many projects to an App. Inc by 10 so gaps exist
-- JNT Landing ////////////////////////////////////////////////////
