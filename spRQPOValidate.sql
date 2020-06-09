-- Paramount Technologies, Inc. $Version: WorkPlace_08.02.00 $  - $Revision: 72 $ $Modtime: 2/03/06 4:15p $
DROP PROCEDURE spRQPOValidate
GO
CREATE PROCEDURE spRQPOValidate
 @xochErrSP		CHAR(32)      	= ''	OUTPUT
,@xonErrNum		INT          	= 0	OUTPUT
,@xostrErrInfo		VARCHAR(255) 	= ''	OUTPUT
,@xonWCValHdrKey	INT		= NULL 	OUTPUT
,@xonRQRevHdrKey	INT
,@xchUDFParam1		VARCHAR(255)	= '' --In great plains, this is for PA budget passwords
,@xstrRFQParam		VARCHAR(255)	= ''
,@xstrSource		VARCHAR(255)	= ''
AS
DECLARE
 @nHDR_idfPTICompanyKey		INT
,@nHDR_idfRQRevDtlKey		INT
,@strHDR_edfBuyer		CHAR (15)
,@strHDR_edfCurrency		CHAR (15)
,@nHDR_edfDropShip		INT
,@strHDR_edfDropShipCustomer	CHAR (15)
,@strHDR_edfFacilityID		VARCHAR(67)
,@nHDR_edfGL				INT
,@strHDR_edfItem			CHAR (31)
,@strHDR_edfItemDesc		CHAR (101)
,@strHDR_edfLocationFrom	CHAR (11)
,@strHDR_edfLocation		CHAR (11)
,@strHDR_edfPAProjectL1		CHAR(11)
,@strHDR_edfPAProjectL2		CHAR(17)
,@strHDR_edfPAProjectL3		CHAR(27)
,@nHDR_edfPOLine			INT
,@strHDR_edfPONumber		CHAR (17)
,@strHDR_edfShipTo		CHAR (15)
,@strHDR_edfBillTo		CHAR (15)
,@strHDR_edfTranType		CHAR (3)
,@strHDR_edfUOM			CHAR (9)
,@strHDR_edfVendor		CHAR (15)
,@strHDR_edfVendorItem		CHAR (31)
,@nHDR_edfWSProductIndicator	INT
,@nConvertedValue		NUMERIC(19,9)
,@nHDR_idfRowKey		INT
,@nHDR_idfFlagBlanketPO		INT
,@strHDR_edfShipMethod CHAR(50)
,@strHDR_edfPaymentTerm CHAR(50)
,@nHDR_idfRQRevDtlRQHeaderKey Char(50)
,@nRQHeaderKey Char(50)
,@nidfRQTypeKey INT
,@strWCSecurity_edfBuyer	VARCHAR(15)
,@nidfRateHome	NUMERIC(19,5)
,@nRQPOPRINTSHIPMETHTOGETHER INT
,@nidfQty NUMERIC(19,5)
SET NOCOUNT OFF

SELECT @nRQPOPRINTSHIPMETHTOGETHER = idfValue FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQPOPRINTSHIPMETHTOGETHER'

SELECT @strWCSecurity_edfBuyer = edfBuyer
FROM dbo.RQRevHdr H WITH (NOLOCK)
	INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON H.idfWCSecurityKey = S.idfWCSecurityKey
WHERE H.idfRQRevHdrKey = @xonRQRevHdrKey

	CREATE TABLE #spRQFNAValidate
	(
		idfRQDetailKey INT
		,idfAmtDiscount NUMERIC(19, 5)
		,idfAmtDiscountApr NUMERIC(19, 5)
		,idfAmtDiscountHome NUMERIC(19, 5)
		,idfAmtFreight NUMERIC(19, 5)
		,idfAmtFreightApr NUMERIC(19, 5)
		,idfAmtFreightHome NUMERIC(19, 5)
		,idfAmtMisc NUMERIC(19, 5)
		,idfAmtMiscApr NUMERIC(19, 5)
		,idfAmtMiscHome NUMERIC(19, 5)
		,idfAmtSubTotal NUMERIC(19, 5)
		,idfAmtSubTotalApr NUMERIC(19, 5)
		,idfAmtSubTotalHome NUMERIC(19, 5)
		,idfAmtTax NUMERIC(19, 5)
		,idfAmtTaxApr NUMERIC(19, 5)
		,idfAmtTaxHome NUMERIC(19, 5)
		,idfAmtTaxIncluded NUMERIC(19, 5)
		,idfAmtTaxIncludedApr NUMERIC(19, 5)
		,idfAmtTaxIncludedHome NUMERIC(19, 5)
		,idfBudgetApplyDate DATETIME
		,idfCommentInternal TEXT
		,idfCurrLineUpSeq INT
		,idfDatePromised DATETIME
		,idfDateRequired DATETIME
		,idfFlagBlanketPO INT
		,idfFlagManualDist INT
		,idfFlagReversal INT
		,idfFlagVCOverride INT
		,idfFulfillType VARCHAR(15)
		,idfGeneratedDocument VARCHAR(30)
		,idfLine INT
		,idfQty NUMERIC(19, 5)
		,idfQtyChangeOrderMin NUMERIC(19, 5)
		,idfQtyPrec INT
		,idfRateHome NUMERIC(19, 5)
		,idfShipToAddr1 VARCHAR(65)
		,idfShipToAddr2 VARCHAR(65)
		,idfShipToAddr3 VARCHAR(65)
		,idfShipToAltPhone1 VARCHAR(40)
		,idfShipToAltPhone2 VARCHAR(40)
		,idfShipToAltPhoneExt1 VARCHAR(20)
		,idfShipToAltPhoneExt2 VARCHAR(20)
		,idfShipToCity VARCHAR(40)
		,idfShipToContact VARCHAR(255)
		,idfShipToCountry VARCHAR(65)
		,idfShipToFax VARCHAR(40)
		,idfShipToName VARCHAR(255)
		,idfShipToState VARCHAR(40)
		,idfShipToZipCode VARCHAR(40)
		,idfURLReference VARCHAR(255)
		,idfVCOverrideNote VARCHAR(60)
		,idfDateCreated DATETIME
		,idfDateModified DATETIME
		,idfAPTaxTypeDtlKey INT
		,idfBUDPeriodKey INT
		,idfEXPTypeKey INT
		,idfGLReferenceKey INT
		,idfLogKey INT
		,idfPTICompanyKey INT
		,idfPTICurrencyRateDtlKeyApr INT
		,idfPTICurrencyRateDtlKeyHome INT
		,idfRCVDetailKey INT
		,idfRQDetailKeyChangeSource INT
		,idfRQHeaderKey INT
		,idfRQMemoKey INT
		,idfRQPriorityKey INT
		,idfRQSessionKey INT
		,idfSessionLinkKey INT
		,idfVCHeaderKey INT
		,idfWCDeptKey INT
		,idfWCICCompanyKeySource INT
		,idfWCICCompanyKeyTarget INT
		,idfWCLineUpKey INT
		,idfWCRRGroupLineUpKey INT
		,idfWCSecurityDelegateKey INT
		,idfWCTaxScheduleHdrKey INT
		,edfAmtAprExtended NUMERIC(19, 5)
		,edfAmtExtended NUMERIC(19, 5)
		,edfAmtHomeExtended NUMERIC(19, 5)
		,edfPrice NUMERIC(19, 5)
		,edfPricePrec INT
		,edfAnalysisGroup CHAR(15)
		,edfBillTo CHAR(15)
		,edfBuyer CHAR(15)
		,edfCurrency CHAR(15)
		,edfDocumentID VARCHAR(7)
		,edfDropShip INT
		,edfDropShipCustomer CHAR(15)
		,edfENCBreakDown CHAR(15)
		,edfENCGrantID CHAR(31)
		,edfENCProjectID CHAR(15)
		,edfENCUserDefined1 CHAR(15)
		,edfENCUserDefined2 CHAR(15)
		,edfENCUserDefined3 CHAR(15)
		,edfENCUserDefined4 CHAR(15)
		,edfENCUserDefined5 CHAR(15)
		,edfENCUserDefined6 CHAR(15)
		,edfENCUserDefined7 CHAR(15)
		,edfFacilityID VARCHAR(67)
		,edfFacilityIDFrom VARCHAR(67)
		,edfGL INT
		,edfItem CHAR(31)
		,edfItemDesc CHAR(101)
		,edfLocation CHAR(15)
		,edfLocationFrom CHAR(11)
		,edfManuItem VARCHAR(30)
		,edfPABudgetAuthCost INT
		,edfPABudgetAuthQty INT
		,edfPALineItemSeq INT
		,edfPAProjectL1 CHAR(11)
		,edfPAProjectL2 CHAR(17)
		,edfPAProjectL3 CHAR(27)
		,edfPaymentTerm VARCHAR(21)
		,edfPOLine INT
		,edfPONumber CHAR(17)
		,edfShipMethod VARCHAR(15)
		,edfShipTo CHAR(15)
		,edfTranType CHAR(3)
		,edfUOM CHAR(9)
		,edfVendor CHAR(15)
		,edfVendorAddrID VARCHAR(15)
		,edfVendorDocNum VARCHAR(21)
		,edfVendorItem CHAR(31)
		,edfWSProductIndicator INT
		,udfDateField01 DATETIME
		,udfDateField02 DATETIME
		,udfDateField03 DATETIME
		,udfDateField04 DATETIME
		,udfDateField05 DATETIME
		,udfLargeTextField01 VARCHAR(255)
		,udfLargeTextField02 VARCHAR(255)
		,udfLargeTextField03 VARCHAR(255)
		,udfNumericField01 NUMERIC(19, 5)
		,udfNumericField02 NUMERIC(19, 5)
		,udfNumericField03 NUMERIC(19, 5)
		,udfNumericField04 NUMERIC(19, 5)
		,udfNumericField05 NUMERIC(19, 5)
		,udfNumericField06 NUMERIC(19, 5)
		,udfNumericField07 NUMERIC(19, 5)
		,udfNumericField08 NUMERIC(19, 5)
		,udfNumericField09 NUMERIC(19, 5)
		,udfNumericField10 NUMERIC(19, 5)
		,udfTextField01 VARCHAR(60)
		,udfTextField02 VARCHAR(60)
		,udfTextField03 VARCHAR(60)
		,udfTextField04 VARCHAR(60)
		,udfTextField05 VARCHAR(60)
		,udfTextField06 VARCHAR(60)
		,udfTextField07 VARCHAR(60)
		,udfTextField08 VARCHAR(60)
		,udfTextField09 VARCHAR(60)
		,udfTextField10 VARCHAR(60)
		,vdfBudgetValid INT
		,vdfBudgetID CHAR(20)
		,vdfComment TEXT
		,vdfDeptID CHAR(20)
		,vdfTaxTypeID NVARCHAR(128)
		,vdfContractID CHAR(20)
		,vdfPriorityID CHAR(20)
		,vdfTaxScheduleID NVARCHAR(120)
		,vdfGL CHAR(129)
		,vdfTypeID CHAR(20)
		,vdfQtyCanceled NUMERIC(19  , 5   )
		,vdfCancelReason VARCHAR(60)
		,idfRQDetailKey_OLD INT
		,idfRowKey INT
    ,idfRowAction				CHAR(2)
    ,idfCodeRev					CHAR(8)
    ,idfRQAprDtlRQHeaderKey		INT
    ,idfRQRevDtlRQHeaderKey		INT
    ,idfWCSecurityKey			INT
    ,vdfOldAmountHomeExtended	NUMERIC(19,5)
    ,vdfOldQty					NUMERIC(19,5)
    ,vdfOldVCHeaderKey			INT
    ,vdfOldItem					VARCHAR(255)
    ,vdfOldBUDPeriodKey			INT
    ,edfPriceHome				NUMERIC(19,5)
    ,vdfExchangeRate			NUMERIC(19,5)
    ,vdfRateDate				DATETIME
    ,vdfRateTime				DATETIME
    ,vdfRateCal					INT
    ,vdfRateType				VARCHAR(60)
    ,vdfRateTable				VARCHAR(255)
    ,vdfOldGL					INT
    ,idfDateRequiredOld			DATETIME
    ,idfGLSegmentHash     NVARCHAR(186)
    )
  
 CREATE TABLE #spRQPOValidate
 (	
	  [idfPTICompanyKey]		INT		NOT NULL
	, idfDateRequired			DATETIME
	, [edfAnalysisGroup]		CHAR(15)
	, [edfBillTo]			CHAR (15)   NULL
	, [edfBuyer]			CHAR (15)	NULL
	, [edfCurrency]			CHAR (15)	NULL
	, [edfDropShip]			INT		NULL
	, [edfDropShipCustomer]		CHAR (15)	NULL
    , edfFacilityID				VARCHAR(67)	NULL	
	, edfENCBreakDown            char(15)     NULL     
	, edfENCGrantID            char(31)     NULL     
    , edfENCProjectID          char(15)     NULL     
    , edfENCUserDefined1       char(15)     NULL
    , edfENCUserDefined2       char(15)     NULL
    , edfENCUserDefined3       char(15)     NULL
    , edfENCUserDefined4       char(15)     NULL
    , edfENCUserDefined5       char(15)     NULL
    , edfENCUserDefined6       char(15)     NULL
    , edfENCUserDefined7       char(15)     NULL
	, [edfGL]			INT		NULL
	, [edfItem]			CHAR (31)	NULL
	, [edfItemDesc]			CHAR (101)	NULL
	, [edfLocationFrom]		CHAR (11)	NULL
	, [edfLocation]			CHAR (11)	NULL
	, [edfPAProjectL1]		CHAR (11)	NULL
	, [edfPAProjectL2]		CHAR (17)	NULL
	, [edfPAProjectL3]		CHAR (27)	NULL
	, [edfPALineItemSeq]		INT		NULL
	, [edfPABudgetAuthQty]		INT		NOT NULL
	, [edfPABudgetAuthCost]		INT		NOT NULL
	, [edfPOLine]			INT		NULL
	, [edfPONumber]			CHAR (17)	NULL
	, [edfShipTo]			CHAR (15)	NULL
	, [edfShipMethod]			CHAR (15)	NULL
	, [edfPaymentTerm]			CHAR (21)	NULL
	, [edfTranType]			CHAR(3)		NULL
	, [edfUOM]			CHAR (9)	NULL
	, [edfVendor]			CHAR (15)	NULL
	, [edfVendorItem]		CHAR (31)	NULL
	, [edfWSProductIndicator]	INT		NOT NULL
	, [idfCodeRev]			CHAR (15)	NULL
	, [idfQty]			NUMERIC(19,5)
	, [edfPrice]			NUMERIC(19,5)
	, [idfQtyPrec]		INT		NOT NULL
	, [edfPricePrec]		INT		NOT NULL
	, [edfAmtHomeExtended]		NUMERIC(19,5)
	, [edfAmtAprExtended]		NUMERIC(19,5)
	, [vdfOldQty]			NUMERIC(19,5)		
	, [vdfOldAmountHomeExtended]	NUMERIC(19,5)
	, [idfVCHeaderKey]     INT
	, [idfBUDPeriodKey]     INT
	, [idfRowKey]			INT IDENTITY(0,1) NOT NULL
	, [idfRQSessionKey]		INT
	, [idfWCDeptKey]		INT
	, [idfRQRevDtlKey]		INT
	, [idfFlagBlanketPO]		INT
	, [idfRQRevDtlRQHeaderKey]	INT
	, [edfManuItem]				VARCHAR(30)
	, [idfFlagVCOverride]		INT
	, [idfRateHome]			NUMERIC(19,5)

)
CREATE TABLE #spWCValDtl
	(
		 idfRowKey		INT
		,idfErrInfo		VARCHAR(255)
		,idfErrNum		INT
		,idfOBJName		CHAR(128)
		,idfIsWarning 	INT
		,idfTableName	VARCHAR(60)
		,ErrorNumber	INT
		,idfRowAction	CHAR(2)
		,idfKey			INT
		,idfParam01		VARCHAR(255)
		,idfParam02		VARCHAR(255)
		,idfParam03		VARCHAR(255)
		,idfFlagTableSpecific	INT
    )
	CREATE TABLE #PCardRQHeader
	(
		idfRQHeaderKey	INT
	)
DELETE dbo.WCValDtl
FROM dbo.RQRevDtl (NOLOCK)
	INNER JOIN dbo.WCValDtl WITH (NOLOCK) ON WCValDtl.idfSessionLinkKey = RQRevDtl.idfRQRevDtlKey AND WCValDtl.idfTableName = 'RQRevDtl'
WHERE idfRQRevHdrKey = @xonRQRevHdrKey
OPTION (FORCE ORDER)
------------------------------------------------------------------------------------------------
-- Validate records that are passed in the following type of temp table
------------------------------------------------------------------------------------------------

IF (@xstrSource <> 'AUTOAPR')
BEGIN
EXEC sp_executesql N'
INSERT INTO #spRQPOValidate 
	(
		[idfPTICompanyKey] 
		, [idfDateRequired]
        , [edfAnalysisGroup]
        , [edfBillTo]
		, [edfBuyer]
		, [edfCurrency]
		, [edfDropShip]
		, [edfDropShipCustomer]
		, edfFacilityID
		, edfENCGrantID
		, edfENCProjectID
		, edfENCUserDefined1
		, edfENCUserDefined2
		, edfENCUserDefined3
		, edfENCUserDefined4
		, edfENCUserDefined5
		, edfENCUserDefined6
		, edfENCUserDefined7
		, [edfGL]
		, [edfItem]
		, [edfItemDesc]
		, [edfLocationFrom]
		, [edfLocation]
		, [edfPAProjectL1]
		, [edfPAProjectL2]
		, [edfPAProjectL3]
		, [edfPALineItemSeq]
		, [edfPABudgetAuthQty]
		, [edfPABudgetAuthCost]
		, [edfPOLine]
		, [edfPONumber]
		, [edfShipTo]
		, [edfShipMethod]
		, [edfPaymentTerm]
		, [edfTranType]
		, [edfUOM]
		, [edfVendor]
		, [edfVendorItem]
		, [edfWSProductIndicator]
		, [idfQty]		
		, [edfPrice]	
    	, [idfQtyPrec]		
        , [edfPricePrec]		
		, [edfAmtHomeExtended]
		, [edfAmtAprExtended]
		, [vdfOldQty]
		, [vdfOldAmountHomeExtended]
		, [idfCodeRev]
	    , [idfVCHeaderKey]
	    , [idfBUDPeriodKey]
		, [idfRQSessionKey]
		, [idfWCDeptKey] 
		, [idfRQRevDtlKey]
		, [idfFlagBlanketPO]
		, [idfRQRevDtlRQHeaderKey]
		, [edfManuItem]
		, [idfFlagVCOverride]
		, idfRateHome
	)
	SELECT 	
		RQRevDtl.idfPTICompanyKey
		, RQRevDtl.idfDateRequired
        , RQRevDtl.edfAnalysisGroup
        , RQRevDtl.edfBillTo
		, RQRevDtl.edfBuyer
		, RQRevDtl.edfCurrency
		, RQRevDtl.edfDropShip
		, RQRevDtl.edfDropShipCustomer
		, RQRevDtl.edfFacilityID
		, RQRevDtl.edfENCGrantID
		, RQRevDtl.edfENCProjectID
		, RQRevDtl.edfENCUserDefined1
		, RQRevDtl.edfENCUserDefined2
		, RQRevDtl.edfENCUserDefined3
		, RQRevDtl.edfENCUserDefined4
		, RQRevDtl.edfENCUserDefined5
		, RQRevDtl.edfENCUserDefined6
		, RQRevDtl.edfENCUserDefined7
		, RQRevDtl.edfGL
		, RQRevDtl.edfItem
		, RQRevDtl.edfItemDesc
		, RQRevDtl.edfLocationFrom
		, RQRevDtl.edfLocation
		, RQRevDtl.edfPAProjectL1
		, RQRevDtl.edfPAProjectL2
		, RQRevDtl.edfPAProjectL3
		, RQRevDtl.edfPALineItemSeq
		, RQRevDtl.edfPABudgetAuthQty
		, RQRevDtl.edfPABudgetAuthCost
		, RQRevDtl.edfPOLine
		, RQRevDtl.edfPONumber
		, RQRevDtl.edfShipTo
		, RQRevDtl.edfShipMethod
		, RQRevDtl.edfPaymentTerm
		, RQRevDtl.edfTranType
		, RQRevDtl.edfUOM
		, RQRevDtl.edfVendor
		, RQRevDtl.edfVendorItem
		, RQRevDtl.edfWSProductIndicator
		, RQRevDtl.idfQty
		, RQRevDtl.edfPrice
    	, RQRevDtl.idfQtyPrec
    	, RQRevDtl.edfPricePrec
		, RQRevDtl.edfAmtHomeExtended
		, RQRevDtl.edfAmtAprExtended
		, RQRevDtl.idfQty
		, RQRevDtl.edfAmtHomeExtended
		, RQRevDtl.idfCodeRev
		, RQRevDtl.idfVCHeaderKey
		, RQRevDtl.idfBUDPeriodKey
		, RQDetail.idfRQSessionKey
		, RQRevDtl.idfWCDeptKey	  
		, RQRevDtl.idfRQRevDtlKey
		, RQRevDtl.idfFlagBlanketPO
		, RQRevDtl.idfRQRevDtlRQHeaderKey
		, RQRevDtl.edfManuItem
		, RQRevDtl.idfFlagVCOverride
		, RQRevDtl.idfRateHome
	FROM dbo.RQRevDtl (NOLOCK)
	INNER JOIN dbo.RQDetail (NOLOCK) ON RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey 
	WHERE idfRQRevHdrKey = @xonRQRevHdrKey
	ORDER BY RQRevDtl.idfRQRevDtlKey'
	,N'@xonRQRevHdrKey INT'
	,@xonRQRevHdrKey

	IF @@ERROR <> 0
	RAISERROR ('spRQPOValidate:100',1,1)
	-- CDB 4/10/02: Remove records that are not in a session of 150.  This is necessary to do this here
	-- instead of in the insert statement so that the idfRowKey is populated correctly due to the way the
	-- errors are positioned.  If we don't then the errors will display on the wrong line.
	EXEC sp_executesql N'DELETE #spRQPOValidate WHERE idfRQSessionKey <> 150 AND idfRQSessionKey <> 155 OPTION (KEEP PLAN)'
	IF @@ERROR <> 0
		RAISERROR ('spRQPOValidate:150',1,1)
END

IF (@xstrSource = 'AUTOAPR')
BEGIN
EXEC sp_executesql N'
INSERT INTO #spRQPOValidate 
	(
		[idfPTICompanyKey] 
		, [idfDateRequired]
        , [edfAnalysisGroup]
        , [edfBillTo]
		, [edfBuyer]
		, [edfCurrency]
		, [edfDropShip]
		, [edfDropShipCustomer]
		, edfFacilityID
		, edfENCGrantID
		, edfENCProjectID
		, edfENCUserDefined1
		, edfENCUserDefined2
		, edfENCUserDefined3
		, edfENCUserDefined4
		, edfENCUserDefined5
		, edfENCUserDefined6
		, edfENCUserDefined7
		, [edfGL]
		, [edfItem]
		, [edfItemDesc]
		, [edfLocationFrom]
		, [edfLocation]
		, [edfPAProjectL1]
		, [edfPAProjectL2]
		, [edfPAProjectL3]
		, [edfPALineItemSeq]
		, [edfPABudgetAuthQty]
		, [edfPABudgetAuthCost]
		, [edfPOLine]
		, [edfPONumber]
		, [edfShipTo]
		, [edfShipMethod]
		, [edfPaymentTerm]
		, [edfTranType]
		, [edfUOM]
		, [edfVendor]
		, [edfVendorItem]
		, [edfWSProductIndicator]
		, [idfQty]		
		, [edfPrice]	
    	, [idfQtyPrec]		
        , [edfPricePrec]		
		, [edfAmtHomeExtended]
		, [edfAmtAprExtended]
		, [vdfOldQty]
		, [vdfOldAmountHomeExtended]
		, [idfCodeRev]
	    , [idfVCHeaderKey]
	    , [idfBUDPeriodKey]
		, [idfRQSessionKey]
		, [idfWCDeptKey] 
		, [idfRQRevDtlKey]
		, [idfFlagBlanketPO]
		, [idfRQRevDtlRQHeaderKey]
		, [edfManuItem]
		, [idfFlagVCOverride]
		, idfRateHome
	)
	SELECT 	
		RQRevDtl.idfPTICompanyKey
		, RQRevDtl.idfDateRequired
        , RQRevDtl.edfAnalysisGroup
        , RQRevDtl.edfBillTo
		, RQRevDtl.edfBuyer
		, RQRevDtl.edfCurrency
		, RQRevDtl.edfDropShip
		, RQRevDtl.edfDropShipCustomer
		, RQRevDtl.edfFacilityID
		, RQRevDtl.edfENCGrantID
		, RQRevDtl.edfENCProjectID
		, RQRevDtl.edfENCUserDefined1
		, RQRevDtl.edfENCUserDefined2
		, RQRevDtl.edfENCUserDefined3
		, RQRevDtl.edfENCUserDefined4
		, RQRevDtl.edfENCUserDefined5
		, RQRevDtl.edfENCUserDefined6
		, RQRevDtl.edfENCUserDefined7
		, RQRevDtl.edfGL
		, RQRevDtl.edfItem
		, RQRevDtl.edfItemDesc
		, RQRevDtl.edfLocationFrom
		, RQRevDtl.edfLocation
		, RQRevDtl.edfPAProjectL1
		, RQRevDtl.edfPAProjectL2
		, RQRevDtl.edfPAProjectL3
		, RQRevDtl.edfPALineItemSeq
		, RQRevDtl.edfPABudgetAuthQty
		, RQRevDtl.edfPABudgetAuthCost
		, RQRevDtl.edfPOLine
		, RQRevDtl.edfPONumber
		, RQRevDtl.edfShipTo
		, RQRevDtl.edfShipMethod
		, RQRevDtl.edfPaymentTerm
		, RQRevDtl.edfTranType
		, RQRevDtl.edfUOM
		, RQRevDtl.edfVendor
		, RQRevDtl.edfVendorItem
		, RQRevDtl.edfWSProductIndicator
		, RQRevDtl.idfQty
		, RQRevDtl.edfPrice
    	, RQRevDtl.idfQtyPrec
    	, RQRevDtl.edfPricePrec
		, RQRevDtl.edfAmtHomeExtended
		, RQRevDtl.edfAmtAprExtended
		, RQRevDtl.idfQty
		, RQRevDtl.edfAmtHomeExtended
		, ''ORDER''
		, RQRevDtl.idfVCHeaderKey
		, 0
		, 150
		, -1  
		, RQRevDtl.idfForeignKey
		, RQRevDtl.idfFlagBlanketPO
		, 0
		, ''''
		, RQRevDtl.idfFlagVCOverride
		, RQRevDtl.idfRateHome
	FROM #spRQPOGenerate RQRevDtl'
	,N'@xonRQRevHdrKey INT'
	,@xonRQRevHdrKey

	IF @@ERROR <> 0
		RAISERROR ('spRQPOValidate:100',1,1)
	-- CDB 4/10/02: Remove records that are not in a session of 150.  This is necessary to do this here
	-- instead of in the insert statement so that the idfRowKey is populated correctly due to the way the
	-- errors are positioned.  If we don't then the errors will display on the wrong line.
	EXEC sp_executesql N'DELETE #spRQPOValidate WHERE idfRQSessionKey <> 150 AND idfRQSessionKey <> 155 OPTION (KEEP PLAN)'
	IF @@ERROR <> 0
		RAISERROR ('spRQPOValidate:150',1,1)
END
-- Validate Financial Data.
	-- Validate Financial Data.'
	EXEC sp_executesql N'
	INSERT INTO #spRQFNAValidate
	(
		 idfPTICompanyKey		
		,idfDateRequired
		,edfAnalysisGroup
		,edfBillTo		
		,edfBuyer			
		,edfCurrency			
		,edfDropShip			
		,edfDropShipCustomer		
		,edfFacilityID       
		,edfENCBreakDown            
		,edfENCGrantID            
		,edfENCProjectID          
		,edfENCUserDefined1       
		,edfENCUserDefined2       
		,edfENCUserDefined3       
		,edfENCUserDefined4       
		,edfENCUserDefined5       
		,edfENCUserDefined6       
		,edfENCUserDefined7
		,edfGL			
		,edfItem			
		,edfItemDesc			
		,edfLocationFrom		
		,edfLocation			
		,edfPAProjectL1		
		,edfPAProjectL2		
		,edfPAProjectL3		
		,edfPALineItemSeq		
		,edfPABudgetAuthQty		
		,edfPABudgetAuthCost		
		,edfPOLine			
		,edfPONumber			
		,edfShipTo	
		,edfShipMethod	
		,edfPaymentTerm			
		,edfTranType			
		,edfUOM			
		,edfVendor			
		,edfVendorItem		
		,edfWSProductIndicator	
		,idfQty			
		,edfPrice			
		,idfQtyPrec		
		,edfPricePrec	
		,edfAmtHomeExtended	
		,edfAmtAprExtended	
		,vdfOldQty		
		,vdfOldAmountHomeExtended	
		,idfVCHeaderKey     
		,idfBUDPeriodKey    
		,idfRowKey		
		,idfRQSessionKey	
		,idfWCDeptKey	
		,edfAmtExtended	
		,edfPriceHome
		,vdfOldItem
		,vdfOldVCHeaderKey
		,vdfOldBUDPeriodKey
		,vdfExchangeRate
		,vdfRateDate
		,vdfRateTime
		,vdfRateCal
		,vdfRateType
		,vdfRateTable
		,idfRQRevDtlRQHeaderKey
		,edfManuItem
		,idfFlagVCOverride
		,idfRateHome
	)
	SELECT  
		 idfPTICompanyKey
		,idfDateRequired		
		,edfAnalysisGroup
		,edfBillTo		
		,edfBuyer			
		,edfCurrency			
		,edfDropShip			
		,edfDropShipCustomer		
		,edfFacilityID       
		,edfENCBreakDown            
		,edfENCGrantID            
		,edfENCProjectID          
		,edfENCUserDefined1       
		,edfENCUserDefined2       
		,edfENCUserDefined3       
		,edfENCUserDefined4       
		,edfENCUserDefined5       
		,edfENCUserDefined6       
		,edfENCUserDefined7
		,edfGL			
		,edfItem			
		,edfItemDesc			
		,edfLocationFrom		
		,edfLocation			
		,edfPAProjectL1		
		,edfPAProjectL2		
		,edfPAProjectL3		
		,edfPALineItemSeq		
		,edfPABudgetAuthQty		
		,edfPABudgetAuthCost		
		,edfPOLine			
		,edfPONumber			
		,edfShipTo
		,edfShipMethod
		,edfPaymentTerm			
		,edfTranType			
		,edfUOM			
		,edfVendor			
		,edfVendorItem		
		,edfWSProductIndicator	
		,idfQty			
		,edfPrice			
		,idfQtyPrec		
		,edfPricePrec	
		,edfAmtHomeExtended	
		,edfAmtAprExtended	
		,vdfOldQty		
		,vdfOldAmountHomeExtended	
		,idfVCHeaderKey     
		,idfBUDPeriodKey    
		,idfRowKey		
		,idfRQSessionKey	
		,idfWCDeptKey	
		,null edfAmtExtended	
		,CONVERT(NUMERIC(19,5),0) AS  edfPriceHome
		,edfItem vdfOldItem
		,idfVCHeaderKey vdfOldVCHeaderKey
		,idfBUDPeriodKey vdfOldBUDPeriodKey
		,null vdfExchangeRate
		,CONVERT(DATETIME,NULL) vdfRateDate
		,CONVERT(DATETIME,NULL) vdfRateTime
		,null vdfRateCal
		,CONVERT(VARCHAR(255),NULL) vdfRateType
		,CONVERT(VARCHAR(255),NULL) vdfRateTable
		,idfRQRevDtlRQHeaderKey
		,edfManuItem
		,idfFlagVCOverride
		,idfRateHome
	FROM #spRQPOValidate 
	WHERE idfCodeRev = ''ORDER'' OR @xstrRFQParam = ''RFQAM''',N'@xstrRFQParam VARCHAR(255)',@xstrRFQParam

	IF @@ERROR <> 0
		RAISERROR ('spRQPOValidate:200',1,1)

	EXEC spRQFNAValidate @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xonWCValHdrKey OUTPUT,'POGEN',@xchUDFParam1

	IF @xonErrNum <> 0
	BEGIN
		RETURN (@xonErrNum)
	END

	EXEC sp_executesql N'
	INSERT INTO #PCardRQHeader
	SELECT idfRQHeaderKey 
	FROM #spRQPOValidate V
	INNER JOIN RQRevDtl D (NOLOCK) ON V.idfRQRevDtlKey = D.idfRQRevDtlKey
	INNER JOIN RQRevDtlRQHeader R (NOLOCK) ON D.idfRQRevDtlRQHeaderKey = R.idfRQRevDtlRQHeaderKey
	INNER JOIN WCPCard P (NOLOCK) ON R.idfRQHeaderKey = P.idfTableLinkKey AND P.idfTableLinkName = ''RQHeader''
	GROUP BY R.idfRQHeaderKey
				HAVING  MIN(V.edfVendor)			<> MAX(V.edfVendor)			
					 OR MIN(V.edfLocation) 			<> MAX(V.edfLocation) 		
					 OR MIN(V.edfCurrency) 			<> MAX(V.edfCurrency) 		
					 OR MIN(V.edfDropShip) 			<> MAX(V.edfDropShip) 		
					 OR MIN(V.edfDropShipCustomer)	<> MAX(V.edfDropShipCustomer) 
					 OR MIN(V.edfFacilityID)		<> MAX(V.edfFacilityID)
					 OR MIN(V.edfShipTo)			<> MAX(V.edfShipTo)			
					 OR MIN(V.edfTranType) 			<> MAX(V.edfTranType)
					 OR MIN(V.edfShipMethod) 		<> MAX(V.edfShipMethod)
					 OR MIN(V.edfPaymentTerm) 		<> MAX(V.edfPaymentTerm)'

	EXEC sp_executesql N'
	INSERT INTO #spWCValDtl (idfRowKey,idfErrNum,idfOBJName,idfIsWarning) 
	SELECT idfRowKey,-118,''spRQPOValidate'',0 
	FROM #spRQPOValidate V
	INNER JOIN RQRevDtl D (NOLOCK) ON V.idfRQRevDtlKey = D.idfRQRevDtlKey
	INNER JOIN RQRevDtlRQHeader R (NOLOCK) ON D.idfRQRevDtlRQHeaderKey = R.idfRQRevDtlRQHeaderKey
	INNER JOIN #PCardRQHeader P (NOLOCK) ON P.idfRQHeaderKey = R.idfRQHeaderKey'
	IF @@ERROR <> 0
		RAISERROR ('spRQPOValidate:300',1,1)

	EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT
	DROP TABLE #spWCValDtl
	IF @xonWCValHdrKey IS NOT NULL AND @xonWCValHdrKey >0
	BEGIN
	   SELECT @xonErrNum = @xonWCValHdrKey
	   RETURN
	   
	END

 --Validate all rows
 EXEC sp_executesql N'
DECLARE curspRQPOValidate INSENSITIVE CURSOR
FOR SELECT
	 idfPTICompanyKey
	,edfBillTo
	,edfBuyer
	,edfCurrency
	,edfDropShip
	,edfDropShipCustomer
	,edfFacilityID
	,edfGL
	,edfItem
	,edfItemDesc
	,edfLocationFrom
	,edfLocation
	,edfPAProjectL1
	,edfPAProjectL2
	,edfPAProjectL3
	,edfPOLine
	,edfPONumber
	,edfShipTo
	,edfTranType
	,edfUOM
	,edfVendor
	,edfVendorItem
	,edfWSProductIndicator
	,idfRowKey
	,idfRQRevDtlKey
	,idfFlagBlanketPO
	,edfShipMethod
	,edfPaymentTerm
	,idfRQRevDtlRQHeaderKey
	,idfRateHome
	,idfQty
FROM #spRQPOValidate
WHERE idfCodeRev = ''ORDER'' OR @xstrRFQParam = ''RFQAM''',N'@xstrRFQParam VARCHAR(255)',@xstrRFQParam

OPEN curspRQPOValidate

FETCH curspRQPOValidate INTO
	 @nHDR_idfPTICompanyKey
	,@strHDR_edfBillTo
	,@strHDR_edfBuyer
	,@strHDR_edfCurrency
	,@nHDR_edfDropShip
	,@strHDR_edfDropShipCustomer
	,@strHDR_edfFacilityID
	,@nHDR_edfGL
	,@strHDR_edfItem
	,@strHDR_edfItemDesc
	,@strHDR_edfLocationFrom
	,@strHDR_edfLocation
	,@strHDR_edfPAProjectL1
	,@strHDR_edfPAProjectL2
	,@strHDR_edfPAProjectL3
	,@nHDR_edfPOLine
	,@strHDR_edfPONumber
	,@strHDR_edfShipTo
	,@strHDR_edfTranType
	,@strHDR_edfUOM
	,@strHDR_edfVendor
	,@strHDR_edfVendorItem
	,@nHDR_edfWSProductIndicator	
	,@nHDR_idfRowKey  
	,@nHDR_idfRQRevDtlKey
	,@nHDR_idfFlagBlanketPO
	,@strHDR_edfShipMethod
	,@strHDR_edfPaymentTerm
	,@nHDR_idfRQRevDtlRQHeaderKey
	,@nidfRateHome
	,@nidfQty
WHILE @@fetch_status <> -1
BEGIN
	IF @@fetch_status <> -2
	BEGIN
		IF @strHDR_edfVendor = '' AND @xstrRFQParam = ''
			BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -101, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQPOValidate
					DEALLOCATE curspRQPOValidate
					RETURN @xonErrNum
				END
			END
		IF @strHDR_edfUOM = '' AND @xstrRFQParam = ''
			BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -103, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQPOValidate
					DEALLOCATE curspRQPOValidate
					RETURN @xonErrNum
				END
			END
		IF @nHDR_edfGL IS NULL
			BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -104, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQPOValidate
					DEALLOCATE curspRQPOValidate
					RETURN @xonErrNum
				END
			END

		-- If location is empty then error.
		IF  (EXISTS (SELECT TOP 1 1 FROM WCSystem WITH (NOLOCK) WHERE idfModuleRegisteredIV = 1) AND (@strHDR_edfLocation = ''))
			BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -102, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQPOValidate
					DEALLOCATE curspRQPOValidate
					RETURN @xonErrNum
				END
			END
		
		EXEC spFNAConvertCur @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @strHDR_edfCurrency,1, 0, @nConvertedValue OUTPUT
		
		--INSERT INTO TEST VALUES (@strHDR_edfCurrency,@nConvertedValue)
		IF @xonErrNum <> 0
			BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -105, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQPOValidate
					DEALLOCATE curspRQPOValidate
					RETURN @xonErrNum
				END
			END
		IF @nHDR_edfDropShip = 1 AND @strHDR_edfDropShipCustomer = ''
		BEGIN
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -106, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQPOValidate
				DEALLOCATE curspRQPOValidate
				RETURN @xonErrNum
			END
		END
		IF EXISTS(SELECT TOP 1 1 FROM IV00101 (NOLOCK) WHERE ITEMNMBR=@strHDR_edfItem AND ITEMTYPE = 2)
		BEGIN
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -242, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQPOValidate
				DEALLOCATE curspRQPOValidate
				RETURN @xonErrNum
			END
		END
		IF EXISTS(SELECT TOP 1 1 FROM IV00101 (NOLOCK) WHERE ITEMNMBR=@strHDR_edfItem AND INACTIVE = 1)
		BEGIN
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -243, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQPOValidate
				DEALLOCATE curspRQPOValidate
				RETURN @xonErrNum
			END
		END
			IF (EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND POSTATUS > 4)
			 OR EXISTS(SELECT 1 FROM dbo.POP30100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber))
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -114, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END 
			
			IF  (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND VENDORID <> @strHDR_edfVendor)
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -115, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END
			
			IF  ((@nRQPOPRINTSHIPMETHTOGETHER = 0) AND (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND SHIPMTHD <> @strHDR_edfShipMethod))
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -212, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END 
			

			IF  (@nHDR_edfDropShip = 1) AND (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND CUSTNMBR <> @strHDR_edfDropShipCustomer)
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -215, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END

			
			IF EXISTS (Select 1 from WCSystem Where idfModuleRegisteredMC = 1)
			BEGIN
				IF  (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND CURNCYID <> @strHDR_edfCurrency)
				BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -216, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
				END
			END 
			
			IF  (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PYMTRMID <> @strHDR_edfPaymentTerm)
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -213, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END 
			
			IF  (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PRSTADCD <> @strHDR_edfShipTo)
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -214, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END
			
			IF  (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PRBTADCD <> @strHDR_edfBillTo)
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -224, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END 
			
			-- Get Buyer ID
			IF EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQBUYERFROMREQUESTER' AND idfValue = 1)
				SELECT @strWCSecurity_edfBuyer = edfBuyer 
				FROM dbo.RQRevDtlRQHeader WITH (NOLOCK)
				INNER JOIN RQHeader WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQRevDtlRQHeader.idfRQHeaderKey
				INNER JOIN WCSecurity WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = RQHeader.idfWCSecurityKey
				WHERE idfRQRevDtlRQHeaderKey = @nHDR_idfRQRevDtlRQHeaderKey
		
			IF  (@strHDR_edfPONumber <> '') AND EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE POP10100.PONUMBER = @strHDR_edfPONumber 
					AND POP10100.BUYERID <> @strWCSecurity_edfBuyer)
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -218, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END 
			
			IF  (@strHDR_edfPONumber <> '') AND (@nHDR_edfDropShip <> 1) AND EXISTS(SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND POTYPE = 2)
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -219, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END 
			
			IF  (@strHDR_edfPONumber <> '') AND (EXISTS (SELECT 1 FROM POP10100 (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND POTYPE = 3) OR (@nHDR_idfFlagBlanketPO = 1))
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -220, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQPOValidate
						DEALLOCATE curspRQPOValidate
						RETURN @xonErrNum
					END			
			END 

		IF @strHDR_edfPONumber <> '' AND @strHDR_edfVendor <> '' AND EXISTS(SELECT 1 FROM #spRQPOValidate (NOLOCK) WHERE edfPONumber =	@strHDR_edfPONumber AND edfVendor <> @strHDR_edfVendor)
		BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -115, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQPOValidate
					DEALLOCATE curspRQPOValidate
					RETURN @xonErrNum
				END			
		END 

		IF (@strHDR_edfTranType = 'PA' AND @nHDR_idfFlagBlanketPO = 1)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -116, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
			

		IF EXISTS (SELECT TOP 1 1 
			FROM WCVendorInfo WITH (NOLOCK) 
			LEFT OUTER JOIN APVendor WITH (NOLOCK) ON APVendor.idfVendorID = WCVendorInfo.edfVendor
			LEFT OUTER JOIN RQRevDtl WITH (NOLOCK) ON idfRQRevDtlKey = @nHDR_idfRQRevDtlKey
			LEFT OUTER JOIN APAddress WITH (NOLOCK) ON APVendor.idfAPVendorKey = APAddress.idfAPVendorKey AND idfAddressID = edfVendorAddrID
			WHERE WCVendorInfo.edfVendor = @strHDR_edfVendor AND idfFlagEmailPO = 1 AND RTRIM(idfEmailTo) = '' AND RTRIM(idfEmail) = '')	
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -236, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey

		-- SCC - XCHGRATE is 0 for GRP when home
		IF EXISTS (SELECT TOP 1 1 FROM vwFNACurrency WITH (NOLOCK) WHERE edfFunctional = 1 AND edfCurrencyID = @strHDR_edfCurrency)
			SELECT @nidfRateHome = 0
		/*IF EXISTS(SELECT TOP 1 1 FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQUSEDATEANDRATEFORPO' AND idfValue = 1)
			IF  (@strHDR_edfPONumber <> '') AND ((SELECT TOP 1 XCHGRATE FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber) <> @nidfRateHome)
			BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -240, 'spRQPOValidate',0,'RQRevDtl',@nHDR_idfRQRevDtlKey
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQPOValidate
					DEALLOCATE curspRQPOValidate
					RETURN @xonErrNum
				END
			END*/

		IF (@xstrSource = 'AUTOAPR') AND EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQONHANDEXISTSERROR' AND idfValue = '1') BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM dbo.IV00102 WITH (NOLOCK) 
						WHERE IV00102.ITEMNMBR = @strHDR_edfItem AND IV00102.LOCNCODE = @strHDR_edfLocation AND QTYONHND - ATYALLOC - QTYCOMTD - @nidfQty > 0)

			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -244, 'spRQPOValidate',1,@xstrParam1 = @strHDR_edfItem ,@xstrParam2 = @strHDR_edfLocation
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQPOValidate
				DEALLOCATE curspRQPOValidate
				RETURN @xonErrNum
			END
		END
	END --@@fetch_status <> -2

	FETCH curspRQPOValidate INTO
		 @nHDR_idfPTICompanyKey
		,@strHDR_edfBillTo
		,@strHDR_edfBuyer
		,@strHDR_edfCurrency
		,@nHDR_edfDropShip
		,@strHDR_edfDropShipCustomer
		,@strHDR_edfFacilityID
		,@nHDR_edfGL
		,@strHDR_edfItem
		,@strHDR_edfItemDesc
		,@strHDR_edfLocationFrom
		,@strHDR_edfLocation
		,@strHDR_edfPAProjectL1
		,@strHDR_edfPAProjectL2
		,@strHDR_edfPAProjectL3
		,@nHDR_edfPOLine
		,@strHDR_edfPONumber
		,@strHDR_edfShipTo
		,@strHDR_edfTranType
		,@strHDR_edfUOM
		,@strHDR_edfVendor
		,@strHDR_edfVendorItem
		,@nHDR_edfWSProductIndicator
		,@nHDR_idfRowKey	 
		,@nHDR_idfRQRevDtlKey
		,@nHDR_idfFlagBlanketPO
		,@strHDR_edfShipMethod
		,@strHDR_edfPaymentTerm
		,@nHDR_idfRQRevDtlRQHeaderKey
		,@nidfRateHome
		,@nidfQty
END --@@fetch_status <> -1
CLOSE curspRQPOValidate
DEALLOCATE curspRQPOValidate

IF @xonErrNum IS NULL OR @xonErrNum = 0
BEGIN
	IF @xonWCValHdrKey IS NULL
		SELECT @xonErrNum = 0
     	ELSE
  		SELECT @xonErrNum = @xonWCValHdrKey
END

RETURN (0)

