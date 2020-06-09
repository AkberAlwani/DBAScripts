We are all set....thanks for the help!

Here is the code we ended up using, in case you  want it:
IF OBJECT_ID('tempdb..#WP_RTRuleDept') IS NOT NULL
    DROP TABLE #WP_RTRuleDept

CREATE TABLE #WP_RTRuleDept
(  
idfWCDeptKey INT
,idfWCRRGroupLineUpKeyMin INT
,idfWCRRGroupLineUpKeyMax INT
,idfWCRRGroupKey INT
)

INSERT INTO #WP_RTRuleDept
Select  
    idfWCDeptKey,
    MIN(GLU.idfWCRRGroupLineUpKey) AS idfWCRRGroupLineUpKeyMin,
    MAX(GLU.idfWCRRGroupLineUpKey) AS idfWCRRGroupLineUpKeyMax, 
    GL.idfWCRRGroupKey 
from WCRRGroup GL
    Inner Join WCRRGroupLineUp GLU on GLU.idfWCRRGroupKey = GL.idfWCRRGroupKey
    INNER JOIN WCDept w ON LEFT(gl.idfDescription,4) = w.idfDeptID
where gl.idfDescription NOT IN ('zOLD_%')
GROUP BY GL.idfWCRRGroupKey, idfWCDeptKey

SELECT
*
FROM
#WP_RTRuleDept

BEGIN TRANSACTION;

SELECT *
FROM
    WCRRTEmplateDtl AS W
    INNER JOIN #WP_RTRuleDept AS T ON W.idfTableLinkKey BETWEEN T.idfWCRRGroupLineUpKeyMin AND T.idfWCRRGroupLineUpKeyMax-- change 9 to the value of idfWCRRGroupLineupKeyfrom the first query
WHERE
    W.idfRQValueWhereSQL like '%Detail.idfWCDeptKey = 1%' 
    AND W.idfTableLinkName ='WCRRGroupLineUp'

UPDATE WCRRTEmplateDtl 
SET
    idfRQValueWhereSQL = REPLACE(CONVERT(VARCHAR(500),W.idfRQValueWhereSQL),'Detail.idfWCDeptKey = 1','Detail.idfWCDeptKey = '+ CONVERT(VARCHAR(20), T.idfWCDeptKey) +'')
    ,idfValue = T.idfWCDeptKey
FROM
    WCRRTEmplateDtl AS W
    INNER JOIN #WP_RTRuleDept AS T ON W.idfTableLinkKey BETWEEN T.idfWCRRGroupLineUpKeyMin AND T.idfWCRRGroupLineUpKeyMax-- change 9 to the value of idfWCRRGroupLineupKeyfrom the first query
WHERE
    W.idfRQValueWhereSQL like '%Detail.idfWCDeptKey = 1%' 
    AND W.idfTableLinkName ='WCRRGroupLineUp'
;

SELECT *
FROM
    WCRRTEmplateDtl AS W
    INNER JOIN #WP_RTRuleDept AS T ON W.idfTableLinkKey BETWEEN T.idfWCRRGroupLineUpKeyMin AND T.idfWCRRGroupLineUpKeyMax-- change 9 to the value of idfWCRRGroupLineupKeyfrom the first query
WHERE
    W.idfRQValueWhereSQL like '%Detail.idfWCDeptKey = 1%' 
    AND W.idfTableLinkName ='WCRRGroupLineUp'

SELECT
*
FROM
    WCRRGroupLineUp AS W
    INNER JOIN #WP_RTRuleDept AS T ON T.idfWCRRGroupKey= W.idfWCRRGroupKey 

UPDATE WCRRGroupLineUp 
SET 
    idfRQRuleSQL = 
    REPLACE
    (
        CONVERT(VARCHAR(500),idfRQRuleSQL)
        ,'Detail.idfWCDeptKey = 1'
        ,'Detail.idfWCDeptKey = '+ CONVERT(VARCHAR(20), T.idfWCDeptKey) +''
    )
    ,idfWCRRTemplateSPParams = REPLACE(CONVERT(VARCHAR(500),idfWCRRTemplateSPParams),'''1'',',''''+ CONVERT(VARCHAR(20), T.idfWCDeptKey) +''',')
FROM
    WCRRGroupLineUp AS W
    INNER JOIN #WP_RTRuleDept AS T ON T.idfWCRRGroupKey= W.idfWCRRGroupKey -- change 9 to the value of idfWCRRGroupLineupKeyfrom the first query

SELECT
*
FROM
    WCRRGroupLineUp AS W
    INNER JOIN #WP_RTRuleDept AS T ON T.idfWCRRGroupKey= W.idfWCRRGroupKey 

--ROLLBACK TRANSACTION;
COMMIT TRANSACTION;