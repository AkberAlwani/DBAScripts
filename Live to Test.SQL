/******************************************************************************/
/*    Description:                                                            */
/*    Creates a full backup of a database to a location on the disk           */
/*                                                                            */
/*    Change you database names of NAS/TEST appropriately                   */
/*    Change the NAS_DAT_DEVICE_NAME                                        */
/*    Change the Backup and restore locations                                 */
/*    Change the Backup locations in EXEC xp_cmdshell for delete sequence     */
/******************************************************************************/
 
 
-- Declare Variable
Declare @CommentText varchar (100)
 
-- Backup the NAS Database.
set @CommentText = '---- Back up the database ----'
Print @CommentText
go
 
 
USE TWO
BACKUP DATABASE TWO
   TO DISK = 'D:\Backup\TWO.BAK'
   WITH INIT, stats = 5, buffercount = 1000, --COMPRESSION
   NAME = 'Full Backup of TWO'
 
---- detach database to force quit connections so the restore process succeeds
--Declare @CommentText varchar (100)
--set @CommentText = '---- Force Quit connections to TEST ----'
--Print @CommentText
--go


 -- Original script
 /*
ALTER DATABASE [TEST] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
EXEC master.dbo.sp_detach_db @dbname = N'TEST'
 */
 -- Alternate SCRIPT
ALTER DATABASE [YTWO] SET  Single_USER WITH ROLLBACK IMMEDIATE
ALTER DATABASE [YTWO] SET  Multi_USER WITH ROLLBACK IMMEDIATE

 
/* Shrink the Management Reporter datamart Database Transaction log to free space on drive F:*/
--Declare @CommentText varchar (100)
--set @CommentText = '---- Shrink the ManagementReporter DM Log ----'
--Print @CommentText
 
--USE [ManagementReporterDM]
--GO
--DBCC SHRINKFILE (N'ManagementReporterDM_log' , 0, TRUNCATEONLY)
 
/* Restore the TEST Database */
Declare @CommentText varchar (100)
set @CommentText = '---- Restore the TEST database ----'
Print @CommentText
go
 
select name FROM sys.database_files where type_desc = 'ROWS'
RESTORE DATABASE YTWO 
FROM DISK = 'D:\Backup\TWO.BAK'
WITH REPLACE,
        MOVE 'GPSTWODat.mdf' TO 'D:\MSSQL12.MSSQLSERVER\MSSQL\DATA\GPSYTWODAT.mdf', 
        MOVE 'GPSTWOLOG.ldf' TO 'D:\MSSQL12.MSSQLSERVER\MSSQL\DATA\GPSYTWOLOG.ldf'
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
 
EXEC xp_cmdshell 'del "D:\Backup\TWO.BAK"', NO_OUTPUT
 
/* Change TEST database options */
set @CommentText = '---- Configure database options and shrink log ----'
Print @CommentText
 
use YTWO
exec sp_changedbowner DYNSA
Update  DYNAMICS..SY01500 set CMPNYNAM = 'Fabrikam <YTWO>'  where INTERID = 'YTWO' 
 
ALTER DATABASE YTWO
SET RECOVERY simple

DBCC SHRINKFILE (N'GPSTWOLOG.ldf' , 0, TRUNCATEONLY)
 
 
/******************************************************************************/
/*    Description:    */
/*    Updates any table that contains a company ID or database name value    */
/*    with the proper values as they are stored in the DYNAMICS.dbo.SY01500 table    */
/*    */
/******************************************************************************/
 
-- Sort database ID's 
set @CommentText = '---- Fix YTWO GP database ID Records ----'
Print @CommentText
go
 
declare @cStatement varchar(255)
declare G_cursor CURSOR for
select case when UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID')
  then 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '+ cast(b.CMPANYID as char(3)) 
  else 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '''+ db_name()+'''' end
from INFORMATION_SCHEMA.COLUMNS a, DYNAMICS.dbo.SY01500 b
  where UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID','INTERID','DB_NAME','DBNAME')
    and b.INTERID = db_name() and COLUMN_DEFAULT is not null
 and rtrim(a.TABLE_NAME)+'-'+rtrim(a.COLUMN_NAME) <> 'SY00100-DBNAME'
  order by a.TABLE_NAME
set nocount on
OPEN G_cursor
FETCH NEXT FROM G_cursor INTO @cStatement
WHILE (@@FETCH_STATUS <> -1)
begin
  exec (@cStatement)
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
 
 
-- select INTERID, * from DYNAMICS..SY01500
--SCRIPT TO INSERT NAS RECORDS into TEST FA49900 & SY04800 AFTER EARLIER DELETION
set @CommentText = '---- Inserting corrected Fixed Assets setup info ----'
Print @CommentText
 
insert into YTWO..FA49900
(CMPANYID,ORGSEGMENT,ACCTSEGMENT,PROJSEGMENT,CORPBOOKINDX,USERDATAAUTOFMT,REQACCOUNT,USRFLD1PROMPT,USRFIELD1FMT,USRFLD2PROMPT,USRFIELD2FMT,USRFLD3PROMPT,USRFIELD3FMT,USRFLD4PROMPT,USRFIELD4FMT,USRFLD5PROMPT,USRFIELD5FMT,USRFLD6PROMPT,USRFIELD6FMT,USRFLD7PROMPT,USRFIELD7FMT,USRFLD8PROMPT,USRFIELD8FMT,USRFLD9PROMPT,USRFIELD9FMT,USRFLD10PROMPT,USRFIELD10FMT,USRFLD11PROMPT,USRFIELD11FMT,USRFLD12PROMPT,USRFIELD12FMT,USRFLD13PROMPT,USRFIELD13FMT,USRFLD14PROMPT,USRFIELD14FMT,USRFLD15PROMPT,USRFIELD15FMT,ListValidValues_1,ListValidValues_2,ListValidValues_3,ListValidValues_4,ListValidValues_5,ListValidValues_6,ListValidValues_7,ListValidValues_8,ListValidValues_9,ListValidValues_10,ValidDate_1,ValidDate_2,ValidDate_3,ValidDate_4,Post_Table_Delete_Option,PO_System_Used,AP_Post_Option,FA_Post_From_POP,POP_Post_Option,Include_Matching_Invoice,FA_Country,Auto_Add_Book_Info,Deflt_Asset_Lbl_from_ID,Validate_Custodian,DEPREXPACCTINDX,DEPRRESVACCTINDX,PRIORYRDEPRACCTINDX,ASSETCOSTACCTINDX,PROCEEDSACCTINDX,RECGAINLOSSACCTINDX,NONRECGAINLOSSACCTINDX,CLEARINGACCTINDX,NOTEINDX,LASTMNTDDATE,LASTMNTDTIME,LASTMNTDUSERID)
select
'4',ORGSEGMENT,ACCTSEGMENT,PROJSEGMENT,CORPBOOKINDX,USERDATAAUTOFMT,REQACCOUNT,USRFLD1PROMPT,USRFIELD1FMT,USRFLD2PROMPT,USRFIELD2FMT,USRFLD3PROMPT,USRFIELD3FMT,USRFLD4PROMPT,USRFIELD4FMT,USRFLD5PROMPT,USRFIELD5FMT,USRFLD6PROMPT,USRFIELD6FMT,USRFLD7PROMPT,USRFIELD7FMT,USRFLD8PROMPT,USRFIELD8FMT,USRFLD9PROMPT,USRFIELD9FMT,USRFLD10PROMPT,USRFIELD10FMT,USRFLD11PROMPT,USRFIELD11FMT,USRFLD12PROMPT,USRFIELD12FMT,USRFLD13PROMPT,USRFIELD13FMT,USRFLD14PROMPT,USRFIELD14FMT,USRFLD15PROMPT,USRFIELD15FMT,ListValidValues_1,ListValidValues_2,ListValidValues_3,ListValidValues_4,ListValidValues_5,ListValidValues_6,ListValidValues_7,ListValidValues_8,ListValidValues_9,ListValidValues_10,ValidDate_1,ValidDate_2,ValidDate_3,ValidDate_4,Post_Table_Delete_Option,PO_System_Used,AP_Post_Option,FA_Post_From_POP,POP_Post_Option,Include_Matching_Invoice,FA_Country,Auto_Add_Book_Info,Deflt_Asset_Lbl_from_ID,Validate_Custodian,DEPREXPACCTINDX,DEPRRESVACCTINDX,PRIORYRDEPRACCTINDX,ASSETCOSTACCTINDX,PROCEEDSACCTINDX,RECGAINLOSSACCTINDX,NONRECGAINLOSSACCTINDX,CLEARINGACCTINDX,NOTEINDX,LASTMNTDDATE,LASTMNTDTIME,LASTMNTDUSERID
from TWO..FA49900
 
INSERT INTO YTWO..SY04800
(CMPANYID,INETPRMPTS_1,INETPRMPTS_2,INETPRMPTS_3,INETPRMPTS_4,INETPRMPTS_5,INETPRMPTS_6,INETPRMPTS_7,INETPRMPTS_8)
SELECT
'4',INETPRMPTS_1,INETPRMPTS_2,INETPRMPTS_3,INETPRMPTS_4,INETPRMPTS_5,INETPRMPTS_6,INETPRMPTS_7,INETPRMPTS_8
FROM TWO..SY04800
 
update YTWO..SY00100 set DBNAME = 'DYNAMICS' 
go


Declare @CommentText varchar (100)
set @CommentText = '---- Reconfigure Analytical data ----'
Print @CommentText
use YTWO
go 


/*******************************************************************************************
NAME: AA_Update_AAG00102.sql
 
DESCRIPTION:
	Updates the AAG00102 with the highest values from the Analytical Accounting
	transaction tables, and tree, dimension, and code setup tables.
 
 
INSTRUCTIONS:
	1. Make a full backup of the DYNAMICS database.
	2. Run the script against the company database.
 
 
GP VERSIONS: 10.0, 2010, 2013
 
REVISION HISTORY:
	Date              Who             Comments
	-------------     --------------    --------------------------------------------------------
	04/12/2005        v-villaw        Created initial script
	02/28/2011        dspecht            Added additional tables
	09/10/2012        kenhub            Added consideration for the SY00800 table
 
*********************************************************************************************/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[aagUpdateAAG00102]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[aagUpdateAAG00102]
GO
 
create     procedure aagUpdateAAG00102
as
begin
	set nocount on    
	declare @CMPANYID    smallint,
		@maxValue    int
 	select    @maxValue = 0
	select  distinct @CMPANYID = CMPANYID from DYNAMICS.dbo.SY01500 where INTERID = DB_NAME()
 	select @maxValue = max(aaGLHdrID) from AAG30000
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 30000 and CMPANYID = @CMPANYID
	select @maxValue = max(aaSubLedgerHdrID) from AAG20000
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 20000 and CMPANYID = @CMPANYID
	select @maxValue = max(aaGLWorkHdrID) from AAG10000
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 10000 and CMPANYID = @CMPANYID
	select @maxValue = max(aaTreeID) from AAG00600
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 600 and CMPANYID = @CMPANYID
	select @maxValue = max(aaTrxDimID) from AAG00400
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 400 and CMPANYID = @CMPANYID
	select @maxValue = max(aaTrxDimCodeID) from AAG00401
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 401 and CMPANYID = @CMPANYID
	select @maxValue = max(aaDateID) from AAG00500
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 500 and CMPANYID = @CMPANYID
	select @maxValue = (select MAX(MaxValue) as MaxOverAll from
	(select MAX(AAG00800.aaAliasID) as MaxValue from AAG00800 
		Union ALL
		select MAX(AAG00201.aaAcctclassID) as MaxValue from AAG00201) AS Subquery)
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 201 and CMPANYID = @CMPANYID
		select @maxValue = max(aaBudgetTreeID) from AAG00900
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 900 and CMPANYID = @CMPANYID
	select @maxValue = max(aaBudgetID) from AAG00903
	if @maxValue > 0
		update DYNAMICS..AAG00102 set aaRowID = @maxValue where aaTableID = 903 and CMPANYID = @CMPANYID
 	set nocount off    
end
GO
 
exec aagUpdateAAG00102
drop procedure aagUpdateAAG00102


--  WorkPlace option disabled
use YTWO
go 

-- select * from TEST..WCInstall 

UPDATE YTWO..WCInstall SET idfDatabaseName = 'YTWO'
 
Declare @CommentText varchar (100)
set @CommentText = '---- Disable Workplace logins for most users in YTWO  ----'
Print @CommentText
 
--Script to inactivate users out of the TEST company except for select few
update wcsecurity set idfflagactive = 0
update wcsecurity set idfflagactive = 1
where idfSecurityID In ('sa', 'user1', 'user2', 'user3')

-- select idfdescription, idfSecurityID,idffLAGaCTIVE, * from wcsecurity WHERE idffLAGaCTIVE = 1 order by 2
-- select idfdescription, idfSecurityID,idffLAGaCTIVE, * from wcsecurity order by 2
 
set @CommentText = '---- Configure Workplace in YTWO ----'
Print @CommentText
go
 
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
 
set @CommentText = '---- Run PTInstaller on YTWO  ----'
Print @CommentText
go
 
-- exec spPTIFixSQLGrant
EXEC xp_cmdshell '\\wpman\D$\WorkPlace_Instancs\WorkPlace2\SQL\PTINETInstaller\PTINETInstaller.exe "/COMMANDFILE=\\wpman\D$\WorkPlace_Instancs\WorkPlace2\SQL\WorkPlace.xml" "/SERVERNAME=WPMAN" "/USERNAME=sa" "/PASSWORD=sasa" "/CONTROLDB=DYNAMICS" "/COMPANYDB=YTWO" "/LOGPATH=\\wpman\D$\WorkPlace_Instancs\WorkPlace2\SQL\PTINETInstaller\Log\AutoGPSQL.log"'
go
 
Declare @CommentText varchar (100)
set @CommentText = '---- Process complete ----'
Print @CommentText
go

