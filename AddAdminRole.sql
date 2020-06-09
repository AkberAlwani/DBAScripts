EXEC sys.sp_enum_oledb_providers

use master
DECLARE @RoleKey INT,@SecurityKey INT,@NextRoleKey INT ,@nidfMaxValueStatic BIGINT,@nNextKey INT 
DECLARE @SQL nVARCHAR(2000),@DbName nVARCHAR(200)
DECLARE @UserName nvarchar(200)
set @UserName='digicelgroup\dtopping'
--digicelgroup\dtopping
DECLARE curCompany cursor for
SELECT ltrim(rtrim(idfDBName)) 
from PTIMaster..PTICompany  WITH (NOLOCK)
--where idfDBName like '[A-Z]%'
--WHERE idfDBName NOT in ('DJL')
order by 1

open curCompany 
FETCH curCompany INTO @DbName
WHILE @@FETCH_STATUS<>-1
BEGIN

   SET @SQL='USE '+@DbName+'; SELECT @RoleKey=idfWCRoleKey from WCRole (NOLOCK) where idfRoleID=''SYSADMIN'''
   EXEC sp_executesql @SQL, N'@RoleKey INT OUTPUT',@RoleKey=@RoleKey OUTPUT
   --Check if Role Exists 
   SET @SecurityKey=0
   set @SQL='USE '+@DbName+'; SELECT @SecurityKey=idfWCSecurityKey from WCSecRole (NOLOCK) WHERE idfWCRoleKey='+convert(varchar,@RoleKey)+'
       AND idfWCSecurityKey in (SELECT idfWCSecurityKey from WCSecurity where idfSecurityID ='''+@UserName+''')'
   EXEC sp_executesql @SQL, N'@SecurityKey INT OUTPUT',@SecurityKey=@SecurityKey OUTPUT
   IF @SecurityKey=0
   BEGIN 
   	    SET @SQL='USE '+@DbName+'; SELECT @SecurityKey=idfWCSecurityKey from WCSecurity (NOLOCK) WHERE idfSecurityID ='''+@UserName+''''
		EXEC sp_executesql @SQL, N'@SecurityKey INT OUTPUT',@SecurityKey=@SecurityKey OUTPUT
		PRINT @SQL
		IF @SecurityKey<>0
		BEGIN 
		SET @SQL='USE '+@DbName+'; SELECT @NextRoleKey=ISNULL(Max(idfWCSecRoleKey),0)+1 from WCSecRole (NOLOCK)'
		EXEC sp_executesql @SQL, N'@NextRoleKey INT OUTPUT',@NextRoleKey=@NextRoleKey OUTPUT
		
        SET @SQL='INSERT INTO '+@DbName+'..WCSecRole (idfWCSecRoleKey,idfDateCreated,idfDateModified,idfWCRoleKey,idfWCSecurityKey)
		VALUES('+CONVERT(varchar,@NextRoleKey)+','''+CONVERT(varchar,getdate())+''','''+CONVERT(varchar,getdate())+''','+CONVERT(varchar,@RoleKey)+','+convert(varchar,@SecurityKey)+')'
		PRINT 'SecKey '+Convert(varchar,@SecurityKey )+' RoleKey '+Convert(varchar,@NextRoleKey)+' Check User '+ Convert(varchar,@SecurityKey)
		EXEC sp_executesql @SQL
		
		SELECT @SQL = N'USE '+@DbName+'; IF EXISTS(SELECT TOP 1 1 FROM sysobjects WHERE name=''WCSecRolePK'' AND type=''SO'') DROP SEQUENCE dbo.WCSecRolePK'  
		EXEC sp_executesql @SQL  
		
		-- Get the last counter value.  
		SET @SQL='USE '+@DbName+N'; SELECT @nNextKey = MAX(idfWCSecRoleKey) FROM WCSecRole (NOLOCK)'  
		EXEC sp_executesql @SQL,N'@nNextKey INT OUTPUT',@nNextKey = @nNextKey OUTPUT 
		
		SET @SQL = 'USE '+@DbName+N'; CREATE SEQUENCE dbo.WCSecRolePK START WITH '+ CONVERT(VARCHAR(100),ISNULL(@nNextKey,0)+1)+ N' INCREMENT BY 1'  
		EXEC sp_executesql @SQL  
		PRINT @SQL
		SET @SQL = 'USE '+@DbName+N';GRANT UPDATE ON [WCSecRolePK] TO [PTIWorkPlaceUser]  
	    GRANT UPDATE ON [WCSecRolePK] TO [PTIWorkPlaceAdmin]  
		GRANT UPDATE ON [WCSecRolePK] TO [PTIWorkPlacePMUserAccess]  
		GRANT UPDATE ON [WCSecRolePK] TO [PTIWorkPlaceRFQVndAccess]  
		GRANT UPDATE ON [WCSecRolePK] TO [PTIWorkPlaceExternalRole]'  
    
		EXEC sp_executesql @SQL 
		END 
	END 

  --  exec(@SQL) 

    FETCH curCompany INTO @DbName
   
   
END
CLOSE curCompany
DEALLOCATE curCompany


--select * from TWO..WCSecRole
