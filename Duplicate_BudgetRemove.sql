select * into GLBudgetHdr_2019 from GLBudgetHdr where idfEAICLink like '%2019%'
select * into GLBudgetDtl_2019 from GLBudgetDtl where idfGLBudgetHdrKey in (select idfGLBudgetHdrKey from GLBudgetHdr_2019 )
WITH BUDH AS (
select ROW_NUMBER() OVER(Partition By idfEAICLink ORDER BY idfEAICLink ) RID,* 
from GLBudgetHdr 
where idfEAICLink like '%2019%')

begin tran
select * from GLBudgetHdr where idfEAICLink like '%2019%'
order by idfEAICLink 

DELETE GLBudgetDtl
from (select ROW_NUMBER() OVER(Partition By idfEAICLink ORDER BY idfEAICLink ) RID,* 
      from GLBudgetHdr 
      where idfEAICLink like '%2019%') H 
INNER JOIN GLBudgetDtl D on H.idfGLBudgetHdrKey=D.idfGLBudgetHdrKey
WHERE RID=2 

DELETE GLBudgetHdr
from (select ROW_NUMBER() OVER(Partition By idfEAICLink ORDER BY idfEAICLink ) RID,* 
      from GLBudgetHdr 
      where idfEAICLink like '%2019%') H 
INNER JOIN GLBudgetHdr D on H.idfGLBudgetHdrKey=D.idfGLBudgetHdrKey
WHERE RID=2 

select * from GLBudgetHdr where idfEAICLink like '%2019%'
order by idfEAICLink 

rollback tran

USE Plt_WCCF
select * from WPEAICLog
update WPEAICLog set idfAction='INSERT' where idfWPEAICLogKey=9083
select * from glbud where budget_code like '%2019%'
update glbud set budget_code=budget_code where budget_code like '%2019%'