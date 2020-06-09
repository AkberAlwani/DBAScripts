-- Declare Variable
Declare @CommentText varchar (100)
-- SELECT * from sys.database_files
-- Backup the TWO Database.
set @CommentText = '---- Back up the database ----'
Print @CommentText
go
 
USE TWO
BACKUP DATABASE TWO
   TO DISK = 'C:\Backup\TWO.BAK'
   --WITH INIT, COMPRESSION, stats = 5, buffercount = 1000,
   --WITH INIT NAME = 'Full Backup of TWO'
 
-- detach database to force quit connections so the restore process succeeds
Declare @CommentText varchar (100)
set @CommentText = '---- Force Quit connections to YTWO ----'
Print @CommentText
go
 
ALTER DATABASE [YTWO] SET  Single_USER WITH ROLLBACK IMMEDIATE
ALTER DATABASE [YTWO] SET  Multi_USER WITH ROLLBACK IMMEDIATE
-- EXEC master.dbo.sp_detach_db @dbname = N'YTWO'
 

 
/* Restore the YTWO Database */
Declare @CommentText varchar (100)
set @CommentText = '---- Restore the YTWO database ----'
Print @CommentText
go
--select * from sys.database_files
select name FROM sys.database_files where type_desc = 'ROWS'
RESTORE DATABASE YTWO 
FROM DISK = 'C:\Backup\TWO.BAK'
WITH REPLACE,
        MOVE 'GPSTWODAT.mdf' TO 'D:\MSSQL12.MSSQLSERVER\MSSQL\DATA\GPSYTWODat.ldf', 
        MOVE 'GPSTWOLOG.ldf' TO 'D:\MSSQL12.MSSQLSERVER\MSSQL\DATA\GPSYTWOLog.ldf'
go
 
-- enable xp_cmdshell
Declare @CommentText varchar (100)
set @CommentText = '---- Enable SQL cmdshell ----'
Print @CommentText
 
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE
 
/* Delete the backup file now that it has served its purpose */
set @CommentText = '---- Delete the backup ----'
Print @CommentText
 
EXEC xp_cmdshell 'del "C:\Backup\TWO.BAK"', NO_OUTPUT
 
/* Change YTWO database options */
set @CommentText = '---- Configure database options and shrink log ----'
Print @CommentText


/* Update the company name in the Company master databse to include the date */
select INTERID, CMPNYNAM, * from DYNAMICS..SY01500 where INTERID = 'YTWO'
select INTERID, CMPNYNAM, * from DYNAMICS..SY01500 where INTERID = 'TWO'
Update  DYNAMICS..SY01500 set CMPNYNAM = 'Y Fabrikam, Inc.'  where INTERID = 'YTWO'
select INTERID, CMPNYNAM, * from DYNAMICS..SY01500 where INTERID = 'YTWO'
 
use YTWO
exec sp_changedbowner DYNSA
-- Update  DYNAMICS..SY01500 set CMPNYNAM = 'z – Clothing Australia <TEST>'  where INTERID = 'YTWO' 
 
ALTER DATABASE YTWO
SET RECOVERY simple
 
DBCC SHRINKFILE (N'GPSTWOLog.ldf' , 0, TRUNCATEONLY)
 
-- Sort database ID's 
set @CommentText = '---- Fix YTWO GP database ID Records ----'
Print @CommentText
go
 
/******************************************************************************/
/*    Description:    */
/*    Updates any table that contains a company ID or database name value    */
/*    with the proper values as they are stored in the DYNAMICS.dbo.SY01500 table    */
/*    */
/******************************************************************************/
 
declare @cStatement varchar(255)
declare G_cursor CURSOR for
select case when UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID')
  then 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '+ cast(b.CMPANYID as char(3)) 
  else 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '''+ db_name()+'''' end
from INFORMATION_SCHEMA.COLUMNS a, DYNAMICS.dbo.SY01500 b
  where UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID','INTERID','DB_NAME','DBNAME') and  a.TABLE_NAME <> 'BP70510'
    and b.INTERID = db_name() and COLUMN_DEFAULT is not null
   and rtrim(a.TABLE_NAME)+'-'+rtrim(a.COLUMN_NAME) <> 'SY00100-DBNAME'
  order by a.TABLE_NAME 
set nocount on
OPEN G_cursor
FETCH NEXT FROM G_cursor INTO @cStatement
WHILE (@@FETCH_STATUS <> -1)
begin
  exec (@cStatement)
 -- print (@cStatement)
  FETCH NEXT FROM G_cursor INTO @cStatement
end
close G_cursor
DEALLOCATE G_cursor
set nocount off
go
 
Declare @CommentText varchar (100)
set @CommentText = '---- Fix Max Note Index ----'
Print @CommentText
 
/* Fix Note Index in DYNAMICS..SY01500 to stop cross linked notes */
USE YTWO
go
/************ FindMaxNoteIndex.SQL  ***********************************
** Purpose:
** Find the max value of NOTEINDX from all tables including Project Accounting. 
** This script must be run against the company in which the notes are incorrect.
** it will automatically update your SY01500 for you to the correct next note index.
**
*/
 
if exists (select * from tempdb..sysobjects where name = '##GPSMaxNote')
drop table dbo.##GPSMaxNote
set nocount on
create table ##GPSMaxNote (MaxNoteIndex numeric(19,5) null)
go
 
-----------------------
declare @cStatement varchar(255) /* Value from the t_cursor */
declare @noteidx numeric(19,5)
declare @database as varchar(5)
set @database = cast(db_name() as varchar(5))
 
/* Get the tables that have a column name of NOTEINDX. */
declare T_cursor cursor for
select 'declare @NoteIndex numeric(19,5) select @NoteIndex = max(' +c.name+ ') from ' + o.name + ' insert ##GPSMaxNote values(@NoteIndex)'
from sysobjects o, syscolumns c
where o.id = c.id
and o.type = 'U'
and (c.name = 'NOTEINDX' or c.name like '%noteidx%' or c.name like '%niteidx%' or c.name ='NOTEINDX2')
 
 
/* Ok, we have the list of tables. Now get the max value of NOTEINDX from each table. */
open T_cursor
fetch next from T_cursor into @cStatement
while (@@fetch_status <> -1)
begin
exec (@cStatement)
fetch next from T_cursor into @cStatement
end
deallocate T_cursor
 
 
/* Display Maximum Note Index */
select 'Max Note Index:', max(MaxNoteIndex) from ##GPSMaxNote where MaxNoteIndex is not null
 
/* Update Next Note Index */
use DYNAMICS
set @noteidx = (select max(MaxNoteIndex) from ##GPSMaxNote where MaxNoteIndex is not null)
update SY01500 set NOTEINDX = (@noteidx + 1.0) where INTERID=@database
set nocount off
go
 
 
Declare @CommentText varchar (100)
set @CommentText = '---- Remove Fixed Assets setup option ----'
Print @CommentText
 
delete YTWO..SY04800
delete YTWO..FA49900
 
 
-- select INTERID, * from DYNAMICS..SY01500 where INTERID = 'YTWO'
--SCRIPT TO INSERT TWO RECORDS into YTWO FA49900 & SY04800 AFTER EARLIER DELETION
set @CommentText = '---- Inserting corrected Fixed Assets setup info ----'
Print @CommentText
 
insert into YTWO..FA49900
(CMPANYID,ORGSEGMENT,ACCTSEGMENT,PROJSEGMENT,CORPBOOKINDX,USERDATAAUTOFMT,REQACCOUNT,USRFLD1PROMPT,USRFIELD1FMT,USRFLD2PROMPT,USRFIELD2FMT,USRFLD3PROMPT,USRFIELD3FMT,USRFLD4PROMPT,USRFIELD4FMT,USRFLD5PROMPT,USRFIELD5FMT,USRFLD6PROMPT,USRFIELD6FMT,USRFLD7PROMPT,USRFIELD7FMT,USRFLD8PROMPT,USRFIELD8FMT,USRFLD9PROMPT,USRFIELD9FMT,USRFLD10PROMPT,USRFIELD10FMT,USRFLD11PROMPT,USRFIELD11FMT,USRFLD12PROMPT,USRFIELD12FMT,USRFLD13PROMPT,USRFIELD13FMT,USRFLD14PROMPT,USRFIELD14FMT,USRFLD15PROMPT,USRFIELD15FMT,ListValidValues_1,ListValidValues_2,ListValidValues_3,ListValidValues_4,ListValidValues_5,ListValidValues_6,ListValidValues_7,ListValidValues_8,ListValidValues_9,ListValidValues_10,ValidDate_1,ValidDate_2,ValidDate_3,ValidDate_4,Post_Table_Delete_Option,PO_System_Used,AP_Post_Option,FA_Post_From_POP,POP_Post_Option,Include_Matching_Invoice,FA_Country,Auto_Add_Book_Info,Deflt_Asset_Lbl_from_ID,Validate_Custodian,DEPREXPACCTINDX,DEPRRESVACCTINDX,PRIORYRDEPRACCTINDX,ASSETCOSTACCTINDX,PROCEEDSACCTINDX,RECGAINLOSSACCTINDX,NONRECGAINLOSSACCTINDX,CLEARINGACCTINDX,NOTEINDX,LASTMNTDDATE,LASTMNTDTIME,LASTMNTDUSERID)
select
'55',ORGSEGMENT,ACCTSEGMENT,PROJSEGMENT,CORPBOOKINDX,USERDATAAUTOFMT,REQACCOUNT,USRFLD1PROMPT,USRFIELD1FMT,USRFLD2PROMPT,USRFIELD2FMT,USRFLD3PROMPT,USRFIELD3FMT,USRFLD4PROMPT,USRFIELD4FMT,USRFLD5PROMPT,USRFIELD5FMT,USRFLD6PROMPT,USRFIELD6FMT,USRFLD7PROMPT,USRFIELD7FMT,USRFLD8PROMPT,USRFIELD8FMT,USRFLD9PROMPT,USRFIELD9FMT,USRFLD10PROMPT,USRFIELD10FMT,USRFLD11PROMPT,USRFIELD11FMT,USRFLD12PROMPT,USRFIELD12FMT,USRFLD13PROMPT,USRFIELD13FMT,USRFLD14PROMPT,USRFIELD14FMT,USRFLD15PROMPT,USRFIELD15FMT,ListValidValues_1,ListValidValues_2,ListValidValues_3,ListValidValues_4,ListValidValues_5,ListValidValues_6,ListValidValues_7,ListValidValues_8,ListValidValues_9,ListValidValues_10,ValidDate_1,ValidDate_2,ValidDate_3,ValidDate_4,Post_Table_Delete_Option,PO_System_Used,AP_Post_Option,FA_Post_From_POP,POP_Post_Option,Include_Matching_Invoice,FA_Country,Auto_Add_Book_Info,Deflt_Asset_Lbl_from_ID,Validate_Custodian,DEPREXPACCTINDX,DEPRRESVACCTINDX,PRIORYRDEPRACCTINDX,ASSETCOSTACCTINDX,PROCEEDSACCTINDX,RECGAINLOSSACCTINDX,NONRECGAINLOSSACCTINDX,CLEARINGACCTINDX,NOTEINDX,LASTMNTDDATE,LASTMNTDTIME,LASTMNTDUSERID
from TWO..FA49900
 
INSERT INTO YTWO..SY04800
(CMPANYID,INETPRMPTS_1,INETPRMPTS_2,INETPRMPTS_3,INETPRMPTS_4,INETPRMPTS_5,INETPRMPTS_6,INETPRMPTS_7,INETPRMPTS_8)
SELECT
'55',INETPRMPTS_1,INETPRMPTS_2,INETPRMPTS_3,INETPRMPTS_4,INETPRMPTS_5,INETPRMPTS_6,INETPRMPTS_7,INETPRMPTS_8
FROM TWO..SY04800
 
update YTWO..SY00100 set DBNAME = 'DYNAMICS' 
go



--use YTWO
--go
--exec sp_change_users_login 'Auto_Fix', 'WPEAICUser'
 /* 
/*  Start of Paramount Edits 
set @CommentText = '---- Configure Workplace in YTWO ----'
Print @CommentText
go

--Script to inactivate users out of the YTWO company except for select few
update wcsecurity set idfflagactive = 0
update wcsecurity set idfflagactive = 1
where idfSecurityID In ('Emirateslr\pa', 'Cotton-on\XXXXXXXX', 'Cotton-on\XXXXXXXX', 'Cotton-on\XXXXXXXX')
 
 
 
exec spPTICompanyInit
exec spPTIFixDB
IF EXISTS (SELECT TOP 1 1 FROM sys.procedures WHERE name = 'spPTIFixPrimaryKeySequence') 
BEGIN
	EXEC spPTIFixPrimaryKeySequence 1
	EXEC spPTIFixPrimaryKey
END
ELSE EXEC spPTIFixPrimaryKey
 
Declare @CommentText varchar (100)
set @CommentText = '---- Disable Workplace email in YTWO ----'
Print @CommentText
 
update WCSystem set idfFlagMail = 0
 
set @CommentText = '---- Run PTInstaller on YTWO ----'
Print @CommentText
go
 
-- exec spPTIFixSQLGrant
EXEC xp_cmdshell '\\Cog-me1-gpwb-01\wp$\WorkPlaceEAIC\SQL\PTINETInstaller\PTINETInstaller.exe "/COMMANDFILE=\\Cog-me1-gpwb-01\wp$\WorkPlaceEAIC\SQL\WorkPlace.xml" "/SERVERNAME=GPDB" "/USERNAME=WPMaintenance" "/PASSWORD=nodeb84them" "/CONTROLDB=xxxxxx" "/COMPANYDB=xxxxxxx" "/LOGPATH=\\Cog-me1-gpwb-01\wp$\WorkPlaceEAIC\SQL\PTINETInstaller\Log\"'

 


End Paramount edit section   
*/

*/

 
-- end of Live to YTWO
Declare @CommentText varchar (100)
set @CommentText = '---- Process complete ----'
Print @CommentText











