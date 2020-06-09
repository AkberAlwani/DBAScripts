--1) Module - Expense:

SELECT   
H.idfEXPExpenseSheetHdrKey AS Expense_Sheet
,CASE WHEN H.idfEXPEntryTypeKey=1 THEN 'Expense' ELSE 'Travel Request' END AS [Type]
,WCSecurity.idfSecurityID AS Employee_ID
,WCSecurity.idfDescription AS Employee
,ISNULL(S2.idfDescription,'') AS Entered_By
,H.idfDateCreated AS Created
,CASE WHEN D.idfEXPSessionKey > 169 THEN H.idfDateModified ELSE NULL END AS Batched
,CASE WHEN H.idfFlagSubmitted=1 THEN 'Yes' ELSE 'No' END AS Submitted
, ISNULL(WCDept.idfDeptID,'') AS Department
, H.idfDescription AS Expense_Sheet_Name
, H.edfAmtHomeExtended AS Total
, SRC.idfCompanyCode AS Source_Company
, ISNULL(STRG.idfCompanyCode,STRG.idfCompanyCode) AS Target_Company
, ISNULL(SPLIT.idfDay,D.idfDay) AS [Date]
, ISNULL(SPLIT.idfDescription,D.idfDescription) AS [Description]
, ISNULL(SEXPType.idfTypeID,EXPType.idfTypeID) AS Expense_Type
, ISNULL(SEXPPayment.idfPaymentID,EXPPayment.idfPaymentID) AS Payment_Method
, ISNULL(SGLAccount.idfGLID,GLAccount.idfGLID) AS GL_Account
, ISNULL(SPLIT.idfQuantity,D.idfQuantity) AS Qty
, ISNULL(SPLIT.edfPrice,D.edfPrice) AS Price
, CURR.edfCurrencyID AS Currency
,ISNULL(SPLIT.edfAmtExtended,D.edfAmtExtended) AS Amount
,ISNULL(EXPSession.idfEXPSessionKey,SEXPSession.idfEXPSessionKey) AS Status_No
,LRD.idfDescription AS Status_Description

FROM
	EXPExpenseSheetHdr AS H WITH (NOLOCK)
	INNER JOIN dbo.EXPExpenseSheetDtl AS D WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrKey = H.idfEXPExpenseSheetHdrKey
	INNER JOIN WCSecurity WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = H.idfWCSecurityKey
	LEFT OUTER JOIN dbo.EXPExpenseSheetDtlSplit  SPLIT WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlKey = SPLIT.idfEXPExpenseSheetDtlKey
	LEFT OUTER JOIN WCSecurity S2 (NOLOCK) ON S2.idfWCSecurityKey = H.idfWCSecurityKeyCreated
	LEFT OUTER JOIN WCDept (NOLOCK) ON H.idfWCDeptKey=WCDept.idfWCDeptKey
	LEFT OUTER JOIN dbo.EXPSession WITH (NOLOCK) ON EXPSession.idfEXPSessionKey = D.idfEXPSessionKey
	LEFT OUTER JOIN dbo.EXPSession SEXPSession WITH (NOLOCK) ON SEXPSession.idfEXPSessionKey = SPLIT.idfEXPSessionKey
	LEFT OUTER JOIN vwFNACurrency CURR WITH (NOLOCK) ON CURR.idfPTICurrencyKey = D.idfPTICurrencyKey
	LEFT OUTER JOIN dbo.EXPType WITH (NOLOCK) ON EXPType.idfEXPTypeKey = D.idfEXPTypeKey
	LEFT OUTER JOIN dbo.EXPType SEXPType WITH (NOLOCK) ON SEXPType.idfEXPTypeKey = SPLIT.idfEXPTypeKey
	LEFT OUTER JOIN dbo.GLAccount WITH (NOLOCK) ON GLAccount.idfGLAccountKey = D.idfGLAccountKey
	LEFT OUTER JOIN dbo.GLAccount SGLAccount WITH (NOLOCK) ON SGLAccount.idfGLAccountKey = SPLIT.idfGLAccountKey
	LEFT OUTER JOIN dbo.EXPPayment WITH (NOLOCK) ON D.idfEXPPaymentKey = EXPPayment.idfEXPPaymentKey
	LEFT OUTER JOIN dbo.EXPPayment SEXPPayment WITH (NOLOCK) ON SPLIT.idfEXPPaymentKey = SEXPPayment.idfEXPPaymentKey
	LEFT OUTER JOIN dbo.WCICCompany SRC WITH (NOLOCK) ON SRC.idfWCICCompanyKey = D.idfWCICCompanyKeySource
	LEFT OUTER JOIN dbo.WCICCompany TRG WITH (NOLOCK) ON TRG.idfWCICCompanyKey = D.idfWCICCompanyKeyTarget
	LEFT OUTER JOIN dbo.WCICCompany STRG WITH (NOLOCK) ON STRG.idfWCICCompanyKey = SPLIT.idfWCICCompanyKeyTarget
	LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRD WITH(NOLOCK) ON LRD.idfWCLanguageKey = 1 AND '::' + LRD.idfResourceID + '::' LIKE '%' + ISNULL(EXPSession.idfDescription,SEXPSession.idfDescription) + '%'

UNION ALL

SELECT
H.idfEXPExpenseSheetHdrHistKey AS Expense_Sheet
,CASE WHEN H.idfEXPEntryTypeKey=1 THEN 'Expense' ELSE 'Travel Request' END AS [Type]
,WCSecurity.idfSecurityID AS Employee_ID
,WCSecurity.idfDescription AS Employee
,ISNULL(S2.idfDescription,'') AS Entered_By
,H.idfDateCreated AS Created
,CASE WHEN D.idfEXPSessionKey > 169 THEN H.idfDateModified ELSE NULL END AS Batched
,CASE WHEN H.idfFlagSubmitted=1 THEN 'Yes' ELSE 'No' END AS Submitted
, ISNULL(WCDept.idfDeptID,'') AS Department
, H.idfDescription AS Expense_Sheet_Name
, H.edfAmtHomeExtended AS Total
, SRC.idfCompanyCode AS Source_Company
, ISNULL(STRG.idfCompanyCode,STRG.idfCompanyCode) AS Target_Company
, ISNULL(SPLIT.idfDay,D.idfDay) AS [Date]
, ISNULL(SPLIT.idfDescription,D.idfDescription) AS [Description]
, ISNULL(SEXPType.idfTypeID,EXPType.idfTypeID) AS Expense_Type
, ISNULL(SEXPPayment.idfPaymentID,EXPPayment.idfPaymentID) AS Payment_Method
, ISNULL(SGLAccount.idfGLID,GLAccount.idfGLID) AS GL_Account
, ISNULL(SPLIT.idfQuantity,D.idfQuantity) AS Qty
, ISNULL(SPLIT.edfPrice,D.edfPrice) AS Price
, CURR.edfCurrencyID AS Currency
,ISNULL(SPLIT.edfAmtExtended,D.edfAmtExtended) AS Amount
,ISNULL(EXPSession.idfEXPSessionKey,SEXPSession.idfEXPSessionKey) AS Status_No
,LRD.idfDescription AS Status_Description

FROM EXPExpenseSheetHdrHist AS H WITH (NOLOCK)
	INNER JOIN dbo.EXPExpenseSheetDtlHist AS D WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
	INNER JOIN WCSecurity WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = H.idfWCSecurityKey
	LEFT OUTER JOIN dbo.EXPExpenseSheetDtlSplitHist AS SPLIT WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = SPLIT.idfEXPExpenseSheetDtlHistKey
	LEFT OUTER JOIN WCSecurity S2 WITH (NOLOCK) ON S2.idfWCSecurityKey = H.idfWCSecurityKeyCreated
	LEFT OUTER JOIN WCDept WITH (NOLOCK) ON H.idfWCDeptKey=WCDept.idfWCDeptKey
	LEFT OUTER JOIN dbo.EXPSession WITH (NOLOCK) ON EXPSession.idfEXPSessionKey = D.idfEXPSessionKey
	LEFT OUTER JOIN dbo.EXPSession SEXPSession WITH (NOLOCK) ON SEXPSession.idfEXPSessionKey = SPLIT.idfEXPSessionKey
	LEFT OUTER JOIN vwFNACurrency CURR WITH (NOLOCK) ON CURR.idfPTICurrencyKey = D.idfPTICurrencyKey
	LEFT OUTER JOIN dbo.EXPType WITH (NOLOCK) ON EXPType.idfEXPTypeKey = D.idfEXPTypeKey
	LEFT OUTER JOIN dbo.EXPType SEXPType WITH (NOLOCK) ON SEXPType.idfEXPTypeKey = SPLIT.idfEXPTypeKey
	LEFT OUTER JOIN dbo.GLAccount WITH (NOLOCK) ON GLAccount.idfGLAccountKey = D.idfGLAccountKey
	LEFT OUTER JOIN dbo.GLAccount SGLAccount WITH (NOLOCK) ON SGLAccount.idfGLAccountKey = SPLIT.idfGLAccountKey
	LEFT OUTER JOIN dbo.EXPPayment WITH (NOLOCK) ON D.idfEXPPaymentKey = EXPPayment.idfEXPPaymentKey
	LEFT OUTER JOIN dbo.EXPPayment SEXPPayment WITH (NOLOCK) ON SPLIT.idfEXPPaymentKey = SEXPPayment.idfEXPPaymentKey
	LEFT OUTER JOIN dbo.WCUDFListDtl WITH (NOLOCK) ON WCUDFListDtl.idfWCUDFListDtlKey = H.idfWCUDFListDtlKey02
	LEFT OUTER JOIN dbo.WCICCompany SRC WITH (NOLOCK) ON SRC.idfWCICCompanyKey = D.idfWCICCompanyKeySource
	LEFT OUTER JOIN dbo.WCICCompany TRG WITH (NOLOCK) ON TRG.idfWCICCompanyKey = D.idfWCICCompanyKeyTarget
	LEFT OUTER JOIN dbo.WCICCompany STRG WITH (NOLOCK) ON STRG.idfWCICCompanyKey = SPLIT.idfWCICCompanyKeyTarget
   	LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRD WITH(NOLOCK) ON LRD.idfWCLanguageKey = 1 AND '::' + LRD.idfResourceID + '::' LIKE '%' + ISNULL(EXPSession.idfDescription,SEXPSession.idfDescription) + '%'	                    