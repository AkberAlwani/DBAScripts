select idfFlagACtiveEXP , * from WCsecurity
--update WCSecurity set idfFlagACtiveEXP =0 where idfWCSecurityKey>3
Select * from PTImaster..PTISecurity where idfModule='EXPENSE'

delete PTIMaster..PTICompany  where idfDBName in ('YTWO','ZTWO')
select * from PTIMaster..PTICompany 
select * into PTIMaster..PTICompany_tmp from PTIMaster..PTICompany
select * from PTIMaster..PTICompany_tmp

--delete PTIMaster..PTICompany where PTICompany.idfPTICompanyKey=18
DELETE PTIMaster..PTICompany where PTICompany.idfDBName not IN  ('WPECompany_1810')
DELETE PTIMaster..PTICompany where PTICompany.idfDBName ='WPECompany_AX'

Begin tran
--SET IDENTITY_INSERT PTIMaster..PTICompany ON;  
insert into PTIMaster..PTICompany (idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName)
select idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName
 from PTIMaster..PTICompany_bak where idfDBName not like '%ZTO%'

--SET IDENTITY_INSERT PTIMaster..PTICompany OFF;
select * from PTIMaster..PTICompany
rollback tran

insert into PTIMaster..PTICompany (idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName)
select idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName
 from PTIMaster..PTICompany_tmp where idfDBName in ('WPCompany_GPBSMF')

 select * from PTImaster.dbo.PTICompany
 exec spPTIMaster..PTICompanyFix 'TWO'

 insert into PTIMaster..PTICompany_bak (idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName)
select idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName
 from PTIMaster..PTICompany where idfDBName in ('WPCompany_EPICOR')

insert into PTIMaster..PTICompany (idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName)
select idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName
 from PTIMaster..PTICompany_bak where idfDBName in ('ZTWO')

 insert into PTIMaster..PTICompany (idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName)
select idfPTICompanyKey,idfDBName,idfFlagActive,idfPTICurrencyRateTypeKey,idfPTICurrencyRateTypeKeyAP,idfPTICurrencyRateTypeKeyAR,edfCompanyCode,edfCompanyID,edfCompanyName
 from PTIMaster..PTICompany_bak where idfDBName NOT IN ('WPECompany_1813')

 select * from ZTWO..WCInstall
 select * from PTIMaster..PTICompany 
 
 
 USE ZTWO
SELECT distinct 'UPDATE '+T.name+' set '+c.Name+'=13' AS Table_Name ,T.name
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE'
and c.name like '%idfPTICompanyKey%'  
--and t.name like '%RCv%'
order by 1

