USE [TWO]
GO
/****** Object:  StoredProcedure [dbo].[spPTISQLRevokeAccess]    Script Date: 1/16/2019 1:11:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Paramount Technologies, Inc. $Version: WorkPlace_08.02.00 $  - $Revision: 4 $ $Modtime: 3/01/06 2:00p $
ALTER PROCEDURE [dbo].[spPTISQLRevokeAccess]
 @xstridfSecurityID		VARCHAR(255) 	
AS
DECLARE 
 @nExistsInAnotherDB 	INT
,@strDBName 		VARCHAR(255)
,@strRemoveSQL		NVARCHAR(4000)
,@strRemoveTemp 	NVARCHAR(4000)
-- 
SET NOCOUNT ON
--
-- ---------------------------------------------------------------------------------------------------------------------------------
-- Look to see if user is in another company db, if yes then only remove from this db, else remove from Control and PTIMaster.
-- ---------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT TOP 1 S.idfSecurityID,C.idfDBName
		FROM PTIMaster..PTISecurity S (NOLOCK)
			INNER JOIN PTIMaster..PTICompany C ON S.idfPTICompanyKey = C.idfPTICompanyKey AND C.idfDBName <> DB_NAME()
		WHERE idfSecurityID = @xstridfSecurityID)
	SELECT @nExistsInAnotherDB = 1
ELSE
	SELECT @nExistsInAnotherDB = 0

-- CDB 1/31/05 - loop through each db to see if user has access to something other than WorkPlace and possibly another db.
DECLARE curSysDatabases INSENSITIVE CURSOR FOR
SELECT name FROM master..sysdatabases WHERE status & 512 = 0 AND status & 32 = 0 AND status & 64 = 0 AND status & 128 = 0 AND status & 256 = 0 
and name = DB_NAME() 
ORDER BY name

SELECT @strRemoveSQL = '
	-- See if user is in this db.
	IF EXISTS(SELECT TOP 1 1 FROM [{0}].dbo.sysusers (NOLOCK) WHERE name = @xstridfSecurityID) BEGIN
		-- Find WorkPlace Role the user is member of.
		DECLARE @strsysusers_name VARCHAR(255)

		SELECT @strsysusers_name = role.name 
		FROM [{0}].dbo.sysusers u (NOLOCK)
			INNER JOIN [{0}].dbo.sysmembers m (NOLOCK) ON u.uid = m.memberuid
			INNER JOIN [{0}].dbo.sysusers role (NOLOCK) ON role.uid = m.groupuid AND role.issqlrole = 1 AND role.name IN (''PTIWorkPlaceUser'',''PTIWorkPlaceAdmin'') 
		WHERE u.name = @xstridfSecurityID
			
		IF (@@ROWCOUNT > 0) BEGIN
			IF (@strsysusers_name = ''PTIWorkPlaceUser'')
				EXEC [{0}].dbo.sp_droprolemember ''PTIWorkPlaceUser'', @xstridfSecurityID 
			IF (@strsysusers_name = ''PTIWorkPlaceAdmin'')
				EXEC [{0}].dbo.sp_droprolemember ''PTIWorkPlaceAdmin'', @xstridfSecurityID 
		END

		-- Check to see if user has a specific table permission or in another role.
		IF EXISTS(SELECT TOP 1 1 
			FROM [{0}].dbo.syspermissions p (NOLOCK)
			INNER JOIN [{0}].dbo.sysusers u (NOLOCK) ON p.grantee = u.uid WHERE u.name = @xstridfSecurityID AND p.id > 0)
			OR
		   EXISTS(SELECT TOP 1 1
			FROM [{0}].dbo.sysusers u (NOLOCK)
				INNER JOIN [{0}].dbo.sysmembers m (NOLOCK) ON u.uid = m.memberuid
				INNER JOIN [{0}].dbo.sysusers role (NOLOCK) ON role.uid = m.groupuid AND role.issqlrole = 1 
			WHERE u.name = @xstridfSecurityID AND role.name <> ''db_owner'')
			SELECT @xonHasPermissions = 1

		-- Revoke access for user if no other permissions.
		IF (@xonHasPermissions = 0)
			EXEC [{0}].dbo.sp_revokedbaccess @xstridfSecurityID
	END'


OPEN curSysDatabases

DECLARE 
 @nDynamicSQLUserHasOtherAccess INT
,@nUserHasOtherAccess			INT

SELECT @nUserHasOtherAccess = 0,@nDynamicSQLUserHasOtherAccess = 0

FETCH NEXT FROM curSysDatabases INTO @strDBName
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		-- IF @nExistsInAnotherDB = 0 then remove from ALL databases, else remove only from this one.
		IF (@nExistsInAnotherDB = 0 OR (@nExistsInAnotherDB = 1 AND DB_NAME() = @strDBName)) BEGIN

			SELECT @strRemoveTemp = REPLACE(@strRemoveSQL,'{0}',@strDBName)
			
			-- Need to reset for each call to the dynamic sql.
			SELECT @nDynamicSQLUserHasOtherAccess = 0
			SELECT @strRemoveTemp

			EXEC sp_executesql @strRemoveTemp
				, N'@xstridfSecurityID VARCHAR(255), @xonHasPermissions INT OUTPUT'
				, @xstridfSecurityID
				, @nDynamicSQLUserHasOtherAccess OUTPUT
				
			IF (@nDynamicSQLUserHasOtherAccess = 1)
				SET @nUserHasOtherAccess = @nDynamicSQLUserHasOtherAccess
		END
	END
	FETCH NEXT FROM curSysDatabases INTO @strDBName
END

CLOSE curSysDatabases
DEALLOCATE curSysDatabases

-- CDB 1/31/05 - If user does not exists in another db and user has no other access then remove from server.
IF (@nExistsInAnotherDB = 0 AND @nUserHasOtherAccess = 0)
	IF EXISTS(SELECT TOP 1 1 FROM master..syslogins WHERE name = @xstridfSecurityID)
		EXEC sp_droplogin @xstridfSecurityID

RETURN(0)