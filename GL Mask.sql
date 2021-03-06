SELECT  TOP 25 S.ACTNUMST AS ACTNUMST, ACTDESCR AS ACTDESCR, G.ACTINDX AS ACTINDX
FROM 
    GL00105 S (NOLOCK) INNER JOIN GL00100 G (NOLOCK) ON S.ACTINDX = G.ACTINDX
     
		  INNER JOIN WCDept VDept1 (NOLOCK) ON ((VDept1.idfGLMask <> '' AND S.ACTNUMST LIKE VDept1.idfGLMask) OR (VDept1.idfGLMask <> '' AND S.ACTNUMST LIKE VDept1.idfGLMask2))
		 AND VDept1.idfDeptID = 'QA'
WHERE 
G.ACTIVE=1
 ORDER BY 1
 

 select * from WCDept
 select * from GL00105 S where ACTNUMST like '?[200%' OR S.ACTNUMST LIKE '600%'

 select * from GL00105 S where ACTNUMST like '[200-600]-????-???'
 select ACTNUMBR_1,count(*) from GL00105 S where ACTNUMST like '200%'  OR ACTNUMST like '600%'
  group by ACTNUMBR_1

select PONOTIDS_7,* from POP10100