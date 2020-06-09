--1. Get the Database Name
--2. Find where this Particular user exists
--3.Create Temp Table and Insert the CompanyID,idfWCSecurityKey,idfSecurityID,Email

--select * from PTIMaster..POCancel WITH (NOLOCK)
--select * from ACN..WCSecurity WITH (NOLOCK)
--Select * from PTImaster..PTICompany WITH (NOLOCK)

SET NOCOUNT ON
DECLARE @UserName varchar(100),@Email varchar(100),@DbName Varchar(100),@SecurityId varchar(100),@SQL nvarchar(1000)
DECLARE @SecurityKey Varchar(100), @PTICompanyKey INT
DECLARE @NextRoleKey INT,@NextWCSecKey INT,@NextRoleSecKey INT
DECLARE @POUsers TABLE (idfPTICompanyKey INT, idfDbName VARCHAR(100),
                        idfWCSecurityKey INT, idfSecurityID VARCHAR(100),
						UserName VARCHAR(100),Email VARCHAR(100))

--delete WCSecRole where idfWCRoleKey=2

DECLARE @CheckRole INT

DECLARE curUser cursor for
SELECT Email,USERNAME 
 FROM PTIMaster..POCancel WITH (NOLOCK)
ORDER BY 1

DECLARE curCompany cursor FOR
SELECT idfPTICompanyKey,idfDbName 
 FROM  PTImaster..PTICompany WITH (NOLOCK)
 WHERE idfDBName='TWO'
---WHERE idfPTICompanyKey<60

OPEN curUser 
FETCH curUser INTO @Email,@UserName
WHILE @@FETCH_STATUS<>-1
BEGIN
   
   --PRINT '***Searching USER IN Each Company: ' +@Email 
   SET @CheckRole=0
   SELECT @CheckRole=1 from WCRole where idfRoleID='SSC_PO_Cancellaiton-Team'
   SELECT @NextRoleKey=Max(idfWCRoleKey)+1 from WCRole
   OPEN curCompany 
   FETCH curCompany INTO @PTICompanyKey,@DbName
   WHILE @@FETCH_STATUS<>-1
   BEGIN 
       SELECT @SecurityId='',@SecurityKey=''
       SET @SQL='USE '+@DbName+' ;SELECT @SecurityKey=idfWCSecurityKey,@SecurityID=idfSecurityID From WCSecurity WITH (NOLOCK)
	   WHERE idfEmail Like ''%'+@Email+'%'''
	   --PRINT @SQL
	   --Create Role if not exists 
	   EXEC sp_executesql @SQL, N'@Email varchar(100),@SecurityKey nvarchar(100) OUTPUT,@SecurityID nvarchar(100) OUTPUT',@Email=@Email, @SecurityID=@SecurityID OUTPUT,@SecurityKey=@SecurityKey OUTPUT

	   
	   IF LEN(@SecurityId)>0
	   BEGIN
	       BEGIN TRAN
	      --PRINT @SQL
	       INSERT INTO @POUsers VALUES (@PTICompanyKey, @DbName,@SecurityKey,@SecurityID,@UserName,@Email)
		   IF @CheckRole=0
	       BEGIN
			  SELECT @NextWCSecKey=Max(idfWCSecurityAccessKey)+1 from WCSecurityAccess 
			  SELECT @NextRoleSecKey=Max(idfWCSecRoleKey)+1 from WCSecRole
			  INSERT INTO WCRole (idfWCRoleKey,idfDescription,idfRoleID,idfDateCreated,idfDateModified,idfPTICompanyKey)
			  VALUES (@NextRoleKey,'SSC_PO_Cancellation','SSC PO Cancellation',getdate(),getDate(),@PTICompanyKey)
			  INSERT INTO WCSecurityAccess (idfWCSecurityAccessKey,idfFlagAllow,idfFlagDeny,idfType,idfDateCreated,idfDateModified,idfWCChartKey,idfWCRoleKey,idfWCRptHdrKey,idfWCSecurityAccessTemplateKey)
			  VALUES (@NextWCSecKey,1,0,'FEATURE',getdate(),getdate(),0,@NextRoleKey,0,220)
			  INSERT INTO WCSecurityAccess (idfWCSecurityAccessKey,idfFlagAllow,idfFlagDeny,idfType,idfDateCreated,idfDateModified,idfWCChartKey,idfWCRoleKey,idfWCRptHdrKey,idfWCSecurityAccessTemplateKey)
			  VALUES (@NextWCSecKey+1,1,0,'FEATURE',getdate(),getdate(),0,@NextRoleKey,0,85)
		      INSERT INTO WCSecRole (idfWCSecRoleKey,idfDateCreated,idfDateModified,idfWCRoleKey,idfWCSecurityKey)
			  VALUES(@NextRoleSecKey,getdate(),getdate(),@NextRoleKey,@SecurityKey)
			  SELECT @CheckRole=1
		  END
		  COMMIT TRAN
	   END
       FETCH curCompany INTO @PTICompanyKey,@DbName
	END
	CLOSE curCompany
    FETCH curUser INTO @Email,@UserName
END
DEALLOCATE curCompany
CLOSE curUser
DEALLOCATE curUser

SELECT * FROM @POUsers
select * from WCRole
select * from WCSecurityAccess where idfWCRoleKey=2
select * from WCSecRole where idfWCRoleKey=2




