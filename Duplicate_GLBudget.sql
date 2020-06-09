WITH CTEDUP_GL as 
(select ROW_NUMBER() OVER (PARTITION By idfWCICCompanyKey,idfBudgetID ORDER BY idfWCICCompanyKey) RowID,* 
from GLBudgetHdr a
--where idfEAICLink in (select idfEAICLink from GLBudgetHdr_tmp b)
)
select * from CTEDUP_GL where RowID>1