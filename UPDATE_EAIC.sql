--Short Version
UPDATE GLPeriod set idfEAICLink= CONVERT(VARCHAR(2),idfPERIODID)+'-'+CONVERT(VARCHAR(20),idfYEAR)+'-'+'TWO' 
-- Long Versionh
--UPDATE GLPeriod set idfEAICLink=CONVERT(VARCHAR(2),PERIODID)+'-'+CONVERT(VARCHAR(20),YEAR1)+'-'+'TWO'  
SELECT * 
FROM TWO.dbo.SY40100 GPPER WITH (NOLOCK)
INNER JOIN GLPeriod WPPER WITH (NOLOCK) on GPPER.PERIODID=WPPER.idfPeriodID and GPPER.Year1=WPPER.idfYear
WHERE (YEAR1 >= 2017)


--Short Version 
UPDATE GLBudgetHdr set idfEAICLink=RTRIM(idfBudgetId) +'-'+ CONVERT(VARCHAR(20),year(idfBudgetStart))+'-TWO'       

--Long Version
UPDATE GLBudgetHdr set idfEAICLink=RTRIM(BUDGETID) +'-'+ CONVERT(VARCHAR(20),YEAR1)+'-TWO'       
FROM TWO.dbo.GL00200 A WITH (NOLOCK)
INNER JOIN GLBudgetHdr B WITH (NOLOCK) on a.BUDGETID=b.idfBudgetId and a.From_Date=idfBudgetStart AND a.ToDate=idfBudgetEnd
WHERE (YEAR1 >2017)

UPDATE GLBudgetDtl
SET idfEAICLink = RTRIM(BUDGETID) +'-'+ CONVERT(VARCHAR(20),GL00201.YEAR1) +'-'+ CONVERT(VARCHAR(20),GL00201.ACTINDX) +'-'+ CONVERT(VARCHAR(20),PERIODID)+'-TWO' 
FROM TWO.dbo.GL00201			  WITH (NOLOCK)
INNER JOIN TWO.dbo.GL00105 GLGP WITH (NOLOCK) ON GLGP.ACTINDX = GL00201.ACTINDX
LEFT OUTER JOIN TWO.dbo.SY00300 S1 WITH (NOLOCK) ON S1.SGMTNUMB = 1
LEFT OUTER JOIN TWO.dbo.SY00300 S2 WITH (NOLOCK) ON S2.SGMTNUMB = 2
LEFT OUTER JOIN TWO.dbo.SY00300 S3 WITH (NOLOCK) ON S3.SGMTNUMB = 3
LEFT OUTER JOIN TWO.dbo.SY00300 S4 WITH (NOLOCK) ON S4.SGMTNUMB = 4
LEFT OUTER JOIN TWO.dbo.SY00300 S5 WITH (NOLOCK) ON S5.SGMTNUMB = 5
INNER JOIN GLAccount GLWP WITH (NOLOCK) ON GLWP.idfGLID=GLGP.ACTNUMST
INNER JOIN GLBudgetDtl DTL WITH (NOLOCK) ON DTL.idfGLAccountKey=GLWP.idfGLAccountKey
WHERE (YEAR1 >= 2017)



UPDATE GLBudgetActual
SET idfEAICLink = RTRIM(BUDGETID) +'-'+ CONVERT(VARCHAR(20),GL00201.YEAR1) +'-'+ CONVERT(VARCHAR(20),GL00201.ACTINDX) +'-'+ CONVERT(VARCHAR(20),PERIODID)+'-TWO' 
FROM TWO.dbo.GL00201			  WITH (NOLOCK)
INNER JOIN TWO.dbo.GL00105 GLGP WITH (NOLOCK) ON GLGP.ACTINDX = GL00201.ACTINDX
LEFT OUTER JOIN TWO.dbo.SY00300 S1 WITH (NOLOCK) ON S1.SGMTNUMB = 1
LEFT OUTER JOIN TWO.dbo.SY00300 S2 WITH (NOLOCK) ON S2.SGMTNUMB = 2
LEFT OUTER JOIN TWO.dbo.SY00300 S3 WITH (NOLOCK) ON S3.SGMTNUMB = 3
LEFT OUTER JOIN TWO.dbo.SY00300 S4 WITH (NOLOCK) ON S4.SGMTNUMB = 4
LEFT OUTER JOIN TWO.dbo.SY00300 S5 WITH (NOLOCK) ON S5.SGMTNUMB = 5
INNER JOIN GLAccount GLWP WITH (NOLOCK) ON GLWP.idfGLID=GLGP.ACTNUMST
INNER JOIN GLBudgetActual DTL WITH (NOLOCK) ON DTL.idfGLAccountKey=GLWP.idfGLAccountKey
WHERE YEAR1 >= 2017)


