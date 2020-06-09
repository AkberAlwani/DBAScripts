
SELECT ISNULL(p.idfWCRRGroupLineUpKey,0) AS LineSeq,D.idfRQHeaderKey as Requisition, wcl.idfDescription AS APPROVAL , wcl.idfFlagParallelApr as Parallel,
IIF(ISNULL(Sec.idfRoleId,'0')!='0',rtrim(Sec.idfRoleID)+'-'+Sec.idfDescription,S.idfDescription) as  APPROVER 
--SELECT * 
FROM WCAprPath	P
LEFT OUTER JOIN RQDetail D WITH (NOLOCK) ON  D.idfRQDetailKey=P.idfLinkTableKey
LEFT OUTER JOIN WCRRGroupLineUp RR WITH (NOLOCK) on RR.idfWCRRGroupLineUpKey=P.idfWCRRGroupLineUpKey
LEFT OUTER JOIN WCLineUpSec lnup WITH (NOLOCK) ON lnup.idfWCLineUpKey = RR.idfWCLineUpKey
LEFT OUTER JOIN WCSecurity S WITH (NOLOCK) ON lnup.idfWCSecurityKey = S.idfWCSecurityKey
LEFT OUTER JOIN WCLineUp WCL on WCL.idfWCLineUpKey=lnup.idfWCLineUpKey
LEFT OUTER Join WCRole Sec on Sec.idfWCRoleKey=lnup.idfWCRoleKey
--WHERE idfLinkTableKey = 59 AND idfLinkTableName = 'RQDetail' ORDER BY idfWCAprPathKey
Where D.idfRQSessionKey>100 and d.idfRQSessionKey<130 

Select * from WCLineUpSec
select * from WcRole
select * from WCRRGroupLineUp 
select * from WCLineUp 
select * from WCAprPath where idfLinkTableKey=59

select idfRCVDetailKey,idfRQSessionKey,idfRQDetailKey from RQDetail where idfRQHeaderKey=56



--SELECT ISNULL(p.idfWCRRGroupLineUpKey,0) AS idfWCRRGroupLineUpKey,ISNULL(g.idfWCLineUpKey,0) AS idfWCLineUpKey,p.idfWCSecurityKey,p.idfWCDataObjectKeyAprReq,p.idfWCDataObjectLinkKeyAprReq,p.idfWCAprPathKey
SELECT s.*
FROM TWO.dbo.WCAprPath p WITH (NOLOCK)
LEFT OUTER JOIN TWO.dbo.WCRRGroupLineUp g WITH (NOLOCK) ON p.idfWCRRGroupLineUpKey = g.idfWCRRGroupLineUpKey
LEFT OUTER JOIN TWO.dbo.WCSecurity S WITH (NOLOCK) ON p.idfWCSecurityKey = S.idfWCSecurityKey
WHERE idfLinkTableKey = 59 AND idfLinkTableName = 'RQDetail' ORDER BY idfWCAprPathKey


SELECT vdfDisplay	= ISNULL(CASE WHEN WCRole.idfWCRoleKey IS NULL THEN WCSecurity.idfNameLast + ', ' + WCSecurity.idfNameFirst ELSE WCRole.idfRoleID END,''),
       vdfDisplayDesc	= ISNULL(CASE WHEN WCRole.idfWCRoleKey IS NULL THEN '' ELSE WCRole.idfDescription END,''),
	    WCLineUp.idfDescription,WCLineUp.idfLineUpID,ISNULL(WCLineUpSec.idfSequence,-1) idfSequence,idfFlagParallelApr,WCLineUpSec.idfWCLineUpSecKey
FROM WCLineUp (NOLOCK)
LEFT OUTER JOIN WCLineUpSec  WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = WCLineUp.idfWCLineUpKey 
LEFT OUTER JOIN WCRole       WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCLineUpSec.idfWCRoleKey
LEFT OUTER JOIN WCSecurity   WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = WCLineUpSec.idfWCSecurityKey
--WHERE WCLineUp.idfWCLineUpKey = 1
ORDER BY WCLineUpSec.idfSequence



SELECT idfLine,GR.idfDescription,idfPrecedence,TD.idfFilterType,TD.*
FROM WCAprPath A
INNER JOIN RQDetail D ON A.idfLinkTableKey = D.idfRQDetailKey AND idfLinkTableName = 'RQDetail'
INNER JOIN RQHeader H ON H.idfRQHeaderKey= D.idfRQHeaderKey
INNER JOIN WCRRGroupLineUp G ON G.idfWCRRGroupLineUpKey = A.idfWCRRGroupLineUpKey
INNER JOIN WCRRGroup GR ON GR.idfWCRRGroupKey = G.idfWCRRGroupKey
INNER JOIN WCRRTemplateDtl TD ON TD.idfTableLinkKey = G.idfWCRRGroupLineUpKey AND idfTableLinkName = 'WCRRGroupLineUp'
WHERE D.idfRQHeaderKey= 2607


---- Expense
SELECT ISNULL(p.idfWCRRGroupLineUpKey,0) AS LineSeq,D.idfEXPExpenseSheetDtlKey as ExpenseDtl,d.idfEXPExpenseSheetHdrKey ExpHDrKey, wcl.idfDescription AS APPROVAL , wcl.idfFlagParallelApr as Parallel,
IIF(ISNULL(Sec.idfRoleId,'0')!='0',rtrim(Sec.idfRoleID)+'-'+Sec.idfDescription,S.idfDescription) as  APPROVER 
--SELECT * 
FROM WCAprPath	P
LEFT OUTER JOIN EXPExpenseSheetDtl D WITH (NOLOCK) ON  D.idfEXPExpenseSheetDtlKey=P.idfLinkTableKey
LEFT OUTER JOIN WCRRGroupLineUp RR WITH (NOLOCK) on RR.idfWCRRGroupLineUpKey=P.idfWCRRGroupLineUpKey
LEFT OUTER JOIN WCLineUpSec lnup WITH (NOLOCK) ON lnup.idfWCLineUpKey = RR.idfWCLineUpKey
LEFT OUTER JOIN WCSecurity S WITH (NOLOCK) ON lnup.idfWCSecurityKey = S.idfWCSecurityKey
LEFT OUTER JOIN WCLineUp WCL on WCL.idfWCLineUpKey=lnup.idfWCLineUpKey
LEFT OUTER Join WCRole Sec on Sec.idfWCRoleKey=lnup.idfWCRoleKey
--WHERE idfLinkTableKey = 59 AND idfLinkTableName = 'RQDetail' ORDER BY idfWCAprPathKey
Where D.idfEXPSessionKey>100 and d.idfEXPSessionKey<130 
--AND d.idfEXPExpenseSheetHdrKey=601
