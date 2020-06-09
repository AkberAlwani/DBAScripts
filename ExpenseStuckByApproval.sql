select idfExPExpenseSheetHdrKey,idfSessionLinkKey,* from EXPExpenseSheetDtl where idfEXPExpenseSheetHdrKey=2
select * from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=2
select * from EXPAprDtl where idfEXPExpenseSheetDtlKey in (select idfEXPExpenseSheetDtlKey from EXPExpenseSheetDtl where idfEXPExpenseSheetHdrKey=2)
select idfEXPAprDtlHistEXPExpenseSheetHdrHistKey,idfEXPExpenseSheetDtlKey,* from EXPAprDtlHist where idfEXPExpenseSheetDtlKey in (select idfEXPExpenseSheetDtlKey from EXPExpenseSheetDtl where idfEXPExpenseSheetHdrKey=2)

select * from EXPAprDtlHist where idfEXPAprDtlHistEXPExpenseSheetHdrHistKey=2546 --Dtl 2498
select * from WCAprPath -- idfLinkTableKey=5, idfWCRRGroupLineUPKey
select * from WCAprPathApproved




--First Query
SELECT a.idfEXPExpenseSheetDtlKey,a.idfAmtExtendedReceipt,idfCurrLineUpSeq,a.idfLine,a.idfDateCreated,
a.idfEXPExpenseSheetHdrKey,a.idfEXPSessionKey,a.idfEXPTypeKey,a.idfSessionLinkKey,a.idfWCDeptKey,a.idfWCLineUPkey,
a.idfWCRRGroupLineUPKey, idfWCAprPathKey,idfLinkTableKey,idfLinkTableName,idfWCSecurityKey
FROM vwEXPExpenseSheetDtlAvail2Approve a
INNER JOIN dbo.WCAprPath WITH (NOLOCK) ON idfLinkTableKey = idfEXPExpenseSheetDtlKey AND idfLinkTableName = 'EXPExpenseSheetDtl'
AND WCAprPath.idfWCRRGroupLineUpKey = a.idfWCRRGroupLineUpKey

--Query1

SELECT edfCompanyName, C.idfPTICompanyKey,C.idfDBName 
FROM DYNAMICS.dbo.vwWCCompany C WITH (NOLOCK) 
INNER JOIN PTIMaster.dbo.PTISecurity S WITH (NOLOCK) ON C.idfPTICompanyKey = S.idfPTICompanyKey AND S.idfModule = 'EXPENSE' 
AND S.idfSecurityID = 'plemay'  ORDER BY edfCompanyName

--Query2

WITH LinesForApproval AS (
    SELECT vwEXPExpenseSheetDtlAvail2Approve.*, idfWCAprPathKey
    FROM vwEXPExpenseSheetDtlAvail2Approve
    INNER JOIN dbo.WCAprPath WITH (NOLOCK) ON idfLinkTableKey = idfEXPExpenseSheetDtlKey AND idfLinkTableName = 'EXPExpenseSheetDtl'
    AND WCAprPath.idfWCRRGroupLineUpKey = vwEXPExpenseSheetDtlAvail2Approve.idfWCRRGroupLineUpKey
	WHERE idfEXPExpenseSheetHdrKey=4
    )
    --INSERT INTO @EXPApproval
    SELECT 	DISTINCT
    EXPExpenseSheetDtl.idfEXPExpenseSheetDtlKey, EXPExpenseSheetDtl.idfEXPExpenseSheetHdrKey, EXPExpenseSheetHdr.idfWCSecurityKey Requester,
    ISNULL(WCLineUpSec.idfWCSecurityKey,WCSecRole.idfWCSecurityKey) Approver, WCLineUpSec.idfWCRoleKey ApproverRole,
    WCLineUpSec.idfWCLineUpSecKey,WCLineUpSec.idfFlagAltrActive,WCRole.idfWCRoleKey,
    CASE
    WHEN NOT EXISTS(SELECT 1 FROM WCLineUpSecAltr WHERE WCLineUpSecAltr.idfWCLineUpSecKey = WCLineUpSec.idfWCLineUpSecKey AND (WCLineUpSecAltr.idfWCRoleKey IS NOT NULL OR WCLineUpSecAltr.idfWCSecurityKey IS NOT NULL)) THEN 0
    --WHEN @nEXPENABLEAPRWITHALTR = 1 AND EXPExpenseSheetHdr.idfWCSecurityKey = WCLineUpSec.idfWCSecurityKey THEN 1
    --WHEN @nEXPENABLEAPRWITHALTR = 1 AND EXPExpenseSheetHdr.idfWCSecurityKey = WCSecRole.idfWCSecurityKey AND WCRole.idfWCRoleKey IS NOT NULL AND Members=1 THEN 1   
	ELSE 0 END idfFlagAltrActiveEnabled,
    idfEXPSessionKey,
    WCLineUp.idfFlagParallelApr, EXPExpenseSheetDtl.idfWCAprPathKey,   WCLineUp.idfFlagInternal,
	  CASE WHEN EXPExpenseSheetDtl.idfWCLineUpKey<0 THEN 1 ELSE 0 END FlagLineUP
    FROM LinesForApproval EXPExpenseSheetDtl
    INNER JOIN EXPExpenseSheetHdr WITH (NOLOCK) ON EXPExpenseSheetDtl.idfEXPExpenseSheetHdrKey = EXPExpenseSheetHdr.idfEXPExpenseSheetHdrKey
    INNER JOIN WCLineUp WITH (NOLOCK) ON WCLineUp.idfWCLineUpKey = EXPExpenseSheetDtl.idfWCLineUpKey
    INNER JOIN WCLineUpSec WITH (NOLOCK) ON WCLineUpSec.idfWCLineUpKey = EXPExpenseSheetDtl.idfWCLineUpKey AND (WCLineUpSec.idfSequence = EXPExpenseSheetDtl.idfCurrLineUpSeq OR WCLineUp.idfFlagParallelApr = 1)
    LEFT OUTER JOIN WCRole WITH (NOLOCK) ON WCRole.idfWCRoleKey = WCLineUpSec.idfWCRoleKey
    LEFT OUTER JOIN WCSecRole WITH (NOLOCK) ON WCSecRole.idfWCRoleKey = WCRole.idfWCRoleKey
    --LEFT OUTER JOIN @RoleMemberCount RoleMemberCount ON RoleMemberCount.idfWCRoleKey = WCRole.idfWCRoleKey




declare @p4 int,@SecurityKey int
SELECT @SecurityKey = idfWCSecurityKey FROM dbo.WCSecurity WITH (NOLOCK) WHERE idfSecurityID = 'plemay'
set @p4=4
exec TWO.dbo.spEXPAprLoad @xnidfWCSecurityKey=3,@xnidfPTICompanyKey=7,@xnGetRecordCountsOnly=1,@xonRecordsPendingApproval=@p4 output
select @p4