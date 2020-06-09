

BEGIN TRAN
/*
UPDATE GLBudgetActual SET idfAmt1000REQUnSubmitted = 0 WHERE idfAmt1000REQUnSubmitted < 0
UPDATE GLBudgetActual SET idfAmt1020REQApproved = 0 WHERE idfAmt1020REQApproved < 0
UPDATE GLBudgetActual SET idfAmt1010REQSubmitted = 0 WHERE idfAmt1010REQSubmitted < 0

DELETE FROM  GLBudgetActualTrx WHERE idfAmount < 0

EXEC spGLBudgetBalance 'GLBudgetActual'

*/

DELETE GLBudgetActual
DELETE GLBudgetActualTrx WHERE idfAmount < 0

EXEC spGLBudgetBalance 'GLBudgetActualTRX'
EXEC spGLBudgetBalance 'GLBudgetActual'

--SELECT * FROM GLBudgetActual
--419
--SELECT DISTINCT idfRQDetailKey  FROM RQDetailDistribution WHERE  idfAmtExtended <= 0

DECLARE @Keys TABLE (idfRQDetailDistributionKey INT, idfRQDetailKey INT)
INSERT INTO @Keys (idfRQDetailDistributionKey,idfRQDetailKey)
SELECT MIN(idfRQDetailDistributionKey) AS idfRQDetailDistributionKey,idfRQDetailKey FROM RQDetailDistribution WHERE  idfAmtExtended <= 0 GROUP BY idfRQDetailKey

DELETE RQDetailDistribution
FROM RQDetailDistribution
LEFT OUTER JOIN @Keys TMP ON TMP.idfRQDetailDistributionKey = RQDetailDistribution.idfRQDetailDistributionKey
WHERE TMP.idfRQDetailDistributionKey IS NULL AND idfAmtExtended <= 0

UPDATE RQDetailDistribution SET idfAmtExtended = RQDetail.edfAmtExtended, idfAmtExtendedHome= RQDetail.edfAmtHomeExtended
FROM RQDetailDistribution
INNER JOIN RQDetail ON RQDetail.idfRQDetailKey = RQDetailDistribution.idfRQDetailKey
WHERE  idfAmtExtended <= 0 
/*
SELECT * FROM @Keys TMP
INNER JOIN RQDetailDistribution ON RQDetailDistribution.idfRQDetailKey = TMP.idfRQDetailKey
*/


--------------------------------------------------------

DECLARE @Keys2 TABLE (idfRQAprDtlDistributionKey INT, idfRQAprDtlKey INT)
INSERT INTO @Keys2 (idfRQAprDtlDistributionKey,idfRQAprDtlKey)
SELECT MIN(idfRQAprDtlDistributionKey) AS idfRQAprDtlDistributionKey,RQAprDtlDistribution.idfRQAprDtlKey 
FROM RQAprDtlDistribution 
INNER JOIN RQAprDtl ON RQAprDtl.idfRQAprDtlKey = RQAprDtlDistribution.idfRQAprDtlKey
INNER JOIN RQDetail ON RQDetail.idfRQDetailKey = RQAprDtl.idfRQDetailKey AND RQDetail.idfRQSessionKey = 120
WHERE  idfAmtExtended <= 0 GROUP BY RQAprDtlDistribution.idfRQAprDtlKey

DELETE RQAprDtlDistribution
FROM RQAprDtlDistribution
INNER JOIN RQAprDtl ON RQAprDtl.idfRQAprDtlKey = RQAprDtlDistribution.idfRQAprDtlKey
INNER JOIN RQDetail ON RQDetail.idfRQDetailKey = RQAprDtl.idfRQDetailKey AND RQDetail.idfRQSessionKey = 120
LEFT OUTER JOIN @Keys2 TMP ON TMP.idfRQAprDtlDistributionKey = RQAprDtlDistribution.idfRQAprDtlDistributionKey
WHERE TMP.idfRQAprDtlDistributionKey IS NULL AND idfAmtExtended <= 0  

UPDATE RQAprDtlDistribution SET idfAmtExtended = RQAprDtl.edfAmtExtended, idfAmtExtendedHome= RQAprDtl.edfAmtHomeExtended
FROM RQAprDtlDistribution
INNER JOIN RQAprDtl ON RQAprDtl.idfRQAprDtlKey = RQAprDtlDistribution.idfRQAprDtlKey
INNER JOIN RQDetail ON RQDetail.idfRQDetailKey = RQAprDtl.idfRQDetailKey AND RQDetail.idfRQSessionKey = 120
WHERE  idfAmtExtended <= 0 

--------------------------------------------------------

DECLARE @Keys3 TABLE (idfRQRevDtlDistributionKey INT, idfRQRevDtlKey INT)
INSERT INTO @Keys3 (idfRQRevDtlDistributionKey,idfRQRevDtlKey)
SELECT MIN(idfRQRevDtlDistributionKey) AS idfRQRevDtlDistributionKey,RQRevDtlDistribution.idfRQRevDtlKey 
FROM RQRevDtlDistribution 
INNER JOIN RQRevDtl ON RQRevDtl.idfRQRevDtlKey = RQRevDtlDistribution.idfRQRevDtlKey
INNER JOIN RQDetail ON RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey AND RQDetail.idfRQSessionKey  > 140 AND RQDetail.idfRQSessionKey < 170
WHERE  idfAmtExtended <= 0 GROUP BY RQRevDtlDistribution.idfRQRevDtlKey

DELETE RQRevDtlDistribution
FROM RQRevDtlDistribution
INNER JOIN RQRevDtl ON RQRevDtl.idfRQRevDtlKey = RQRevDtlDistribution.idfRQRevDtlKey
INNER JOIN RQDetail ON RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey AND RQDetail.idfRQSessionKey  > 140 AND RQDetail.idfRQSessionKey < 170
LEFT OUTER JOIN @Keys3 TMP ON TMP.idfRQRevDtlDistributionKey = RQRevDtlDistribution.idfRQRevDtlDistributionKey
WHERE TMP.idfRQRevDtlDistributionKey IS NULL AND  idfAmtExtended <= 0

UPDATE RQRevDtlDistribution SET idfAmtExtended = RQRevDtl.edfAmtExtended, idfAmtExtendedHome= RQRevDtl.edfAmtHomeExtended
FROM RQRevDtlDistribution
INNER JOIN RQRevDtl ON RQRevDtl.idfRQRevDtlKey = RQRevDtlDistribution.idfRQRevDtlKey
INNER JOIN RQDetail ON RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey AND RQDetail.idfRQSessionKey  > 140 AND RQDetail.idfRQSessionKey < 170
WHERE  idfAmtExtended <= 0 

EXEC spGLBudgetBalance 'GLBudgetActualTRX'
EXEC spGLBudgetBalance 'GLBudgetActual'


SELECT * FROM GLBudgetActual

SELECT * FROM RQDetailDistribution WHERE idfAmtExtended <= 0
SELECT * FROM RQDetailDistribution

ROLLBACK TRAN
