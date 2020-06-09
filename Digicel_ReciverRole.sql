--Checking and Processing Receive/Match Invoice Access in RECEIVER ROLE
USE master
SET NOCOUNT ON

DECLARE @DbName NVARCHAR(MAX),@SQL nvarchar(max)
DECLARE @WCRoleKey INT,@CheckRec INT,@NextWCSecKey INT
DECLARE curCompany cursor for
SELECT ltrim(rtrim(idfDBName)) 
FROM PTIMaster..PTICompany  WITH (NOLOCK)
WHERE idfDBName like '[A-Z]%'
ORDER by 1

open curCompany 
FETCH curCompany INTO @DbName
WHILE @@FETCH_STATUS<>-1
BEGIN
   SET @WCRoleKey=0
   SET @SQL='USE '+@DbName+'; SELECT @WCRoleKey=idfWCRoleKey from WCRole WITH (NOLOCK) where idfRoleID=''RECEIVER'''
   EXEC sp_executesql @SQL, N'@WCRoleKey INT OUTPUT',@WCRoleKey=@WCRoleKey OUTPUT
   SET @CheckRec=0
   SET @SQL='USE '+@DbName+'; SELECT @CheckRec=idfWCSecurityAccessKey from WCSecurityAccess WITH (NOLOCK) where idfWCRoleKey='+convert(varchar,@WCRoleKey)+' and idfWCSecurityAccessTemplateKey=95'
   EXEC sp_executesql @SQL, N'@CheckRec INT OUTPUT',@CheckRec=@CheckRec OUTPUT
   IF @CheckRec=0
   BEGIN
		PRINT @SQL
		--PRINT @SQL+' Role '+Convert(nvarchar,@WCRoleKey)
    	SET @SQL='USE '+@DbName+'; SELECT @NextWCSecKey=Max(idfWCSecurityAccessKey)+1 from WCSecurityAccess'
		EXEC sp_executesql @SQL, N'@NextWCSecKey INT OUTPUT',@NextWCSecKey=@NextWCSecKey OUTPUT

		 SET @SQL='INSERT INTO '+@DBName+'..WCSecurityAccess (idfWCSecurityAccessKey,idfFlagAllow,idfFlagDeny,idfType,idfDateCreated,idfDateModified,idfWCChartKey,idfWCRoleKey,idfWCRptHdrKey,idfWCSecurityAccessTemplateKey)
				  VALUES ('+CONVERT(nvarchar,@NextWCSecKey)+',1,0,''FEATURE'','''+convert(nvarchar,getdate())+''','''+convert(nvarchar,getdate())+''',0,'+convert(nvarchar,@WCRoleKey)+',0,95)'
		EXEC sp_executesql @SQL
		
		SET @SQL='UPDATE '+@DbName+'..WCPrimaryKey set idfNextKey='+CONVERT(varchar,ISNULL(@NextWCSecKey,0))+' WHERE idfTableName=''WCSecurityAccess'''
		EXEC sp_executesql @SQL
		
		--Print '***START Database : ' +@DbName 
	END
   --SET @SQL=@DbName +'..sp_addrolemember ''PTIWorkPlaceLanguageAccess'',''WPLanguageUser1'''
   --SET @SQL=@DbName +'..sp_addrolemember ''PTIWorkPlaceUser'',''DIGICELGROUP\JAM_GRP_Finance_GPWebclientUsers'''
   FETCH curCompany INTO @DbName
   
END
CLOSE curCompany
DEALLOCATE curCompany




--select * from WCRole where idfRoleID='RECEIVER'
--select * from DBL..WCSecurityAccess WITH (NOLOCK) where idfWCRoleKey=135 and idfWCSecurityAccessTemplateKey=95
