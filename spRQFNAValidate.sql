DROP PROCEDURE spRQFNAValidate
GO
-- Paramount Technologies, Inc. $Version: WorkPlace_08.02.00 $  - $Revision: 103 $ $Modtime: 2/14/06 10:11a $
CREATE PROCEDURE spRQFNAValidate
 @xochErrSP			CHAR(32)      	= ''	OUTPUT
,@xonErrNum			INT          	= 0	OUTPUT
,@xostrErrInfo			VARCHAR(255) 	= ''	OUTPUT
,@xonWCValHdrKey		INT		= NULL 	OUTPUT
,@xstrSource			CHAR(20)	= NULL	-- ENTRY, APPROVAL, REVIEW, POGEN, UDFTEMPLATE, VENDORCONTRACT, DISTRIBUTION
,@xstrPassword			CHAR(11)	= NULL  -- Override Budget Password.
,@xstrCondition			CHAR(20)	= NULL
AS
DECLARE
 @nHDR_idfPTICompanyKey		INT
,@strHDR_edfBuyer		CHAR (15)
,@nidfQty			NUMERIC(19,5)
,@strHDR_edfCurrency		CHAR (15)
,@nedfPrice			NUMERIC(19,5)
,@nedfPriceHome			NUMERIC(19,5)
,@nedfAmtExtended		NUMERIC(19,5)
,@nedfAmtHomeExtended		NUMERIC(19,5)
,@nvdfExchangeRate		NUMERIC(19,5)
,@strvdfRateDate		VARCHAR(15)
,@strvdfRateTime		VARCHAR(15)
,@nvdfRateCal			NUMERIC(19,5)
,@strvdfRateType		VARCHAR(255)
,@strvdfRateTable		VARCHAR(255)
,@strHDR_edfAnalysisGroup	CHAR(15)
,@strHDR_edfDropShip    	INT
,@strHDR_edfDropShipCustomer	CHAR(15)
,@nHDR_edfGL			INT
,@strvdfGL				VARCHAR(255)
,@strHDR_edfItem		CHAR (31)
,@strHDR_edfItemDesc		CHAR (101)
,@strHDR_edfLocationFrom	CHAR (11)
,@strHDR_edfLocation		CHAR (11)
,@strHDR_edfPAProjectL1		CHAR(17)
,@strHDR_edfPAProjectL2		CHAR(27)
,@nedfWSProductIndicator	INT
,@nedfPALineItemSeq		INT
,@strHDR_edfPAProjectL3		CHAR(27)
,@nHDR_edfPOLine		INT
,@strHDR_edfPONumber		CHAR (17)
,@strHDR_edfShipTo		CHAR (15)
,@strHDR_edfBillTo		CHAR (15)
,@strHDR_edfShipMethod		CHAR (15)
,@strHDR_edfPaymentTerm		CHAR (21)
,@stredfShipMethodTmp		CHAR (15)
,@stredfPaymentTermTmp		CHAR (21)
,@strHDR_edfTranType		CHAR (3)
,@strHDR_edfUOM			CHAR (9)
,@strHDR_edfVendor		CHAR (15)
,@strHDR_edfVendorItem		CHAR (31)
,@n__HDR_idfFlagBlanketPO	INT
,@nQtyPer			INT
,@xItemCurrPer      INT
,@strUOMSCHDL			VARCHAR(255)
,@n__IV00101_ITEMTYPE		INT
,@n__IV00101_RELEASECOST	NUMERIC(19,5)
,@n__IV00101_STNDCOST		NUMERIC(19,5)
,@nHDR_idfRowKey		INT
,@nGRPAutoPODestination		INT
,@nGRPIsStandardPO		INT
,@nIsMiscIVItem			INT
,@nidfWCDeptKey			INT
,@nidfFlagGLAccountOverride INT
,@nRetVal				INT
,@nDTL_PACogs_Idx		INT
,@nDTL_PACGBWIPIDX		INT
,@chedfENCBreakDown		char(15)
,@chedfENCGrantID		char(31)
,@chedfENCProjectID		char(15)
,@chedfENCUserDefined1	char(15)
,@chedfENCUserDefined2	char(15)
,@chedfENCUserDefined3	char(15)
,@chedfENCUserDefined4	char(15)
,@chedfENCUserDefined5	char(15)
,@chedfENCUserDefined6	char(15)
,@chedfENCUserDefined7	char(15)
,@nedfAmtAprExtended		NUMERIC(19,5)
,@nEDITORidfWCSecurityKey	INT
,@nIV00101_GL			INT
-- dbo.WCSystem --
,@strWCSystem_edfCurrencyApproval	VARCHAR(15)
,@n__OverrideIVReturnVal	INT
,@n__OverrideIV_GLActIndxDst	INT		
,@strOverrideIV_GLActNumSt	CHAR(129)	
,@n__OverrideIV_GLActIndxSrc					INT
,@n__WCSystem_idfFlagIVUnitPriceOverride		INT
,@nFromTemplate									INT
,@n__WCSystemSettings_IVOVERRIDEPRICE_4SVCITEM	INT
,@n__WCSystemSettings_RQDEFAULTVENDOR_PRICE		INT
,@n__WCSystemSettings_RQFORCEDTRQINOPENPRD		INT
,@n__WCSystemSettings_RQVENDERRELATION			INT
,@n__WCSystemSettings_RQIGNSEGOVERRIDE				INT
,@n__WCSystemSettings_IVOVERRIDEPRICEWITHCURRENTCOST INT
,@n__WCSystemSettings_IVOVERRIDEPRICEWITHSTDCOST INT
,@n__WCSystemSettings_IVOVERRIDEITMDESCWITHDESC INT
,@dtidfDateRequired		DATETIME
,@nHDR_idfVCHeaderKey	INT
,@nRQType				INT
,@nidfRQDetailKey		INT
,@chedfVendorDocNum		CHAR(21)
,@chedfVendorAddrID		CHAR(15)
,@nRQVCUNIQUEBYITM_MI_UOM INT
,@stredfManuItem		char(60)
,@stredfFacilityID		VARCHAR(67)
,@stredfFacilityIDFrom	VARCHAR(67)
,@stredfDocumentID		VARCHAR(7)
,@nSecAddInvItem		INT
,@nidfPAProjectKey			INT
,@nidfPAProjectPhaseKey 	INT
,@nidfPAPhaseActivityKey	INT
,@strvdfProjectID	VARCHAR(60)
,@strvdfPhaseID		VARCHAR(60)
,@strvdfActivityID	VARCHAR(60)
,@strSQLInsert		NVARCHAR(4000)
,@strJOIN			NVARCHAR (255) 
,@strSelectINS		VARCHAR(56)
,@strSelect			VARCHAR(56)
,@nRQGLOVERLAYPRIMARY INT
,@nRQOVERRIDESITEIDWITHSHIPTO INT
,@nCount INT
,@nNewKey INT
,@nRQENABLEPRIMARYVENDCONT INT
,@strvdfPriorityID	char(20)
,@nidfRQPriorityKey INT
,@nAllowInvalidGL INT
,@dtHDR_idfDateCreated DATETIME
,@n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND INT
,@nidfRateHome NUMERIC(19,5)
,@dtidfRQDate DATETIME
,@xodtXchRateDate DATETIME
,@strvdfTaxScheduleID NVARCHAR(120)
,@nidfWCTaxScheduleHdrKey INT
,@nRQOVERRIDEWITHEXPECTEDDAYS	INT
,@nidfWCListHdrKeyShipTo	INT
,@nidfFlagVCOverride	INT
,@nSSRQREQVCOVERREASON INT
,@stridfVCOverrideNote VARCHAR(60)
,@strRQGLACCTONLYFORSALESINV VARCHAR(60)
,@nRQPOPRINTSHIPMETHTOGETHER INT
,@nSSRQALLOWDISCONFULFILL INT
,@strvdfTypeID char(20)
,@strvdfTaxTypeID NVARCHAR(64)
,@nidfEXPTypeKey INT
,@nidfAPTaxTypeDtlKey INT
,@nRQALLOWCHECKREQUEST INT
,@n__OVERLAY_NewGL INT
,@strOVERLAY_OverlayString VARCHAR(255)
,@strOVERLAY_GLString VARCHAR(255)
,@nSSRQCREATEITMSITEREL INT
,@strRemoveAprVal						VARCHAR(5)
,@nidfFlagRQEditFromApr INT
,@nidfWCSecurityKeyCurrent INT
,@nISCheckReqByLine	INT
,@n__WCSystem_idfModuleRegisteredIV	INT
,@n__WCSystem_idfModuleRegisteredMC	INT
,@stridfShipToAddr1				VARCHAR(40)		
,@stridfShipToAddr2				VARCHAR(40)		
,@stridfShipToAddr3				VARCHAR(40)		
,@stridfShipToAltPhone1			VARCHAR(40)		
,@stridfShipToAltPhone2			VARCHAR(40)		
,@stridfShipToAltPhoneExt1		VARCHAR(20)		
,@stridfShipToAltPhoneExt2		VARCHAR(20)		
,@stridfShipToCity				VARCHAR(40)		
,@stridfShipToContact			VARCHAR(255)	
,@stridfShipToCountry			VARCHAR(40)		
,@stridfShipToFax				VARCHAR(40)		
,@stridfShipToName				VARCHAR(255)	
,@stridfShipToState				VARCHAR(40)		
,@stridfShipToZipCode			VARCHAR(40)		
,@nidfRQHeaderKey				INT
,@nRCV1099BYHEADER				INT
,@nidfWCSecurityKeyDelegateKey	INT
,@nRQUSEDATEANDRATEFORPO		INT 
,@nForceGivenRate				INT

--
SET NOCOUNT OFF
--
SELECT	 @xochErrSP			= 'spRQFNAValidate'
		,@xonErrNum			= 0
		,@xostrErrInfo		= ''
		,@nFromTemplate		= 0

SELECT   @n__WCSystem_idfModuleRegisteredIV	= idfModuleRegisteredIV
		,@n__WCSystem_idfModuleRegisteredMC	= idfModuleRegisteredMC
FROM dbo.WCSystem WITH (NOLOCK)

SELECT @nRQALLOWCHECKREQUEST  = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQALLOWCHECKREQUEST'
SELECT @nRCV1099BYHEADER = idfValue FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RCV1099BYHEADER'
		
SELECT @nRQGLOVERLAYPRIMARY = 0
IF EXISTS (SELECT 1 FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQGLOVERLAYPRIMARY' AND idfValue = 1)
	SELECT @nRQGLOVERLAYPRIMARY = 1
		
SELECT @nRQOVERRIDESITEIDWITHSHIPTO = 0
IF EXISTS (SELECT 1 FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQOVERRIDESITEIDWITHSHIPTO' AND idfValue = 1)
	SELECT @nRQOVERRIDESITEIDWITHSHIPTO = 1

SELECT @nSSRQREQVCOVERREASON = 0
IF EXISTS (SELECT 1 FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQREQVCOVERREASON' AND idfValue = 1)
	SELECT @nSSRQREQVCOVERREASON = 1

SELECT @nSSRQALLOWDISCONFULFILL = 0
IF EXISTS (SELECT 1 FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQALLOWDISCONFULFILL' AND idfValue = 1)
	SELECT @nSSRQALLOWDISCONFULFILL = 1

SELECT @nSSRQCREATEITMSITEREL = 0
IF EXISTS (SELECT 1 FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQCREATEITMSITEREL' AND idfValue = 1)
	SELECT @nSSRQCREATEITMSITEREL = 1

SELECT @strRQGLACCTONLYFORSALESINV = idfValue FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQGLACCTONLYFORSALESINV'

SELECT @nRQPOPRINTSHIPMETHTOGETHER = idfValue FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQPOPRINTSHIPMETHTOGETHER'

SET @nidfWCSecurityKeyCurrent = dbo.fnWCSecurity('KEY')
EXEC @nidfFlagRQEditFromApr = spWCSecurityAccessGet @nidfWCSecurityKeyCurrent,'EDITFROMAPPROVAL',@xnHideOutput=1
IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQREMOVEAPRVALIDATION' AND idfValue = 1) AND @nidfFlagRQEditFromApr = 0
	SET @strRemoveAprVal = 'TRUE'
ELSE
	SET @strRemoveAprVal = 'FALSE'
	
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

	DELETE dbo.WCTEMPRQFNAValidate FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID

INSERT INTO dbo.WCTEMPRQFNAValidate
(idfOwnerSPID,idfOwnerCreated,idfOwnerProcess,idfRQDetailKey,idfBudgetApplyDate
,idfCommentInternal,idfCurrLineUpSeq,idfDatePromised,idfDateRequired,idfFlagBlanketPO
,idfFlagManualDist,idfLine,idfLogKey,idfQty,idfQtyPrec,idfSessionLinkKey,idfURLReference
,idfDateCreated,idfDateModified,idfBUDPeriodKey,idfRQHeaderKey,idfRQMemoKey,idfRQPriorityKey
,idfRQSessionKey,idfPTICompanyKey,idfVCHeaderKey,idfWCDeptKey,idfWCLineUpKey,idfWCRRGroupLineUpKey
,idfWCSecurityDelegateKey,edfAmtAprExtended,edfAmtExtended,edfAmtHomeExtended,edfPrice,edfPricePrec
,edfAnalysisGroup,edfBillTo,edfBuyer,edfCurrency,edfDropShip,edfDropShipCustomer
,edfENCBreakDown,edfENCProjectID,edfENCGrantID,edfENCUserDefined1,edfENCUserDefined2,edfENCUserDefined3
,edfENCUserDefined4,edfENCUserDefined5,edfENCUserDefined6,edfENCUserDefined7,edfGL,edfItem,edfItemDesc
,edfLocation,edfLocationFrom,edfPABudgetAuthCost,edfPABudgetAuthQty,edfPALineItemSeq
,edfPAProjectL1,edfPAProjectL2,edfPAProjectL3,edfPaymentTerm,edfPOLine,edfPONumber,edfShipMethod
,edfShipTo,edfTranType,edfUOM,edfVendor,edfVendorDocNum,edfVendorAddrID,edfVendorItem,edfWSProductIndicator
,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01
,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,udfNumericField03
,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08
,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04
,udfTextField05,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10
,vdfBudgetValid,vdfBudgetID,vdfComment,vdfDeptID,vdfContractID,vdfGL,idfRowKey,idfRowAction
,idfCodeRev,idfRQAprDtlRQHeaderKey,idfRQRevDtlRQHeaderKey,idfWCSecurityKey,vdfOldAmountHomeExtended
,vdfOldQty,vdfOldVCHeaderKey,vdfOldItem,vdfOldBUDPeriodKey,edfPriceHome,vdfExchangeRate,vdfRateDate
,vdfRateTime,vdfRateCal,vdfRateType,vdfRateTable,idfFlagVCOverride,edfManuItem
,edfFacilityID,edfFacilityIDFrom,edfDocumentID,vdfPriorityID
,idfRateHome,vdfTaxScheduleID,idfVCOverrideNote,idfGLSegmentHash
,idfAmtDiscount,idfAmtDiscountApr,idfAmtDiscountHome,idfAmtFreight,idfAmtFreightApr,idfAmtFreightHome,idfAmtMisc
,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,idfAmtTax,idfAmtTaxApr
,idfAmtTaxHome,idfDateRequiredOld,vdfOldGL,idfEXPTypeKey,vdfTypeID,vdfTaxTypeID,idfAPTaxTypeDtlKey
,idfShipToAddr1,idfShipToAddr2,idfShipToAddr3,idfShipToAltPhone1,idfShipToAltPhone2,idfShipToAltPhoneExt1,idfShipToAltPhoneExt2,idfShipToCity,idfShipToContact,idfShipToCountry,idfShipToFax,idfShipToName,idfShipToState,idfShipToZipCode
)
SELECT @@SPID,GETDATE(),'spRQFNAValidate',idfRQDetailKey,idfBudgetApplyDate
,idfCommentInternal,idfCurrLineUpSeq,idfDatePromised,idfDateRequired
,idfFlagBlanketPO,idfFlagManualDist,idfLine,idfLogKey,idfQty,idfQtyPrec,idfSessionLinkKey
,idfURLReference,idfDateCreated,idfDateModified,idfBUDPeriodKey,idfRQHeaderKey,idfRQMemoKey,idfRQPriorityKey
,idfRQSessionKey,idfPTICompanyKey,idfVCHeaderKey,idfWCDeptKey,idfWCLineUpKey,idfWCRRGroupLineUpKey
,idfWCSecurityDelegateKey,edfAmtAprExtended,edfAmtExtended,edfAmtHomeExtended,edfPrice,edfPricePrec
,edfAnalysisGroup,edfBillTo,edfBuyer,edfCurrency,edfDropShip,edfDropShipCustomer
,edfENCBreakDown,edfENCProjectID,edfENCGrantID,edfENCUserDefined1,edfENCUserDefined2,edfENCUserDefined3
,edfENCUserDefined4,edfENCUserDefined5,edfENCUserDefined6,edfENCUserDefined7,edfGL,edfItem,edfItemDesc
,edfLocation,edfLocationFrom,edfPABudgetAuthCost,edfPABudgetAuthQty,edfPALineItemSeq
,edfPAProjectL1,edfPAProjectL2,edfPAProjectL3,edfPaymentTerm,edfPOLine,edfPONumber,edfShipMethod
,edfShipTo,edfTranType,edfUOM,edfVendor,edfVendorDocNum,edfVendorAddrID,edfVendorItem,edfWSProductIndicator
,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01
,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,udfNumericField03
,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08
,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04
,udfTextField05,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10
,vdfBudgetValid,vdfBudgetID,vdfComment,vdfDeptID,vdfContractID,vdfGL,idfRowKey,idfRowAction
,idfCodeRev,idfRQAprDtlRQHeaderKey,idfRQRevDtlRQHeaderKey,idfWCSecurityKey,vdfOldAmountHomeExtended
,vdfOldQty,vdfOldVCHeaderKey,vdfOldItem,vdfOldBUDPeriodKey,edfPriceHome,vdfExchangeRate,vdfRateDate
,vdfRateTime,vdfRateCal,vdfRateType,vdfRateTable,idfFlagVCOverride,edfManuItem
,edfFacilityID,edfFacilityIDFrom,edfDocumentID,vdfPriorityID
,idfRateHome,vdfTaxScheduleID,idfVCOverrideNote,idfGLSegmentHash
,idfAmtDiscount,idfAmtDiscountApr,idfAmtDiscountHome,idfAmtFreight,idfAmtFreightApr,idfAmtFreightHome,idfAmtMisc
,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,idfAmtTax,idfAmtTaxApr
,idfAmtTaxHome,idfDateRequiredOld,vdfOldGL,idfEXPTypeKey,vdfTypeID,vdfTaxTypeID,idfAPTaxTypeDtlKey
,idfShipToAddr1,idfShipToAddr2,idfShipToAddr3,idfShipToAltPhone1,idfShipToAltPhone2,idfShipToAltPhoneExt1,idfShipToAltPhoneExt2,idfShipToCity,idfShipToContact,idfShipToCountry,idfShipToFax,idfShipToName,idfShipToState,idfShipToZipCode
FROM #spRQFNAValidate
OPTION (KEEP PLAN, KEEPFIXED PLAN)

IF @@ERROR <> 0
	RAISERROR ('spRQFNAValidate:100',1,1)

EXEC sp_executesql N'SELECT TOP 1 @nFromTemplate = 1 FROM tempdb.dbo.syscolumns WITH (NOLOCK) WHERE id = object_id(''tempdb..#spRQFNAValidate'') AND name = ''idfRQTemplateDtlKey'''
	,N'@nFromTemplate INT OUTPUT',@nFromTemplate OUTPUT
	
IF @@ERROR <> 0
	RAISERROR ('spRQFNAValidate:200',1,1)

SELECT @strWCSystem_edfCurrencyApproval = edfCurrencyApproval
	,@n__WCSystem_idfFlagIVUnitPriceOverride = idfFlagIVUnitPriceOverride FROM dbo.WCSystem WITH (NOLOCK)
	
SET @n__WCSystemSettings_IVOVERRIDEPRICE_4SVCITEM = 0
SELECT @n__WCSystemSettings_IVOVERRIDEPRICE_4SVCITEM = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'IVOVERRIDEPRICE_4SVCITEM'

SET @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 0
SELECT @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQDEFAULTVENDOR&PRICE'

SET @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = 0
SELECT @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQDEFAULTVENDOR&PRICEBYVEND'

SET @n__WCSystemSettings_RQFORCEDTRQINOPENPRD = 0
SELECT @n__WCSystemSettings_RQFORCEDTRQINOPENPRD = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQFORCEDTRQINOPENPRD'

SET @n__WCSystemSettings_RQIGNSEGOVERRIDE = 0
SELECT @n__WCSystemSettings_RQIGNSEGOVERRIDE = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQIGNSEGOVERRIDE'

SET @n__WCSystemSettings_RQVENDERRELATION = 0
SELECT @n__WCSystemSettings_RQVENDERRELATION = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQVENDERRELATION'

SET @n__WCSystemSettings_IVOVERRIDEPRICEWITHCURRENTCOST = 0
SELECT @n__WCSystemSettings_IVOVERRIDEPRICEWITHCURRENTCOST = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'IVOVERRIDEPRICEWITHCURRENTCOST'

SET @n__WCSystemSettings_IVOVERRIDEPRICEWITHSTDCOST = 0
SELECT @n__WCSystemSettings_IVOVERRIDEPRICEWITHSTDCOST = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'IVOVERRIDEPRICEWITHSTDCOST'

SET @n__WCSystemSettings_IVOVERRIDEITMDESCWITHDESC = 0
SELECT @n__WCSystemSettings_IVOVERRIDEITMDESCWITHDESC = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'IVOVERRIDEITMDESCWITHDESC'


	SELECT @nGRPAutoPODestination = 0

UPDATE dbo.WCTEMPRQFNAValidate SET edfItem = ITEMNMBR
FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate1)
	INNER JOIN dbo.IV00103 V WITH (NOLOCK) ON idfOwnerSPID = @@SPID  AND V.VENDORID = edfVendor AND VNDITNUM = edfVendorItem AND edfItem = ''
WHERE edfVendorItem > '' 

-- SELECT * FROM IV00103 WHERE VNDITNUM=''

-- CDB 9/10/04 - if vendor and item are specified then default try to default vendor item.
UPDATE dbo.WCTEMPRQFNAValidate 
SET edfVendorItem = VNDITNUM
FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate1)
	INNER JOIN dbo.IV00103 V WITH (NOLOCK) ON  idfOwnerSPID = @@SPID AND V.VENDORID = edfVendor AND edfVendorItem = '' AND ITEMNMBR = edfItem
WHERE edfItem > ''



IF (@n__WCSystemSettings_IVOVERRIDEPRICEWITHCURRENTCOST = 1)
	UPDATE dbo.WCTEMPRQFNAValidate 
	SET edfPrice = IV00101.CURRCOST
	FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID) 
	INNER JOIN dbo.IV00101 WITH (NOLOCK) ON WCTEMPRQFNAValidate.edfItem = IV00101.ITEMNMBR 
	WHERE idfOwnerSPID = @@SPID 

IF (@n__WCSystemSettings_IVOVERRIDEPRICEWITHSTDCOST = 1)
	UPDATE dbo.WCTEMPRQFNAValidate 
	SET edfPrice = IV00101.STNDCOST
	FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID) 
	INNER JOIN dbo.IV00101 WITH (NOLOCK) ON WCTEMPRQFNAValidate.edfItem = IV00101.ITEMNMBR 
	WHERE idfOwnerSPID = @@SPID 

IF (@n__WCSystemSettings_IVOVERRIDEITMDESCWITHDESC = 1)
	UPDATE dbo.WCTEMPRQFNAValidate 
	SET edfItemDesc = IV00101.ITEMDESC
	FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID) 
	INNER JOIN dbo.IV00101 WITH (NOLOCK) ON WCTEMPRQFNAValidate.edfItem = IV00101.ITEMNMBR 
	WHERE idfOwnerSPID = @@SPID 

-- CDB 9/22/04 - update item, vendor, and site id to be always uppercase.
UPDATE dbo.WCTEMPRQFNAValidate 
SET edfItem = UPPER(edfItem)
	,edfVendor = UPPER(edfVendor)
	,edfLocation = UPPER(edfLocation)
FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID) 
WHERE idfOwnerSPID = @@SPID 
 
IF (@nRQOVERRIDESITEIDWITHSHIPTO = 1)
	UPDATE dbo.WCTEMPRQFNAValidate SET edfLocation = CONVERT(CHAR(11),edfShipTo) 
	FROM dbo.WCTEMPRQFNAValidate W WITH (NOLOCK INDEX=idfOwnerSPID) 
	WHERE idfOwnerSPID = @@SPID 

--Update default values for edfShipMethod and edfPaymentTerm
--based on the vendor table PM00200 when edfShipMethod 
--and edfPaymentTerm are blank
UPDATE dbo.WCTEMPRQFNAValidate 
SET	 edfShipTo		= CASE WHEN edfShipTo	   = '' AND edfDropShip = 1 THEN ISNULL(RR.ADRSCODE,'') ELSE edfShipTo	    END 
	,edfPaymentTerm = CASE WHEN edfPaymentTerm = ''						THEN ISNULL(I.PYMTRMID,'')  ELSE edfPaymentTerm END
	,edfVendorAddrID = CASE WHEN edfVendorAddrID = '' THEN ISNULL(I.VADCDPAD,'')  ELSE edfVendorAddrID END
FROM dbo.PM00200 I WITH (NOLOCK)
	INNER JOIN dbo.WCTEMPRQFNAValidate  D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate0) ON idfOwnerSPID = @@SPID  AND D.edfVendor = I.VENDORID
	LEFT OUTER JOIN dbo.RM00101 R WITH (NOLOCK) ON D.edfDropShipCustomer = R.CUSTNMBR
	LEFT OUTER JOIN dbo.RM00102 RR WITH (NOLOCK) ON R.PRSTADCD = RR.ADRSCODE AND R.CUSTNMBR = RR.CUSTNMBR

DECLARE @memLowestPrice  TABLE
(
	 edfLPVendor CHAR(15)
	,edfLPItem   CHAR(31)
	,edfLPPrice  NUMERIC(19,5)
)
-- populate the @memLowestPrice with a cursor rather than insert into as performance is important as the IV00103 may have many records in it.
-- Loop through all unique items in temp table and insert into @memLowestPrice 
DECLARE curLowPrice INSENSITIVE CURSOR 
FOR SELECT edfItem 
FROM dbo.WCTEMPRQFNAValidate T WITH (NOLOCK INDEX=WCTEMPRQFNAValidate2) 
WHERE T.idfOwnerSPID = @@SPID
GROUP BY idfOwnerSPID, edfItem

OPEN curLowPrice


DECLARE 
 @strcurLowPrice_edfItem				CHAR(31) 
,@n__curLowPrice_Last_Originating_Cost	NUMERIC(19,5)
,@strcurLowPrice_edfLPVendor			CHAR(15)

FETCH curLowPrice INTO @strcurLowPrice_edfItem
	
WHILE @@fetch_status <> -1
BEGIN
	IF @@fetch_status <> -2
	BEGIN
		-- Find the items lowest price
		SELECT @n__curLowPrice_Last_Originating_Cost = MIN(Last_Originating_Cost)
		FROM dbo.IV00103 WITH (NOLOCK)
		WHERE ITEMNMBR = @strcurLowPrice_edfItem
		
		IF (@@ROWCOUNT > 0) BEGIN
			-- Find the first item in the table that has the lowest price and use.
			SELECT TOP 1 @strcurLowPrice_edfLPVendor = VENDORID 
			FROM dbo.IV00103 WITH (NOLOCK)
			WHERE ITEMNMBR = @strcurLowPrice_edfItem AND Last_Originating_Cost = @n__curLowPrice_Last_Originating_Cost
					
			INSERT INTO @memLowestPrice
			(edfLPVendor,edfLPItem,edfLPPrice )
			VALUES (@strcurLowPrice_edfLPVendor,@strcurLowPrice_edfItem,@n__curLowPrice_Last_Originating_Cost)
		END
	END --@@fetch_status <> -2
FETCH curLowPrice INTO @strcurLowPrice_edfItem
END --@@fetch_status <> -1
CLOSE curLowPrice
DEALLOCATE curLowPrice 

UPDATE dbo.WCTEMPRQFNAValidate SET
 edfItem 		= CASE WHEN edfItem = '' 	THEN ISNULL(I.ITEMNMBR,'')	ELSE edfItem END
,edfItemDesc 	= CASE WHEN edfItemDesc = '' 	THEN ISNULL(ITEMDESC,'') 	ELSE edfItemDesc END
,edfLocation 	= CASE WHEN edfLocation = '' 	THEN ISNULL(I.LOCNCODE,'')	ELSE edfLocation END

,edfVendor 		= CASE WHEN edfVendor = '' AND ISNULL(edfPrice,0) = 0 THEN 
							CASE WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 1 THEN ISNULL(V.VENDORID,'') 
								 WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = 1 THEN ISNULL(SSQ.PRIMVNDR,'') 
								 ELSE edfVendor END
					   ELSE edfVendor END

,edfVendorItem	= CASE WHEN edfVendorItem = '' AND @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 1 THEN 
							CASE WHEN ISNULL(edfPrice,0) = 0  THEN ISNULL(V.VNDITNUM,'') 
								 WHEN ISNULL(edfPrice,0) <> 0 THEN '' END
					   WHEN edfVendorItem = '' AND @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = 1 THEN 
							CASE WHEN ISNULL(edfPrice,0) = 0  THEN ISNULL(SSV.VNDITNUM,'') 
								 WHEN ISNULL(edfPrice,0) <> 0 THEN '' END
					   WHEN edfVendorItem = '' AND @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 0 AND @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = 0 THEN ISNULL(V.VNDITNUM,'') 
					   ELSE edfVendorItem END
,edfPaymentTerm	= CASE WHEN edfPaymentTerm = '' AND edfVendor = '' AND @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 1 AND ISNULL(edfPrice,0) = 0  THEN ISNULL(VEND.PYMTRMID,'') 
					   WHEN edfPaymentTerm = '' AND edfVendor = '' AND @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = 1 AND ISNULL(edfPrice,0) = 0  THEN ISNULL(SSVEND.PYMTRMID,'') 
					   ELSE edfPaymentTerm END

,edfUOM 		= CASE WHEN edfUOM = ''		THEN ISNULL(U.UOFM,'')	 	ELSE edfUOM END

,edfPrice 		= CASE	WHEN S.idfFlagRQDefaultPriceFromItem = 1 AND ISNULL(edfPrice,0) = 0 
								THEN ISNULL(V.Last_Originating_Cost,CURRCOST) * ISNULL(QTYBSUOM,1)
						WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 1 AND ISNULL(edfPrice,0) = 0 
								THEN CASE WHEN	ISNULL(edfVendor,'') = ''		
										THEN ISNULL(V.Last_Originating_Cost,CURRCOST) * ISNULL(QTYBSUOM,1) 
										WHEN ISNULL(edfVendor,'') <>''		
										THEN ISNULL(CURRCOST,0) * ISNULL(QTYBSUOM,1)  END
						WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = 1 AND ISNULL(edfPrice,0) = 0 
								THEN ISNULL(SSV.Last_Originating_Cost,CURRCOST) * ISNULL(QTYBSUOM,1)
						ELSE ISNULL(edfPrice,0)  END

,edfCurrency    = CASE WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 1 AND ISNULL(V.Last_Currency_ID,'') <> '' AND ISNULL(edfPrice,0) = 0 THEN V.Last_Currency_ID ELSE edfCurrency END					   
FROM dbo.IV00101 I WITH (NOLOCK) 
	INNER JOIN dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate2) ON idfOwnerSPID = @@SPID AND D.edfItem = I.ITEMNMBR 
	CROSS JOIN dbo.WCSystem S WITH (NOLOCK)
	LEFT OUTER JOIN @memLowestPrice M ON D.edfItem = M.edfLPItem
	LEFT OUTER JOIN dbo.IV00102 SSQ WITH (NOLOCK)		ON D.edfItem = SSQ.ITEMNMBR AND SSQ.LOCNCODE = D.edfLocation
	LEFT OUTER JOIN dbo.IV00103 SSV WITH (NOLOCK)		ON SSV.ITEMNMBR = D.edfItem AND SSV.VENDORID = SSQ.PRIMVNDR
	LEFT OUTER JOIN dbo.IV00102 Q WITH (NOLOCK)			ON I.ITEMNMBR = Q.ITEMNMBR AND Q.LOCNCODE <> '' AND ((Q.LOCNCODE = I.LOCNCODE AND '' = '') OR Q.LOCNCODE='')
	LEFT OUTER JOIN dbo.IV00103 V WITH (NOLOCK)			ON V.ITEMNMBR = CASE WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 1 THEN M.edfLPItem ELSE Q.ITEMNMBR END AND 
														   V.VENDORID = CASE WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICE = 1 AND edfVendor = '' THEN M.edfLPVendor ELSE edfVendor END
	LEFT OUTER JOIN dbo.GL00105 G WITH (NOLOCK)			ON I.IVIVINDX = G.ACTINDX 
	LEFT OUTER JOIN dbo.IV00106 U WITH (NOLOCK)			ON U.ITEMNMBR = I.ITEMNMBR 
															AND U.UOFM = CASE WHEN edfUOM <> '' THEN edfUOM 
																			  WHEN @n__WCSystemSettings_RQDEFAULTVENDOR_PRICEBYVEND = 1 AND ISNULL(SSV.PRCHSUOM,'') <> '' THEN SSV.PRCHSUOM
																			  WHEN ISNULL(V.PRCHSUOM,'') ='' THEN 
																					CASE WHEN S.idfFlagRQUOMFromSales = 0 OR I.ITEMTYPE <> 1 OR I.SELNGUOM = '' THEN I.PRCHSUOM 
																						 ELSE I.SELNGUOM END 
																			  ELSE V.PRCHSUOM END 
	LEFT OUTER JOIN dbo.PM00200 VEND WITH (NOLOCK)		ON VEND.VENDORID = V.VENDORID
	LEFT OUTER JOIN dbo.PM00200 SSVEND WITH (NOLOCK)	ON SSVEND.VENDORID = SSV.VENDORID

-- SCC - Update Tax and Ship Method after Vendor and Vendor Address Default
UPDATE dbo.WCTEMPRQFNAValidate 
SET  idfWCTaxScheduleHdrKey = WCTaxScheduleHdr.idfWCTaxScheduleHdrKey
	,edfShipMethod  = CASE WHEN edfShipMethod  = '' AND edfDropShip = 0 THEN ISNULL(ADDR.SHIPMTHD,ISNULL(VEND.SHIPMTHD,''))
						   WHEN edfShipMethod  = '' AND edfDropShip = 1 THEN ISNULL(RR.SHIPMTHD,'') ELSE edfShipMethod  END
	,idfEXPTypeKey = ET.idfEXPTypeKey
	,idfAPTaxTypeDtlKey = APTaxTypeDtl.idfAPTaxTypeDtlKey
FROM dbo.WCTEMPRQFNAValidate TMP WITH (NOLOCK INDEX=idfOwnerSPID)
	LEFT OUTER JOIN dbo.PM00200 VEND WITH (NOLOCK) ON VEND.VENDORID = TMP.edfVendor
	LEFT OUTER JOIN dbo.PM00300 ADDR WITH (NOLOCK) ON ADDR.VENDORID = TMP.edfVendor AND ADDR.ADRSCODE = edfVendorAddrID
	LEFT OUTER JOIN dbo.RM00101 R WITH (NOLOCK) ON TMP.edfDropShipCustomer = R.CUSTNMBR
	LEFT OUTER JOIN dbo.RM00102 RR WITH (NOLOCK) ON R.PRSTADCD = RR.ADRSCODE AND R.CUSTNMBR = RR.CUSTNMBR
	LEFT OUTER JOIN WCTaxScheduleHdr WITH (NOLOCK) ON    (WCTaxScheduleHdr.idfTaxScheduleID = TMP.vdfTaxScheduleID AND TMP.vdfTaxScheduleID > '') 
													  OR (VEND.TAXSCHID = WCTaxScheduleHdr.idfTaxScheduleID AND TMP.edfVendorAddrID = '' AND TMP.vdfTaxScheduleID = '')
													  OR (ADDR.TAXSCHID = WCTaxScheduleHdr.idfTaxScheduleID AND TMP.edfVendorAddrID > '' AND TMP.vdfTaxScheduleID = '')
	LEFT OUTER JOIN dbo.EXPType ET WITH (NOLOCK) ON TMP.vdfTypeID = ET.idfTypeID AND ET.idfFlagActive = 1
	LEFT OUTER JOIN dbo.APTaxTypeDtl WITH (NOLOCK) ON TMP.vdfTaxTypeID = APTaxTypeDtl.idfDescription
WHERE TMP.idfOwnerSPID = @@SPID

-- ------------------------------------------------------------------------------------------------------------------------
-- Replace GL Account with Segment
-- ------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------	



SELECT @nidfFlagGLAccountOverride = idfFlagGLAccountOverride FROM dbo.WCSystem WITH (NOLOCK)
-- Check to see if item is on a vendor contract - if yes then override everything.
IF @xstrSource <> 'VENDORCONTRACT' 
BEGIN
	DECLARE @VenAddr TABLE
	(
		idfRowKey		INT,
		edfVendorAddrID VARCHAR(15),
		edfVendor		nvarchar(30)
	)
	IF (EXISTS(SELECT TOP 1 1 FROM dbo.WCSystem WITH (NOLOCK) WHERE idfFlagVendorContractDefault = 1))
	BEGIN
			SELECT @nRQVCUNIQUEBYITM_MI_UOM = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQVCUNIQUEBYITM_MI_UOM'	 	
			
			CREATE TABLE #LowestPrice(idfVCDetailKey INT,edfPrice NUMERIC(19,5),edfItem VARCHAR(31),edfUOM VARCHAR(9),edfManuItem VARCHAR(30),idfRowKey INT)
			CREATE TABLE #LowestAvail(idfVCDetailKey INT,edfPrice NUMERIC(19,5),edfItem VARCHAR(31),edfUOM VARCHAR(9),edfManuItem VARCHAR(30),idfFlagPrimary INT,idfRowKey INT)

			SELECT @strJOIN = '',@strSelectINS = '',@strSelect = ''
		
			IF (@nRQVCUNIQUEBYITM_MI_UOM = 1)
			BEGIN
				SELECT   @strJOIN = 'AND (R.edfUOM = V.edfUOM OR R.edfUOM = '''') AND (R.edfManuItem = V.edfManuItem OR R.edfManuItem = '''')'
						,@strSelectINS = ',edfUOM,edfManuItem'
						,@strSelect = ',V.edfUOM,V.edfManuItem'
			END

			-- FIND ALL Vendor Contracts Restricted by UDFT and System Settings
			SELECT @strSQLInsert = N'
			INSERT INTO #LowestAvail(idfVCDetailKey,edfPrice,edfItem'+@strSelectINS+',idfFlagPrimary,idfRowKey)
			SELECT idfVCDetailKey,V.edfPrice,V.edfItem'+@strSelect+',H.idfFlagPrimary,R.idfRowKey
			FROM dbo.WCTEMPRQFNAValidate R WITH (NOLOCK INDEX=WCTEMPRQFNAValidate3)
			INNER JOIN dbo.VCDetail V WITH (NOLOCK) ON R.edfItem = V.edfItem '+@strJOIN+'
			INNER JOIN dbo.VCHeader H WITH (NOLOCK) ON V.idfVCHeaderKey=H.idfVCHeaderKey
			LEFT OUTER JOIN dbo.WCSecurity		 WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey	 = R.idfWCSecurityKey
			LEFT OUTER JOIN dbo.WCUDFTemplateDtl WITH (NOLOCK) ON WCSecurity.idfWCUDFTemplateKey = WCUDFTemplateDtl.idfWCUDFTemplateHdrKey AND idfWCUDFTemplateFieldKey = 22
			LEFT OUTER JOIN dbo.WCListDtl		 WITH (NOLOCK) ON WCListDtl.idfWCListHdrKey		 = WCUDFTemplateDtl.idfRestrictByValue 
			LEFT OUTER JOIN dbo.WCListDtl ST WITH (NOLOCK) ON ST.idfWCListHdrKey = H.idfWCListHdrKeyShipTo
			WHERE R.idfOwnerSPID = @@SPID AND (R.idfDateRequired BETWEEN H.idfPeriodBegin AND H.idfPeriodEnd) AND H.idfFlagActive = 1
				AND (ISNULL(R.edfShipTo,'''') = '''' OR ST.idfWCListDtlKey IS NULL OR ST.idfCodeID = R.edfShipTo)
				AND ((WCUDFTemplateDtl.idfWCUDFTemplateDtlKey IS NULL) 
				OR (WCUDFTemplateDtl.idfRestrictByValueType = ''K'' AND H.idfVCHeaderKey = WCUDFTemplateDtl.idfRestrictByValue) 
				OR (WCUDFTemplateDtl.idfRestrictByValueType = ''L'' AND H.idfVCHeaderKey = WCListDtl.idfCodeKey))
				AND (R.idfFlagVCOverride <> 1 OR (NOT EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = ''RQVCOVER'' AND idfValue = 1)))'
			
			EXEC sp_executesql @strSQLInsert

			-- ONLY Remove Non-Primary Recs if a primary exists and system setting is on
			SELECT @nRQENABLEPRIMARYVENDCONT = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQENABLEPRIMARYVENDCONT'	 	
			IF (@nRQENABLEPRIMARYVENDCONT = 1)
				IF EXISTS (SELECT TOP 1 1 FROM #LowestAvail WHERE idfFlagPrimary = 1)
					DELETE FROM #LowestAvail WHERE idfFlagPrimary = 0
	
			--Determine Lowest Price FROM allowed contracts
			SELECT @strSQLInsert = N'
			INSERT INTO #LowestPrice(idfRowKey,edfPrice,edfItem'+@strSelectINS+')
			SELECT idfRowKey,MIN(V.edfPrice),V.edfItem'+@strSelect+'
			FROM #LowestAvail V GROUP BY idfRowKey,V.edfItem'+@strSelect+''
			
			EXEC sp_executesql @strSQLInsert

			--ADD VCDetailKey to table for joining purposes.
			SELECT @strSQLInsert = N'
			UPDATE #LowestPrice SET idfVCDetailKey = R.idfVCDetailKey
			FROM #LowestPrice V
			INNER JOIN #LowestAvail R ON R.idfRowKey = V.idfRowKey AND V.edfPrice = R.edfPrice AND V.edfItem = R.edfItem '+@strJOIN+''  
			
			EXEC sp_executesql @strSQLInsert
			
			INSERT INTO @VenAddr SELECT idfRowKey,edfVendorAddrID,edfVendor FROM dbo.WCTEMPRQFNAValidate W WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID

			UPDATE dbo.WCTEMPRQFNAValidate 
			SET	 idfVCHeaderKey = D.idfVCHeaderKey 
				,edfVendor 		= H.edfVendor
				,edfItem 		= D.edfItem
				,edfManuItem	= D.edfManuItem
				,edfVendorItem	= D.edfVendorItem
				,edfUOM 		= D.edfUOM
				,edfShipMethod	= H.edfShippingMethod
				,edfPaymentTerm	= H.edfPaymentTerms
				,edfPrice 		= D.edfPrice
				,edfVendorAddrID = CASE WHEN H.edfVendor <> W.edfVendor THEN vwFNAVendor.edfVendorAddrID ELSE W.edfVendorAddrID END
			FROM dbo.WCTEMPRQFNAValidate W WITH (NOLOCK INDEX=WCTEMPRQFNAValidate3)
				INNER JOIN dbo.VCDetail D WITH (NOLOCK) ON W.edfItem = D.edfItem AND D.edfItem <> ''
				INNER JOIN dbo.VCHeader H WITH (NOLOCK) ON D.idfVCHeaderKey=H.idfVCHeaderKey
				INNER JOIN dbo.vwFNAVendor WITH (NOLOCK) ON vwFNAVendor.edfVendor = H.edfVendor
				INNER JOIN #LowestPrice L ON  L.idfVCDetailKey = D.idfVCDetailKey AND W.idfRowKey = L.idfRowKey
			WHERE W.idfOwnerSPID = @@SPID AND W.idfFlagVCOverride = 0
			
			UPDATE dbo.WCTEMPRQFNAValidate 
			SET idfWCTaxScheduleHdrKey = CASE WHEN (TMP.edfVendor <> V.edfVendor OR V.edfVendorAddrID <> TMP.edfVendorAddrID) THEN T.idfWCTaxScheduleHdrKey ELSE TMP.idfWCTaxScheduleHdrKey END
			FROM dbo.WCTEMPRQFNAValidate TMP WITH (NOLOCK INDEX=idfOwnerSPID)
				INNER JOIN @VenAddr V ON V.idfRowKey = TMP.idfRowKey
				INNER JOIN dbo.PM00200  VEND WITH (NOLOCK) ON VEND.VENDORID = TMP.edfVendor
				INNER JOIN dbo.PM00300  ADDR WITH (NOLOCK) ON ADDR.VENDORID = TMP.edfVendor AND ADDR.ADRSCODE = TMP.edfVendorAddrID
				INNER JOIN dbo.WCTaxScheduleHdr T WITH (NOLOCK) ON ADDR.TAXSCHID = T.idfTaxScheduleID AND TMP.edfVendorAddrID > ''
			WHERE TMP.idfOwnerSPID = @@SPID

			DELETE @VenAddr

			DROP TABLE #LowestAvail
			DROP TABLE #LowestPrice
		END
			
	DELETE dbo.WCTEMPVCDefault FROM dbo.WCTEMPVCDefault WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID
	INSERT INTO dbo.WCTEMPVCDefault 
	(
		 idfOwnerSPID    
		,idfOwnerCreated 
		,idfOwnerProcess 
		,idfPTICompanyKey
		,idfRowKey       
		,idfVCHeaderKey  
		,edfItem
		,edfManuItem
		,edfPaymentTerm  
		,edfPrice        
		,edfShipMethod 
		,edfUOM          
		,edfVendor       
		,edfVendorItem   
	)
	SELECT 
		 @@SPID
		,GETDATE()
		,'spRQFNAValidate'
		,idfPTICompanyKey	
		,idfRowKey			
		,idfVCHeaderKey 
		,edfItem
		,edfManuItem
		,edfPaymentTerm
		,edfPrice
		,edfShipMethod
		,edfUOM            
		,edfVendor         
		,edfVendorItem     
	FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate3)
	WHERE idfOwnerSPID = @@SPID AND ISNULL(idfVCHeaderKey,0) <> 0
	
	EXEC dbo.spVCDefault @xochErrSP OUTPUT, @xonErrNum OUTPUT, @xostrErrInfo OUTPUT

	INSERT INTO @VenAddr SELECT idfRowKey,edfVendorAddrID,edfVendor FROM dbo.WCTEMPRQFNAValidate W WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID
	
	UPDATE dbo.WCTEMPRQFNAValidate 
		SET edfVendor		= WCTEMPVCDefault.edfVendor, 
			edfItem			= WCTEMPVCDefault.edfItem, 
			edfManuItem		= WCTEMPVCDefault.edfManuItem,
			edfVendorItem	= WCTEMPVCDefault.edfVendorItem, 
			edfUOM			= WCTEMPVCDefault.edfUOM, 
			edfShipMethod	= WCTEMPVCDefault.edfShipMethod, 
			edfPaymentTerm	= WCTEMPVCDefault.edfPaymentTerm, 
			edfPrice		= WCTEMPVCDefault.edfPrice,
			edfVendorAddrID = CASE WHEN WCTEMPVCDefault.edfVendor <> W.edfVendor THEN vwFNAVendor.edfVendorAddrID ELSE W.edfVendorAddrID END
	FROM dbo.WCTEMPVCDefault WITH (NOLOCK INDEX=WCTEMPVCDefault1)
		INNER JOIN dbo.WCTEMPRQFNAValidate W WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) ON  W.idfOwnerSPID=@@SPID  AND WCTEMPVCDefault.idfRowKey = W.idfRowKey
		INNER JOIN dbo.vwFNAVendor WITH (NOLOCK) ON vwFNAVendor.edfVendor = WCTEMPVCDefault.edfVendor
	WHERE WCTEMPVCDefault.idfOwnerSPID=@@SPID 
	
	UPDATE dbo.WCTEMPRQFNAValidate 
			SET idfWCTaxScheduleHdrKey = CASE WHEN (TMP.edfVendor <> V.edfVendor OR V.edfVendorAddrID <> TMP.edfVendorAddrID) THEN T.idfWCTaxScheduleHdrKey ELSE TMP.idfWCTaxScheduleHdrKey END
			FROM dbo.WCTEMPRQFNAValidate TMP WITH (NOLOCK INDEX=idfOwnerSPID)
				INNER JOIN @VenAddr V ON V.idfRowKey = TMP.idfRowKey
				INNER JOIN dbo.PM00200  VEND WITH (NOLOCK) ON VEND.VENDORID = TMP.edfVendor
				INNER JOIN dbo.PM00300  ADDR WITH (NOLOCK) ON ADDR.VENDORID = TMP.edfVendor AND ADDR.ADRSCODE = TMP.edfVendorAddrID
				INNER JOIN dbo.WCTaxScheduleHdr T WITH (NOLOCK) ON ADDR.TAXSCHID = T.idfTaxScheduleID AND TMP.edfVendorAddrID > ''
	WHERE TMP.idfOwnerSPID = @@SPID

	DELETE @VenAddr
	DELETE dbo.WCTEMPVCDefault FROM dbo.WCTEMPVCDefault WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID
END -- IF @xstrSource <> 'VENDORCONTRACT'

		DECLARE @RQTypeVal TABLE
		(
			 idfRowKey		INT IDENTITY(0,1)
			,idfPTIDataFld	VARCHAR(60)
			,idfResourceID	VARCHAR(60)
			,idfRQTypeKey	INT
		)
		
		INSERT INTO @RQTypeVal
		(
			 idfPTIDataFld
			,idfResourceID	
			,idfRQTypeKey
		)
		SELECT 
			 idfPTIDataFld
			,'::'+idfResourceID+'::'
			,idfRQTypeKey
		FROM dbo.RQTypeLayout WITH (NOLOCK) 
		INNER JOIN dbo.WCFormDtl WITH (NOLOCK) ON WCFormDtl.idfWCFormDtlKey = RQTypeLayout.idfWCFormDtlKey AND idfWCFormHdrKey = 1 AND idfFlagRequired = 1
		WHERE @xstrSource = 'ENTRY'
		
		INSERT INTO @RQTypeVal
		(
			 idfPTIDataFld
			,idfResourceID	
			,idfRQTypeKey
		)
		SELECT 
			 idfPTIDataFld
			,'::'+idfResourceID+'::'
			,idfRQTypeKey
		FROM dbo.RQTypeLayout WITH (NOLOCK) 
		INNER JOIN dbo.WCFormDtl WITH (NOLOCK) ON WCFormDtl.idfWCFormDtlKey = RQTypeLayout.idfWCFormDtlKey AND idfWCFormHdrKey = 18 AND idfFlagRequired = 1
		WHERE @xstrSource = 'APPROVAL'
		
		INSERT INTO @RQTypeVal
		(
			 idfPTIDataFld
			,idfResourceID	
			,idfRQTypeKey
		)
		SELECT 
			 idfPTIDataFld
			,'::'+idfResourceID+'::'
			,idfRQTypeKey
		FROM dbo.RQTypeLayout WITH (NOLOCK) 
		INNER JOIN dbo.WCFormDtl WITH (NOLOCK) ON WCFormDtl.idfWCFormDtlKey = RQTypeLayout.idfWCFormDtlKey AND idfWCFormHdrKey = 19 AND idfFlagRequired = 1
		WHERE @xstrSource = 'REVIEW'
		
		DECLARE 
		 @stridfPTIDataFld  VARCHAR(60)
		,@stridfResourceID  VARCHAR(60)
		,@nidfRQTypeKey		INT
		,@strSQL			NVARCHAR(4000)
	
		DECLARE curspRQTypeValidate INSENSITIVE CURSOR 
		FOR SELECT idfPTIDataFld,idfResourceID,idfRQTypeKey	FROM @RQTypeVal 

		OPEN curspRQTypeValidate

		FETCH curspRQTypeValidate INTO @stridfPTIDataFld,@stridfResourceID,@nidfRQTypeKey
			
		WHILE @@fetch_status <> -1
		BEGIN
			IF @@fetch_status <> -2
			BEGIN
				IF (@stridfPTIDataFld > '')
					SELECT @strSQL = N'INSERT INTO #spWCValDtl(idfRowKey, idfErrNum, idfRowAction,idfOBJName,idfParam01)
						SELECT idfRowKey, -432, ''IN'',''spRQFNAValidate'','''+@stridfResourceID+N'''
						FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID)
						INNER JOIN dbo.RQHeader WITH (NOLOCK) ON WCTEMPRQFNAValidate.idfRQHeaderKey = RQHeader.idfRQHeaderKey
						WHERE idfOwnerSPID = @@SPID 
							AND RQHeader.idfRQTypeKey = '+ CONVERT(VARCHAR(3),@nidfRQTypeKey) + N' 
							AND WCTEMPRQFNAValidate.' + @stridfPTIDataFld + N'= '''''
					   
				EXEC sp_executesql @strSQL		 
			END --@@fetch_status <> -2
		FETCH curspRQTypeValidate INTO @stridfPTIDataFld,@stridfResourceID,@nidfRQTypeKey
		END --@@fetch_status <> -1
		CLOSE curspRQTypeValidate
		DEALLOCATE curspRQTypeValidate 
		
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT	

 --Validate all rows
DECLARE curspRQFNAValidate INSENSITIVE CURSOR 
FOR SELECT
	 W.idfPTICompanyKey
	,W.edfBuyer
	,W.idfQty
	,W.edfCurrency
	,W.edfPrice
	,W.edfPriceHome
	,W.edfAmtHomeExtended
	,W.vdfExchangeRate
	,W.vdfRateDate
	,W.vdfRateTime
	,W.vdfRateCal
	,W.vdfRateType
	,W.vdfRateTable
	,W.edfAnalysisGroup
	,W.edfBillTo
   	,W.edfDropShip
	,W.edfDropShipCustomer
	,W.edfENCBreakDown
	,W.edfENCGrantID		
	,W.edfENCProjectID		
	,W.edfENCUserDefined1
	,W.edfENCUserDefined2
	,W.edfENCUserDefined3
	,W.edfENCUserDefined4
	,W.edfENCUserDefined5
	,W.edfENCUserDefined6
	,W.edfENCUserDefined7
	,W.edfShipMethod
	,W.edfPaymentTerm
	,W.edfGL
	,W.edfItem
	,W.edfItemDesc
	,W.edfLocationFrom
	,W.edfLocation
	,W.edfPAProjectL1
	,W.edfPAProjectL2
	,W.edfPALineItemSeq
	,W.edfPAProjectL3
	,W.edfPOLine
	,W.edfPONumber
	,W.edfShipTo
	,W.edfTranType
	,W.edfWSProductIndicator
	,W.edfUOM
	,W.edfVendor
	,UPPER(W.edfVendorDocNum)
	,W.edfVendorAddrID
	,W.edfVendorItem
	,W.idfWCDeptKey
	,W.idfRowKey
	,W.idfFlagBlanketPO
	,W.idfDateRequired
	,W.idfVCHeaderKey
	,W.idfRQDetailKey
	,RQHeader.idfRQTypeKey
	,W.edfManuItem
	,W.edfFacilityID
	,W.edfFacilityIDFrom
	,W.edfDocumentID
	,W.vdfProjectID
	,W.vdfPhaseID
	,W.vdfActivityID
	,W.idfPAProjectKey			
	,W.idfPAProjectPhaseKey 	
	,W.idfPAPhaseActivityKey	
	,W.vdfPriorityID
	,W.idfRQPriorityKey
	,RQHeader.idfDateCreated
	,W.idfRateHome
	,RQHeader.idfRQDate
	,W.vdfTaxScheduleID
	,W.idfWCTaxScheduleHdrKey
	,W.idfFlagVCOverride
	,W.idfVCOverrideNote
	,W.vdfTypeID
	,W.vdfTaxTypeID
	,W.idfEXPTypeKey
	,W.idfAPTaxTypeDtlKey
	,W.idfShipToAddr1				
	,W.idfShipToAddr2				
	,W.idfShipToAddr3				
	,W.idfShipToAltPhone1			
	,W.idfShipToAltPhone2			
	,W.idfShipToAltPhoneExt1		
	,W.idfShipToAltPhoneExt2		
	,W.idfShipToCity				
	,W.idfShipToContact			
	,W.idfShipToCountry			
	,W.idfShipToFax				
	,W.idfShipToName				
	,W.idfShipToState				
	,W.idfShipToZipCode
	,W.idfRQHeaderKey
FROM dbo.WCTEMPRQFNAValidate W WITH (NOLOCK INDEX=idfOwnerSPID) 
LEFT OUTER JOIN dbo.RQHeader WITH (NOLOCK) ON W.idfRQHeaderKey = RQHeader.idfRQHeaderKey
WHERE idfOwnerSPID = @@SPID 

OPEN curspRQFNAValidate

FETCH curspRQFNAValidate INTO
	 @nHDR_idfPTICompanyKey
	,@strHDR_edfBuyer
	,@nidfQty
	,@strHDR_edfCurrency
	,@nedfPrice
	,@nedfPriceHome
	,@nedfAmtHomeExtended
	,@nvdfExchangeRate
	,@strvdfRateDate
	,@strvdfRateTime
	,@nvdfRateCal
	,@strvdfRateType
	,@strvdfRateTable
	,@strHDR_edfAnalysisGroup
	,@strHDR_edfBillTo
   	,@strHDR_edfDropShip
	,@strHDR_edfDropShipCustomer
	,@chedfENCBreakDown
	,@chedfENCGrantID		
	,@chedfENCProjectID		
	,@chedfENCUserDefined1
	,@chedfENCUserDefined2
	,@chedfENCUserDefined3
	,@chedfENCUserDefined4
	,@chedfENCUserDefined5
	,@chedfENCUserDefined6
	,@chedfENCUserDefined7
	,@strHDR_edfShipMethod
	,@strHDR_edfPaymentTerm
	,@nHDR_edfGL
	,@strHDR_edfItem
	,@strHDR_edfItemDesc
	,@strHDR_edfLocationFrom
	,@strHDR_edfLocation
	,@strHDR_edfPAProjectL1
	,@strHDR_edfPAProjectL2
	,@nedfPALineItemSeq
	,@strHDR_edfPAProjectL3
	,@nHDR_edfPOLine
	,@strHDR_edfPONumber
	,@strHDR_edfShipTo
	,@strHDR_edfTranType
	,@nedfWSProductIndicator
	,@strHDR_edfUOM
	,@strHDR_edfVendor
	,@chedfVendorDocNum
	,@chedfVendorAddrID
	,@strHDR_edfVendorItem
	,@nidfWCDeptKey
	,@nHDR_idfRowKey
	,@n__HDR_idfFlagBlanketPO
	,@dtidfDateRequired
	,@nHDR_idfVCHeaderKey
	,@nidfRQDetailKey
	,@nRQType
	,@stredfManuItem
	,@stredfFacilityID
	,@stredfFacilityIDFrom
	,@stredfDocumentID
	,@strvdfProjectID
	,@strvdfPhaseID
	,@strvdfActivityID
	,@nidfPAProjectKey			
	,@nidfPAProjectPhaseKey 	
	,@nidfPAPhaseActivityKey	
	,@strvdfPriorityID
	,@nidfRQPriorityKey
	,@dtHDR_idfDateCreated
	,@nidfRateHome
	,@dtidfRQDate
	,@strvdfTaxScheduleID
	,@nidfWCTaxScheduleHdrKey
	,@nidfFlagVCOverride
	,@stridfVCOverrideNote
	,@strvdfTypeID
	,@strvdfTaxTypeID
	,@nidfEXPTypeKey
	,@nidfAPTaxTypeDtlKey
	,@stridfShipToAddr1				
	,@stridfShipToAddr2				
	,@stridfShipToAddr3				
	,@stridfShipToAltPhone1			
	,@stridfShipToAltPhone2			
	,@stridfShipToAltPhoneExt1		
	,@stridfShipToAltPhoneExt2		
	,@stridfShipToCity				
	,@stridfShipToContact			
	,@stridfShipToCountry			
	,@stridfShipToFax				
	,@stridfShipToName				
	,@stridfShipToState				
	,@stridfShipToZipCode	
	,@nidfRQHeaderKey		
WHILE @@fetch_status <> -1
BEGIN
	IF @@fetch_status <> -2
	BEGIN
	IF @xstrSource = 'ENTRY' 
		SELECT @nISCheckReqByLine = CASE WHEN H.idfAPVendorKey IS NULL THEN 1 ELSE 0 END
		FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) 
		INNER JOIN dbo.RQHeader H WITH (NOLOCK) ON H.idfRQHeaderKey = D.idfRQHeaderKey
		WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey

	IF @xstrSource = 'APPROVAL'
		SELECT @nISCheckReqByLine = CASE WHEN H.idfAPVendorKey IS NULL THEN 1 ELSE 0 END
		FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
		INNER JOIN dbo.RQAprDtlRQHeader H WITH (NOLOCK) ON H.idfRQAprDtlRQHeaderKey = D.idfRQAprDtlRQHeaderKey
		WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
	
	IF @xstrSource IN ('REVIEW','POGEN')
		SELECT @nISCheckReqByLine = CASE WHEN H.idfAPVendorKey IS NULL THEN 1 ELSE 0 END
		FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
		INNER JOIN dbo.RQRevDtlRQHeader H WITH (NOLOCK) ON H.idfRQRevDtlRQHeaderKey = D.idfRQRevDtlRQHeaderKey
		WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey

	IF ((@nidfFlagVCOverride = 1) AND (@nSSRQREQVCOVERREASON = 1) AND (@stridfVCOverrideNote = ''))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -465, 'spRQFNAValidate'

	SELECT @nidfWCListHdrKeyShipTo = ISNULL(idfWCListHdrKeyShipTo,'') FROM dbo.VCHeader WITH (NOLOCK) WHERE idfVCHeaderKey = @nHDR_idfVCHeaderKey
	IF ((@nHDR_idfVCHeaderKey IS NOT NULL) AND (@nidfWCListHdrKeyShipTo > '') AND (@strHDR_edfShipTo > '') 
				AND NOT EXISTS (SELECT TOP 1 1 FROM dbo.WCListDtl WITH (NOLOCK) WHERE idfWCListHdrKey = @nidfWCListHdrKeyShipTo AND idfCodeID = @strHDR_edfShipTo))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -464, 'spRQFNAValidate'
	IF EXISTS (SELECT TOP 1 1 FROM dbo.VCHeader WITH (NOLOCK) 
			WHERE VCHeader.idfVCHeaderKey = @nHDR_idfVCHeaderKey 
				AND VCHeader.idfPAProjectKey IS NOT NULL 
				AND VCHeader.idfPAProjectKey <> @nidfPAProjectKey)
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -471, 'spRQFNAValidate'
	SELECT @nForceGivenRate = 0
	IF  (@strHDR_edfPONumber <> '') 
	BEGIN
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND VENDORID <> @strHDR_edfVendor)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -451, 'spRQFNAValidate'

		IF ((@nRQPOPRINTSHIPMETHTOGETHER = 0) AND EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND SHIPMTHD <> @strHDR_edfShipMethod))
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -452, 'spRQFNAValidate'
	
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND CUSTNMBR <> @strHDR_edfDropShipCustomer) AND @strHDR_edfDropShip = 1
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -453, 'spRQFNAValidate'

		IF EXISTS(SELECT 1 from dbo.WCSystem WITH (NOLOCK) WHERE idfModuleRegisteredMC = 1) AND EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND CURNCYID <> @strHDR_edfCurrency)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -454, 'spRQFNAValidate'
		
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PYMTRMID <> @strHDR_edfPaymentTerm)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -455, 'spRQFNAValidate'

		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PRSTADCD <> @strHDR_edfShipTo)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -456, 'spRQFNAValidate'

		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PRBTADCD <> @strHDR_edfBillTo)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -457, 'spRQFNAValidate'
		
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND POSTATUS > 4)
			 OR EXISTS(SELECT 1 FROM dbo.POP30100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -458, 'spRQFNAValidate'

		IF (@xstrSource = 'REVIEW')
		BEGIN
			IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE POP10100.PONUMBER = @strHDR_edfPONumber AND POP10100.BUYERID <> @strHDR_edfBuyer)
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -459, 'spRQFNAValidate'
		END

		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND POTYPE = 2) AND @strHDR_edfDropShip <> 1
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -460, 'spRQFNAValidate'

		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber AND POTYPE = 3) AND @n__HDR_idfFlagBlanketPO = 1
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -461, 'spRQFNAValidate'

		--IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND TAXSCHID <> @strvdfTaxScheduleID)
		--	EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -463, 'spRQFNAValidate'

		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND VADCDPAD <> @chedfVendorAddrID)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -462, 'spRQFNAValidate'

		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND ADDRESS1 <> @stridfShipToAddr1)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -473, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND ADDRESS2 <> @stridfShipToAddr2)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -474, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND ADDRESS3 <> @stridfShipToAddr3)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -475, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PHONE1 <> @stridfShipToAltPhone1)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -476, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND PHONE2 <> @stridfShipToAltPhone2)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -477, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND CITY <> @stridfShipToCity)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -478, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND CONTACT <> @stridfShipToContact)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -479, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND COUNTRY <> @stridfShipToCountry)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -480, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND FAX <> @stridfShipToFax)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -481, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND CMPNYNAM <> @stridfShipToName)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -482, 'spRQFNAValidate'
			
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND STATE <> @stridfShipToState)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -483, 'spRQFNAValidate'	
						
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND ZIPCODE <> @stridfShipToZipCode)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -484, 'spRQFNAValidate'

		IF EXISTS (SELECT TOP 1 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber)
		BEGIN
			SELECT @nidfRateHome = XCHGRATE FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER = @strHDR_edfPONumber
			UPDATE WCTEMPRQFNAValidate SET idfRateHome = @nidfRateHome WHERE idfRowKey = @nHDR_idfRowKey
			SELECT @nvdfExchangeRate = @nidfRateHome, @nForceGivenRate = 1, @xodtXchRateDate = @dtidfRQDate
		END
/*
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND '' <> @stredfFacilityID)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -462, 'spRQFNAValidate'

		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND '' <> @stredfDocumentID)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -462, 'spRQFNAValidate'


		IF EXISTS (SELECT TOP 1 1 FROM WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQBREAKPOBYRQDATE' AND idfValue = 1)
		IF EXISTS(SELECT 1 FROM dbo.POP10100 WITH (NOLOCK) WHERE PONUMBER =	@strHDR_edfPONumber AND REQDATE <> @dtidfRQDate)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -485, 'spRQFNAValidate'
*/
	END
		
	IF ((@strvdfTypeID > '') AND (@nidfEXPTypeKey IS NULL))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -467, 'spRQFNAValidate'
				
	IF ((@strvdfTaxTypeID > '') AND (@nidfAPTaxTypeDtlKey IS NULL))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -468, 'spRQFNAValidate'
				
	IF ((@strvdfTaxScheduleID > '') AND (@nidfWCTaxScheduleHdrKey IS NULL))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -449, 'spRQFNAValidate'

	IF ((EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQFORCEDATEGREATERTHAN' AND idfValue = 1))
		AND @dtidfDateRequired <= @dtHDR_idfDateCreated
		AND @nRQType <> 3)
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -447, 'spRQFNAValidate'

	IF (EXISTS (SELECT TOP 1 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem AND ITEMTYPE = 2) AND (@nSSRQALLOWDISCONFULFILL = 0))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -437, 'spRQFNAValidate'

	IF (EXISTS (SELECT TOP 1 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem AND INACTIVE = 1))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -469, 'spRQFNAValidate'
				
	IF (@nHDR_idfVCHeaderKey <> '')
		IF EXISTS (SELECT 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQVCUNIQUEBYITM_MI_UOM' AND idfValue = 1) 
			IF NOT EXISTS (SELECT 1 FROM VCDetail WITH (NOLOCK) WHERE  edfItem = @strHDR_edfItem AND edfManuItem = @stredfManuItem AND edfUOM = @strHDR_edfUOM AND idfVCHeaderKey = @nHDR_idfVCHeaderKey)
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -414, 'spRQFNAValidate'
	
		IF (@n__WCSystemSettings_RQFORCEDTRQINOPENPRD = 1) BEGIN
			-- If Fiscal Period exists but is closed for date shipped
			IF @dtidfDateRequired <> '' AND EXISTS(SELECT 1 FROM dbo.SY40100 WITH (NOLOCK)
			WHERE ODESCTN = 'Purchasing Invoice Entry' 
			AND CLOSED = '1' 
			AND @dtidfDateRequired BETWEEN PERIODDT AND PERDENDT)
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -408, 'spRQFNAValidate'

			-- If Fiscal Period does not exist for date shipped
			IF (@nFromTemplate = 0)
				IF @dtidfDateRequired <> '' AND NOT(EXISTS(SELECT 1 FROM dbo.SY40100 WITH (NOLOCK)
				WHERE ODESCTN = 'Purchasing Invoice Entry' 
				AND @dtidfDateRequired BETWEEN PERIODDT AND PERDENDT))
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -409, 'spRQFNAValidate'
		END
		
			IF @xstrSource = 'ENTRY' 
				SELECT @nEDITORidfWCSecurityKey = S.idfWCSecurityKey
				FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) 
				INNER JOIN dbo.RQHeader H WITH (NOLOCK) ON H.idfRQHeaderKey = D.idfRQHeaderKey
				INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
				WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey

			IF @xstrSource = 'APPROVAL'
				SELECT @nEDITORidfWCSecurityKey = S.idfWCSecurityKey 
				FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
				INNER JOIN dbo.RQAprDtlRQHeader H WITH (NOLOCK) ON H.idfRQAprDtlRQHeaderKey = D.idfRQAprDtlRQHeaderKey
				INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
				WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
			
			IF @xstrSource IN ('REVIEW','POGEN')
				SELECT @nEDITORidfWCSecurityKey = S.idfWCSecurityKey 
				FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
				INNER JOIN dbo.RQRevDtlRQHeader H WITH (NOLOCK) ON H.idfRQRevDtlRQHeaderKey = D.idfRQRevDtlRQHeaderKey
				INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
				WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey

		-- Figure out what type of PO we are generating.
		SELECT @nGRPIsStandardPO = 1

 
			-- Check if Vendor Doc No is not required and duplicated 
	   		IF (@nRQType = 3 AND LEN(@chedfVendorDocNum) = 0 AND (@nRQALLOWCHECKREQUEST=1 OR @nISCheckReqByLine = 1))
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -411, 'spRQFNAValidate'
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQFNAValidate 
						DEALLOCATE curspRQFNAValidate 
						RETURN @xonErrNum
					END
			END	


			IF (@nRQType = 3 AND @n__WCSystem_idfModuleRegisteredIV = 1 AND @strHDR_edfLocation = '' AND EXISTS(SELECT TOP 1 1 FROM IV00101 (NOLOCK) WHERE ITEMNMBR=@strHDR_edfItem))
			BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -470, 'spRQFNAValidate'
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQFNAValidate
						DEALLOCATE curspRQFNAValidate
						RETURN @xonErrNum
					END	
			END
					
			IF LEN(@chedfVendorDocNum) > 0 AND @nRQType = 3
			AND EXISTS(SELECT TOP 1 1 FROM dbo.PM40100 WITH (NOLOCK) WHERE ADUPINNM IN (1,2))
			AND EXISTS(
					SELECT TOP 1 1 FROM dbo.PM10000 WITH (NOLOCK)
						WHERE VENDORID = @strHDR_edfVendor AND DOCNUMBR = @chedfVendorDocNum
					UNION
					SELECT TOP 1 1 FROM dbo.PM20000 WITH (NOLOCK)
						WHERE VENDORID = @strHDR_edfVendor AND DOCNUMBR = @chedfVendorDocNum
					UNION
					SELECT TOP 1 1  FROM dbo.PM30200 WITH (NOLOCK) 
						WHERE VENDORID = @strHDR_edfVendor AND DOCNUMBR = @chedfVendorDocNum
					UNION
					SELECT TOP 1 1  FROM POP10300 WITH (NOLOCK) 
						WHERE VENDORID = @strHDR_edfVendor AND VNDDOCNM = @chedfVendorDocNum
					UNION
					SELECT TOP 1 1  FROM dbo.RQDetail WITH (NOLOCK) 
									INNER JOIN dbo.RQHeader WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey AND RQHeader.idfRQTypeKey = 3
						WHERE (@nRQALLOWCHECKREQUEST=1 OR @nISCheckReqByLine = 1) AND edfVendor = @strHDR_edfVendor AND edfVendorDocNum = @chedfVendorDocNum AND RQDetail.idfRQHeaderKey <> @nidfRQHeaderKey 
					)
			BEGIN		
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -412, 'spRQFNAValidate'
					IF @xonErrNum <> 0
					BEGIN
						CLOSE curspRQFNAValidate 
						DEALLOCATE curspRQFNAValidate
						RETURN @xonErrNum
					END
			END
 
		IF (@nGRPIsStandardPO = 1)
			SELECT @strHDR_edfTranType = 'STD'
		ELSE
			SELECT @strHDR_edfTranType = 'PA'
			
		--Insert Field Validations Here
		--Validate Buyer
		IF (@nGRPIsStandardPO=1) AND (@strHDR_edfBuyer <> '') AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.POP00101 WITH (NOLOCK) WHERE BUYERID=@strHDR_edfBuyer))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -101, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END

		--Default Item Code from Vendor Item.
		IF (@strHDR_edfVendorItem <> '') AND (@strHDR_edfVendor <> '') AND (@strHDR_edfItem = '')
		BEGIN
			SELECT @strHDR_edfItem = ITEMNMBR FROM dbo.IV00103 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND VNDITNUM = @strHDR_edfVendorItem
			UPDATE dbo.WCTEMPRQFNAValidate
				SET edfItem = @strHDR_edfItem
			FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
			WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
		END -- (@strHDR_edfVendorItem <> '') AND (@strHDR_edfVendor <> '') AND (@strHDR_edfItem = '')

		--Verify that vendor item and item go together - only if there is a vendor item setup for this vendor and item or vendor and vendor item.
		--CDB 9/10/04-make sure that if there is an empty vendor item that it doesn't perform this check.
		IF (@strHDR_edfVendorItem <> '' AND @strHDR_edfVendor <> '' AND @strHDR_edfItem <> '')
			IF NOT(EXISTS(SELECT TOP 1 1 FROM dbo.IV00103 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND ITEMNMBR = @strHDR_edfItem AND VNDITNUM = ''))
				IF (EXISTS(SELECT TOP 1 1 FROM dbo.IV00103 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND VNDITNUM = @strHDR_edfVendorItem) OR
					EXISTS(SELECT TOP 1 1 FROM dbo.IV00103 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND ITEMNMBR = @strHDR_edfItem))
					IF NOT(EXISTS(SELECT TOP 1 1 FROM dbo.IV00103 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND VNDITNUM = @strHDR_edfVendorItem AND ITEMNMBR = @strHDR_edfItem))
						EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -129, 'spRQFNAValidate'

		--Find out if item is miscellanious.
		IF EXISTS(SELECT TOP 1 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem)
			SELECT @nIsMiscIVItem = 0
		ELSE
			SELECT @nIsMiscIVItem = 1

		--Validate Inventory Item
		IF (@nIsMiscIVItem=0) AND (@nGRPIsStandardPO=1) AND (@strHDR_edfItem <> '') AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -105, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
		--Validate Vendor Address
		IF (@chedfVendorAddrID <> '') AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.PM00300 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND ADRSCODE = @chedfVendorAddrID))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -430, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END

		--Validate Currency
		IF (@strHDR_edfCurrency <> '') AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.vwFNACurrency WITH (NOLOCK) WHERE edfCurrencyID = @strHDR_edfCurrency))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -102, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
		--Validate Drop Ship Customer
		IF (@strHDR_edfDropShipCustomer <> '') AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.RM00101 WITH (NOLOCK) WHERE CUSTNMBR = @strHDR_edfDropShipCustomer AND INACTIVE = 0))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -103, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
       	--Validate Customer ID for dropship items
        IF (@strHDR_edfDropShip = 1) AND (@strHDR_edfDropShipCustomer = '')
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -122, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END


		--Validate Analysis Group
		--SELECT * FROM DTA00100
		IF (RTRIM(@strHDR_edfAnalysisGroup) <> '') 
		BEGIN
			IF (NOT EXISTS(SELECT TOP 1 1 FROM dbo.DTA00100 WITH (NOLOCK) WHERE GROUPID = @strHDR_edfAnalysisGroup))
			BEGIN
				EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -124, 'spRQFNAValidate'
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQFNAValidate
					DEALLOCATE curspRQFNAValidate
					RETURN @xonErrNum
				END
			END
			ELSE BEGIN
				-- Only perform GL Checks if @xstrSource is not 'UDFTEMPLATE'
				IF (@xstrSource <> 'UDFTEMPLATE')
				BEGIN
					IF (@nHDR_edfGL IS NULL OR NOT EXISTS(SELECT TOP 1 1 FROM dbo.GL00100 WITH (NOLOCK) WHERE ACTINDX = @nHDR_edfGL ))
					BEGIN
						EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -125, 'spRQFNAValidate'
						IF @xonErrNum <> 0
						BEGIN
							CLOSE curspRQFNAValidate
							DEALLOCATE curspRQFNAValidate
							RETURN @xonErrNum
						END
					END
					ELSE BEGIN
						-- Verify that analysis group belongs to the passed gl and the type is OPTIONAL only.
						IF (NOT EXISTS(SELECT TOP 1 1 FROM dbo.DTA00300 WITH (NOLOCK) WHERE ACTINDX=@nHDR_edfGL AND GROUPID = @strHDR_edfAnalysisGroup AND ACCTSTAT=3))
						BEGIN
							EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -126, 'spRQFNAValidate'
							IF @xonErrNum <> 0
							BEGIN
								CLOSE curspRQFNAValidate
								DEALLOCATE curspRQFNAValidate
								RETURN @xonErrNum
							END
						END
					END
				END
			END
		END
DECLARE @nVendorValid int
SELECT @nVendorValid = 1
		--Validate Vendor
		IF ((@nGRPIsStandardPO=1) OR (@strHDR_edfTranType = '')) AND (@strHDR_edfVendor <> '') AND 
			(NOT EXISTS(SELECT TOP 1 1 FROM dbo.PM00200 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND VENDSTTS <> 2))
		BEGIN
			SELECT @nVendorValid = 0
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -106, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
		ELSE
		BEGIN
			--Default Currency if Vendor is Specified.
			IF (@strHDR_edfCurrency = '')
			BEGIN
				SELECT @strHDR_edfCurrency = ISNULL(CURNCYID,'') FROM dbo.PM00200 WITH (NOLOCK) WHERE VENDORID = @strHDR_edfVendor AND VENDSTTS <> 2
				IF (@strHDR_edfCurrency <> '')
					UPDATE dbo.WCTEMPRQFNAValidate
						SET edfCurrency = @strHDR_edfCurrency
					FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
						WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
			END
		END

		IF (@strHDR_edfVendor <> '')  AND @nVendorValid = 1
			AND EXISTS(SELECT 1 FROM dbo.IV00101 I WITH (NOLOCK) 
						CROSS JOIN dbo.WCSystem WITH (NOLOCK) 
						LEFT OUTER JOIN dbo.IV00103 V WITH (NOLOCK) ON I.ITEMNMBR = V.ITEMNMBR AND V.VENDORID = @strHDR_edfVendor
						WHERE I.ITEMNMBR = @strHDR_edfItem AND idfFlagRQRestrictItemVendor = 1	AND V.VENDORID IS NULL) 
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -130, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
		--Validate Location To
		IF (@strHDR_edfLocation <> '') AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.IV40700 WITH (NOLOCK) WHERE LOCNCODE = @strHDR_edfLocation AND IV40700.INACTIVE = 0))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -109, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
		--Validate edfShipMethod and edfPaymentTerm
	
		IF (@strHDR_edfShipMethod <> '') --edfShipMethod
			IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.SY03000 WITH (NOLOCK) WHERE SHIPMTHD = @strHDR_edfShipMethod)
				EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -134, 'spRQFNAValidate'

		IF (@strHDR_edfPaymentTerm <> '') --edfPaymentTerm
			IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.SY03300 WITH (NOLOCK) WHERE PYMTRMID = @strHDR_edfPaymentTerm)
				EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -133, 'spRQFNAValidate'

		--Validate Ship To
		--IF @strHDR_edfDropShip=1 then look at RM00102 table versus SY00600
		IF (@strHDR_edfShipTo <> '') AND 
			(
				(@strHDR_edfDropShip = 0 AND NOT EXISTS(SELECT TOP 1 1 FROM dbo.SY00600 WITH (NOLOCK) WHERE LOCATNID = @strHDR_edfShipTo))
				OR
				(@strHDR_edfDropShip = 1 AND NOT EXISTS(SELECT TOP 1 1 FROM dbo.RM00102 WITH (NOLOCK) WHERE CUSTNMBR = @strHDR_edfDropShipCustomer AND ADRSCODE = @strHDR_edfShipTo))
			)
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -111, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
		
		--Validate Bill To
		IF ((@strHDR_edfBillTo <> '') AND  (NOT EXISTS(SELECT TOP 1 1 FROM dbo.SY00600 WITH (NOLOCK) WHERE LOCATNID = @strHDR_edfBillTo)))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -413, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END

		--Validate Priority
		IF ((@strvdfPriorityID <> '') AND  (@nidfRQPriorityKey IS NULL))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -446, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END

		--G/L Account can only be assigned to IV Items that are type Sales Inventory
		IF (@xstrSource IN ('ENTRY', 'APPROVAL', 'REVIEW'))
			IF ((@strRQGLACCTONLYFORSALESINV <> '') AND (@nHDR_edfGL <> '') AND 
				EXISTS (SELECT TOP 1 1 
						FROM dbo.WCListHdr WITH (NOLOCK) 
						INNER JOIN dbo.WCListDtl WITH (NOLOCK) ON WCListDtl.idfWCListHdrKey = WCListHdr.idfWCListHdrKey 
						INNER JOIN vwFNAGLAccount WITH (NOLOCK) ON vwFNAGLAccount.ACTINDX = WCListDtl.idfCodeKey AND vwFNAGLAccount.ACTINDX = @nHDR_edfGL
						WHERE WCListHdr.idfWCListTypeKey = 2 AND WCListHdr.idfListID = @strRQGLACCTONLYFORSALESINV) AND
				NOT EXISTS (SELECT TOP 1 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE IV00101.ITEMTYPE = 1 AND ITEMNMBR = @strHDR_edfItem))
			BEGIN
				EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -466, 'spRQFNAValidate'
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQFNAValidate
					DEALLOCATE curspRQFNAValidate
					RETURN @xonErrNum
				END
			END
		
		--Default UOM to Purchase UOM if Empty and Item is specified.
		IF (@nIsMiscIVItem=0) AND (@strHDR_edfUOM = '' AND @strHDR_edfItem <> '')
		BEGIN
			SELECT @strHDR_edfUOM = ISNULL(PRCHSUOM,'') FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem
			IF (@strHDR_edfUOM <> '')
				UPDATE dbo.WCTEMPRQFNAValidate
					SET edfUOM = @strHDR_edfUOM
				FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
					WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey

		END
	
		--Validate UOM only if Item is Valid and a UOM is Specified.
		IF (@nIsMiscIVItem=0) AND (@strHDR_edfItem <> '' AND @strHDR_edfUOM <> '')
			IF (EXISTS(SELECT TOP 1 1 FROM dbo.IV00101 WITH  (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem))
				IF  NOT(EXISTS(SELECT TOP 1 1 FROM dbo.IV00106 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem AND UOFM = @strHDR_edfUOM)) BEGIN
					EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -112, 'spRQFNAValidate'
					IF @xonErrNum <> 0 BEGIN
						CLOSE curspRQFNAValidate
						DEALLOCATE curspRQFNAValidate
						RETURN @xonErrNum
						END
				END

		-- Default G/L Account if No Value is set and Item is specified.
		SELECT @nIV00101_GL = NULL

		IF ((@nIsMiscIVItem=0) AND 
			(@nHDR_edfGL IS NULL  OR 
				(@nidfFlagGLAccountOverride = 1 AND EXISTS(SELECT TOP 1 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR=@strHDR_edfItem AND ITEMTYPE IN (1,2)))
			) AND 
			(@strHDR_edfItem <> ''))
		BEGIN
			-- Make sure there is an account setup
			SELECT @nIV00101_GL = CASE WHEN idfFlagRQGLByItemType = 1 AND ITEMTYPE = 1 AND ISNULL(@nRQType,0) <> 4 THEN IVIVOFIX ELSE IVIVINDX END
				FROM dbo.IV00101 WITH (NOLOCK) 
				CROSS JOIN dbo.WCSystem WITH (NOLOCK) 
				WHERE ITEMNMBR = @strHDR_edfItem
		END
		
		-- CDB 4/12/06: If line is drop ship and inventoriable then set account to drop ship account if available.
		IF (@nIsMiscIVItem = 0 AND @strHDR_edfDropShip = 1) BEGIN
			SELECT @nIV00101_GL = CASE WHEN DPSHPIDX = 0 THEN @nIV00101_GL ELSE DPSHPIDX END
				FROM dbo.IV00101 WITH (NOLOCK) 
				WHERE ITEMNMBR = @strHDR_edfItem
		END
	
		-- CDB 4/12/06: If GL was set from Inventory or from Drop Ship then update Requisition Line.		
		IF (@nIV00101_GL IS NOT NULL AND @nIV00101_GL > 0) BEGIN
			SELECT @nHDR_edfGL = @nIV00101_GL

			IF (@nHDR_edfGL IS NOT NULL)
				UPDATE dbo.WCTEMPRQFNAValidate
					SET edfGL = @nHDR_edfGL
				FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
					WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
		END

		-- Default edfItemDesc if Empty and Item is specified.
		IF (@nIsMiscIVItem=0) AND (@strHDR_edfItemDesc = '' AND @strHDR_edfItem <> '')
		BEGIN
			SELECT @strHDR_edfItemDesc = ISNULL(ITEMDESC,'') FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem
			IF (@strHDR_edfItemDesc <> '')
				UPDATE dbo.WCTEMPRQFNAValidate
					SET edfItemDesc = @strHDR_edfItemDesc
				FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
					WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
		END
		
		-- Perform Site ID Segment Override.
		-- Do not perform site id override it line has a cost category.
		IF (@n__WCSystemSettings_RQIGNSEGOVERRIDE = 0 AND @strHDR_edfPAProjectL3 = '') BEGIN
			
			SELECT @n__OverrideIV_GLActIndxSrc = edfGL FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
			 
			EXEC @n__OverrideIVReturnVal = dbo.spFNAGetOverridenGLFromIV @strHDR_edfLocation,@n__OverrideIV_GLActIndxSrc, @n__OverrideIV_GLActIndxDst OUTPUT,@strOverrideIV_GLActNumSt OUTPUT
			
			-- If No errors where encountered then set new GL Account.
			IF (@n__OverrideIVReturnVal = 0) BEGIN
				SELECT @nHDR_edfGL = @n__OverrideIV_GLActIndxDst
				UPDATE dbo.WCTEMPRQFNAValidate SET edfGL = @nHDR_edfGL FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
			END
		END

		SELECT @strvdfGL =	''
		SELECT @strvdfGL = GL00105.ACTNUMST FROM dbo.GL00105 WITH (NOLOCK) WHERE dbo.GL00105.ACTINDX =	 @nHDR_edfGL

		IF @xstrSource <> 'UDFTEMPLATE'
		BEGIN
			DECLARE 
				@strOverlayString varchar(255)
				,@strGLString varchar(255)
				,@nNewGL int
				
			IF ((@nRQGLOVERLAYPRIMARY=0) 
			 OR (@xstrSource <> 'DISTRIBUTION') 
			 OR (@xstrSource = 'DISTRIBUTION' AND @nHDR_idfRowKey=0 AND @nRQGLOVERLAYPRIMARY=1))
			BEGIN	
				-- ------------------------------------------------------------------------------------------------------------------------
				-- Apply DEPARTMENT Overlay Mask
				-- ------------------------------------------------------------------------------------------------------------------------
				SELECT @nNewGL = null, @strOverlayString = null, @strGLString = null
				SELECT @strvdfGL = GL00105.ACTNUMST FROM dbo.GL00105 WITH (NOLOCK) WHERE GL00105.ACTINDX =	 @nHDR_edfGL
				
				SELECT @strOverlayString = idfGLOverlayMask FROM dbo.WCDept WITH (NOLOCK) WHERE idfWCDeptKey = @nidfWCDeptKey
				
				if (@strOverlayString IS NOT NULL)
				BEGIN
					EXEC dbo.spFNAApplyOverlay @strvdfGL, @strOverlayString, @strGLString OUTPUT

					SELECT @nNewGL = GL00105.ACTINDX 
					FROM dbo.GL00105 WITH (NOLOCK) 
					INNER JOIN dbo.GL00100 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
					WHERE GL00105.ACTNUMST = @strGLString  AND GL00100.ACTIVE = 1
				END

				IF @nNewGL IS NOT NULL
				BEGIN
					SELECT @nHDR_edfGL = @nNewGL

					UPDATE dbo.WCTEMPRQFNAValidate SET edfGL = @nNewGL FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
				END
			END

			-- ------------------------------------------------------------------------------------------------------------------------
			-- Apply EXPENSE TYPE Overlay Mask
			-- ------------------------------------------------------------------------------------------------------------------------
			IF (@nidfEXPTypeKey IS NOT NULL) BEGIN
				SELECT @nHDR_edfGL = edfGL FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
				SELECT @strvdfGL = GL00105.ACTNUMST FROM dbo.GL00105 WITH (NOLOCK) WHERE GL00105.ACTINDX =	 @nHDR_edfGL

				SELECT @n__OVERLAY_NewGL = null, @strOVERLAY_OverlayString = null, @strOVERLAY_GLString = null
			
				SELECT @strOVERLAY_OverlayString = idfGLOverlayMask FROM EXPType (NOLOCK) WHERE idfTypeID = @strvdfTypeID
			
				EXEC spFNAApplyOverlay @strvdfGL, @strOVERLAY_OverlayString, @strOVERLAY_GLString OUTPUT
		
				SELECT @n__OVERLAY_NewGL = GL00105.ACTINDX 
				FROM GL00105 (NOLOCK) 
				INNER JOIN dbo.GL00100 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
				WHERE GL00105.ACTNUMST = @strOVERLAY_GLString AND GL00100.ACTIVE = 1

				IF @n__OVERLAY_NewGL IS NOT NULL
				BEGIN
					UPDATE dbo.WCTEMPRQFNAValidate 
					SET edfGL = @n__OVERLAY_NewGL
					FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
					WHERE idfOwnerSPID=@@SPID AND idfRowKey = @nHDR_idfRowKey

					SELECT @nHDR_edfGL = @n__OVERLAY_NewGL
				END
			END
			-- ------------------------------------------------------------------------------------------------------------------------

			-- ------------------------------------------------------------------------------------------------------------------------
			-- Apply UDF Template GLOBAL Overlay Mask
			-- ------------------------------------------------------------------------------------------------------------------------
			SELECT @nNewGL = null, @strOverlayString = null, @strGLString = null

			SELECT @strvdfGL = GL00105.ACTNUMST FROM dbo.GL00105 WITH (NOLOCK) WHERE GL00105.ACTINDX =	 @nHDR_edfGL
			IF @xstrSource = 'ENTRY' AND @nFromTemplate = 0
				SELECT @strOverlayString = U.idfDefaultValue 
				FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
				INNER JOIN dbo.RQHeader H WITH (NOLOCK) ON H.idfRQHeaderKey = D.idfRQHeaderKey
				INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
				INNER JOIN dbo.WCUDFTemplateDtl U WITH (NOLOCK) ON U.idfWCUDFTemplateHdrKey = S.idfWCUDFTemplateKey AND U.idfWCUDFTemplateFieldKey = 146
				WHERE D.idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey

			IF @xstrSource = 'APPROVAL'
				SELECT @strOverlayString = U.idfDefaultValue 
				FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
				INNER JOIN dbo.RQAprDtlRQHeader H WITH (NOLOCK) ON H.idfRQAprDtlRQHeaderKey = D.idfRQAprDtlRQHeaderKey
				INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
				INNER JOIN dbo.WCUDFTemplateDtl U WITH (NOLOCK) ON U.idfWCUDFTemplateHdrKey = S.idfWCUDFTemplateKey AND U.idfWCUDFTemplateFieldKey = 146
				WHERE D.idfOwnerSPID = @@SPID AND  idfRowKey = @nHDR_idfRowKey AND (@strRemoveAprVal = 'FALSE')
			
			IF @xstrSource = 'REVIEW'
				SELECT @strOverlayString = U.idfDefaultValue 
				FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
				INNER JOIN dbo.RQRevDtlRQHeader H WITH (NOLOCK) ON H.idfRQRevDtlRQHeaderKey = D.idfRQRevDtlRQHeaderKey
				INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
				INNER JOIN dbo.WCUDFTemplateDtl U WITH (NOLOCK) ON U.idfWCUDFTemplateHdrKey = S.idfWCUDFTemplateKey AND U.idfWCUDFTemplateFieldKey = 146
				WHERE D.idfOwnerSPID = @@SPID AND  idfRowKey = @nHDR_idfRowKey
				
			IF @xstrSource = 'DISTRIBUTION'
				SELECT @strOverlayString = U.idfDefaultValue 
				FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
				INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = D.idfWCSecurityKey
				INNER JOIN dbo.WCUDFTemplateDtl U WITH (NOLOCK) ON U.idfWCUDFTemplateHdrKey = S.idfWCUDFTemplateKey AND U.idfWCUDFTemplateFieldKey = 146
				WHERE D.idfOwnerSPID = @@SPID AND  idfRowKey = @nHDR_idfRowKey
				
			if (@strOverlayString IS NOT NULL)
			BEGIN
				EXEC dbo.spFNAApplyOverlay @strvdfGL, @strOverlayString, @strGLString OUTPUT

				SELECT @nNewGL = GL00105.ACTINDX 
				FROM dbo.GL00105 WITH (NOLOCK) 
				INNER JOIN dbo.GL00100 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
				WHERE GL00105.ACTNUMST = @strGLString AND GL00100.ACTIVE = 1
			END

			IF @nNewGL IS NOT NULL BEGIN
				SELECT @nHDR_edfGL = @nNewGL

				UPDATE dbo.WCTEMPRQFNAValidate SET edfGL = @nNewGL FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
			END
			-- ------------------------------------------------------------------------------------------------------------------------
			-- Apply UDF Template IV Items that are Sales Inventory (1) or Services (5) type Only Overlay Mask
			-- ------------------------------------------------------------------------------------------------------------------------
			IF  (@nIsMiscIVItem = 0) AND EXISTS(SELECT TOP 1 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem AND ITEMTYPE IN (1,5)) BEGIN

				SELECT @nNewGL = null, @strOverlayString = null, @strGLString = null
	
				SELECT @strvdfGL = GL00105.ACTNUMST FROM dbo.GL00105 WITH (NOLOCK) WHERE GL00105.ACTINDX = @nHDR_edfGL
				IF @xstrSource = 'ENTRY' AND @nFromTemplate = 0
					SELECT @strOverlayString = U.idfDefaultValue 
					FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
					INNER JOIN dbo.RQHeader H WITH (NOLOCK) ON H.idfRQHeaderKey = D.idfRQHeaderKey
					INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
					INNER JOIN dbo.WCUDFTemplateDtl U WITH (NOLOCK) ON U.idfWCUDFTemplateHdrKey = S.idfWCUDFTemplateKey AND U.idfWCUDFTemplateFieldKey = 149
					WHERE D.idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
	
				IF @xstrSource = 'APPROVAL'
					SELECT @strOverlayString = U.idfDefaultValue 
					FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
					INNER JOIN dbo.RQAprDtlRQHeader H WITH (NOLOCK) ON H.idfRQAprDtlRQHeaderKey = D.idfRQAprDtlRQHeaderKey
					INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
					INNER JOIN dbo.WCUDFTemplateDtl U WITH (NOLOCK) ON U.idfWCUDFTemplateHdrKey = S.idfWCUDFTemplateKey AND U.idfWCUDFTemplateFieldKey = 149
					WHERE D.idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey AND (@strRemoveAprVal = 'FALSE')
				
				IF @xstrSource = 'REVIEW'
					SELECT @strOverlayString = U.idfDefaultValue 
					FROM dbo.WCTEMPRQFNAValidate D WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
					INNER JOIN dbo.RQRevDtlRQHeader H WITH (NOLOCK) ON H.idfRQRevDtlRQHeaderKey = D.idfRQRevDtlRQHeaderKey
					INNER JOIN dbo.WCSecurity S WITH (NOLOCK) ON S.idfWCSecurityKey = H.idfWCSecurityKey
					INNER JOIN dbo.WCUDFTemplateDtl U WITH (NOLOCK) ON U.idfWCUDFTemplateHdrKey = S.idfWCUDFTemplateKey AND U.idfWCUDFTemplateFieldKey = 149
					WHERE D.idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
				
				if (@strOverlayString IS NOT NULL)	
				BEGIN
					EXEC dbo.spFNAApplyOverlay @strvdfGL, @strOverlayString, @strGLString OUTPUT
	
					SELECT @nNewGL = GL00105.ACTINDX 
					FROM dbo.GL00105 WITH (NOLOCK) 
					INNER JOIN dbo.GL00100 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
					WHERE GL00105.ACTNUMST = @strGLString AND GL00100.ACTIVE = 1 
				END

				IF @nNewGL IS NOT NULL BEGIN
					SELECT @nHDR_edfGL = @nNewGL
	
					UPDATE dbo.WCTEMPRQFNAValidate SET edfGL = @nNewGL FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
				END
			END
			
		END
				
		SELECT @strvdfGL = GL00105.ACTNUMST FROM dbo.GL00105 WITH (NOLOCK) WHERE GL00105.ACTINDX = @nHDR_edfGL
		
		--Validate GL Mask.
		IF @nidfWCDeptKey <> -1 AND @strvdfGL <> '' AND (NOT EXISTS(SELECT 1 FROM dbo.WCDept WHERE (@strvdfGL LIKE WCDept.idfGLMask OR @strvdfGL LIKE WCDept.idfGLMask2) AND idfWCDeptKey = @nidfWCDeptKey) AND @nidfWCDeptKey IS NOT NULL)
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -128, 'spRQFNAValidate',@xstrParam1=@strvdfGL
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQDetail 
				DEALLOCATE curspRQDetail 
				RETURN @xonErrNum
			END
		END			

		SELECT @nAllowInvalidGL = 0
		IF @xstrCondition IS NOT NULL
			IF (@xstrCondition = 'SHIPMENT')
				SELECT @nAllowInvalidGL = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RCVALLOWRCVINACTIVEGL'
			ELSE
				SELECT @nAllowInvalidGL = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RCVALLOWINVINACTIVEGL'	
				 
		--Validate G/L Account
		IF (@nAllowInvalidGL = 0 AND @nHDR_edfGL IS NOT NULL AND NOT EXISTS(SELECT TOP 1 1 FROM dbo.GL00100 WITH (NOLOCK) WHERE ACTINDX = @nHDR_edfGL AND ACTIVE = 1))
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -104, 'spRQFNAValidate'
			IF @xonErrNum <> 0
			BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END
		-- If item is inventoriable then make sure it is configurated for the passed location.
		IF ((@nSSRQCREATEITMSITEREL = 0) AND (@nIsMiscIVItem=0) AND (@strHDR_edfLocation <> '' AND @strHDR_edfItem <> '' AND EXISTS(SELECT 1 FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem)))
		BEGIN
			IF NOT (EXISTS(SELECT 1 FROM dbo.IV00102 WITH  (NOLOCK) WHERE RCRDTYPE = 2 AND ITEMNMBR = @strHDR_edfItem AND LOCNCODE=@strHDR_edfLocation))
			BEGIN
				EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -118, 'spRQFNAValidate'
				IF @xonErrNum <> 0 BEGIN
					CLOSE curspRQFNAValidate
					DEALLOCATE curspRQFNAValidate
					RETURN @xonErrNum
				END
			END
		END
		
		IF (@nIsMiscIVItem=0) 
		BEGIN
			SELECT   @strUOMSCHDL 		= UOMSCHDL
				,@n__IV00101_ITEMTYPE 	= ITEMTYPE
				,@n__IV00101_RELEASECOST= CASE WHEN VCTNMTHD > 3 THEN STNDCOST ELSE CURRCOST END
				,@n__IV00101_STNDCOST	= STNDCOST
			FROM dbo.IV00101 WITH (NOLOCK)
			WHERE ITEMNMBR = @strHDR_edfItem

			-- If the price override is active and item is qty trackable then update with the proper price from inventory.
			IF (@n__WCSystem_idfFlagIVUnitPriceOverride = 1 AND (@n__IV00101_ITEMTYPE = 1 OR @n__IV00101_ITEMTYPE = 2)) 
				SELECT @nedfPrice = @n__IV00101_RELEASECOST

			-- Perform price overide for service items if enabled.
			IF (@n__WCSystemSettings_IVOVERRIDEPRICE_4SVCITEM = 1 AND @n__IV00101_ITEMTYPE = 5 AND @n__IV00101_STNDCOST > 0)
			BEGIN
				DECLARE @nQTYUOM INT
				SELECT @nQTYUOM = QTYBSUOM FROM dbo.IV00106 WITH (NOLOCK) WHERE ITEMNMBR = @strHDR_edfItem AND UOFM = @strHDR_edfUOM
				SELECT @nedfPrice = @n__IV00101_STNDCOST * @nQTYUOM
			END
			
			SELECT @nQtyPer = UMDPQTYS - 1 FROM dbo.IV40201 WITH (NOLOCK) WHERE UOMSCHDL = @strUOMSCHDL
		END
		ELSE
			SELECT @nQtyPer = NULL

		IF @nQtyPer IS NULL
		BEGIN
			IF (@nGRPIsStandardPO=1 OR 1=1)
				SELECT @nQtyPer = DECPLQTY - 1 FROM dbo.POP40100 WITH (NOLOCK)
		END 

		IF @nQtyPer < 0 
		BEGIN
		    SELECT @nQtyPer = 2
		END
		
		IF (FLOOR(@nidfQty * POWER(10,@nQtyPer))/POWER(10,@nQtyPer)) <> @nidfQty
		BEGIN
			IF @nQtyPer = 0
			BEGIN
				EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -119, 'spRQFNAValidate'
				IF @xonErrNum <> 0 BEGIN
					CLOSE curspRQFNAValidate
					DEALLOCATE curspRQFNAValidate
					RETURN @xonErrNum
				END
			END
			ELSE
			BEGIN
				EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -120, 'spRQFNAValidate'
				IF @xonErrNum <> 0 BEGIN
					CLOSE curspRQFNAValidate
					DEALLOCATE curspRQFNAValidate
					RETURN @xonErrNum
				END
			END
		END
		
		EXEC dbo.spRQFNARoundCurrency '',0,'', @strHDR_edfTranType,  @strHDR_edfCurrency, @nedfPrice, @nedfPrice OUTPUT, @strHDR_edfItem,@xItemCurrPer OUTPUT

		UPDATE dbo.WCTEMPRQFNAValidate SET idfQtyPrec = @nQtyPer, edfPricePrec = @xItemCurrPer FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey

		SELECT @nedfAmtExtended = @nedfPrice * @nidfQty
		EXEC dbo.spFNARoundCurrency '',0,'', @strHDR_edfCurrency, @nedfAmtExtended, @nedfAmtExtended OUTPUT
				
		SELECT @nRQUSEDATEANDRATEFORPO = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQUSEDATEANDRATEFORPO'

		IF (@nRQUSEDATEANDRATEFORPO = 1)
			SELECT @nvdfExchangeRate = @nidfRateHome, @nForceGivenRate = 1, @xodtXchRateDate = @dtidfRQDate
		ELSE 
			SELECT @xodtXchRateDate = NULL
		
		EXEC dbo.spFNAConvertCur '',0,''
		, @strHDR_edfCurrency
		, 1
		, @nedfPrice
		, @nedfPriceHome	OUTPUT
		, @nvdfExchangeRate OUTPUT
		, @strvdfRateType	OUTPUT
		, @strvdfRateTable	OUTPUT
		, @nvdfRateCal		OUTPUT
		, @strvdfRateDate	OUTPUT
		, @strvdfRateTime	OUTPUT
		, NULL	
		, @xodtXchRateDate
		, 1	
		, @nForceGivenRate

		SELECT @nedfAmtHomeExtended = @nedfPriceHome * @nidfQty
		
		--Round Home Currency
		EXEC dbo.spRQFNARoundCurrency '',0,'', @strHDR_edfTranType, NULL, @nedfAmtHomeExtended, @nedfAmtHomeExtended OUTPUT
				--Update Ship and Payment where empty

		UPDATE dbo.WCTEMPRQFNAValidate
		SET edfPrice = @nedfPrice
			, edfPriceHome = @nedfPriceHome
			, edfAmtExtended = @nedfAmtExtended
			, edfAmtHomeExtended = @nedfAmtHomeExtended
			, vdfExchangeRate = @nvdfExchangeRate 
			, vdfRateType = @strvdfRateType 
			, vdfRateTable = @strvdfRateTable 
			, vdfRateCal = @nvdfRateCal 
			, vdfRateDate = @strvdfRateDate 
			, vdfRateTime = @strvdfRateTime 
			, idfRateHome = CASE WHEN (@nRQUSEDATEANDRATEFORPO = 0) THEN @nvdfExchangeRate ELSE idfRateHome END
		FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) 
		WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
		
		IF (@nedfAmtExtended < 0)
		BEGIN
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -123, 'spRQFNAValidate'
			IF @xonErrNum <> 0 BEGIN
				CLOSE curspRQFNAValidate
				DEALLOCATE curspRQFNAValidate
				RETURN @xonErrNum
			END
		END

		-- Convert Function to Approval Currency
		-- ** If approval currency is specified then convert, else if empty then just put the 
		--    home amount into the approval amount.
		IF (@strWCSystem_edfCurrencyApproval <> '') BEGIN
			EXEC dbo.spFNAConvertCur '',0,'', @strWCSystem_edfCurrencyApproval, 2, @nedfAmtHomeExtended, @nedfAmtAprExtended OUTPUT
			, @nvdfExchangeRate OUTPUT
			, @strvdfRateType OUTPUT
			, @strvdfRateTable OUTPUT
			, @nvdfRateCal OUTPUT
			, @strvdfRateDate OUTPUT
			, @strvdfRateTime OUTPUT
			, NULL	
			, @xodtXchRateDate
	
			--Round Approval Currency
			EXEC dbo.spRQFNARoundCurrency '',0,'', @strHDR_edfTranType, NULL, @nedfAmtAprExtended, @nedfAmtAprExtended OUTPUT
		END
		ELSE
			SELECT @nedfAmtAprExtended = @nedfAmtHomeExtended
		
		UPDATE dbo.WCTEMPRQFNAValidate SET edfAmtAprExtended = @nedfAmtAprExtended FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4) WHERE idfOwnerSPID = @@SPID AND idfRowKey = @nHDR_idfRowKey
		
		
		IF (ISNULL(@nvdfExchangeRate,0.00000) = 0.00000) AND (@xstrSource <> 'UDFTEMPLATE')
			EXEC dbo.spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @nHDR_idfRowKey, -448, 'spRQFNAValidate'
	END --@@fetch_status <> -2

	FETCH curspRQFNAValidate INTO
		 @nHDR_idfPTICompanyKey
		,@strHDR_edfBuyer
		,@nidfQty
		,@strHDR_edfCurrency
		,@nedfPrice
		,@nedfPriceHome
		,@nedfAmtHomeExtended
		,@nvdfExchangeRate
		,@strvdfRateDate
		,@strvdfRateTime
		,@nvdfRateCal
		,@strvdfRateType
		,@strvdfRateTable
		,@strHDR_edfAnalysisGroup
		,@strHDR_edfBillTo
        ,@strHDR_edfDropShip
		,@strHDR_edfDropShipCustomer
		,@chedfENCBreakDown
		,@chedfENCGrantID		
		,@chedfENCProjectID		
		,@chedfENCUserDefined1
		,@chedfENCUserDefined2
		,@chedfENCUserDefined3
		,@chedfENCUserDefined4
		,@chedfENCUserDefined5
		,@chedfENCUserDefined6
		,@chedfENCUserDefined7
		,@strHDR_edfShipMethod
		,@strHDR_edfPaymentTerm
		,@nHDR_edfGL
		,@strHDR_edfItem
		,@strHDR_edfItemDesc
		,@strHDR_edfLocationFrom
		,@strHDR_edfLocation
		,@strHDR_edfPAProjectL1
		,@strHDR_edfPAProjectL2
		,@nedfPALineItemSeq
		,@strHDR_edfPAProjectL3
		,@nHDR_edfPOLine
		,@strHDR_edfPONumber
		,@strHDR_edfShipTo
		,@strHDR_edfTranType
		,@nedfWSProductIndicator
		,@strHDR_edfUOM
		,@strHDR_edfVendor
		,@chedfVendorDocNum
		,@chedfVendorAddrID
		,@strHDR_edfVendorItem
		,@nidfWCDeptKey
		,@nHDR_idfRowKey
		,@n__HDR_idfFlagBlanketPO
		,@dtidfDateRequired
		,@nHDR_idfVCHeaderKey
		,@nidfRQDetailKey
		,@nRQType
		,@stredfManuItem
		,@stredfFacilityID
		,@stredfFacilityIDFrom
		,@stredfDocumentID
		,@strvdfProjectID
		,@strvdfPhaseID
		,@strvdfActivityID
		,@nidfPAProjectKey			
		,@nidfPAProjectPhaseKey 	
		,@nidfPAPhaseActivityKey	
		,@strvdfPriorityID
		,@nidfRQPriorityKey
		,@dtHDR_idfDateCreated
		,@nidfRateHome
		,@dtidfRQDate
		,@strvdfTaxScheduleID
		,@nidfWCTaxScheduleHdrKey
		,@nidfFlagVCOverride
		,@stridfVCOverrideNote
		,@strvdfTypeID
		,@strvdfTaxTypeID
		,@nidfEXPTypeKey
		,@nidfAPTaxTypeDtlKey
		,@stridfShipToAddr1				
		,@stridfShipToAddr2				
		,@stridfShipToAddr3				
		,@stridfShipToAltPhone1			
		,@stridfShipToAltPhone2			
		,@stridfShipToAltPhoneExt1		
		,@stridfShipToAltPhoneExt2		
		,@stridfShipToCity				
		,@stridfShipToContact			
		,@stridfShipToCountry			
		,@stridfShipToFax				
		,@stridfShipToName				
		,@stridfShipToState				
		,@stridfShipToZipCode	
		,@nidfRQHeaderKey
END --@@fetch_status <> -1
CLOSE curspRQFNAValidate
DEALLOCATE curspRQFNAValidate

IF ((EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQCREATEITMSITEREL' AND idfValue = 1)) AND (@xstrSource='ENTRY')) 
BEGIN
	DECLARE @ItemSiteInsert TABLE
	(
		 edfItem		VARCHAR(31)
		,edfLocation	VARCHAR(15)
	)

	INSERT INTO @ItemSiteInsert (edfItem,edfLocation)
	SELECT TMP.edfItem,TMP.edfLocation
	FROM dbo.WCTEMPRQFNAValidate TMP WITH (NOLOCK INDEX=idfOwnerSPID)
	INNER JOIN dbo.IV00101		WITH (NOLOCK) ON IV00101.ITEMNMBR = TMP.edfItem 
	LEFT OUTER JOIN dbo.IV00102 WITH (NOLOCK) ON IV00102.ITEMNMBR = TMP.edfItem AND IV00102.LOCNCODE = TMP.edfLocation 
	WHERE IV00102.LOCNCODE IS NULL AND TMP.idfOwnerSPID = @@SPID

	INSERT INTO IV00102
	(
		 ITEMNMBR
		,LOCNCODE
		,RCRDTYPE
		,PRIMVNDR
		,ITMFRFLG
		,BGNGQTY
		,LSORDQTY
		,LSTORDDT
		,LSORDVND
		,LSRCPTDT
		,QTYRQSTN
		,QTYONORD
		,QTYBKORD
		,QTY_Drop_Shipped
		,QTYINUSE
		,QTYINSVC
		,QTYRTRND
		,QTYDMGED
		,QTYONHND
		,ATYALLOC
		,QTYCOMTD
		,QTYSOLD
		,NXTCNTDT
		,NXTCNTTM
		,LSTCNTDT
		,LSTCNTTM
		,STCKCNTINTRVL
		,Landed_Cost_Group_ID
		,BUYERID
		,PLANNERID
		,ORDERPOLICY
		,FXDORDRQTY
		,ORDRPNTQTY
		,NMBROFDYS
		,MNMMORDRQTY
		,MXMMORDRQTY
		,ORDERMULTIPLE
		,REPLENISHMENTMETHOD
		,SHRINKAGEFACTOR
		,PRCHSNGLDTM
		,MNFCTRNGFXDLDTM
		,MNFCTRNGVRBLLDTM
		,STAGINGLDTME
		,PLNNNGTMFNCDYS
		,DMNDTMFNCPRDS
		,INCLDDINPLNNNG
		,CALCULATEATP
		,AUTOCHKATP
		,PLNFNLPAB
		,FRCSTCNSMPTNPRD
		,ORDRUPTOLVL
		,SFTYSTCKQTY
		,REORDERVARIANCE
		,PORECEIPTBIN
		,PORETRNBIN
		,SOFULFILLMENTBIN
		,SORETURNBIN
		,BOMRCPTBIN
		,MATERIALISSUEBIN
		,MORECEIPTBIN
		,REPAIRISSUESBIN
		,ReplenishmentLevel
		,POPOrderMethod
		,MasterLocationCode
		,POPVendorSelection
		,POPPricingSelection
		,PurchasePrice
		,IncludeAllocations
		,IncludeBackorders
		,IncludeRequisitions
		,PICKTICKETITEMOPT
		,INCLDMRPMOVEIN
		,INCLDMRPMOVEOUT
		,INCLDMRPCANCEL
		,Move_Out_Fence
	)
	SELECT
		 edfItem		--ITEMNMBR
		,edfLocation	--LOCNCODE
		,2				--RCRDTYPE
		,''				--PRIMVNDR
		,0				--ITMFRFLG
		,0				--BGNGQTY
		,0				--LSORDQTY
		,'1900-01-01 00:00:00.000'				--LSTORDDT
		,''				--LSORDVND
		,'1900-01-01 00:00:00.000'				--LSRCPTDT
		,0				--QTYRQSTN
		,0				--QTYONORD
		,0				--QTYBKORD
		,0				--QTY_Drop_Shipped
		,0				--QTYINUSE
		,0				--QTYINSVC
		,0				--QTYRTRND
		,0				--QTYDMGED
		,0				--QTYONHND
		,0				--ATYALLOC
		,0				--QTYCOMTD
		,0				--QTYSOLD
		,'1900-01-01 00:00:00.000'				--NXTCNTDT
		,'1900-01-01 00:00:00.000'				--NXTCNTTM
		,'1900-01-01 00:00:00.000'				--LSTCNTDT
		,'1900-01-01 00:00:00.000'				--LSTCNTTM
		,0				--STCKCNTINTRVL
		,''				--Landed_Cost_Group_ID
		,''				--BUYERID
		,''				--PLANNERID
		,1				--ORDERPOLICY
		,0				--FXDORDRQTY
		,0				--ORDRPNTQTY
		,1				--NMBROFDYS
		,0				--MNMMORDRQTY
		,0				--MXMMORDRQTY
		,1				--ORDERMULTIPLE
		,2				--REPLENISHMENTMETHOD
		,0				--SHRINKAGEFACTOR
		,0				--PRCHSNGLDTM
		,0				--MNFCTRNGFXDLDTM
		,0				--MNFCTRNGVRBLLDTM
		,0				--STAGINGLDTME
		,0				--PLNNNGTMFNCDYS
		,0				--DMNDTMFNCPRDS
		,1				--INCLDDINPLNNNG
		,0				--CALCULATEATP
		,0				--AUTOCHKATP
		,0				--PLNFNLPAB
		,3				--FRCSTCNSMPTNPRD
		,0				--ORDRUPTOLVL
		,0				--SFTYSTCKQTY
		,0				--REORDERVARIANCE
		,''				--PORECEIPTBIN
		,''				--PORETRNBIN
		,''				--SOFULFILLMENTBIN
		,''				--SORETURNBIN
		,''				--BOMRCPTBIN
		,''				--MATERIALISSUEBIN
		,''				--MORECEIPTBIN
		,''				--REPAIRISSUESBIN
		,1				--ReplenishmentLevel
		,1				--POPOrderMethod
		,''				--MasterLocationCode
		,1				--POPVendorSelection
		,1				--POPPricingSelection
		,0				--PurchasePrice
		,1				--IncludeAllocations
		,1				--IncludeBackorders
		,1				--IncludeRequisitions
		,3				--PICKTICKETITEMOPT
		,1				--INCLDMRPMOVEIN
		,1				--INCLDMRPMOVEOUT
		,1				--INCLDMRPCANCEL
		,0				--Move_Out_Fence
	FROM @ItemSiteInsert
END


-- Validate the Project Budgets.
-- Since it is possible that the batch can contain more than one update against the same project/cost category we must
-- sum these values together!




IF (@xstrSource IS NOT NULL AND @xstrSource <> '')
BEGIN

	DELETE dbo.WCTEMPVCValidate FROM dbo.WCTEMPVCValidate  WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID
	
	INSERT INTO dbo.WCTEMPVCValidate
	(
		 idfOwnerSPID            
		,idfOwnerCreated         
		,idfOwnerProcess         
		,idfPTICompanyKey        
		,idfQty                  
		,idfQtyHdr             
		,idfRowKey               
		,idfVCHeaderKey          
		,edfAmtHomeExtended  
		,edfAmtHomeExtendedHdr    
		,edfItem                 
		,edfVendor               
		,edfVendorItem           
		,vdfOldAmountHomeExtended
		,vdfOldAmountHomeExtendedHdr
		,vdfOldItem              
		,vdfOldQty   
		,vdfOldQtyHdr            
		,vdfOldVCHeaderKey       
		,idfDateRequired
	)
	SELECT
		 @@SPID
		,GETDATE()
		,'spRQFNAValidate'
		,VAL.idfPTICompanyKey	
		,VALSUM.idfQty
		,VALSUMHDR.idfQty
		,VAL.idfRowKey		
        ,VAL.idfVCHeaderKey
		,VALSUM.edfAmtHomeExtended	
		,VALSUMHDR.edfAmtHomeExtended
		,VAL.edfItem	
        ,VAL.edfVendor
        ,VAL.edfVendorItem
		,VALSUM.vdfOldAmountHomeExtended
		,VALSUMHDR.vdfOldAmountHomeExtended
        ,VAL.vdfOldItem
		,VALSUM.vdfOldQty
		,VALSUMHDR.vdfOldQty
        ,VAL.vdfOldVCHeaderKey	
        ,VAL.idfDateRequired
	FROM dbo.WCTEMPRQFNAValidate VAL WITH (NOLOCK INDEX=WCTEMPRQFNAValidate3)
		INNER JOIN (SELECT SUM(idfQty) AS 'idfQty',SUM(edfAmtHomeExtended) AS 'edfAmtHomeExtended',
				SUM(vdfOldQty) AS 'vdfOldQty',SUM(vdfOldAmountHomeExtended) AS 'vdfOldAmountHomeExtended', idfVCHeaderKey, edfItem FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate3) WHERE idfOwnerSPID = @@SPID 
				GROUP BY idfVCHeaderKey, edfItem) AS VALSUM ON VAL.idfVCHeaderKey=VALSUM.idfVCHeaderKey AND VAL.edfItem=VALSUM.edfItem
		INNER JOIN (SELECT SUM(idfQty) AS 'idfQty',SUM(edfAmtHomeExtended) AS 'edfAmtHomeExtended',
				SUM(vdfOldQty) AS 'vdfOldQty',SUM(vdfOldAmountHomeExtended) AS 'vdfOldAmountHomeExtended', idfVCHeaderKey FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=WCTEMPRQFNAValidate3) WHERE idfOwnerSPID = @@SPID 
				GROUP BY idfVCHeaderKey) AS VALSUMHDR ON VAL.idfVCHeaderKey=VALSUMHDR.idfVCHeaderKey 
	WHERE VAL.idfOwnerSPID = @@SPID AND VAL.idfVCHeaderKey <> 0 AND VAL.idfVCHeaderKey IS NOT NULL

	EXEC dbo.spVCValidate @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xonWCValHdrKey OUTPUT,@xstrSource

	UPDATE dbo.WCTEMPRQFNAValidate
	SET  edfVendor			= WCTEMPVCValidate.edfVendor
		,edfVendorItem		= WCTEMPVCValidate.edfVendorItem
	FROM dbo.WCTEMPRQFNAValidate W  WITH (NOLOCK INDEX=WCTEMPRQFNAValidate4)
		INNER JOIN dbo.WCTEMPVCValidate WITH (NOLOCK INDEX=WCTEMPVCValidate0) ON WCTEMPVCValidate.idfOwnerSPID = @@SPID AND W.idfRowKey = WCTEMPVCValidate.idfRowKey
	WHERE W.idfOwnerSPID = @@SPID  

	DELETE dbo.WCTEMPVCValidate FROM dbo.WCTEMPVCValidate WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID

	DELETE dbo.WCTEMPBUDValidate FROM dbo.WCTEMPBUDValidate WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID
	INSERT INTO dbo.WCTEMPBUDValidate
	(
		 idfOwnerSPID            
		,idfOwnerCreated         
		,idfOwnerProcess         
		,idfBUDPeriodKey         
		,idfPTICompanyKey        
		,idfRowKey               
		,edfAmtHomeExtended      
		,vdfOldAmountHomeExtended
		,vdfOldBUDPeriodKey      
	)
	SELECT
		 @@SPID
		,GETDATE()
		,'spRQFNAValidate' 
        ,VAL.idfBUDPeriodKey
		,VAL.idfPTICompanyKey	
		,VAL.idfRowKey		
		,VALSUM.edfAmtHomeExtended	
		,VALSUM.vdfOldAmountHomeExtended
        ,VAL.vdfOldBUDPeriodKey	
	FROM dbo.WCTEMPRQFNAValidate VAL WITH (NOLOCK INDEX=idfOwnerSPID)
		INNER JOIN (SELECT SUM(edfAmtHomeExtended) AS 'edfAmtHomeExtended',
				SUM(vdfOldAmountHomeExtended) AS 'vdfOldAmountHomeExtended', idfBUDPeriodKey FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID
				GROUP BY idfBUDPeriodKey) AS VALSUM 
			ON VAL.idfBUDPeriodKey=VALSUM.idfBUDPeriodKey
	WHERE VAL.idfOwnerSPID = @@SPID AND VAL.idfBUDPeriodKey <> 0 AND VAL.idfBUDPeriodKey IS NOT NULL

	EXEC dbo.spBUDValidate @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xonWCValHdrKey OUTPUT,@xstrSource
	
	DELETE dbo.WCTEMPBUDValidate FROM dbo.WCTEMPBUDValidate WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID
END

-- ------------------------------------------------------------------------------------------------------------------------
-- Validate GL Segment
-- ------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------	

DECLARE @nidfWCUDFTemplateKey INT, @nWCValHdrKey INT


	--If System Setting is Active Set all vendors to offset days
	SELECT @nRQOVERRIDEWITHEXPECTEDDAYS = ISNULL(idfValue,0) FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RQOVERRIDEWITHEXPECTEDDAYS'
	IF (@nRQOVERRIDEWITHEXPECTEDDAYS = 1)
	BEGIN
		IF @xstrSource = 'ENTRY'
			UPDATE dbo.WCTEMPRQFNAValidate SET idfDatePromised = idfRQDate + idfDatePromisedOffset
			FROM dbo.WCTEMPRQFNAValidate TMP WITH (NOLOCK INDEX=idfOwnerSPID)
			INNER JOIN dbo.RQHeader WITH (NOLOCK) ON TMP.idfRQHeaderKey = RQHeader.idfRQHeaderKey
			INNER JOIN dbo.APVendor WITH (NOLOCK) ON APVendor.idfVendorID = TMP.edfVendor
			WHERE idfOwnerSPID=@@SPID AND idfDatePromisedOffset > 0
		ELSE IF @xstrSource = 'APPROVAL'
			UPDATE dbo.WCTEMPRQFNAValidate SET idfDatePromised = idfRQDate + idfDatePromisedOffset
			FROM dbo.WCTEMPRQFNAValidate TMP WITH (NOLOCK INDEX=idfOwnerSPID)
			INNER JOIN dbo.RQAprDtlRQHeader WITH (NOLOCK) ON TMP.idfRQAprDtlRQHeaderKey = RQAprDtlRQHeader.idfRQAprDtlRQHeaderKey
			INNER JOIN dbo.APVendor WITH (NOLOCK) ON APVendor.idfVendorID = TMP.edfVendor
			WHERE idfOwnerSPID=@@SPID AND idfDatePromisedOffset > 0
		ELSE IF @xstrSource = 'REVIEW'
			UPDATE dbo.WCTEMPRQFNAValidate SET idfDatePromised = idfRQDate + idfDatePromisedOffset
			FROM dbo.WCTEMPRQFNAValidate TMP WITH (NOLOCK INDEX=idfOwnerSPID)
			INNER JOIN dbo.RQRevDtlRQHeader WITH (NOLOCK) ON TMP.idfRQRevDtlRQHeaderKey = RQRevDtlRQHeader.idfRQRevDtlRQHeaderKey
			INNER JOIN dbo.APVendor WITH (NOLOCK) ON APVendor.idfVendorID = TMP.edfVendor
			WHERE idfOwnerSPID=@@SPID AND idfDatePromisedOffset > 0
	END
	EXEC spRQFNAValidateAfter '',0,'',@xonWCValHdrKey OUTPUT,@xstrSource

	DELETE #spRQFNAValidate
	INSERT INTO #spRQFNAValidate
	(idfRQDetailKey,idfBudgetApplyDate,idfCommentInternal,idfCurrLineUpSeq,idfDatePromised,idfDateRequired
	,idfFlagBlanketPO,idfFlagManualDist,idfLine,idfLogKey,idfQty,idfQtyPrec,idfSessionLinkKey,idfURLReference
	,idfDateCreated,idfDateModified,idfBUDPeriodKey,idfRQHeaderKey,idfRQMemoKey,idfRQPriorityKey,idfRQSessionKey
	,idfPTICompanyKey,idfVCHeaderKey,idfWCDeptKey,idfWCLineUpKey,idfWCRRGroupLineUpKey,idfWCSecurityDelegateKey
	,edfAmtAprExtended,edfAmtExtended,edfAmtHomeExtended,edfPrice,edfPricePrec,edfAnalysisGroup,edfBuyer
	,edfCurrency,edfDropShip,edfDropShipCustomer,edfENCBreakDown,edfENCProjectID,edfENCGrantID,edfENCUserDefined1
	,edfENCUserDefined2,edfENCUserDefined3,edfENCUserDefined4,edfENCUserDefined5,edfENCUserDefined6,edfENCUserDefined7
	,edfGL,edfItem,edfItemDesc,edfLocation,edfLocationFrom,edfPABudgetAuthCost,edfPABudgetAuthQty,edfPALineItemSeq
	,edfPAProjectL1,edfPAProjectL2,edfPAProjectL3,edfPaymentTerm,edfPOLine,edfPONumber,edfShipMethod,edfShipTo,edfTranType
	,edfUOM,edfVendor,edfVendorItem,edfWSProductIndicator,udfDateField01,udfDateField02,udfDateField03,udfDateField04
	,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02
	,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08
	,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05
	,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10,vdfBudgetValid,vdfBudgetID,vdfComment
	,vdfDeptID,vdfContractID,vdfGL,idfRowKey,idfRowAction,idfCodeRev,idfRQAprDtlRQHeaderKey,idfRQRevDtlRQHeaderKey
	,idfWCSecurityKey,vdfOldAmountHomeExtended,vdfOldQty,vdfOldVCHeaderKey,vdfOldItem,vdfOldBUDPeriodKey,edfPriceHome
	,vdfExchangeRate,vdfRateDate,vdfRateTime,vdfRateCal,vdfRateType,vdfRateTable,idfFlagVCOverride,edfManuItem
	,edfFacilityID,edfFacilityIDFrom,edfDocumentID,edfVendorAddrID,idfRateHome,idfWCTaxScheduleHdrKey,idfGLSegmentHash
	,idfAmtDiscount,idfAmtDiscountApr,idfAmtDiscountHome,idfAmtFreight,idfAmtFreightApr,idfAmtFreightHome,idfAmtMisc
	,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,idfAmtTax,idfAmtTaxApr,idfAmtTaxHome
	,vdfOldGL,idfEXPTypeKey,vdfTypeID,vdfTaxTypeID,idfAPTaxTypeDtlKey)
	SELECT idfRQDetailKey,idfBudgetApplyDate,idfCommentInternal,idfCurrLineUpSeq,idfDatePromised,idfDateRequired
	,idfFlagBlanketPO,idfFlagManualDist,idfLine,idfLogKey,idfQty,idfQtyPrec,idfSessionLinkKey,idfURLReference
	,idfDateCreated,idfDateModified,idfBUDPeriodKey,idfRQHeaderKey,idfRQMemoKey,idfRQPriorityKey,idfRQSessionKey
	,idfPTICompanyKey,idfVCHeaderKey,idfWCDeptKey,idfWCLineUpKey,idfWCRRGroupLineUpKey,idfWCSecurityDelegateKey
	,edfAmtAprExtended,edfAmtExtended,edfAmtHomeExtended,edfPrice,edfPricePrec,edfAnalysisGroup,edfBuyer
	,edfCurrency,edfDropShip,edfDropShipCustomer,edfENCBreakDown,edfENCProjectID,edfENCGrantID,edfENCUserDefined1
	,edfENCUserDefined2,edfENCUserDefined3,edfENCUserDefined4,edfENCUserDefined5,edfENCUserDefined6,edfENCUserDefined7
	,edfGL,edfItem,edfItemDesc,edfLocation,edfLocationFrom,edfPABudgetAuthCost,edfPABudgetAuthQty,edfPALineItemSeq
	,edfPAProjectL1,edfPAProjectL2,edfPAProjectL3,edfPaymentTerm,edfPOLine,edfPONumber,edfShipMethod,edfShipTo,edfTranType
	,edfUOM,edfVendor,edfVendorItem,edfWSProductIndicator,udfDateField01,udfDateField02,udfDateField03,udfDateField04
	,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02
	,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08
	,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05
	,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10,vdfBudgetValid,vdfBudgetID,vdfComment
	,vdfDeptID,vdfContractID,vdfGL,idfRowKey,idfRowAction,idfCodeRev,idfRQAprDtlRQHeaderKey,idfRQRevDtlRQHeaderKey
	,idfWCSecurityKey,vdfOldAmountHomeExtended,vdfOldQty,vdfOldVCHeaderKey,vdfOldItem,vdfOldBUDPeriodKey,edfPriceHome
	,vdfExchangeRate,vdfRateDate,vdfRateTime,vdfRateCal,vdfRateType,vdfRateTable,idfFlagVCOverride,edfManuItem
	,edfFacilityID,edfFacilityIDFrom,edfDocumentID,edfVendorAddrID,idfRateHome,idfWCTaxScheduleHdrKey,idfGLSegmentHash
	,idfAmtDiscount,idfAmtDiscountApr,idfAmtDiscountHome,idfAmtFreight,idfAmtFreightApr,idfAmtFreightHome,idfAmtMisc
	,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,idfAmtTax,idfAmtTaxApr,idfAmtTaxHome
	,vdfOldGL,idfEXPTypeKey,vdfTypeID,vdfTaxTypeID,idfAPTaxTypeDtlKey
	FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID)
	WHERE idfOwnerSPID=@@SPID
	OPTION (KEEP PLAN,KEEPFIXED PLAN)

	IF @@ERROR <> 0
		RAISERROR ('spRQFNAValidate:300',1,1)

	DELETE dbo.WCTEMPRQFNAValidate FROM dbo.WCTEMPRQFNAValidate WITH (NOLOCK INDEX=idfOwnerSPID) WHERE idfOwnerSPID = @@SPID

IF @xonErrNum IS NULL OR @xonErrNum = 0
BEGIN
	IF @xonWCValHdrKey IS NULL
		SELECT @xonErrNum = 0
     	ELSE
  		SELECT @xonErrNum = @xonWCValHdrKey
END

RETURN (0)

