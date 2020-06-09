Hi Michael,
Following queries can be run to get the desire result, you can customized these queries per your need:

-- invoices Not sent over to Sage and next approval stage
SELECT ISNULL(p.idfWCRRGroupLineUpKey,0) AS LineSeq,D.idfRCVHeaderKey as Receipt, H.idfRCTNumber,wcl.idfDescription AS APPROVAL , wcl.idfFlagParallelApr as Parallel,
IIF(ISNULL(Sec.idfRoleId,'0')!='0',rtrim(Sec.idfRoleID)+'-'+Sec.idfDescription,S.idfDescription) as  APPROVER 
--SELECT * 
FROM WCAprPath	P
LEFT OUTER JOIN RCVDetail D WITH (NOLOCK) ON  D.idfRCVDetailKey=P.idfLinkTableKey
LEFT OUTER JOIN RCVHeader H WITH (NOLOCK) ON  H.idfRCVHeaderKey=D.idfRCVHeaderKey
LEFT OUTER JOIN WCRRGroupLineUp RR WITH (NOLOCK) on RR.idfWCRRGroupLineUpKey=P.idfWCRRGroupLineUpKey
LEFT OUTER JOIN WCLineUpSec lnup WITH (NOLOCK) ON lnup.idfWCLineUpKey = RR.idfWCLineUpKey
LEFT OUTER JOIN WCSecurity S WITH (NOLOCK) ON lnup.idfWCSecurityKey = S.idfWCSecurityKey
LEFT OUTER JOIN WCLineUp WCL on WCL.idfWCLineUpKey=lnup.idfWCLineUpKey
LEFT OUTER Join WCRole Sec on Sec.idfWCRoleKey=lnup.idfWCRoleKey
--WHERE idfLinkTableKey = 59 AND idfLinkTableName = 'RQDetail' ORDER BY idfWCAprPathKey
Where D.idfRCVSessionKey>100 and d.idfRCVSessionKey<130 
AND H.idfTransactionType in (2,3)

--- invoice not sent over
SELECT h.idfRCTNumber,*
from RCVHeader H WITH (NOLOCK) 
INNER JOIN RCVDetail D WITH (NOLOCK) ON  H.idfRCVHeaderKey=D.idfRCVHeaderKey
WHERE H.idfTransactionType in (2,3)

--PO not sent over to Sage
select d.idfRQHeaderKey ReqNo ,edfPONumber PONumber,Case D.idfRQSessionKey 
          When 145 THEN 'Pending Review'
		  WHEN 150 THEN 'In Review Session' 
		  WHEN 170 THEN 'Review Process' ELSE 'NONE' END,idfRQSessionKey
,* 
from RQDetail D WITH (NOLOCK)  
INNER JOIN RQHeader H WITH (NOLOCK) on d.idfRQHeaderKey=h.idfRQHeaderKey
WHERE idfRQSessionKey>=140
and edfPONumber=''

--PO Sent to Sage (POHeaderHist & PODetailHist for those PO which are fully closed)
SELECT idfRQDetailKey,idfPONumber,* 
FROM POHeader H WITH (NOLOCK) 
INNER JOIN PODetail D WITH (NOLOCK)  on H.idfPOHeaderKey=D.idfPOHeaderKey


Thanks
Ali