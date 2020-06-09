SELECT *
  FROM [TWO].[dbo].[RQDetail]
WHERE datalength(idfCommentInternal)>100
select * from WCLanguageResource
Select * from PTImaster..PTICompany
delete PTImaster..PTICompany where PTICompany.idfDBName='YTWO'
select * from PTImaster..PTICompany


SELECT distinct 'UPDATE '+T.name+' set '+c.Name+'=41' AS Table_Name ,T.name
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE'
and c.name like '%idfPTICompanyKey%'  
--and t.name like '%RCv%'
order by 1


SELECT distinct 'DELETE '+T.name+' WHERE idfRQDetailKey in (
SELECT idfRQDetailKey from RQDetail (NOLOCK) where idfRQHeaderKey in (21875,14639,16076,748,16088,26147,17514,24954,23036,16293))' AS Table_Name ,T.name
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE'
and c.name like '%idfRQDetailKey'  
--and t.name like '%RCv%'
order by 1

SELECT distinct T.name AS Table_Name 
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE'
--and c.name like '%report%'  
and t.name like 'PA%'
order by 1

SELECT T.name AS Table_Name ,
       C.name AS Column_Name ,
       P.name AS Data_Type ,
       P.max_length AS Size ,
       CAST(P.precision AS VARCHAR) + '/' + CAST(P.scale AS VARCHAR) AS Precision_Scale
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE'
and t.name like '%RQDe%'
and c.name like '%HDR_idfRQType%' 
--and c.name like 'idfWCSecurityKey%' 
--and t.name like '%Email%'
order by 1

select * from WCTEMPRQValidate
select * from RQMemo order by 1 desc


SELECT T.name AS Table_Name ,
       C.name AS Column_Name ,
       P.name AS Data_Type ,
       P.max_length AS Size ,
       CAST(P.precision AS VARCHAR) + '/' + CAST(P.scale AS VARCHAR) AS Precision_Scale
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
--WHERE  T.type_desc = 'USER_TABLE'
and c.name like '%idfWCRRGroupKey%' 
--where t.name like '%Template%'  
--where t.name like '%Shop%'
order by 1

select * from APTaxType
select * from APTaxTypeDtl

SELECT 'SELECT * from '+T.name AS Table_Name  
FROM   sys.objects AS T
WHERE  T.type_desc = 'USER_TABLE'
and t.name like 'EXPMobile%' 
--and t.name like '%List%'

select * from sys.procedures where name like '%Email%'
select * from sys.triggers where name like '%tiWCLog%'

SELECT DISTINCT
       o.name AS Object_Name,
       o.type_desc
  FROM sys.sql_modules m
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
 WHERE m.definition Like '%DYNAMICS%'
 and o.name like '$Email%'
 --WHERE m.definition Like '%\[DYNAMICS\]%' ESCAPE '\'


Declare @UserName Varchar(50)
Select @UserName=idfSecurityID from WCSecurity where idfSecurityID='sa'
Delete from WCSecuritySetting
FROM WCSecuritySetting WS
INNER JOIN WCSecurity WC ON WC.idfWCSecurityKey=WS.idfWCSecurityKey
WHERE idfName like '%ZOOM_LOCKINFO_LOCK%' AND 
WC.idfSecurityID =@UserName


select edfCompanyName,* from PTICompany
update PTICompany set edfCompanyName=rtrim(edfCompanyName)+'('+edfCompanyCode+')'  where edfCompanyID<-1



DECLARE @SearchText varchar(1000) = 'INSERT INTO EXPExpenseSheetDtlHist';

SELECT DISTINCT SPName 
FROM (
    (SELECT ROUTINE_NAME SPName
        FROM INFORMATION_SCHEMA.ROUTINES 
        WHERE ROUTINE_DEFINITION LIKE '%' + @SearchText + '%' 
        AND ROUTINE_TYPE='PROCEDURE')
    UNION ALL
    (SELECT OBJECT_NAME(id) SPName
        FROM SYSCOMMENTS 
        WHERE [text] LIKE '%' + @SearchText + '%' 
        AND OBJECTPROPERTY(id, 'IsProcedure') = 1 
        GROUP BY OBJECT_NAME(id))
    UNION ALL
    (SELECT OBJECT_NAME(object_id) SPName
        FROM sys.sql_modules
        WHERE OBJECTPROPERTY(object_id, 'IsProcedure') = 1
        AND definition LIKE '%' + @SearchText + '%')
) AS T
ORDER BY T.SPName

DECLARE @SearchText varchar(1000) = 'INSERT INTO @WCEFT';

SELECT DISTINCT SPName 
FROM (
    (SELECT ROUTINE_NAME SPName
        FROM INFORMATION_SCHEMA.ROUTINES 
        WHERE ROUTINE_DEFINITION LIKE '%' + @SearchText + '%' 
        AND ROUTINE_TYPE='PROCEDURE')
    UNION ALL
    (SELECT OBJECT_NAME(id) SPName
        FROM SYSCOMMENTS 
        WHERE [text] LIKE '%' + @SearchText + '%' 
        AND OBJECTPROPERTY(id, 'IsProcedure') = 1 
        GROUP BY OBJECT_NAME(id))
    UNION ALL
    (SELECT OBJECT_NAME(object_id) SPName
        FROM sys.sql_modules
        WHERE OBJECTPROPERTY(object_id, 'IsProcedure') = 1
        AND definition LIKE '%' + @SearchText + '%')
) AS T
ORDER BY T.SPName

--select object_name(id),* from SYScomments where text like '%IF @xstrSource = ''APPROVAL''%'


select * from sys.triggers where name='IFC_tuidWCEFT'

select so.name, text
from sysobjects so, syscomments sc
where type = 'TR'
and so.id = sc.id
and text like '%WCEFT%'

IF EXISTS (SELECT TOP 1 1 FROM sys.procedures WHERE name = 'spPTIFixPrimaryKeySequence')
EXEC spPTIFixPrimaryKeySequence 1
ELSE
EXEC spPTIFixPrimaryKey
GO
