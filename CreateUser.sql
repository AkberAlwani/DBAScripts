select idfAPTaxTypeDtlKey,idfAPTaxTypeKey,* from APVendor 
where idfAPTaxTypeKey=1 and idfAPTaxTypeKey is not NULL

UPDATE PM00200 set VENDORID=VENDORID
update APVendor set idfAPTaxTypeDtlKey=0 where idfAPTaxTypeKey=1 and idfAPTaxTypeKey is not NULL

use master

CREATE LOGIN  WorkplaceSession WITH PASSWORD = 'F@rgo007'
CREATE LOGIN WorkPlaceUser	WITH PASSWORD = 'F@rgo007'
CREATE LOGIN WorkPlaceCrystal WITH PASSWORD = 'F@rgo007'
CREATE LOGIN WorkPlaceExternal	WITH PASSWORD = 'F@rgo007'
CREATE LOGIN WorkplaceLanguage	WITH PASSWORD = 'F@rgo007'
CREATE LOGIN WorkplaceVendor	WITH PASSWORD = 'F@rgo007'

SELECT a.idfDeptId 'DeptId',a.idfDescription 'DeptName',
b.idfWCSecurityKey SecurityKey,b.idfSecurityId LoginId,b.idfDEscription UserName
from WCDept a
inner join WCSecurity b on a.idfWCDeptKey=b.idfWCDeptKey

SELECT a.idfDeptId 'DeptId',a.idfDescription 'DeptName',
b.idfWCSecurityKey SecurityKey,b.idfSecurityId LoginId,b.idfDEscription UserName
from WCSecDept c 
inner join WCDept a     on a.idfWCDeptKey=c.idfWCDeptKey 
left  join WCSecurity b on a.idfWCDeptKey=c.idfWCDeptKey and c.idfWCSecurityKey=b.idfWCSecurityKey

---left join WCSecurity b on a.idfWCDeptKey=b.idfWCDeptKey
left join WCSecDept c  on  a.idfWCDeptKey=c.idfWCDeptKey and c.idfWCSecurityKey=b.idfWCSecurityKey


select * from WCSecDept

select * from sys.sql_logins where name='xxx'