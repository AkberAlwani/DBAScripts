use master
GO
SET NOCOUNT ON
DECLARE @UserName varchar(100),@Email varchar(100),@DbName Varchar(100),@SecurityId varchar(100),@SQL nvarchar(1000)
DECLARE @SecurityKey INT, @PTICompanyKey INT,@RoleName VARCHAR(200)
DECLARE @NextRoleKey INT,@NextWCSecKey INT,@NextRoleSecKey INT
DECLARE @POUsers TABLE (idfPTICompanyKey INT, idfDbName VARCHAR(100),
                        idfWCSecurityKey INT, idfSecurityID VARCHAR(100),
						UserName VARCHAR(100),Email VARCHAR(100))

--delete WCSecRole where idfWCRoleKey=2

DECLARE @CheckRole INT,@CheckUser INT

DECLARE curUser cursor for
SELECT UserID,[RoleID] WPRole
 FROM PTIMaster..NewUser_Setup WITH (NOLOCK)
ORDER BY 1

DECLARE curCompany cursor FOR
SELECT idfPTICompanyKey,rtrim(ltrim(idfDbName))
 FROM  PTImaster..PTICompany WITH (NOLOCK)
 WHERE idfDBName  in ('ACN')

OPEN curUser 
FETCH NEXT FROM curUser INTO @Role,@UserName
WHILE @@FETCH_STATUS<>-1
BEGIN
  
   --PRINT '***Searching USER IN Each Company: ' +@Email 
   OPEN curCompany 
   FETCH NEXT FROM curCompany INTO @PTICompanyKey,@DbName
   SET @CheckRole=0
   WHILE @@FETCH_STATUS<>-1
   BEGIN 
		SET @SQL='USE '+@DbName+'; SELECT @CheckRole=idfWCRoleKey,@NextRoleKey=idfWCRoleKey from WCRole where idfRoleID='''+@RoleName+''
		EXEC sp_executesql @SQL, N'@CheckRole INT OUTPUT,@NextRoleKey INT OUTPUT',@CheckRole=@CheckRole OUTPUT,@NextRoleKey=@NextRoleKey  OUTPUT
 	    
		IF @CheckRole=0
		BEGIN
			SET @SQL='USE '+@DbName+'; SELECT @NextRoleKey=Max(idfWCRoleKey)+1 from WCRole'
			EXEC sp_executesql @SQL, N'@NextRoleKey INT OUTPUT',@NextRoleKey=@NextRoleKey OUTPUT
		END
		--ELSE
			--SET @NextRoleKey=@CheckRole
		PRINT 'Role :' +convert(varchar,@NextRoleKey )
   		SELECT @SecurityId='',@SecurityKey=0
		
		SET @SQL='USE '+@DbName+' ;SELECT @SecurityKey=idfWCSecurityKey,@SecurityID=idfSecurityID From WCSecurity WITH (NOLOCK) WHERE idfSecurity Like ''%'+@UserName+'%'''
		EXEC sp_executesql @SQL, N'@SecurityKey INT OUTPUT',@SecurityKey=@SecurityKey OUTPUT
		IF @SecurityKey=0
		BEGIN
		  print 'user creation'
		END

		--Step 2 Find the User Created then create User Role
		SET @CheckUser=0
		SET @SQL='USE '+@DBName+'; SELECT @CheckUser=idfWCSecRoleKey FROM WCSecRole WHERE idfWCRoleKey='+convert(nvarchar,@NextRoleKey)+' and idfWCSecurityKey='+convert(nvarchar,@SecurityKey)
		EXEC sp_executesql @SQL, N'@NextRoleKey INT,@SecurityKey INT,@CheckUser INT OUTPUT',@NextRoleKey=@NextRoleKey, @SecurityKey=@SecurityKey,@CheckUser=@CheckUser OUTPUT
		
		IF @CheckUser=0
		BEGIN
			PRINT '* DATABASE :'+@DbName+' EMAIL: '+@Email
			INSERT INTO @POUsers VALUES (@PTICompanyKey, @DbName,@SecurityKey,@SecurityID,@UserName,@Email)
		    
			SET @SQL='INSERT INTO '+@DBName+'..WCSecRole (idfWCSecRoleKey,idfDateCreated,idfDateModified,idfWCRoleKey,idfWCSecurityKey)
			VALUES('+CONVERT(varchar,@NextRoleSecKey)+','''+CONVERT(varchar,getdate())+''','''+CONVERT(varchar,getdate())+''','+CONVERT(varchar,@NextRoleKey)+','+convert(varchar,@SecurityKey)+')'
			PRINT 'SecKey '+Convert(varchar,@SecurityKey )+' RoleKey '+Convert(varchar,@NextRoleKey)+' Check User '+ Convert(varchar,@CheckUser)
			EXEC sp_executesql @SQL
		END
		SELECT @CheckRole=1
       FETCH NEXT FROM curCompany INTO @PTICompanyKey,@DbName
	END
	CLOSE curCompany
    FETCH NEXT FROM curUser INTO @Email,@UserName
END
DEALLOCATE curCompany
CLOSE curUser
DEALLOCATE curUser
SELECT * FROM @POUsers

