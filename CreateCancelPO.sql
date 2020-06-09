--1. Get the Database Name
--2. Find where this Particular user exists
--3.Create Temp Table and Insert the CompanyID,idfWCSecurityKey,idfSecurityID,Email
--select * from PTIMaster..POCancel WITH (NOLOCK)
--select * from ACN..WCSecurity WITH (NOLOCK)
--Select * from PTImaster..PTICompany WITH (NOLOCK)
--select * from TWO..WCSecRole WHERE idfWCRoleKey in (select idfWCRoleKey from TWO..WCRole where idfRoleID='SSC PO Cancellation')
--select * from TWO..WCSecRole WHERE idfWCRoleKey in (select idfWCRoleKey from TWO..WCRole where idfRoleID='SSC PO Cancellation')
--select * from TWO..WCRole WHERE idfRoleID='SSC PO Cancellation'
--delete from WCSecRole WHERE idfWCRoleKey in (select idfWCRoleKey from WCRole where idfRoleID='SSC_PO_Cancellation')
--delete from WCSecRole WHERE idfWCRoleKey in (select idfWCRoleKey from WCRole where idfRoleID='SSC_PO_Cancellation')
--delete from WCRole WHERE idfRoleID='SSC_PO_Cancellation'

use master
GO
SET NOCOUNT ON
DECLARE @UserName varchar(100),@Email varchar(100),@DbName Varchar(100),@SecurityId varchar(100),@SQL nvarchar(1000)
DECLARE @SecurityKey Varchar(100), @PTICompanyKey INT
DECLARE @NextRoleKey INT,@NextWCSecKey INT,@NextRoleSecKey INT
DECLARE @POUsers TABLE (idfPTICompanyKey INT, idfDbName VARCHAR(100),
                        idfWCSecurityKey INT, idfSecurityID VARCHAR(100),
						UserName VARCHAR(100),Email VARCHAR(100))

--delete WCSecRole where idfWCRoleKey=2

DECLARE @CheckRole INT,@CheckUser INT

DECLARE curUser cursor for
SELECT Email,USERNAME 
 FROM PTIMaster..POCancel WITH (NOLOCK)
ORDER BY 1

DECLARE curCompany cursor FOR
SELECT idfPTICompanyKey,rtrim(ltrim(idfDbName))
 FROM  PTImaster..PTICompany WITH (NOLOCK)
 WHERE idfDBName Not in ('DJL')
 --WHERE idfDBName like '%Accpac%'
---WHERE idfPTICompanyKey<60

OPEN curUser 
FETCH NEXT FROM curUser INTO @Email,@UserName
WHILE @@FETCH_STATUS<>-1
BEGIN
  
   --PRINT '***Searching USER IN Each Company: ' +@Email 
   OPEN curCompany 
   FETCH NEXT FROM curCompany INTO @PTICompanyKey,@DbName
   SET @CheckRole=0
  
   WHILE @@FETCH_STATUS<>-1
   BEGIN 
        
		SET @SQL='USE '+@DbName+'; SELECT @CheckRole=idfWCRoleKey,@NextRoleKey=idfWCRoleKey from WCRole where idfRoleID=''SSC_PO_Cancellation'''
		EXEC sp_executesql @SQL, N'@CheckRole INT OUTPUT,@NextRoleKey INT OUTPUT',@CheckRole=@CheckRole OUTPUT,@NextRoleKey=@NextRoleKey  OUTPUT
 	    
		IF @CheckRole=0
		BEGIN
			SET @SQL='USE '+@DbName+'; SELECT @NextRoleKey=Max(idfWCRoleKey)+1 from WCRole'
			EXEC sp_executesql @SQL, N'@NextRoleKey INT OUTPUT',@NextRoleKey=@NextRoleKey OUTPUT
		END
		--ELSE
			--SET @NextRoleKey=@CheckRole
		
		--PRINT 'Role :' +convert(varchar,@NextRoleKey )
   		SELECT @SecurityId='',@SecurityKey=''
		SET @SQL='USE '+@DbName+' ;SELECT @SecurityKey=idfWCSecurityKey,@SecurityID=idfSecurityID From WCSecurity WITH (NOLOCK) WHERE idfEmail Like ''%'+@Email+'%'''
		--PRINT @SQL
		--Create Role if not exists 
		EXEC sp_executesql @SQL, N'@Email varchar(100),@SecurityKey nvarchar(100) OUTPUT,@SecurityID nvarchar(100) OUTPUT',@Email=@Email, @SecurityID=@SecurityID OUTPUT,@SecurityKey=@SecurityKey OUTPUT

		IF LEN(@SecurityId)>0
		BEGIN
 		    SET @SQL='USE '+@DbName+'; SELECT @NextWCSecKey=Max(idfWCSecurityAccessKey)+1 from WCSecurityAccess'
			EXEC sp_executesql @SQL, N'@NextWCSecKey INT OUTPUT',@NextWCSecKey=@NextWCSecKey OUTPUT
			SET @SQL='USE '+@DbName+'; SELECT @NextRoleSecKey=Max(idfWCSecRoleKey)+1 from WCSecRole'
			EXEC sp_executesql @SQL, N'@NextRoleSecKey INT OUTPUT',@NextRoleSecKey=@NextRoleSecKey OUTPUT
			IF @CheckRole=0
			BEGIN

				  SET @SQL='INSERT INTO '+@DBName+'..WCRole (idfWCRoleKey,idfRoleID,idfDescription,idfDateCreated,idfDateModified,idfPTICompanyKey) 
				  VALUES ('+CONVERT(VARCHAR,@NextRoleKey)+',''SSC_PO_Cancellation'',''SSC PO Cancellation'','''+convert(nvarchar,getdate())+''','''+convert(nvarchar,getDate())+''','+CONVERT(nvarchar,@PTICompanyKey)+')'
				  EXEC sp_executesql @SQL
				  --PRINT @SQL
				 -- PRINT 'Role :' +convert(varchar,@NextRoleKey )
				
				  SET @SQL='INSERT INTO '+@DBName+'..WCSecurityAccess (idfWCSecurityAccessKey,idfFlagAllow,idfFlagDeny,idfType,idfDateCreated,idfDateModified,idfWCChartKey,idfWCRoleKey,idfWCRptHdrKey,idfWCSecurityAccessTemplateKey)
				  VALUES ('+CONVERT(nvarchar,@NextWCSecKey)+',1,0,''FEATURE'','''+convert(nvarchar,getdate())+''','''+convert(nvarchar,getdate())+''',0,'+convert(nvarchar,@NextRoleKey)+',0,220)'
				  EXEC sp_executesql @SQL
				 -- PRINT 'Role :' +convert(varchar,@NextRoleKey )
				  --PRINT @SQL
			END
			

			--Step 2 Find The User First
		    SET @CheckUser=0
			SET @SQL='USE '+@DBName+'; SELECT @CheckUser=idfWCSecRoleKey FROM WCSecRole WHERE idfWCRoleKey='+convert(nvarchar,@NextRoleKey)+' and idfWCSecurityKey='+convert(nvarchar,@SecurityKey)
			EXEC sp_executesql @SQL, N'@NextRoleKey INT,@SecurityKey INT,@CheckUser INT OUTPUT',@NextRoleKey=@NextRoleKey, @SecurityKey=@SecurityKey,@CheckUser=@CheckUser OUTPUT
			PRINT @SQL
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
	
	   END
       FETCH NEXT FROM curCompany INTO @PTICompanyKey,@DbName
	END
	CLOSE curCompany
    FETCH NEXT FROM curUser INTO @Email,@UserName
END
DEALLOCATE curCompany
CLOSE curUser
DEALLOCATE curUser

--SELECT a.idfDBName DBName,CMPNYNAM CompanyName,idfWCSecurityKey SecurityKey,
--idfSecurityID UserID,UserName,Email FROM @POUsers a
--inner JOIN DYNAMICS..SY01500 b on a.idfDbName=INTERID

SELECT * FROM @POUsers

