--This what we use to fix all SQL Server logins in a restored database, wrapped in a stored procedure. Run it in the restored database.

SET NOCOUNT ON
DECLARE CUSR CURSOR LOCAL STATIC FOR
SELECT u.name
FROM sysusers u
JOIN master.dbo.syslogins l ON l.name=u.name
WHERE u.sid!=l.sid AND u.issqluser=1
ORDER BY u.name

OPEN CUSR 
DECLARE @user SYSNAME
WHILE 1=1 BEGIN
FETCH NEXT FROM CUSR INTO @user
IF @@FETCH_STATUS!=0 BREAK

PRINT CHAR(13)+'*** Fixing User '+@user+' ...'
  EXEC sp_change_users_login 'auto_fix', @user
END
CLOSE CUSR DEALLOCATE CUSR 

--USE DATABASE
--GO

--EXEC sp_change_users_login 'update_one'
--,'databse username'
--,'loginname'
--GO 

select * from WCSEcurityAccess where idfWCSecurityKey is null and idfType='REPORT'