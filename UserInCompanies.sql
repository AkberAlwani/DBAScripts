--TRUNCATE TABLE dbo.PTICurrency
--TRUNCATE TABLE dbo.PTICurrencyRateHdr
--TRUNCATE TABLE dbo.PTICurrencyRateDtl


SELECT * FROM PTICurrency
SELECT	* FROM PTICurrencyRateHdr WHERE idfPTICurrencyKeyFrom = 48 AND idfPTICurrencyKeyTo = 77 
SELECT 	* FROM PTICurrencyRateHdr WHERE idfPTICurrencyKeyFrom = 77 AND idfPTICurrencyKeyTo = 48
--select * into PTICurrencyRateDtl_bak from PTICurrencyRateDtl where idfPTICurrencyRateHdrKey=11 and idfPTICurrencyRateDtlKey>42765
--delete from PTICurrencyRateDtl where idfPTICurrencyRateHdrKey=133 and idfPTICurrencyRateDtlKey>=110963
--delete from PTICurrencyRateDtl where idfPTICurrencyRateHdrKey=125 and idfPTICurrencyRateDtlKey>=95631
SELECT 	* FROM PTICurrencyRateDtl WHERE idfPTICurrencyRateHdrKey = 133
SELECT 	* FROM PTICurrencyRateDtl WHERE idfPTICurrencyRateHdrKey = 125

SELECT  * from WCEmailQueue

SELECT
	COUNT(DISTINCT (idfSecurityID)) AS 'USERCOUNT'
FROM PTIMaster..PTISecurity 

SELECT idfSecurityID,COUNT(DISTINCT idfPTICompanyKey )
FROM (
SELECT idfSecurityID,idfPTICompanyKey 
FROM PTIMaster..PTISecurity p) t1
GROUP BY idfSecurityID
ORDER BY 1

SELECT DISTINCT p.idfDBName,p1.idfSecurityID,p.idfPTICompanyKey 
FROM PTIMaster..PTICompany p
INNER JOIN PTImaster..PTISecurity p1
ON P.idfPTICompanyKey=p1.idfPTICompanyKey

SELECT
idfSecurityID,
   [WPECompany_FE], [WPECompany],[TWO],[WPECompany_SL],[WPECompany_SAGE],[WPECompany_1810]
FROM (SELECT DISTINCT p.idfDBName,p1.idfSecurityID,p.idfPTICompanyKey 
FROM PTIMaster..PTICompany p
INNER JOIN PTImaster..PTISecurity p1
ON P.idfPTICompanyKey=p1.idfPTICompanyKey) ps
PIVOT
(Count(ps.idfPTICompanyKey)
FOR ps.idfDBName IN ([WPECompany_FE], [WPECompany],[TWO],[WPECompany_SL],[WPECompany_SAGE],[WPECompany_1810])
) AS pvt
