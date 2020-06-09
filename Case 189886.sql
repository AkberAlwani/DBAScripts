--Case 189886 use NRMCP 
--2/26/2018 1:30
select * from PTIMaster..PTICompany
select * from RQHeader where idfRQHeaderKey between 364 and 366
select * from RQHeader where idfRQHeaderKey between 368 and 371
select idfCurrLineUpSeq,* from RQDetail where idfRQHeaderKey between 361 and 361
select idfRQHeaderKey,Sum(edfAmtAprExtended) edfAmtAprExtended,Sum(edfAmtHomeExtended) edfAmtHomeExtended,Sum(idfAmtSubTotal) idfAmtSubTotal,Sum(idfAmtSubTotalApr) idfAmtSubTotalApr,Sum(idfAmtSubTotalHome) idfAmtSubTotalHome
from RQDetail 
where idfRQHeaderKey between 361 and 362
GROUP BY idfRQHeaderKey

BEGIN TRAN
 UPDATE RQDetail set idfAmtSubTotal=edfAmtExtended, 
                     idfAmtSubTotalApr=edfAmtAprExtended,
					 idfAmtSubTotalHome=edfAmtHomeExtended
 WHERE idfRQHeaderKey between 361 and 361

 SELECT idfRQHeaderKey,Sum(edfAmtAprExtended) edfAmtAprExtended,Sum(edfAmtHomeExtended) edfAmtHomeExtended,Sum(idfAmtSubTotal) idfAmtSubTotal,Sum(idfAmtSubTotalApr) idfAmtSubTotalApr,Sum(idfAmtSubTotalHome) idfAmtSubTotalHome
 from RQDetail 
 where idfRQHeaderKey between 361 and 361
 GROUP BY idfRQHeaderKey

 Update RQHeader set idfAmtSubTotal=b.idfAmtSubTotal,idfAmtSubTotalApr=B.idfAmtSubTotalApr,idfAmtSubTotalHome=B.idfAmtSubTotalHome
 From RQHeader a
 INNER JOIN (SELECT idfRQHeaderKey,Sum(edfAmtAprExtended) edfAmtAprExtended,Sum(edfAmtHomeExtended) edfAmtHomeExtended,Sum(idfAmtSubTotal) idfAmtSubTotal,Sum(idfAmtSubTotalApr) idfAmtSubTotalApr,Sum(idfAmtSubTotalHome) idfAmtSubTotalHome
 from RQDetail 
 where idfRQHeaderKey between 361 and 361
 GROUP BY idfRQHeaderKey ) b on a.idfRQHeaderKey=b.idfRQHeaderKey
 
 select * from RQHeader where idfRQHeaderKey between 361 and 361
ROLLBACK TRAN


BEGIN TRAN
update RQDetail  set idfAmtSubTotal=10000,idfAmtSubTotalApr=13116.47,idfAmtSubTotalHome=13116.47,idfCurrLineUpSeq=1 where idfRQHeaderKey=145
update RQHeader set idfAmtSubTotal=10000,idfAmtSubTotalApr=13116.47,idfAmtSubTotalHome=13116.47,udfNumericField01=10000 where idfRQHeaderKey=145

SELECT * FROM RQDetail where idfRQHeaderKey=145
SELECT * FROM RQHeader where idfRQHeaderKey=145
ROLLBACK TRAN

SELECT D.* 
	,SD.idfNameLast + ', ' + SD.idfNameFirst + ' ('+ SD.idfSecurityID + ')' AS vdfDelegate
	,ISNULL(CASE WHEN SP.idfWCSecurityKey IS NOT NULL THEN SP.idfSecurityID WHEN WCRole.idfWCRoleKey IS NULL THEN WCSecurity.idfSecurityID ELSE WCRole.idfRoleID END,'') AS vdfDisplay
	,ISNULL(CASE WHEN SP.idfWCSecurityKey IS NOT NULL THEN SP.idfNameLast + ', ' + SP.idfNameFirst WHEN WCRole.idfWCRoleKey IS NULL THEN WCSecurity.idfNameLast + ', ' + WCSecurity.idfNameFirst ELSE WCRole.idfDescription END,'') AS vdfDisplayDesc
    ,WCLineUp.idfFlagParallelApr
    ,WCLineUp.idfMinAprRequired
    ,WCLineUpSec.idfWCLineUpSecKey
	FROM RVSG.dbo.RQDetail			D	WITH (NOLOCK)
	INNER JOIN RVSG.dbo.RQHeader		H	WITH (NOLOCK) ON H.idfRQHeaderKey = D.idfRQHeaderKey
	INNER JOIN RVSG.dbo.RQSession	S	WITH (NOLOCK) ON S.idfRQSessionKey = D.idfRQSessionKey
	LEFT OUTER JOIN RVSG.dbo.WCLineUp		WITH (NOLOCK) ON WCLineUp.idfWCLineUpKey = D.idfWCLineUpKey
	LEFT OUTER JOIN RVSG.dbo.WCLineUpSec		WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
                                                            AND (WCLineUpSec.idfSequence =  D.idfCurrLineUpSeq OR (WCLineUp.idfFlagParallelApr = 1 AND WCLineUpSec.idfSequence = 0 AND D.idfRQSessionKey IN (110,120)))
	LEFT OUTER JOIN RVSG.dbo.WCRole			WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCLineUpSec.idfWCRoleKey
	LEFT OUTER JOIN RVSG.dbo.WCSecurity		WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCLineUpSec.idfWCSecurityKey
	LEFT OUTER JOIN RVSG.dbo.WCSecurity	SD	WITH (NOLOCK) ON SD.idfWCSecurityKey = H.idfWCSecurityKeyDelegate
    LEFT OUTER JOIN RVSG.dbo.WCSecurity  SP  WITH (NOLOCK) ON SP.idfWCSecurityKey = (D.idfWCLineUpKey * -1)
	WHERE D.idfRQHeaderKey = 364 ORDER BY D.idfLine