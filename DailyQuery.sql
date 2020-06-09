select * from RCVDistribution
select * from WCValDtl WHERE idfInternalMsg LIKE '%119%'
select * from RQDetailWork

DELETE WCValDtl WHERE idfInternalMsg LIKE '%119%'
DELETE RQDetailWork WHERE idfRQHeaderKey in (-1,0)

select * from test_exchange

select idfPTICompanyKey,idfDBName,idfDateCreated,edfCompanyCode 
from PTIMaster..PTICompany


Select idfPTICompanyKey,idfDBName from PTIMaster.dbo.PTICompany
Select idfWCSecurityKey,idfPTICompanyKey,idfSecurityID from WCSecurity where idfSecurityID='xxx'



select idfValue,* FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQUSEDATEANDRATEFORPO'
select idfRateHome,* from RQHeader
elect idfWCSecurityKey,idfSecurityID,w.idfDescription,idfEmployeeID,d.idfDeptID,d.idfDescription Dept,idfEmail
from WCSecurity w
inner join WCDept d ON w.idfWCDeptKey=d.idfWCDeptKey
Where idfEmail in (select idfEmail FROM WCSecurity 
GROUP BY idfEmail HAVING COUNT(1) > 1 )
order by idfEmail


Delete WCSecurity  Where idfSecurityID=xxx

SELECT idfEmail,idfNameFirst, idfEmailFormat, idfEmailSubject, idfNotifyCountApr 
from WCSecurity

select * from WCEmailQueueSent
select * from WCEmailDocHdr
select * from WCEmailDocDtl

select * from WCSecurityACCESS where idfType='CHART'
select idfCaption,idfSQLData1,idfSQLData2,idfSQLData3,* from WCChart
select * from WCChartPageRegion
select * from WCChartProperty
select * from WCChartPropertySetting
select * from gl00105

update WCSecurityACCESS  
set idfFlagAllow=0,idfFlagDeny=1
where idfType='CHART'

delete from WCLanguageResource where idfResourceID in ('11351','RCVNAME','RQNAME') and idfWCLanguageKey=1
select * from WCLanguageResourceD where idfResourceID in ('11351','RCVNAME','RQNAME') and idfWCLanguageKey=1
select count(*) from OAKWD..WCLanguageResource
delete from WCLanguageResourceD where idfResourceID in ('11351','RCVNAME','RQNAME') and idfWCLanguageKey=1

select * from PTIMaster..WCValDtl

SELECT T.name AS Table_Name ,
       C.name AS Column_Name ,
       P.name AS Data_Type ,
       P.max_length AS Size ,
       CAST(P.precision AS VARCHAR) + '/' + CAST(P.scale AS VARCHAR) AS Precision_Scale
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE'
and t.name Like '%QUEU%'

SELECT idfEmail FROM WCSecurity GROUP BY idfEmail HAVING COUNT(1) > 1 

select * from PTICompany