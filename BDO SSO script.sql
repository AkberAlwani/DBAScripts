-- 2.1 Update Workplace User to SSO
set nocount on 
Declare @Email VARCHAR(255),@Name VARCHAR(255)
Declare @UserID VARCHAR(255)
--select * from WCSecurity where idfSecurityID='Godwin.Axisa@bdo.com.au'
--select * from WCSecurity where idfEmail='Godwin.Axisa@bdo.com.au'
DECLARE curSSO cursor for 
SELECT  idfSecurityID,idfEmail,idfDescription
from WCSecurity
Where idfSecurityID<>idfEmail
AND idfEmail not in ('admin@127.0.0.1','Godwin.Axisa@bdo.com.au')
AND LEN(rtrim(ltrim(idfemail)))>1
AND idfEmail not in (select idfEmail from WCSecurity group by idfEMail having count(idfemail)>1)

OPEN curSSO
FETCH NEXT FROM curSSO INTO @UserID,@Email,@Name
BEGIN TRAN
WHILE @@FETCH_STATUS<>-1
BEGIN
  UPDATE WCSecurity set idfSecurityID=idfEmail where idfSecurityID=@UserID
  UPDATE PTImaster..PTISecurity  set idfSecurityID=@Email where idfSecurityID=@UserID
  IF @@ROWCOUNT>=1
	    PRINT @Name + ' '+@email+' has been transfer to SSO '
	--SELECT top 1 * from PTImaster..PTISecurity where idfSecurityID=@Email 
  FETCH NEXT FROM curSSO INTO @UserID,@Email,@Name
END
close curSSO
deallocate curSSO
--SELECT idfEmail,idfSecurityID from WCSecurity
--select * from PTIMaster..PTISecurity
COMMIT tran

EXEC spWCSecurityAccessEffectiveSync  
EXEC spPTIFixDB

