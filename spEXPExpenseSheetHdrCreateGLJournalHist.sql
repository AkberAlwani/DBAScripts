 
ALTER PROCEDURE spEXPExpenseSheetHdrCreateGLJournalHist
 @xochErrSP						CHAR(32)		OUTPUT
,@xonErrNum						INT				OUTPUT
,@xostrErrInfo					VARCHAR(255)	OUTPUT
,@xnidfEXPExpenseSheetHdrHistKey	INT			
,@xnPostGL                      INT = 0		
AS
DECLARE
 @nInterCo					INT
,@stredfPrecision			INT			
,@nidfGLJournalHdrKey		INT
,@nGLAccount_LinkType		VARCHAR(10)
,@nIVLANDCOSTINCLFRHT		INT
,@nIVLANDCOSTINCLMISC		INT
,@nIVLANDCOSTINCLTAX		INT
,@nEXPLANDCOSTINCLFRHT		INT
,@nEXPLANDCOSTINCLMISC		INT
,@nEXPLANDCOSTINCLTAX		INT
,@nFunc_vdfCurrencyID		VARCHAR(20)
,@strEXPNumber				VARCHAR(60)
,@nIVNONINVPRICEPREC		INT
,@nedfPrecisionHome			INT

--
SET NOCOUNT ON
--
	CREATE TABLE #GLJournalHdr
	(
		idfGLJournalHdrKey INT
		,idfAppConnCreated INT
		,idfAppConnCreatedDate DATETIME
		,idfDatePost DATETIME
		,idfDescription NVARCHAR(256)
		,idfDocument01 NVARCHAR(256)
		,idfDocument02 NVARCHAR(256)
		,idfFlagIC INT
		,idfFlagPosted INT
		,idfFlagSummary INT
		,idfJournalNumber NVARCHAR(120)
		,idfRateHome NUMERIC(19, 5)
		,idfTableLinkName VARCHAR(80)
		,idfDateCreated DATETIME
		,idfDateModified DATETIME
		,idfUserCreated NVARCHAR(256)
		,idfUserModified NVARCHAR(256)
		,idfGLJournalTypeKey INT
		,idfPTICurrencyKey INT
		,idfPTICurrencyRateDtlKey INT
		,idfTableLinkKey INT
		,idfWCICCompanyKey INT
		,idfWCSecurityKey INT
		,udfTextField01 VARCHAR(60)
		,udfTextField02 VARCHAR(60)
		,udfTextField03 VARCHAR(60)
		,udfTextField04 VARCHAR(60)
		,udfTextField05 VARCHAR(60)
		,vdfCurrencyID VARCHAR(20)
		,vdfCompanyCode VARCHAR(60)
		,vdfSecurityID VARCHAR(256)		,idfTimeStamp				TIMESTAMP
		,idfRowAction				CHAR(2)
		,idfRowKey				INT IDENTITY(0,1)
	)
	
	CREATE TABLE #GLJournalDtl
	(
		idfGLJournalDtlKey INT
		,idfAmount NUMERIC(19, 5)
		,idfAmountHome NUMERIC(19, 5)
		,idfDescription NVARCHAR(256)
		,idfDocument01 NVARCHAR(256)
		,idfDocument02 NVARCHAR(256)
		,idfFlagEncumbrance INT
		,idfFlagICOffset INT
		,idfRateHome NUMERIC(19, 5)
		,idfTableLinkName VARCHAR(80)
		,idfDateCreated DATETIME
		,idfDateModified DATETIME
		,idfUserCreated NVARCHAR(256)
		,idfUserModified NVARCHAR(256)
		,idfGLAccountKey INT
		,idfGLAccountKeyOffset INT
		,idfGLJournalHdrKey INT
		,idfGLPostCodeTypeKey INT
		,idfGLReferenceKey INT
		,idfGLSegmentDtlKey01 INT
		,idfGLSegmentDtlKey02 INT
		,idfGLSegmentDtlKey03 INT
		,idfGLSegmentDtlKey04 INT
		,idfGLSegmentDtlKey05 INT
		,idfGLSegmentDtlKey06 INT
		,idfGLSegmentDtlKey07 INT
		,idfGLSegmentDtlKey08 INT
		,idfGLSegmentDtlKey09 INT
		,idfGLSegmentDtlKey10 INT
		,idfGLSegmentDtlKey11 INT
		,idfGLSegmentDtlKey12 INT
		,idfGLSegmentDtlKey13 INT
		,idfGLSegmentDtlKey14 INT
		,idfGLSegmentDtlKey15 INT
		,idfIVSiteKey INT
		,idfPAPhaseActivityKey INT
		,idfPAProjectKey INT
		,idfPAProjectPhaseKey INT
		,idfPTICurrencyKey INT
		,idfPTICurrencyRateDtlKey INT
		,idfTableLinkKey INT
		,idfWCDeptKey INT
		,idfWCICCompanyKey INT
		,idfWCOrganizationKey INT
		,idfFlagPosted INT
		,vdfCurrencyID VARCHAR(20)
		,vdfReferenceID VARCHAR(40)
		,vdfActivityID VARCHAR(20)
		,vdfCompanyCode VARCHAR(60)
		,vdfGLID NVARCHAR(512)
		,vdfGLIDOffset NVARCHAR(512)
		,vdfOrganizationID VARCHAR(20)
		,vdfPhaseID VARCHAR(32)
		,vdfProjectID VARCHAR(32)		,idfTimeStamp				TIMESTAMP
		,idfRowAction				CHAR(2)
		,idfRowKey				INT IDENTITY(0,1)
	)
	

SELECT @nFunc_vdfCurrencyID=edfCurrencyID FROM vwFNACurrency WHERE edfFunctional=1

CREATE TABLE #spWCDistributionReAlloc
(
	 idfPK				INT IDENTITY(0,1)
	,idfAmtAllocated	NUMERIC(19,5)
	,idfAmtAllocatedHome NUMERIC(19,5)
	,idfAmtToAlloc		NUMERIC(19,5)
	,idfAmtToAllocHome	NUMERIC(19,5)
	,idfFlagPrimary		INT
	,idfForeignKey		INT
	,idfGLAccountKey	INT
	,idfPercent			NUMERIC(19,5)
)

SELECT @strEXPNumber			= idfEXPExpenseSheetHdrHistKey 
FROM dbo.EXPExpenseSheetHdrHist WITH (NOLOCK) 	
WHERE idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey

SELECT @nGLAccount_LinkType = idfLinkType FROM dbo.WCICCompanyTableLinkType WITH (NOLOCK) WHERE idfModule='GLOBAL' AND idfTableName = 'GLAccount'

SELECT @nIVNONINVPRICEPREC=idfValue		FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVNONINVPRICEPREC'
	
SELECT @nIVLANDCOSTINCLFRHT=idfValue	FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVLANDCOSTINCLFRHT'	
SELECT @nIVLANDCOSTINCLMISC=idfValue	FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVLANDCOSTINCLMISC'	
SELECT @nIVLANDCOSTINCLTAX=idfValue		FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVLANDCOSTINCLTAX'	

SELECT @nEXPLANDCOSTINCLFRHT=idfValue	FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='EXPLANDCOSTINCLFRHT'	
SELECT @nEXPLANDCOSTINCLMISC=idfValue	FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='EXPLANDCOSTINCLMISC'	
SELECT @nEXPLANDCOSTINCLTAX=idfValue	FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='EXPLANDCOSTINCLTAX'	

SELECT @nedfPrecisionHome = edfPrecision FROM dbo.vwFNACurrency WHERE edfFunctional = 1

DECLARE @tblGLJournalDtl TABLE (idfTableLinkKey INT,idfTableLinkName VARCHAR(80), idfAmount NUMERIC(19,5), idfAmountHome NUMERIC(19,5), idfType VARCHAR(10), idfGLAccountKey INT, idfGLReferenceKey INT NULL, idfGLAccountKey_PAY INT NULL, idfFlagEncumbrance 
INT NULL, idfFlagOverlayGL INT, idfFlagOverlay_PAY INT, idfWCOrganizationKey INT)

INSERT INTO #spWCDistributionReAlloc (idfAmtAllocated,idfAmtAllocatedHome,idfAmtToAlloc,idfAmtToAllocHome,idfFlagPrimary,idfForeignKey,idfPercent,idfGLAccountKey)
SELECT 
	 0
	,0
	,ROUND(D.idfAmtSubTotal,C.edfPrecision) +
		CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN D.edfFreight			ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN D.edfMiscCharges		ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN D.idfAmtTax			ELSE 0 END 
	,ROUND(D.idfAmtSubTotalHome,@nedfPrecisionHome) +
		CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN D.idfAmtFreightHome		ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN D.idfAmtMiscHome			ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN D.idfAmtTaxHome			ELSE 0 END 
	,RD.idfFlagPrimary
	,D.idfEXPExpenseSheetDtlHistKey
	,RD.idfPercent
	,RD.idfGLAccountKey
FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
	INNER JOIN dbo.EXPExpenseSheetDtlDistributionHist RD	WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = RD.idfEXPExpenseSheetDtlHistKey
	INNER JOIN dbo.vwFNACurrency C ON C.idfPTICurrencyKey=D.idfPTICurrencyKey
WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey 
	AND D.idfQuantity > 0
	AND idfFlagSplit = 0

EXEC dbo.spWCDistributionReAlloc

		
-- Insert Debit side using expense accounts.
INSERT INTO @tblGLJournalDtl (idfTableLinkKey,idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey, idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
SELECT	 D.idfEXPExpenseSheetDtlHistKey
		,'EXPExpenseSheetDtlHist'
		,SUM(ISNULL(RD.idfAmtAllocated,ROUND(D.idfAmtSubTotal,C.edfPrecision) +
		CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN D.edfFreight			ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN D.edfMiscCharges		ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN D.idfAmtTax			ELSE 0 END))  -- For return change to credit else leave purch as debit.
		,SUM(ISNULL(RD.idfAmtAllocatedHome,ROUND(D.idfAmtSubTotal,@nedfPrecisionHome) +
		CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN D.idfAmtFreightHome		ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN D.idfAmtMiscHome			ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN D.idfAmtTaxHome			ELSE 0 END))  -- For return change to credit else leave purch as debit.
		,'PURCH'
		,ISNULL(RD.idfGLAccountKey,MIN(ASA_PURCH.idfGLAccountKey))
		,MIN(ASA_PAY.idfGLAccountKey)
		,0						--idfFlagOverlayGL
		,1						--idfFlagOverlay_PAY
		,NULL	--idfWCOrganizationKey
FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
	INNER JOIN dbo.EXPExpenseSheetHdrHist			H	    WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
	INNER JOIN dbo.vwFNACurrency C ON C.idfPTICurrencyKey=D.idfPTICurrencyKey
	LEFT OUTER JOIN #spWCDistributionReAlloc	RD		WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = RD.idfForeignKey
	LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY	WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
	LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PURCH	WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PURCH.idfAPVendorKey	AND ASA_PURCH.idfGLPostCodeTypeKey=20100	AND ASA_PURCH.idfIVSiteKey = 0
WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey AND D.idfFlagSplit = 0
GROUP BY D.idfEXPExpenseSheetDtlHistKey, RD.idfGLAccountKey

INSERT INTO @tblGLJournalDtl (idfTableLinkKey,idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey, idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
SELECT	 S.idfEXPExpenseSheetDtlSplitHistKey
		,'EXPExpenseSheetDtlSplitHist'
		,SUM(ROUND(S.idfAmtSubTotal,C.edfPrecision) +
		CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN S.edfFreight			ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN S.edfMiscCharges		ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN S.idfAmtTax			ELSE 0 END 
		) -- For return change to credit else leave purch as debit.
		,SUM(ROUND(S.idfAmtSubTotalHome,@nedfPrecisionHome) +
		CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN S.idfAmtFreightHome		ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN S.idfAmtMiscHome			ELSE 0 END +
		CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN S.idfAmtTaxHome			ELSE 0 END 
		) -- For return change to credit else leave purch as debit.
		,'PURCH'
		,ISNULL(S.idfGLAccountKey,MIN(ASA_PURCH.idfGLAccountKey))
		,MIN(ASA_PAY.idfGLAccountKey)
		,0						--idfFlagOverlayGL
		,1						--idfFlagOverlay_PAY
		,NULL	--idfWCOrganizationKey
FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
	INNER JOIN dbo.EXPExpenseSheetHdrHist			H	    WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
	INNER JOIN dbo.EXPExpenseSheetDtlSplitHist		S		WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = S.idfEXPExpenseSheetDtlHistKey
	INNER JOIN dbo.vwFNACurrency C ON C.idfPTICurrencyKey=D.idfPTICurrencyKey
	LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY	WITH (NOLOCK) ON S.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
	LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PURCH	WITH (NOLOCK) ON S.idfAPVendorKey = ASA_PURCH.idfAPVendorKey	AND ASA_PURCH.idfGLPostCodeTypeKey=20100	AND ASA_PURCH.idfIVSiteKey = 0
WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey AND D.idfFlagSplit = 1
GROUP BY S.idfEXPExpenseSheetDtlSplitHistKey, S.idfGLAccountKey

-- Insert Credit (Accrual or Pay) side.
INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
SELECT	 ISNULL(S.idfEXPExpenseSheetDtlSplitHistKey,D.idfEXPExpenseSheetDtlHistKey)
		,CASE WHEN MAX(D.idfFlagSplit) = 0 THEN 'EXPExpenseSheetDtlHist' ELSE 'EXPExpenseSheetDtlSplitHist' END
		,SUM(ISNULL(RD.idfAmtAllocated, ISNULL((ROUND(S.idfAmtSubTotal,C.edfPrecision) +
							CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN S.edfFreight			ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN S.edfMiscCharges		ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN S.idfAmtTax			ELSE 0 END
						),(ROUND(D.idfAmtSubTotal,C.edfPrecision) +
							CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN D.edfFreight			ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN D.edfMiscCharges		ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN D.idfAmtTax			ELSE 0 END))
		)) * -1 -- For return change to debit else leave accrual/pay as credit.
		,SUM(ISNULL(RD.idfAmtAllocatedHome, ISNULL((ROUND(S.idfAmtSubTotalHome,@nedfPrecisionHome) +
							CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN S.idfAmtFreightHome		ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN S.idfAmtMiscHome			ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN S.idfAmtTaxHome			ELSE 0 END
						),(ROUND(D.idfAmtSubTotalHome,@nedfPrecisionHome) +
							CASE WHEN @nEXPLANDCOSTINCLFRHT=1	THEN D.idfAmtFreightHome		ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLMISC=1	THEN D.idfAmtMiscHome			ELSE 0 END +
							CASE WHEN @nEXPLANDCOSTINCLTAX=1	THEN D.idfAmtTaxHome			ELSE 0 END))
		)) * -1 -- For return change to debit else leave accrual/pay as credit.
		,'PAY'
		,MIN(ASA_PAY.idfGLAccountKey)
		,1						--idfFlagOverlayGL
		,0						--idfFlagOverlay_PAY
		,NULL	--idfWCOrganizationKey
FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
	INNER JOIN dbo.EXPExpenseSheetHdrHist		H	WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
	INNER JOIN dbo.vwFNACurrency C ON C.idfPTICurrencyKey=D.idfPTICurrencyKey
	LEFT OUTER JOIN #spWCDistributionReAlloc RD	WITH (NOLOCK) ON D.idfFlagSplit = 0 AND  D.idfEXPExpenseSheetDtlHistKey = RD.idfForeignKey
	LEFT OUTER JOIN EXPExpenseSheetDtlSplitHist S WITH (NOLOCK) ON D.idfFlagSplit = 1 AND D.idfEXPExpenseSheetDtlHistKey = S.idfEXPExpenseSheetDtlHistKey
	LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY		WITH (NOLOCK) ON ISNULL(S.idfAPVendorKey,D.idfAPVendorKey) = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey 
GROUP BY ISNULL(S.idfEXPExpenseSheetDtlSplitHistKey,D.idfEXPExpenseSheetDtlHistKey)

-- Add in TAX for items that did not include tax in the expense/inventory account.
-- *note: look at tax details for account code, if not specified use system account.
IF (@nIVLANDCOSTINCLTAX=0 OR @nEXPLANDCOSTINCLTAX=0)
BEGIN
	INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey,idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 D.idfEXPExpenseSheetDtlHistKey
			,'EXPExpenseSheetDtlHist'
			,TAX.idfAmountTax
			,TAX.idfAmountTaxHome
			,'TAX'
			,ISNULL(WCTax.idfGLAccountKey,ASA_TAX.idfGLAccountKey)
			,ASA_PAY.idfGLAccountKey
			,1						--idfFlagOverlayGL
			,1						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
	FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		INNER JOIN dbo.EXPExpenseSheetHdrHist	H		WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
		INNER JOIN dbo.EXPExpenseSheetDtlTaxHist TAX		WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = TAX.idfEXPExpenseSheetDtlHistKey AND idfFlagTaxIncluded = 0
		INNER JOIN dbo.WCTax			WCTax	WITH (NOLOCK) ON TAX.idfWCTaxKey = WCTax.idfWCTaxKey 
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_TAX		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_TAX.idfAPVendorKey		AND ASA_TAX.idfGLPostCodeTypeKey=20500		AND ASA_TAX.idfIVSiteKey = 0
	WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey 
		AND D.idfAmtTaxHome <> 0
		AND @nEXPLANDCOSTINCLTAX = 0	
		AND D.idfFlagSplit = 0

	INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey,idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 S.idfEXPExpenseSheetDtlSplitHistKey
			,'EXPExpenseSheetDtlSplitHist'
			,TAX.idfAmountTax
			,TAX.idfAmountTaxHome
			,'TAX'
			,ISNULL(WCTax.idfGLAccountKey,ASA_TAX.idfGLAccountKey)
			,ASA_PAY.idfGLAccountKey
			,1						--idfFlagOverlayGL
			,1						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
	FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		INNER JOIN dbo.EXPExpenseSheetDtlSplitHist S WITH (NOLOCK) ON S.idfEXPExpenseSheetDtlHistKey = D.idfEXPExpenseSheetDtlHistKey
		INNER JOIN dbo.EXPExpenseSheetDtlSplitTaxHist TAX		WITH (NOLOCK) ON S.idfEXPExpenseSheetDtlSplitHistKey = TAX.idfEXPExpenseSheetDtlSplitHistKey AND idfFlagTaxIncluded = 0
		INNER JOIN dbo.WCTax			WCTax	WITH (NOLOCK) ON TAX.idfWCTaxKey = WCTax.idfWCTaxKey 
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_TAX		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_TAX.idfAPVendorKey		AND ASA_TAX.idfGLPostCodeTypeKey=20500		AND ASA_TAX.idfIVSiteKey = 0
	WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey 
		AND S.idfAmtTaxHome <> 0
		AND @nEXPLANDCOSTINCLTAX = 0	
		AND D.idfFlagSplit = 1


END	
	-- Insert tax included DEBIT
	INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey,idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 D.idfEXPExpenseSheetDtlHistKey
			,'EXPExpenseSheetDtlHist'
			,TAX.idfAmountTax
			,TAX.idfAmountTaxHome
			,'TAX'
			,ISNULL(WCTax.idfGLAccountKey,ASA_TAX.idfGLAccountKey)
			,-1
			,1						--idfFlagOverlayGL
			,0						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
	FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		INNER JOIN dbo.EXPExpenseSheetHdrHist	H		WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
		INNER JOIN dbo.EXPExpenseSheetDtlTaxHist TAX		WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = TAX.idfEXPExpenseSheetDtlHistKey AND idfFlagTaxIncluded = 1
		INNER JOIN dbo.WCTax			WCTax	WITH (NOLOCK) ON TAX.idfWCTaxKey = WCTax.idfWCTaxKey 
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_TAX		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_TAX.idfAPVendorKey		AND ASA_TAX.idfGLPostCodeTypeKey=20500		AND ASA_TAX.idfIVSiteKey = 0
	WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey 
		AND D.idfAmtTaxIncludedHome <> 0
		AND D.idfFlagSplit = 0

	INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey,idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 S.idfEXPExpenseSheetDtlSplitHistKey
			,'EXPExpenseSheetDtlSplitHist'
			,TAX.idfAmountTax
			,TAX.idfAmountTaxHome
			,'TAX'
			,ISNULL(WCTax.idfGLAccountKey,ASA_TAX.idfGLAccountKey)
			,-1
			,1						--idfFlagOverlayGL
			,0						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
	FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		INNER JOIN dbo.EXPExpenseSheetDtlSplitHist S WITH (NOLOCK) ON S.idfEXPExpenseSheetDtlHistKey = D.idfEXPExpenseSheetDtlHistKey
		INNER JOIN dbo.EXPExpenseSheetDtlSplitTaxHist TAX		WITH (NOLOCK) ON S.idfEXPExpenseSheetDtlSplitHistKey = TAX.idfEXPExpenseSheetDtlSplitHistKey AND idfFlagTaxIncluded = 1
		INNER JOIN dbo.WCTax			WCTax	WITH (NOLOCK) ON TAX.idfWCTaxKey = WCTax.idfWCTaxKey 
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_TAX		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_TAX.idfAPVendorKey		AND ASA_TAX.idfGLPostCodeTypeKey=20500		AND ASA_TAX.idfIVSiteKey = 0
	WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey 
		AND S.idfAmtTaxIncludedHome <> 0
		AND D.idfFlagSplit = 1

	-- Insert tax included Credit
	DELETE FROM #spWCDistributionReAlloc
	INSERT INTO #spWCDistributionReAlloc (idfAmtAllocated,idfAmtAllocatedHome,idfAmtToAlloc,idfAmtToAllocHome,idfFlagPrimary,idfForeignKey,idfPercent,idfGLAccountKey)
	SELECT 0
		,0
		,SUM(TAX.idfAmountTax)
		,SUM(TAX.idfAmountTaxHome)
		,RD.idfFlagPrimary
		,D.idfEXPExpenseSheetDtlHistKey
		,MAX(ISNULL(RD.idfPercent,100))
		,RD.idfGLAccountKey
	FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		LEFT OUTER JOIN dbo.EXPExpenseSheetDtlDistributionHist RD	WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = RD.idfEXPExpenseSheetDtlHistKey
		INNER JOIN dbo.EXPExpenseSheetDtlTaxHist         TAX	WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = TAX.idfEXPExpenseSheetDtlHistKey AND idfFlagTaxIncluded = 1
	WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey AND D.idfFlagSplit = 0
	GROUP BY D.idfEXPExpenseSheetDtlHistKey, RD.idfGLAccountKey,RD.idfFlagPrimary
	
	EXEC dbo.spWCDistributionReAlloc

	INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey, idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 D.idfEXPExpenseSheetDtlHistKey
			,'EXPExpenseSheetDtlHist'
			,SUM(ISNULL(RD.idfAmtAllocated,D.edfAmtExtended)) * -1
			,SUM(ISNULL(RD.idfAmtAllocatedHome,D.edfAmtHomeExtended)) * -1
			,'PURCH'
			,ISNULL(RD.idfGLAccountKey,MIN(ASA_PURCH.idfGLAccountKey))
			,-1
			,0						--idfFlagOverlayGL
			,0						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
	FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		INNER JOIN dbo.EXPExpenseSheetHdrHist			H	    WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
		INNER JOIN #spWCDistributionReAlloc			RD		WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = RD.idfForeignKey
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY	WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ASA_PAY.idfIVSiteKey = 0
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PURCH	WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PURCH.idfAPVendorKey	AND ASA_PURCH.idfGLPostCodeTypeKey=20100		AND ASA_PURCH.idfIVSiteKey = 0
	WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey AND D.idfFlagSplit = 0
	GROUP BY D.idfEXPExpenseSheetDtlHistKey, RD.idfGLAccountKey

	INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey, idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 S.idfEXPExpenseSheetDtlSplitHistKey
			,'EXPExpenseSheetDtlSplitHist'
			,SUM(S.idfAmtTaxIncluded) * -1
			,SUM(S.idfAmtTaxIncludedHome) * -1
			,'PURCH'
			,ISNULL(S.idfGLAccountKey,MIN(ASA_PURCH.idfGLAccountKey))
			,-1
			,0						--idfFlagOverlayGL
			,0						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
	FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		INNER JOIN dbo.EXPExpenseSheetHdrHist			H	    WITH (NOLOCK) ON D.idfEXPExpenseSheetHdrHistKey = H.idfEXPExpenseSheetHdrHistKey
		INNER JOIN dbo.EXPExpenseSheetDtlSplitHist		S		WITH (NOLOCK) ON S.idfEXPExpenseSheetDtlHistKey = D.idfEXPExpenseSheetDtlHistKey
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PURCH	WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PURCH.idfAPVendorKey	AND ASA_PURCH.idfGLPostCodeTypeKey=20100	AND ASA_PURCH.idfIVSiteKey = 0
	WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey AND D.idfFlagSplit = 1 AND S.idfAmtTaxIncludedHome <> 0
	GROUP BY S.idfEXPExpenseSheetDtlSplitHistKey, S.idfGLAccountKey

-- Add in MISC for items that did not include misc in the expense/inventory account.
IF (@nIVLANDCOSTINCLMISC=0 OR @nEXPLANDCOSTINCLMISC=0)
	WITH detail AS
	(
		SELECT ISNULL(S.idfEXPExpenseSheetDtlSplitHistKey, D.idfEXPExpenseSheetDtlHistKey) idfTableLinkKey,
			CASE WHEN D.idfFlagSplit = 1 THEN 'EXPExpenseSheetDtlSplitHist' ELSE 'EXPExpenseSheetDtlHist' END idfTableLinkName,
			ISNULL(S.idfAmtMiscHome, D.idfAmtMiscHome) idfAmtMiscHome,
			ISNULL(S.edfMiscCharges, D.edfMiscCharges) idfAmtMisc,
			ISNULL(S.idfAPVendorKey, D.idfAPVendorKey) idfAPVendorKey
		FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		LEFT OUTER JOIN dbo.EXPExpenseSheetDtlSplitHist S WITH (NOLOCK) ON S.idfEXPExpenseSheetDtlHistKey = D.idfEXPExpenseSheetDtlHistKey
		WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey
	)
	INSERT INTO @tblGLJournalDtl (idfTableLinkKey,idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey,idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 D.idfTableLinkKey
			,D.idfTableLinkName
			,D.idfAmtMisc
			,D.idfAmtMiscHome
			,'MISC'
			,ASA_MISC.idfGLAccountKey
			,ASA_PAY.idfGLAccountKey
			,1						--idfFlagOverlayGL
			,1						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
	FROM detail D
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND ISNULL(ASA_PAY.idfIVSiteKey,0) = 0
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_MISC	WITH (NOLOCK) ON D.idfAPVendorKey = ASA_MISC.idfAPVendorKey		AND ASA_MISC.idfGLPostCodeTypeKey=20400		AND ISNULL(ASA_MISC.idfIVSiteKey,0) = 0 
	WHERE D.idfAmtMiscHome <> 0
		AND @nEXPLANDCOSTINCLMISC = 0

-- Add in FREIGHT for items that did not include freight in the expense/inventory account.
IF (@nIVLANDCOSTINCLFRHT=0 OR @nEXPLANDCOSTINCLFRHT=0)
	WITH detail AS
	(
		SELECT ISNULL(S.idfEXPExpenseSheetDtlSplitHistKey, D.idfEXPExpenseSheetDtlHistKey) idfTableLinkKey,
			CASE WHEN D.idfFlagSplit = 1 THEN 'EXPExpenseSheetDtlSplitHist' ELSE 'EXPExpenseSheetDtlHist' END idfTableLinkName,
			ISNULL(S.idfAmtFreightHome, D.idfAmtFreightHome) idfAmtFreightHome,
			ISNULL(S.edfFreight, D.edfFreight) idfAmtFreight,
			ISNULL(S.idfAPVendorKey, D.idfAPVendorKey) idfAPVendorKey
		FROM dbo.EXPExpenseSheetDtlHist	D WITH (NOLOCK)
		LEFT OUTER JOIN dbo.EXPExpenseSheetDtlSplitHist S WITH (NOLOCK) ON S.idfEXPExpenseSheetDtlHistKey = D.idfEXPExpenseSheetDtlHistKey
		WHERE D.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey
	)
	INSERT INTO @tblGLJournalDtl (idfTableLinkKey,idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey,idfGLAccountKey_PAY, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 D.idfTableLinkKey
			,D.idfTableLinkName
			,D.idfAmtFreight
			,D.idfAmtFreightHome
			,'FREIGHT'
			,ASA_FREIGHT.idfGLAccountKey
			,ASA_PAY.idfGLAccountKey
			,1						--idfFlagOverlayGL
			,1						--idfFlagOverlay_PAY
			,NULL	--idfWCOrganizationKey
		FROM detail D
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_PAY		WITH (NOLOCK) ON D.idfAPVendorKey = ASA_PAY.idfAPVendorKey		AND ASA_PAY.idfGLPostCodeTypeKey=20000		AND  ASA_PAY.idfIVSiteKey = 0
		LEFT OUTER JOIN dbo.vwAPVendorSiteAccount ASA_FREIGHT	WITH (NOLOCK) ON D.idfAPVendorKey = ASA_FREIGHT.idfAPVendorKey		AND ASA_FREIGHT.idfGLPostCodeTypeKey=20300		AND ASA_FREIGHT.idfIVSiteKey = 0
	WHERE D.idfAmtFreightHome <> 0
		AND @nEXPLANDCOSTINCLFRHT = 0

	-- CDB 5/7/12: Insert Credit/Pay side for Tax/Misc/Freight.
	INSERT INTO @tblGLJournalDtl (idfTableLinkKey, idfTableLinkName, idfAmount, idfAmountHome, idfType, idfGLAccountKey, idfFlagOverlayGL, idfFlagOverlay_PAY, idfWCOrganizationKey)
	SELECT	 idfTableLinkKey
			,idfTableLinkName
			,SUM(idfAmount)*-1 
			,SUM(idfAmountHome)*-1 
			,'PAY'
			,idfGLAccountKey_PAY
			,1						--idfFlagOverlayGL
			,0						--idfFlagOverlay_PAY
			,idfWCOrganizationKey	--idfWCOrganizationKey
	FROM @tblGLJournalDtl
	WHERE idfType IN ('FREIGHT','MISC','TAX') AND idfGLAccountKey_PAY <> -1
	GROUP BY idfTableLinkKey, idfTableLinkName,idfGLAccountKey_PAY,idfWCOrganizationKey
	HAVING SUM(idfAmount) <> 0

-- If there are no journal entries then do not add a header.  This can happen when the receipt creates only an inventory adjustment.
-- CDB 10/30/14: Make sure there is at least 1 entry with an amount not equal to $0.  For example you could receive with accruals on for $0, if it was just one line there
--               would be no GLJournalDtl records with an amount so in this case do NOT create a GLJournalHdr either.
IF EXISTS(SELECT TOP 1 1 FROM @tblGLJournalDtl WHERE idfAmount <> 0 ) BEGIN
	--IF EXISTS(SELECT TOP 1 1 
	--			FROM @tblGLJournalDtl T 
	--				INNER JOIN dbo.GLAccount G WITH (NOLOCK) ON T.idfGLAccountKey = G.idfGLAccountKey
	--			GROUP BY G.idfWCICCompanyKey
	--			HAVING MIN(ISNULL(G.idfWCICCompanyKey,0)) <> MAX(ISNULL(G.idfWCICCompanyKey,0)))
	--	SET @nInterCo = 1
	--ELSE
		SET @nInterCo = 0
				
	-- Create GL Journal Headers for all companies involved.
	INSERT INTO #GLJournalHdr (
		 idfAppConnCreated
		,idfAppConnCreatedDate
		,idfDatePost
		,idfDescription
		,idfDocument01
		,idfDocument02
		,idfFlagIC
		,idfFlagPosted
		,idfFlagSummary
		,idfJournalNumber
		,idfRateHome
		,idfTableLinkName
		,idfTableLinkKey
		,idfGLJournalTypeKey
		,vdfCompanyCode
		,vdfCurrencyID                                                                                                                                                                                                                                               
   
		,vdfSecurityID                                                                                                                                                                                                                                               
   
		,idfRowAction   
		,udfTextField01
		,udfTextField02
		,udfTextField03
		,udfTextField04
		,udfTextField05                                                                                                                                                                                                                                              
  
	)
	SELECT 
		 0										-- idfAppConnCreated
		,'19000101'								-- idfAppConnCreatedDate
		,GETDATE()
		,CONVERT(VARCHAR(128),H.idfComment)		-- idfDescription
		,H.idfEXPExpenseSheetHdrHistKey			-- idfDocument01
		,''										-- idfDocument02
		,@nInterCo								-- idfFlagIC
		,ISNULL(@xnPostGL,0)                    -- idfFlagPosted
		,0										-- idfFlagSummary
		,''										-- idfJournalNumber
		,0										-- idfRateHome
		,'EXPExpenseSheetHdrHist'					-- idfTableLinkName
		,H.idfEXPExpenseSheetHdrHistKey			-- idfTableLinkKey
		,50000									-- idfGLJournalTypeKey
		,ISNULL(ICS.idfCompanyCode,'')			-- vdfCompanyCode                                                                                                                                                                                                           
                                      
		,@nFunc_vdfCurrencyID					-- vdfCurrencyID                                                                                                                                                                                                                   
                               
		,S.idfSecurityID						-- vdfSecurityID                                                                                                                                                                                                                       
                           
		,'IN'									-- idfRowAction   
		,''--udfTextField01
		,''--udfTextField02
		,''--udfTextField03
		,''--udfTextField04
		,''--udfTextField05                                                                                                                                                                                                                                          
      
	FROM dbo.EXPExpenseSheetHdrHist	H  WITH (NOLOCK) 
		INNER JOIN dbo.WCSecurity		S  WITH (NOLOCK) ON H.idfWCSecurityKey = S.idfWCSecurityKey
		LEFT OUTER JOIN dbo.WCICCompany	ICS	WITH (NOLOCK) ON ICS.idfWCICCompanyKey= H.idfWCICCompanyKeySource
	WHERE H.idfEXPExpenseSheetHdrHistKey = @xnidfEXPExpenseSheetHdrHistKey 	

	-- Insert Header
	EXEC dbo.spGLJournalHdr
		 @xochErrSP			OUTPUT
		,@xonErrNum			OUTPUT
		,@xostrErrInfo		OUTPUT
		,'CM'
	
	IF(ISNULL(@xonErrNum,0) <> 0) BEGIN
		RETURN (@xonErrNum)
	END

	SELECT @nidfGLJournalHdrKey = idfGLJournalHdrKey FROM #GLJournalHdr;

	-- ***********************************************************************************************************************
	-- Add GLJournalDtl Lines
	-- ***********************************************************************************************************************
	WITH expense AS (
		SELECT 
			 D.idfEXPExpenseSheetHdrHistKey
			,ISNULL(S.idfEXPExpenseSheetDtlSplitHistKey, D.idfEXPExpenseSheetDtlHistKey) idfTableLinkKey
			,CASE WHEN idfFlagSplit = 0 THEN 'EXPExpenseSheetDtlHist' ELSE 'EXPExpenseSheetDtlSplitHist'  END idfTableLinkName
			,ISNULL(S.idfWCDeptKey, D.idfWCDeptKey) idfWCDeptKey
			,ISNULL(S.idfWCICCompanyKeySource, D.idfWCICCompanyKeySource) idfWCICCompanyKeySource
			,ISNULL(S.idfWCICCompanyKeyTarget, D.idfWCICCompanyKeyTarget) idfWCICCompanyKeyTarget
			,ISNULL(S.idfDescription, D.idfDescription) idfDescription
			,ISNULL(SP.idfPAProjectKey, P.idfPAProjectKey) idfPAProjectKey
			,ISNULL(SP.idfPAPhaseActivityKey, P.idfPAPhaseActivityKey) idfPAPhaseActivityKey
			,ISNULL(SP.idfPAProjectPhaseKey, P.idfPAProjectPhaseKey) idfPAProjectPhaseKey
			,D.idfRateHome
			,D.idfPTICurrencyKey
		FROM EXPExpenseSheetDtlHist D WITH (NOLOCK)
		LEFT OUTER JOIN EXPExpenseSheetDtlSplitHist S WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlHistKey = S.idfEXPExpenseSheetDtlHistKey
		LEFT OUTER JOIN EXPExpenseSheetDtlProjectDistributionHist P WITH (NOLOCK) ON P.idfEXPExpenseSheetDtlHistKey = D.idfEXPExpenseSheetDtlHistKey AND P.idfFlagPrimary = 1
		LEFT OUTER JOIN EXPExpenseSheetDtlSplitProjectDistributionHist SP WITH (NOLOCK) ON SP.idfEXPExpenseSheetDtlSplitHistKey = S.idfEXPExpenseSheetDtlSplitHistKey AND SP.idfFlagPrimary = 1
	)
	INSERT INTO #GLJournalDtl (
		 idfAmount
		,idfAmountHome
		,idfDescription
		,idfDocument01
		,idfDocument02
		,idfFlagEncumbrance
		,idfFlagICOffset
		,idfRateHome
		,idfGLJournalHdrKey
		,idfGLPostCodeTypeKey
		,vdfActivityID                                                                                                                                                                                                                                              
    
		,vdfCompanyCode                                                                                                                                                                                                                                              
   
		,vdfCurrencyID                                                                                                                                                                                                                                               
   
		,vdfGLID  
		,vdfGLIDOffset                                                                                                                                                                                                                                               
       
		,vdfOrganizationID                                                                                                                                                                                                                                           
   
		,vdfPhaseID                                                                                                                                                                                                                                                  
   
		,vdfProjectID              
		,vdfReferenceID                                                                                                                                                                                                                                     
		,idfRowAction      
		,idfTableLinkName
		,idfTableLinkKey                                                                                                                                                                                                                                             
	
		,idfGLSegmentDtlKey01
		,idfGLSegmentDtlKey02
		,idfGLSegmentDtlKey03
		,idfGLSegmentDtlKey04
		,idfGLSegmentDtlKey05
		,idfGLSegmentDtlKey06
		,idfGLSegmentDtlKey07
		,idfGLSegmentDtlKey08
		,idfGLSegmentDtlKey09
		,idfGLSegmentDtlKey10
		,idfGLSegmentDtlKey11
		,idfGLSegmentDtlKey12
		,idfGLSegmentDtlKey13
		,idfGLSegmentDtlKey14
		,idfGLSegmentDtlKey15
		,idfIVSiteKey        
		,idfWCDeptKey
	)
				SELECT 
		 T.idfAmount					-- idfAmount
		,T.idfAmountHome					-- idfAmountHome
		,SUBSTRING(DH.idfDescription,1,128)								-- idfDescription
		,@strEXPNumber
		,''	-- idfDocument02
		,ISNULL(T.idfFlagEncumbrance,0)	-- idfFlagEncumbrance
		,0								-- idfFlagICOffset
		,DH.idfRateHome					-- idfRateHome
		,@nidfGLJournalHdrKey
		,CASE	WHEN T.idfType = 'PAY'			THEN 20000
				WHEN T.idfType = 'PURCH'		THEN 20100
				WHEN T.idfType = 'ACCRUAL'		THEN 20200
				WHEN T.idfType = 'FREIGHT'		THEN 20300
				WHEN T.idfType = 'MISC'			THEN 20400
				WHEN T.idfType = 'TAX'			THEN 20500
		 ELSE 0 END						-- idfGLPostCodeTypeKey
		,A.idfActivityID				-- vdfActivityID                                                                                                                                                                                                                         
                         
		,CASE	WHEN T.idfType = 'PAY'	  	AND C.idfCompanyCode IS NULL	THEN ISNULL(ICS.idfCompanyCode,'')
				WHEN T.idfType = 'PURCH'	AND C.idfCompanyCode IS NULL	THEN ISNULL(ICT.idfCompanyCode,'')
				WHEN T.idfType = 'ACCRUAL'	AND C.idfCompanyCode IS NULL	THEN ISNULL(ICS.idfCompanyCode,'')
				WHEN T.idfType = 'FREIGHT'	AND C.idfCompanyCode IS NULL	THEN ISNULL(ICT.idfCompanyCode,'')
				WHEN T.idfType = 'MISC'		AND C.idfCompanyCode IS NULL	THEN ISNULL(ICT.idfCompanyCode,'')
				WHEN T.idfType = 'TAX'		AND C.idfCompanyCode IS NULL	THEN ISNULL(ICT.idfCompanyCode,'')
		 ELSE ISNULL(C.idfCompanyCode,'') END	-- vdfCompanyCode
		,CUR.edfCurrencyID			-- vdfCurrencyID                                                                                                                                                                                                                        
                          
		,G.idfGLID						-- vdfGLID                                                                                                                                                                                                                                   
                     
		,GOffset.idfGLID				-- vdfGLIDOffset                                                                                                                                                                                                                         
                             
		,''								-- vdfOrganizationID                                                                                                                                                                                                                              
                
		,PP.idfPhaseID					-- vdfPhaseID                                                                                                                                                                                                                             
                        
		,P.idfProjectID					-- vdfProjectID    
		,R.idfReferenceID				-- vdfReferenceID                                                                                                                                                                                                                       
                        
		,'IN'							-- idfRowAction        
		,T.idfTableLinkName
		,T.idfTableLinkKey 
		,ISNULL(DSHS.idfGLSegmentDtlKey01,DSH.idfGLSegmentDtlKey01) idfGLSegmentDtlKey01
		,ISNULL(DSHS.idfGLSegmentDtlKey02,DSH.idfGLSegmentDtlKey02) idfGLSegmentDtlKey02
		,ISNULL(DSHS.idfGLSegmentDtlKey03,DSH.idfGLSegmentDtlKey03) idfGLSegmentDtlKey03
		,ISNULL(DSHS.idfGLSegmentDtlKey04,DSH.idfGLSegmentDtlKey04) idfGLSegmentDtlKey04
		,ISNULL(DSHS.idfGLSegmentDtlKey05,DSH.idfGLSegmentDtlKey05) idfGLSegmentDtlKey05
		,ISNULL(DSHS.idfGLSegmentDtlKey06,DSH.idfGLSegmentDtlKey06) idfGLSegmentDtlKey06
		,ISNULL(DSHS.idfGLSegmentDtlKey07,DSH.idfGLSegmentDtlKey07) idfGLSegmentDtlKey07
		,ISNULL(DSHS.idfGLSegmentDtlKey08,DSH.idfGLSegmentDtlKey08) idfGLSegmentDtlKey08
		,ISNULL(DSHS.idfGLSegmentDtlKey09,DSH.idfGLSegmentDtlKey09) idfGLSegmentDtlKey09
		,ISNULL(DSHS.idfGLSegmentDtlKey10,DSH.idfGLSegmentDtlKey10) idfGLSegmentDtlKey10
		,ISNULL(DSHS.idfGLSegmentDtlKey11,DSH.idfGLSegmentDtlKey11) idfGLSegmentDtlKey11
		,ISNULL(DSHS.idfGLSegmentDtlKey12,DSH.idfGLSegmentDtlKey12) idfGLSegmentDtlKey12
		,ISNULL(DSHS.idfGLSegmentDtlKey13,DSH.idfGLSegmentDtlKey13) idfGLSegmentDtlKey13
		,ISNULL(DSHS.idfGLSegmentDtlKey14,DSH.idfGLSegmentDtlKey14) idfGLSegmentDtlKey14
		,ISNULL(DSHS.idfGLSegmentDtlKey15,DSH.idfGLSegmentDtlKey15) idfGLSegmentDtlKey15
		,NULL
		,DH.idfWCDeptKey
	FROM @tblGLJournalDtl T
		LEFT OUTER JOIN expense			DH      WITH (NOLOCK) ON T.idfTableLinkKey = DH.idfTableLinkKey AND T.idfTableLinkName = DH.idfTableLinkName
		LEFT OUTER JOIN dbo.vwFNACurrency	CUR		 ON DH.idfPTICurrencyKey = CUR.idfPTICurrencyKey
		LEFT OUTER JOIN dbo.EXPExpenseSheetHdrHist			DHH     WITH (NOLOCK) ON DHH.idfEXPExpenseSheetHdrHistKey = DH.idfEXPExpenseSheetHdrHistKey
		LEFT OUTER JOIN dbo.EXPExpenseSheetDtlSegmentHist	DSH     WITH (NOLOCK) ON T.idfTableLinkKey = DSH.idfEXPExpenseSheetDtlHistKey AND T.idfTableLinkName = 'EXPExpenseSheetDtlHist'
		LEFT OUTER JOIN dbo.EXPExpenseSheetDtlSplitSegmentHist	DSHS     WITH (NOLOCK) ON T.idfTableLinkKey = DSHS.idfEXPExpenseSheetDtlSplitHistKey AND T.idfTableLinkName = 'EXPExpenseSheetDtlSplitHist'
		LEFT OUTER JOIN dbo.GLAccount				G       WITH (NOLOCK) ON T.idfGLAccountKey = G.idfGLAccountKey
		LEFT OUTER JOIN dbo.GLAccount				GOffset WITH (NOLOCK) ON T.idfGLAccountKey_PAY = GOffset.idfGLAccountKey
		LEFT OUTER JOIN dbo.WCICCompany				C       WITH (NOLOCK) ON G.idfWCICCompanyKey = C.idfWCICCompanyKey
		LEFT OUTER JOIN dbo.GLReference				R       WITH (NOLOCK) ON T.idfGLReferenceKey = R.idfGLReferenceKey
		LEFT OUTER JOIN dbo.WCICCompany				ICS		WITH (NOLOCK) ON ICS.idfWCICCompanyKey= DH.idfWCICCompanyKeySource
		LEFT OUTER JOIN dbo.WCICCompany				ICT		WITH (NOLOCK) ON ICT.idfWCICCompanyKey= DH.idfWCICCompanyKeyTarget
		LEFT OUTER JOIN dbo.PAPhaseActivity			PA		WITH (NOLOCK) ON PA.idfPAPhaseActivityKey= DH.idfPAPhaseActivityKey
		LEFT OUTER JOIN dbo.PAActivity				A		WITH (NOLOCK) ON A.idfPAActivityKey= PA.idfPAActivityKey
		LEFT OUTER JOIN dbo.PAProject				P		WITH (NOLOCK) ON P.idfPAProjectKey= DH.idfPAProjectKey
		LEFT OUTER JOIN dbo.PAProjectPhase			PP		WITH (NOLOCK) ON PP.idfPAProjectPhaseKey= DH.idfPAProjectPhaseKey
	WHERE T.idfAmount <> 0 

	-- Insert Detail
	EXEC dbo.spGLJournalDtl
		 @xochErrSP			OUTPUT
		,@xonErrNum			OUTPUT
		,@xostrErrInfo		OUTPUT
		,'CM'

	UPDATE dbo.GLJournalHdr
	SET  idfFlagIC = 1
	FROM dbo.GLJournalHdr H WITH (NOLOCK)
		INNER JOIN dbo.GLJournalDtl D WITH (NOLOCK) ON H.idfGLJournalHdrKey = D.idfGLJournalHdrKey
	WHERE H.idfGLJournalHdrKey = @nidfGLJournalHdrKey 
	AND ISNULL(H.idfWCICCompanyKey,0) <> ISNULL(D.idfWCICCompanyKey,0)

    -- CDB 6/20/16: If Auto GL Post is on then post all newly created GL Journals.
    IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='GLAUTOPOSTJRNL' AND idfValue = '1') AND ISNULL(@xnPostGL,0) = 0 BEGIN
	    DECLARE curGLJournalHdr INSENSITIVE CURSOR FOR
	    SELECT idfJournalNumber 
	    FROM #GLJournalHdr

	    OPEN curGLJournalHdr

        DECLARE @strcurGLJournalHdr_idfJournalNumber NVARCHAR(60)

	    FETCH NEXT FROM curGLJournalHdr INTO @strcurGLJournalHdr_idfJournalNumber
	    WHILE (@@fetch_status <> -1) BEGIN
		    IF (@@fetch_status <> -2) BEGIN	
			    EXEC dbo.spGLJournalBatchPost
                            @xochErrSP	                    = @xochErrSP    OUTPUT
                        ,@xonErrNum                     = @xonErrNum    OUTPUT
                        ,@xostrErrInfo                  = @xostrErrInfo OUTPUT
                        ,@xstrvdfJournalNumberTo		= @strcurGLJournalHdr_idfJournalNumber
                        ,@xstrvdfJournalNumberFrom		= @strcurGLJournalHdr_idfJournalNumber
		    END
		    FETCH NEXT FROM curGLJournalHdr INTO @strcurGLJournalHdr_idfJournalNumber
	    END
	    CLOSE curGLJournalHdr
	    DEALLOCATE curGLJournalHdr
    END
END
	
IF(ISNULL(@xonErrNum,0) <> 0) 
	RETURN (@xonErrNum)
		
RETURN (0)

