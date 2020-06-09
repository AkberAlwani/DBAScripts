/* This query allows to retrieve all the most current Exchange Rates from the Rate Table MC00100
in the DYNAMICS DB. Given the nature of error prone entries, it can't be based on the Expiration date,
as sometimes totally unreallistic dates show up there (like 3016-12-31, due to a typo).
The query was written in a way that lists in descending order by the latest EXCHDATE
(c) 2017-02-03 B. Bucher
*/
SELECT EXGTBLID
,CURNCYID ,EXCHDATE ,XCHGRATE ,EXPNDATE
FROM DYNAMICS.dbo.MC00100 
Inner join (Select EXGTBLID as ExcTabID, max(EXCHDATE) as ExcDate
from MC00100
Group by EXGTBLID) GroupDT
on MC00100.EXGTBLID = GroupDT.ExcTabID
and MC00100.EXCHDATE = GroupDT.ExcDate
ORDER BY GroupDT.ExcDate DESC