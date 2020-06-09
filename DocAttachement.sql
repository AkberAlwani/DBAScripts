select * from WCAttach order by 1 desc  --idfLinkTableName

select * from RQHeader  where idfRQHeaderKey=289
select * from RQDetail  where idfRQDetailKey=289

select * from RcvHeader

select * from WCLanguage
select * from WCFormDtl
select * from WCLanguageResourceD

use two

select * from pop10100 order by 1 desc


SELECT T.name AS Table_Name ,
       C.name AS Column_Name ,
       P.name AS Data_Type ,
       P.max_length AS Size ,
       CAST(P.precision AS VARCHAR) + '/' + CAST(P.scale AS VARCHAR) AS Precision_Scale
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE'
and c.name like '%JC_Contract_Number%'


SELECT  *
FROM RCVHeader


Select idfPTICompanyKey,idfSecurityID,* from WCSecurity

select * from PTIMaster.dbo.PTISecurity where idfSecurityID='CONTOSO\ali'
select * from WCInstall
select * from WCInstallObject

SELECT idfFlagScriptingEndedWithError,idfLogMessage FROM WCInstall WHERE idfWCInstallKey IN (SELECT MAX(idfWCInstallKey) FROM dbo.WCInstall WITH (NOLOCK))


select * from WCSecuritySetting WHERE idfName LIKE '%zoom%'
DELETE WCSecuritySetting WHERE idfName LIKE '%zoom%'
AND idfWCSecurityKey = (SELECT idfWCSecurityKey FROM WCSecurity WHERE idfSecurityID = 'XXX') 