select idfSecurityID,* from WCSecurity

update WCSecurity set idfSecurityID='sa' where idfWCSecurityKey=3
Select idfPTICompanyKey,idfDBName from PTIMaster..PTICompany
select idfPTICompanyKey,idfSecurityID from WCSecurity
update WCSecurity set idfPTICompanyKey=XX 

select * from WCSecurityAccess where idfWCRoleKey=1
and idfWCSecurityAccessTemplateKey not in (select idfWCSecurityAccessTemplateKey  from temp1)

SELECT a.idfWCRoleKey,idfWCSecurityAccessTemplateKey,b.idfRoleID
from WCSecurityAccess a 
inner join WCRole b on a.idfWCRoleKey=b.idfWCRoleKey
where a.idfWCSecurityAccessTemplateKey =5

select * from WCRole
select * from WCSecurityAccess where idfWCSecurityAccessTemplateKey=5

