update WCSecurity set idfFlagActiveTE=0,idfFlagActivePA=0,idfFlagActiveExp=1,idfFlagActiveRQ=0
update WCSecurity set idfFlagActiveTE=0,idfFlagActivePA=0,idfFlagActiveExp=0

update WCSecurity set idfFlagActivePA=0
select idfPTICompanyKey,idfSecurityID from PTIMaster..PTISecurity  where idfPTICompanyKey=2
delete PTIMaster..PTISecurity  where idfPTICompanyKey=2 and idfSecurityID='sa'
delete PTIMaster..PTISecurity where idfSecurityID<>'sa'



update WCSecurity set idfFlagActiveRQ=0
delete PTIMaster..PTISecurity where idfModule in ('REQUISITION')

update WCSecurity set idfFlagActiveEXP=0
delete PTIMaster..PTISecurity where idfModule in ('EXPENSE')
update WCSecurity set idfFlagActivePA=0
delete PTIMaster..PTISecurity where idfModule in ('PROJECT')
update WCSecurity set idfFlagActiveTE=0
delete PTIMaster..PTISecurity where idfModule in ('TIME')
update WCSecurity set idfFlagActiveHC=0
delete PTIMaster..PTISecurity where idfModule in ('HANDHELD')
update WCSecurity set idfFlagActiveEmpl=0
delete PTIMaster..PTISecurity where idfModule in ('EMPLOYEE')


delete from PTIMaster..PTINETSessionHdr

EXeC spWCSecurityAccessEffectiveSync

DECLARE @dbname sysname, @days int
SET @dbname = 'TWO' --substitute for whatever database name you want
SET @days = -30 --previous number of days, script will default to 30
SELECT
 rsh.destination_database_name AS [Database],
 rsh.user_name AS [Restored By],
 CASE WHEN rsh.restore_type = 'D' THEN 'Database'
  WHEN rsh.restore_type = 'F' THEN 'File'
  WHEN rsh.restore_type = 'G' THEN 'Filegroup'
  WHEN rsh.restore_type = 'I' THEN 'Differential'
  WHEN rsh.restore_type = 'L' THEN 'Log'
  WHEN rsh.restore_type = 'V' THEN 'Verifyonly'
  WHEN rsh.restore_type = 'R' THEN 'Revert'
  ELSE rsh.restore_type 
 END AS [Restore Type],
 rsh.restore_date AS [Restore Started],
 bmf.physical_device_name AS [Restored From], 
 rf.destination_phys_name AS [Restored To]
FROM msdb.dbo.restorehistory rsh
 INNER JOIN msdb.dbo.backupset bs ON rsh.backup_set_id = bs.backup_set_id
 INNER JOIN msdb.dbo.restorefile rf ON rsh.restore_history_id = rf.restore_history_id
 INNER JOIN msdb.dbo.backupmediafamily bmf ON bmf.media_set_id = bs.media_set_id
WHERE rsh.restore_date >= DATEADD(dd, ISNULL(@days, -30), GETDATE()) --want to search for previous days
AND destination_database_name = ISNULL(@dbname, destination_database_name) --if no dbname, then return all
ORDER BY rsh.restore_history_id DESC
GO

spWCSecurityAccessEffectiveSync

delete PTImaster..PTILicenseAttr




select * from PTIMaster..PTICompany
delete PTIMaster..PTICompany where idfDBName<>'WPECompany_1813'
select * into PTIMaster..PTICompany_bak from PTIMaster..PTICompany