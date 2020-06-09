-- Paramount Technologies, Inc. $Version: WorkPlace_08.02.00 $  - $Revision: 30 $ $Modtime: 3/01/06 5:00p $
ALTER PROCEDURE spEXPValidate
 @xochErrSP				CHAR(32)      	= ''	OUTPUT
,@xonErrNum				INT          	= 0		OUTPUT
,@xostrErrInfo			VARCHAR(255) 	= ''	OUTPUT
,@xonWCValHdrKey		INT				= NULL 	OUTPUT
,@xstrSource			CHAR(20)		= NULL	-- ENTRY, ENTRY_POST, APPROVAL, REVIEW, UDFTEMPLATEF, DISTRIBUTION, ATTENDEE_ENTRY, ATTENDEE_APPROVAL
,@xnidfWCSecurityKey	INT				= NULL
,@xstrGUID				VARCHAR(64)		= ''
AS
DECLARE
 @n__idfRowKey					INT
,@stridfComment					VARCHAR(8000)
,@dt_idfDay						DATETIME
,@stridfDescription				VARCHAR(30)
,@n__idfQuantity				NUMERIC(19, 5)
,@n__idfEXPExpenseSheetHdrKey	INT
,@n__idfEXPPaymentKey			INT
,@n__idfEXPTypeKey				INT
,@n__idfWCDeptKey				INT
,@n__idfWCUDFListDtlKey02		INT
,@n__edf1099Amount				NUMERIC(19, 5)
,@n__edfAmtAprExtended			NUMERIC(19, 5)
,@n__edfAmtExtended				NUMERIC(19, 5)
,@n__edfAmtHomeExtended			NUMERIC(19, 5)
,@n__edfFreight					NUMERIC(19, 5)
,@n__edfMiscCharges				NUMERIC(19, 5)
,@n__edfPrice					NUMERIC(19, 5)
,@n__idfAmtTax					NUMERIC(19, 5)
,@stredfTax						VARCHAR(10)
,@strvdfTaxScheduleID			VARCHAR(60)
,@strvdfCountryID				VARCHAR(10)
,@nWCCountryKey					INT
,@stredfCurrency            	CHAR(15)
,@nidfGLAccountKey				INT
,@nidfAPVendorKey				INT
,@strvdfVendorID				VARCHAR(60)
,@strvdfGL						VARCHAR(129)


,@stredfBillType            	CHAR(3)
,@stredfCardName				CHAR(15)
,@stredfPAProjectL1				VARCHAR(11)
,@stredfPAProjectL1Class		VARCHAR(15)
,@stredfPAProjectL2				VARCHAR(17)
,@stredfPAProjectL2Class		VARCHAR(15)
,@stredfPAProjectL3				VARCHAR(27)
,@stredfPAProjectL3Class		VARCHAR(15)
,@nedfWSProductIndicator		INT
,@stredfShippingMethod      	CHAR(15)
,@stredfTaxSchedule         	CHAR(15)
,@stredfUOM                 	CHAR(9)
,@stredfFacilityID				VARCHAR(67)

,@nidfAmtExtendedReceipt		NUMERIC(19,5)
,@strvdfPaymentID				CHAR(20)
,@strvdfTypeID					CHAR(20)
,@strvdfProjectID				VARCHAR(32)
,@strvdfPhaseID					VARCHAR(20)
,@strvdfActivityID				VARCHAR(20)
,@strvdfID						CHAR(20)
,@strvdfDeptID					CHAR(20)
,@nidfWCUDFListHdrKey			INT
,@nidfFlagForced				INT
,@nidfWCUDFTemplateKey			INT
,@nvdfExchangeRate				NUMERIC(19,5)
,@strvdfRateType 				VARCHAR(255)
,@strvdfRateTable 				VARCHAR(255)
,@nvdfRateCal 					INT
,@strvdfRateDate 				VARCHAR(15)
,@strvdfRateTime 				VARCHAR(15)
,@strWCSystem_edfCurrencyApproval VARCHAR(15)
,@n__edfPriceApproval			NUMERIC(19,5)
,@n__edf1099AmountHome			NUMERIC(19,5)
,@n__edfFreightHome				NUMERIC(19,5)
,@n__edfMiscChargesHome			NUMERIC(19,5)
,@n__edfPriceHome				NUMERIC(19,5)
,@n__edf1099AmountApr			NUMERIC(19,5)
,@n__edfFreightApr				NUMERIC(19,5)
,@n__edfMiscChargesApr			NUMERIC(19,5)
,@n__edfPriceApr				NUMERIC(19,5)
,@dtTETimePeriod_idfPeriodBegin DATETIME
,@dtTETimePeriod_idfPeriodEnd	DATETIME
,@stridfEmployeeID				VARCHAR(60)
,@nEmployee__idfWCSecurityKey	INT
,@nidfDailyPerDiem				NUMERIC(19,5)
,@nidfDailyPerDiemSUM			NUMERIC(19,5)
,@nidfFlagImported				INT
,@nidfFlagManualDist			INT
,@stridfImportedRefNo			NVARCHAR(255)
,@nidfWCImportMapKey			INT
,@edfGL							INT
,@strOVERLAY_OverlayString		VARCHAR(255)
,@strOVERLAY_GLString			VARCHAR(255)
,@n__OVERLAY_NewGL				INT
,@nBREAKONEXCHRATE				INT 
,@dt_EXidfDay					DATETIME
,@nidfFlagEXPRestrictByPhaseActivity	INT
,@nidfFlagEXPRestrictByPhase			INT
,@nidfFlagEXPRestrictByProject			INT				
,@nidfFlagEXPRestrictByActivity			INT
,@nWCValHdrKey							INT
,@nidfEXPExpenseSheetDtlKey				INT
,@nEXPREIMBURSEMENTCURR					INT
,@strReimCurrencyID						CHAR(15)	
,@strHomeCurrencyID						CHAR(15)
,@n__edfAmtHomeExtendedUnRound			NUMERIC(19,5)
,@nedfAmtReimExtended					NUMERIC(19,5)
,@n__edfAmtExtendedUnRound				NUMERIC(19,5)
,@nDEPLCUR								INT
,@nEXPLINESOUTSIDETIME					INT
,@nidfFlagEXPRequireTimePeriod			INT
,@stridfRowAction						VARCHAR(3)
,@nidfWCICCompanyKeySource				INT
,@strRemoveAprVal						VARCHAR(5)
,@nidfEXPSessionKey						INT
,@nidfFlagEXPEditFromApr				INT
,@nidfWCSecurityKey						INT
,@nidfEXPExpenseSheetDtlKeyTravel		INT
,@strvdfCompanyCodeTarget				VARCHAR(60)
,@nidfWCICCompanyKeyTarget				INT
,@stridfCodeApr							VARCHAR(60)
,@nidfAmtSubtotal						NUMERIC(19,5)
,@nidfPTICurrencyKeyReim				INT
,@strvdfCurrencyIDReim					VARCHAR(60)
,@strvdfCurrencyIDReceipt				VARCHAR(60)
,@nRateTypeKeyApr						INT
,@xstrRateType							VARCHAR(60)
,@nidfPTICurrencyKeyHome				INT
,@strvdfCurrencyIDHome					VARCHAR(60)
,@strvdfCurrencyID						VARCHAR(60)
,@nidfPTICurrencyKeyReceipt				INT
,@nidfBUDHeaderKey						INT
,@dtidfBudgetApplyDate					DATETIME
,@strvdfBudgetID						CHAR(20)
,@nvdfBudgetValid						INT
,@nCOGsAccount							INT
,@nWIPAccount							INT
,@nPA01201_PAProjectType				INT
,@nPA01201_PAAcctgMethod				INT
,@nPA01201_PAbllngtype					INT
,@nPurchAccount							INT
,@nEXPALLOWMULTIPLETRAVEL				INT
,@nvdfGLExists							INT
,@nidfPTICurrencyKey					INT
,@nidfEXPEventKey						INT
,@strvdfEventID							VARCHAR(20)
,@nidfAmount							NUMERIC(19,5)
,@nidfPercent							NUMERIC(19,5)
,@nDistKey								INT
,@nidfGL								INT
,@nidfAmountHome						NUMERIC(19,5)
,@nidfGLPeriodKey						INT
,@nidfGLSegmentDtlKey01					INT
,@nidfGLSegmentDtlKey02					INT
,@nidfGLSegmentDtlKey03					INT
,@nidfGLSegmentDtlKey04					INT
,@nidfGLSegmentDtlKey05					INT
,@nidfGLSegmentDtlKey06					INT
,@nidfGLSegmentDtlKey07					INT
,@nidfGLSegmentDtlKey08					INT
,@nidfGLSegmentDtlKey09					INT
,@nidfGLSegmentDtlKey10					INT
,@nidfGLSegmentDtlKey11					INT
,@nidfGLSegmentDtlKey12					INT
,@nidfGLSegmentDtlKey13					INT
,@nidfGLSegmentDtlKey14					INT
,@nidfGLSegmentDtlKey15					INT
,@nidfFlagPrimary						INT
,@nidfCount								INT
,@nidfTotalCount						INT
,@nedfPrecision							INT
,@nidfSourceKey							INT
,@nidfAmountRd							NUMERIC(19,5)

--
SET NOCOUNT ON
--
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


SELECT @nEXPREIMBURSEMENTCURR = idfValue FROM WCSystemSetting WHERE idfSettingID = 'EXPREIMBURSEMENTCURR'
SELECT @strReimCurrencyID = edfCurrencyID FROM vwFNACurrency WITH (NOLOCK) WHERE idfPTICurrencyKey = @nEXPREIMBURSEMENTCURR
SELECT @strHomeCurrencyID = edfCurrencyID FROM vwFNACurrency WITH (NOLOCK) WHERE edfFunctional = 1
SELECT @nEXPLINESOUTSIDETIME = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPLINESOUTSIDETIME'
SELECT @nidfFlagEXPRequireTimePeriod = idfFlagEXPRequireTimePeriod FROM dbo.WCSystem WITH (NOLOCK)
SELECT @nEXPALLOWMULTIPLETRAVEL = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPALLOWMULTIPLETRAVEL'

SET @nidfWCSecurityKey = dbo.fnWCSecurity('KEY')
EXEC @nidfFlagEXPEditFromApr = spWCSecurityAccessGet @nidfWCSecurityKey,'EXPEDITFROMAPR',@xnHideOutput=1
IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPREMOVEAPRVALIDATION' AND idfValue = 1) AND @nidfFlagEXPEditFromApr = 0
	SET @strRemoveAprVal = 'TRUE'
ELSE
	SET @strRemoveAprVal = 'FALSE'

	CREATE TABLE #AttendeeTable
	(
		 idfGLOverlayMask	VARCHAR(255)
		,idfAmount			NUMERIC(19,5)
		,idfPercent			NUMERIC(19,5)
		,idfCount			INT
		,idfTotalCount		INT
		,idfSourceKey		INT
		,idfAmountTotal		NUMERIC(19,5)
		,idfAmountRem		NUMERIC(19,5)
		,idfRowKey			INT
	)

	CREATE TABLE #AttendeeTableDist
	(
		 idfGLOverlayMask	VARCHAR(255)
		,idfAmount			NUMERIC(19,5)
		,idfPercent			NUMERIC(19,5)
		,idfCount			INT
		,idfTotalCount		INT
		,idfSourceKey		INT
		,idfAmountTotal		NUMERIC(19,5)
		,idfAmountRem		NUMERIC(19,5)
		,idfRowKey			INT
	)

	CREATE TABLE #DtlDistribution 
	(
		  idfKey						INT IDENTITY(0,1)
		, idfAmtExtended                numeric(19, 5)    
		, idfAmtExtendedHome            numeric(19, 5)    
		, idfFlagPrimary                int               
		, idfPercent                    numeric(19, 5)        
		, idfGLAccountKey               int      
		, idfSourceKey					int        
	) 

--{$xml_tem plate ImportID="StandardTemplates" TemplateID="CreateTempTablespEXPFNAValidate" TableName="spEXPValidateWork" ExcludedColumns=""}
	CREATE TABLE #spEXPValidateWork
	(
		idfEXPExpenseSheetDtlKey INT,idfAmtExtendedReceipt NUMERIC(19, 5),idfAmtExtendedTravelAllocated NUMERIC(19, 5),idfAmtFreightApr NUMERIC(19, 5),idfAmtFreightHome NUMERIC(19, 5),idfAmtMiscApr NUMERIC(19, 5),idfAmtMiscHome NUMERIC(19, 5),idfAmtSubTotal 
		NUMERIC(19, 5),idfAmtSubTotalApr NUMERIC(19, 5),idfAmtSubTotalHome NUMERIC(19, 5),idfAmtTax NUMERIC(19, 5),idfAmtTaxApr NUMERIC(19, 5),idfAmtTaxHome NUMERIC(19, 5),idfAmtTaxIncluded NUMERIC(19, 5),idfAmtTaxIncludedApr NUMERIC(19, 5),idfAmtTaxIncludedHome 
		NUMERIC(19, 5),idfBudgetApplyDate DATETIME,idfComment TEXT,idfCurrLineUpSeq INT,idfDay DATETIME,idfDescription VARCHAR(255),idfFlagImported INT,idfFlagManualDist INT,idfFlagOutsidePeriod INT,idfFlagSplit INT,idfImportedRefNo NVARCHAR(510),idfLine INT,
		idfQuantity NUMERIC(19, 5),idfRateHome NUMERIC(19, 5),idfRateReimCalc NUMERIC(19, 5),idfRateReimSystem NUMERIC(19, 5),idfDateCreated DATETIME,idfDateModified DATETIME,idfAPVendorKey INT,idfAPVoucherDtlKeyCM INT,idfBUDHeaderKey INT,idfEXPCreditCardKey INT,idfEXPExpenseSheetDtlKeyTravel INT,
		idfEXPExpenseSheetHdrKey INT,idfEXPPaymentKey INT,idfEXPSessionKey INT,idfEXPTypeKey INT,idfGLAccountKey INT,idfPABillTypeKey INT,idfPAPhaseActivityKey INT,idfPAProjectKey INT,idfPAProjectPhaseKey INT,idfPTICurrencyKey INT,idfPTICurrencyKeyReceipt INT,idfSessionLinkKey INT,idfWCCountryKey INT,
		idfWCDeptKey INT,idfWCICCompanyKeySource INT,idfWCICCompanyKeyTarget INT,idfWCImportMapKey INT,idfWCLineUpKey INT,idfWCRRGroupLineUpKey INT,idfWCShippingMethodKey INT,idfWCTaxScheduleHdrKey INT,edf1099Amount NUMERIC(19, 5),edfAmtAprExtended NUMERIC(19, 5),edfAmtExtended NUMERIC(19, 5),
		edfAmtHomeExtended NUMERIC(19, 5),edfAmtReimExtended NUMERIC(19, 5),edfDocument01 NVARCHAR(510),edfDocument02 NVARCHAR(510),edfFreight NUMERIC(19, 5),edfMiscCharges NUMERIC(19, 5),edfPrice NUMERIC(19, 5),edfTax VARCHAR(10),edfBillType CHAR(3),edfCardName VARCHAR(15),edfCurrency CHAR(15),
		edfDocLine INT,edfDocNo VARCHAR(17),edfFacilityID VARCHAR(67),edfGL INT,edfPAProjectL1 VARCHAR(11),edfPAProjectL2 VARCHAR(17),edfPAProjectL3 VARCHAR(27),edfShippingMethod CHAR(15),edfTaxSchedule CHAR(15),edfUOM CHAR(9),edfWSProductIndicator INT,udfDateField01 DATETIME,udfDateField02 DATETIME,
		udfDateField03 DATETIME,udfDateField04 DATETIME,udfDateField05 DATETIME,udfLargeTextField01 VARCHAR(255),udfLargeTextField02 VARCHAR(255),udfLargeTextField03 VARCHAR(255),udfNumericField01 NUMERIC(19, 5),udfNumericField02 NUMERIC(19, 5),udfNumericField03 NUMERIC(19, 5),udfNumericField04 NUMERIC(19, 5),udfNumericField05 NUMERIC(19, 5),
		udfNumericField06 NUMERIC(19, 5),udfNumericField07 NUMERIC(19, 5),udfNumericField08 NUMERIC(19, 5),udfNumericField09 NUMERIC(19, 5),udfNumericField10 NUMERIC(19, 5),udfTextField01 VARCHAR(60),udfTextField02 VARCHAR(60),udfTextField03 VARCHAR(60),udfTextField04 VARCHAR(60),udfTextField05 VARCHAR(60),
		udfTextField06 VARCHAR(60),udfTextField07 VARCHAR(60),udfTextField08 VARCHAR(60),udfTextField09 VARCHAR(60),udfTextField10 VARCHAR(60),idfEXPEventKey INT,vdfEXPExpenseSheetDtlKeyDuplicatedFrom INT,vdfEXPMobileExpenseKey INT,vdfCurrencyID VARCHAR(20),vdfCurrencyIDReceipt VARCHAR(20),vdfCurrencyIDReim VARCHAR(20),
		vdfBudgetID CHAR(20),vdfCompanyCodeSource VARCHAR(60),vdfCompanyCodeTarget VARCHAR(60),vdfCountryID VARCHAR(10),vdfDeptID CHAR(20),vdfEventID VARCHAR(20),vdfPaymentID CHAR(20),vdfShippingMethodID NVARCHAR(80),vdfTaxScheduleID NVARCHAR(120),vdfGL CHAR(129),vdfTypeID CHAR(20),vdfVendorID NVARCHAR(60),idfRowKey INT
		,idfRowAction				CHAR(2)
		,idfTETimePeriodKey			INT
		,idfWCUDFListDtlKey02		INT
		,idfWCSecurityKey			INT
		,edfPAProjectL1Class		VARCHAR(11)
		,edfPAProjectL2Class		VARCHAR(17)
		,edfPAProjectL3Class		VARCHAR(27)
		,vdfID 						VARCHAR(20)
		,idfEXPEntryTypeKey			INT
		,HDR_idfWCSecurityKeyCreated INT
		,idfCodeApr                 char(8)
		,idfAmtHomeExtOld			NUMERIC(19,5)
		,idfBUDHeaderKeyOld			INT
		,idfBudgetApplyDateOld		DATETIME
		,vdfBudgetValid				INT
		,idfTableLinkKey			INT
    )
  
IF @@ERROR <> 0 
	RAISERROR ('spEXPValidate:100',1,1)

EXEC sp_executesql N'INSERT INTO #spEXPValidateWork
SELECT
	idfEXPExpenseSheetDtlKey,idfAmtExtendedReceipt,idfAmtExtendedTravelAllocated,idfAmtFreightApr,idfAmtFreightHome,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,idfAmtTax,idfAmtTaxApr,idfAmtTaxHome,idfAmtTaxIncluded,idfAmtTaxIncludedApr,
	idfAmtTaxIncludedHome,idfBudgetApplyDate,idfComment,idfCurrLineUpSeq,idfDay,idfDescription,idfFlagImported,idfFlagManualDist,idfFlagOutsidePeriod,idfFlagSplit,idfImportedRefNo,idfLine,idfQuantity,idfRateHome,idfRateReimCalc,idfRateReimSystem,
	idfDateCreated,idfDateModified,idfAPVendorKey,idfAPVoucherDtlKeyCM,idfBUDHeaderKey,idfEXPCreditCardKey,idfEXPExpenseSheetDtlKeyTravel,idfEXPExpenseSheetHdrKey,idfEXPPaymentKey,idfEXPSessionKey,idfEXPTypeKey,idfGLAccountKey,idfPABillTypeKey,idfPAPhaseActivityKey,
	idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyKeyReceipt,idfSessionLinkKey,idfWCCountryKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCImportMapKey,idfWCLineUpKey,idfWCRRGroupLineUpKey,idfWCShippingMethodKey,
	idfWCTaxScheduleHdrKey,edf1099Amount,edfAmtAprExtended,edfAmtExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,edfFreight,edfMiscCharges,edfPrice,edfTax,edfBillType,edfCardName,edfCurrency,edfDocLine,edfDocNo,edfFacilityID,
	edfGL,edfPAProjectL1,edfPAProjectL2,edfPAProjectL3,edfShippingMethod,edfTaxSchedule,edfUOM,edfWSProductIndicator,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,
	udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,
	udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfEXPEventKey,vdfEXPExpenseSheetDtlKeyDuplicatedFrom,vdfEXPMobileExpenseKey,vdfCurrencyID,vdfCurrencyIDReceipt,vdfCurrencyIDReim,vdfBudgetID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfCountryID,
	vdfDeptID,vdfEventID,vdfPaymentID,vdfShippingMethodID,vdfTaxScheduleID,vdfGL,vdfTypeID,vdfVendorID,idfRowKey
	,idfRowAction		
	,idfTETimePeriodKey	
	,idfWCUDFListDtlKey02		
	,idfWCSecurityKey
	,edfPAProjectL1Class		
	,edfPAProjectL2Class		
	,edfPAProjectL3Class		
	,vdfID			
	,idfEXPEntryTypeKey
	,HDR_idfWCSecurityKeyCreated
	,idfCodeApr 
	,idfAmtHomeExtOld
	,idfBUDHeaderKeyOld
	,idfBudgetApplyDateOld
	,1 --vdfBudgetValid
	,idfTableLinkKey
FROM #spEXPValidate'

IF @@ERROR <> 0 
	RAISERROR ('spEXPValidate:200',1,1)

SELECT	 @xochErrSP	= 'spEXPValidate', @xonErrNum	= 0, @xostrErrInfo	= ''

SELECT 	@strWCSystem_edfCurrencyApproval = edfCurrencyApproval FROM WCSystem (NOLOCK)


IF (@xstrSource NOT IN ('DISTRIBUTION','UDFTEMPLATE', 'ATTENDEE_ENTRY','ATTENDEE_APPROVAL', 'ENTRY_POST'))
BEGIN
	-- ----------------------------------------------------------------------------------------------------------------------------------------
	-- START: Update KEY Driven from Virtual Columns.
	-- ----------------------------------------------------------------------------------------------------------------------------------------
	SELECT 	 @nidfWCUDFListHdrKey 	= idfWCUDFListHdrKey
			,@nidfFlagForced		= idfFlagForced
	FROM dbo.WCUDFListHdr WITH (NOLOCK) WHERE idfCategory = 'LISTUDF02'

	UPDATE #spEXPValidateWork SET 
	 idfWCICCompanyKeySource = SRC.idfWCICCompanyKey
	,idfWCICCompanyKeyTarget = TRG.idfWCICCompanyKey
	FROM #spEXPValidateWork D
	LEFT OUTER JOIN WCICCompany SRC WITH (NOLOCK) ON SRC.idfCompanyCode = D.vdfCompanyCodeSource
	LEFT OUTER JOIN WCICCompany TRG WITH (NOLOCK) ON TRG.idfCompanyCode = D.vdfCompanyCodeTarget


	--GL Account
	
		UPDATE #spEXPValidateWork SET
		idfGLAccountKey = GLAccount.idfGLAccountKey
		FROM #spEXPValidateWork WITH (NOLOCK )
		INNER JOIN dbo.WCICCompanyTableLinkType LT WITH (NOLOCK) ON LT.idfModule = 'GLOBAL' AND idfTableName = 'GLAccount'
		LEFT OUTER JOIN dbo.GLAccount WITH (NOLOCK) ON #spEXPValidateWork.vdfGL = GLAccount.idfGLID AND GLAccount.idfFlagActive = 1
		AND (GLAccount.idfWCICCompanyKey IS NULL
		OR (LT.idfLinkType='SOURCE' AND GLAccount.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeySource)
		OR (LT.idfLinkType='TARGET' AND GLAccount.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeyTarget))
		WHERE 1=1
		OPTION (FORCE ORDER, KEEPFIXED PLAN)
	

	--Shipping Method
	
		UPDATE #spEXPValidateWork SET
		idfWCShippingMethodKey = WCShippingMethod.idfWCShippingMethodKey
		FROM #spEXPValidateWork WITH (NOLOCK )
		INNER JOIN dbo.WCICCompanyTableLinkType LT WITH (NOLOCK) ON LT.idfModule = 'GLOBAL' AND idfTableName = 'WCShippingMethod'
		LEFT OUTER JOIN dbo.WCShippingMethod WITH (NOLOCK) ON #spEXPValidateWork.vdfShippingMethodID = WCShippingMethod.idfShippingMethodID AND WCShippingMethod.idfFlagActive = 1
		AND (WCShippingMethod.idfWCICCompanyKey IS NULL
		OR (LT.idfLinkType='SOURCE' AND WCShippingMethod.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeySource)
		OR (LT.idfLinkType='TARGET' AND WCShippingMethod.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeyTarget))
		WHERE 1=1
		OPTION (FORCE ORDER, KEEPFIXED PLAN)
	

	--Tax Schedule
	
		UPDATE #spEXPValidateWork SET
		idfWCTaxScheduleHdrKey = WCTaxScheduleHdr.idfWCTaxScheduleHdrKey
		FROM #spEXPValidateWork WITH (NOLOCK )
		INNER JOIN dbo.WCICCompanyTableLinkType LT WITH (NOLOCK) ON LT.idfModule = 'GLOBAL' AND idfTableName = 'WCTaxScheduleHdr'
		LEFT OUTER JOIN dbo.WCTaxScheduleHdr WITH (NOLOCK) ON #spEXPValidateWork.vdfTaxScheduleID = WCTaxScheduleHdr.idfTaxScheduleID AND WCTaxScheduleHdr.idfFlagActive = 1
		AND (WCTaxScheduleHdr.idfWCICCompanyKey IS NULL
		OR (LT.idfLinkType='SOURCE' AND WCTaxScheduleHdr.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeySource)
		OR (LT.idfLinkType='TARGET' AND WCTaxScheduleHdr.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeyTarget))
		WHERE 1=1
		OPTION (FORCE ORDER, KEEPFIXED PLAN)
	
	/*
	--Vendor
	
		UPDATE #spEXPValidateWork SET
		idfAPVendorKey = APVendor.idfAPVendorKey
		FROM #spEXPValidateWork WITH (NOLOCK )
		INNER JOIN dbo.WCICCompanyTableLinkType LT WITH (NOLOCK) ON LT.idfModule = 'GLOBAL' AND idfTableName = 'APVendor'
		LEFT OUTER JOIN dbo.APVendor WITH (NOLOCK) ON #spEXPValidateWork.vdfVendorID = APVendor.idfVendorID AND APVendor.idfFlagActive = 1
		AND (APVendor.idfWCICCompanyKey IS NULL
		OR (LT.idfLinkType='SOURCE' AND APVendor.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeySource)
		OR (LT.idfLinkType='TARGET' AND APVendor.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeyTarget))
		WHERE 1=1
		OPTION (FORCE ORDER, KEEPFIXED PLAN)
	
	*/
	UPDATE  #spEXPValidateWork 
	SET 	 #spEXPValidateWork.idfWCUDFListDtlKey02 	= ISNULL(T.idfWCUDFListDtlKey02,L.idfWCUDFListDtlKey)
			,#spEXPValidateWork.idfWCDeptKey			= CASE WHEN WCSystem.idfFlagDeptHdrEXP IS NULL THEN WCDept.idfWCDeptKey ELSE T.idfWCDeptKey END 
			,#spEXPValidateWork.idfEXPPaymentKey		= EXPPayment.idfEXPPaymentKey
			,#spEXPValidateWork.idfEXPTypeKey			= EXPType.idfEXPTypeKey
			,#spEXPValidateWork.idfWCCountryKey			= WCCountry.idfWCCountryKey
			,#spEXPValidateWork.idfPTICurrencyKey		= CASE WHEN TRAVEL.idfPTICurrencyKey IS NOT NULL THEN TRAVEL.idfPTICurrencyKey ELSE PTICurrency.idfPTICurrencyKey END
			,#spEXPValidateWork.idfPTICurrencyKeyReceipt = CASE WHEN vdfCurrencyIDReceipt = '' THEN PTICurrency.idfPTICurrencyKey ELSE PTICurrencyRCT.idfPTICurrencyKey END
			,#spEXPValidateWork.idfEXPEventKey			= EXPEvent.idfEXPEventKey
			,#spEXPValidateWork.idfBUDHeaderKey			= BUDHeader.idfBUDHeaderKey
			,#spEXPValidateWork.edfGL					= G.ACTINDX
			,#spEXPValidateWork.edfPrice				= CASE WHEN idfFlagPriceFixed = 1 THEN
																CASE WHEN EXPTypeCountry.idfPrice IS NOT NULL THEN EXPTypeCountry.idfPrice ELSE EXPType.idfPrice END
														   ELSE T.edfPrice END
			,#spEXPValidateWork.edfAmtExtended			= ROUND(CASE WHEN idfFlagPriceFixed = 1 THEN
																CASE WHEN EXPTypeCountry.idfPrice IS NOT NULL THEN (EXPTypeCountry.idfPrice * T.idfQuantity) + T.edfFreight + T.edfMiscCharges + T.idfAmtTax ELSE (EXPType.idfPrice * T.idfQuantity) + T.edfFreight + T.edfMiscCharges + T.idfAmtTax END
															ELSE
																T.edfAmtExtended 
														  END,PTICurrency.idfPrecision)
			,#spEXPValidateWork.idfFlagOutsidePeriod = CASE WHEN (@nEXPLINESOUTSIDETIME = 0 OR @nidfFlagEXPRequireTimePeriod = 0) THEN 0 
															WHEN T.idfDay BETWEEN PRD.idfPeriodBegin AND PRD.idfPeriodEnd THEN 0
															ELSE 1 END
			,idfAPVendorKey = CASE WHEN EXPPayment.idfAPVendorKey IS NULL THEN APVendor.idfAPVendorKey ELSE EXPPayment.idfAPVendorKey END
			,#spEXPValidateWork.vdfCurrencyIDReceipt = CASE WHEN vdfCurrencyIDReceipt = '' THEN vdfCurrencyID ELSE vdfCurrencyIDReceipt END
	

	FROM #spEXPValidateWork T 
			LEFT OUTER JOIN dbo.EXPExpenseSheetDtl TRAVEL WITH (NOLOCK)	ON T.idfEXPExpenseSheetDtlKeyTravel = TRAVEL.idfEXPExpenseSheetDtlKey
			LEFT OUTER JOIN dbo.WCSecurity SEC		WITH (NOLOCK)	ON T.idfWCSecurityKey	= SEC.idfWCSecurityKey
			LEFT OUTER JOIN dbo.TETimePeriod PRD	WITH (NOLOCK)   ON T.idfTETimePeriodKey = PRD.idfTETimePeriodKey
			LEFT OUTER JOIN dbo.WCUDFListDtl L		WITH (NOLOCK)	ON T.vdfID				= L.idfID AND L.idfWCUDFListHdrKey = @nidfWCUDFListHdrKey
			LEFT OUTER JOIN dbo.WCDept				WITH (NOLOCK)	ON T.vdfDeptID			= WCDept.idfDeptID AND WCDept.idfFlagActive = 1
			LEFT OUTER JOIN dbo.EXPPayment			WITH (NOLOCK)	ON T.vdfPaymentID		= EXPPayment.idfPaymentID
			LEFT OUTER JOIN dbo.EXPType				WITH (NOLOCK)	ON T.vdfTypeID			= EXPType.idfTypeID AND EXPType.idfFlagActive = 1
			LEFT OUTER JOIN dbo.WCCountry			WITH (NOLOCK)	ON T.vdfCountryID		= WCCountry.idfCountryID
			LEFT OUTER JOIN dbo.EXPTypeCountry		WITH (NOLOCK)	ON EXPType.idfEXPTypeKey = EXPTypeCountry.idfEXPTypeKey AND WCCountry.idfWCCountryKey = EXPTypeCountry.idfWCCountryKey AND T.idfDay BETWEEN EXPTypeCountry.idfDateFrom AND EXPTypeCountry.idfDateTo 
			LEFT OUTER JOIN DYNAMICS.dbo.PTICurrency PTICurrency WITH (NOLOCK) ON T.vdfCurrencyID = PTICurrency.idfCurrencyID
			LEFT OUTER JOIN DYNAMICS.dbo.PTICurrency PTICurrencyRCT WITH (NOLOCK) ON T.vdfCurrencyIDReceipt = PTICurrencyRCT.idfCurrencyID
			LEFT OUTER JOIN dbo.EXPEvent			WITH (NOLOCK)   ON EXPEvent.idfEventID = T.vdfEventID AND EXPEvent.idfFlagActive = 1
			LEFT OUTER JOIN dbo.BUDHeader		   	WITH (NOLOCK) ON BUDHeader.idfBudgetID = T.vdfBudgetID AND BUDHeader.idfFlagActive = 1
			LEFT OUTER JOIN dbo.GL00105 G			WITH (NOLOCK)	ON T.vdfGL				= G.ACTNUMST
			LEFT OUTER JOIN dbo.APVendor			WITH (NOLOCK)   ON APVendor.idfVendorID = SEC.edfVendor
			LEFT OUTER JOIN dbo.WCSystem WITH (NOLOCK) ON idfFlagDeptHdrEXP = 1
			LEFT OUTER JOIN dbo.GLPeriod GP	WITH (NOLOCK) ON T.idfDay BETWEEN GP.idfPeriodBegin AND GP.idfPeriodEnd 
															AND GP.idfPeriodID > 0 AND ISNULL(T.idfWCICCompanyKeyTarget,0) = ISNULL(GP.idfWCICCompanyKey,0)

	UPDATE #spEXPValidateWork SET vdfGL = CASE WHEN vdfGL = '' THEN ISNULL(AGL.idfGLID,PGL.idfGLID) ELSE vdfGL END
	FROM #spEXPValidateWork T 
		LEFT OUTER JOIN dbo.PAProjectPhase PHA WITH (NOLOCK) ON PHA.idfPAProjectPhaseKey = T.idfPAProjectPhaseKey
		LEFT OUTER JOIN dbo.PAPhaseActivity ACT WITH (NOLOCK) ON ACT.idfPAPhaseActivityKey = T.idfPAPhaseActivityKey
		LEFT OUTER JOIN dbo.GLAccount PGL WITH (NOLOCK) ON PGL.idfGLAccountKey = PHA.idfGLAccountKeyExpense
		LEFT OUTER JOIN dbo.GLAccount AGL WITH (NOLOCK) ON AGL.idfGLAccountKey = ACT.idfGLAccountKeyExpense

	--Override the tax if setup from department
	UPDATE #spEXPValidateWork SET idfWCTaxScheduleHdrKey = ISNULL(WCDept.idfWCTaxScheduleHdrKey,TMP.idfWCTaxScheduleHdrKey)
	FROM #spEXPValidateWork TMP
	INNER JOIN dbo.WCDept WITH (NOLOCK) ON WCDept.idfWCDeptKey = TMP.idfWCDeptKey AND WCDept.idfFlagActive = 1
END
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- END: Update KEY Driven from Virtual Columns.
-- ---------------------------------------------------------------------------------------------------------------------------------------- 
	SELECT @nBREAKONEXCHRATE = idfValue FROM dbo.WCSystemSetting WITH(NOLOCK) WHERE idfSettingID = 'BREAKONEXCHRATE'

SELECT @nidfFlagEXPRestrictByPhaseActivity	= idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPRTPHAACTBYUSER'
SELECT @nidfFlagEXPRestrictByPhase			= idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPRTPHABYUSER'
SELECT @nidfFlagEXPRestrictByActivity		= idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPRTACTBYUSER'	
SELECT @nidfFlagEXPRestrictByProject		= idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPRTPROJBYUSER'	
-- ------------------------------------------------------------------------------------------------------------------------
-- Perform MAP Mileage Validation/Enforcement
-- ------------------------------------------------------------------------------------------------------------------------
-- Only do MAP stuff if at least 1 EXPType is enabled for it.
IF EXISTS(SELECT TOP 1 1 FROM dbo.EXPType T WITH (NOLOCK) WHERE idfFlagRequireMapDistance = 1 ) BEGIN 
	-- If @xstrGUID is passed then this means they is potential for temporary records tied by rowkey and guid.  Updates are only for ENTRY currently, no Approval Update/edit.
	IF (@xstrGUID > '' AND @xstrSource = 'ENTRY')  BEGIN
		UPDATE #spEXPValidateWork
		SET idfQuantity = CASE WHEN T.idfMapDistanceUOM = 0 THEN H.idfTotalBusinessMI ELSE H.idfTotalBusinessKM END
		FROM #spEXPValidateWork W
			INNER JOIN dbo.EXPMileageHdr H WITH (NOLOCK) ON W.idfRowKey*-1 = H.idfTableLinkKey AND H.idfTableLinkName= 'EXPExpenseSheetDtl' AND H.idfTableLinkGUID = @xstrGUID
			INNER JOIN dbo.EXPType T WITH (NOLOCK) ON W.idfEXPTypeKey = T.idfEXPTypeKey
		WHERE T.idfFlagRequireMapDistance = 1 

		-- Delete Routes where EXPType is idfFlagRequireMapDistance = 0
		DELETE dbo.EXPMileageHdr 
		WHERE idfEXPMileageHdrKey IN 
		(
			SELECT H.idfEXPMileageHdrKey
			FROM #spEXPValidateWork W
				INNER JOIN dbo.EXPMileageHdr H WITH (NOLOCK) ON W.idfRowKey*-1 = H.idfTableLinkKey AND H.idfTableLinkName= 'EXPExpenseSheetDtl' AND H.idfTableLinkGUID = @xstrGUID
				INNER JOIN dbo.EXPType T WITH (NOLOCK) ON W.idfEXPTypeKey = T.idfEXPTypeKey
			WHERE T.idfFlagRequireMapDistance = 0
		)

		-- Update idfDay on EXPMileageHdr
		UPDATE dbo.EXPMileageHdr
		SET idfDay = W.idfDay
		FROM dbo.EXPMileageHdr H WITH (NOLOCK)
			INNER JOIN #spEXPValidateWork W ON W.idfRowKey*-1 = H.idfTableLinkKey AND H.idfTableLinkName= 'EXPExpenseSheetDtl' AND H.idfTableLinkGUID = @xstrGUID
	END
	-- Update Physically Linked Records.
	UPDATE #spEXPValidateWork
	SET idfQuantity = CASE WHEN T.idfMapDistanceUOM = 0 THEN H.idfTotalBusinessMI ELSE H.idfTotalBusinessKM END
	FROM #spEXPValidateWork W
		INNER JOIN dbo.EXPMileageHdr H WITH (NOLOCK) ON W.idfEXPExpenseSheetDtlKey = H.idfTableLinkKey AND H.idfTableLinkName= 'EXPExpenseSheetDtl' AND idfTableLinkGUID IS NULL
		INNER JOIN dbo.EXPType T WITH (NOLOCK) ON W.idfEXPTypeKey = T.idfEXPTypeKey
	WHERE T.idfFlagRequireMapDistance = 1 
	
	-- Delete Routes where EXPType is idfFlagRequireMapDistance = 0
	DELETE dbo.EXPMileageHdr 
	WHERE idfEXPMileageHdrKey IN 
	(
		SELECT H.idfEXPMileageHdrKey
		FROM #spEXPValidateWork W
			INNER JOIN dbo.EXPMileageHdr H WITH (NOLOCK) ON W.idfEXPExpenseSheetDtlKey = H.idfTableLinkKey AND H.idfTableLinkName= 'EXPExpenseSheetDtl'  AND idfTableLinkGUID IS NULL
			INNER JOIN dbo.EXPType T WITH (NOLOCK) ON W.idfEXPTypeKey = T.idfEXPTypeKey
		WHERE T.idfFlagRequireMapDistance = 0
	)
	-- Update idfDay on EXPMileageHdr
	UPDATE dbo.EXPMileageHdr
	SET idfDay = W.idfDay
	FROM dbo.EXPMileageHdr H WITH (NOLOCK)
		INNER JOIN #spEXPValidateWork W ON W.idfEXPExpenseSheetDtlKey = H.idfTableLinkKey AND H.idfTableLinkName= 'EXPExpenseSheetDtl'  AND idfTableLinkGUID IS NULL
END

-- ------------------------------------------------------------------------------------------------------------------------
--Validate Project
-- ------------------------------------------------------------------------------------------------------------------------	
-- ------------------------------------------------------------------------------------------------------------------------	

-- ------------------------------------------------------------------------------------------------------------------------	
-- Validate Budget Filter
-- ------------------------------------------------------------------------------------------------------------------------	
	SELECT #spEXPValidateWork.*
		, AmtSum.edfAmtHomeExtended		AS HDR_edfAmtHomeExtended
		, AmtSum.edfAmtAprExtended		AS HDR_edfAmtAprExtended
		, idfWCSecurityKey				AS HDR_idfWCSecurityKey
		, 0								AS HDR_idfAmtDiscountApr 
		, dbo.fnWCSubtotalCalc(AmtSum.idfAmtSubTotalApr,AmtSum.idfAmtTaxIncludedApr) AS HDR_idfAmtSubTotalApr
		, AmtSum.idfAmtFreightApr		AS HDR_idfAmtFreightApr     
		, AmtSum.idfAmtMiscApr			AS HDR_idfAmtMiscApr          
		, AmtSum.idfAmtTaxApr			AS HDR_idfAmtTaxApr       
		, BUDHeader.idfWCFilterHdrKey
		,'Budget'								AS idfSourceTable
		,#spEXPValidateWork.idfRowKey			AS idfSourceKey
		, 0 AS vdfFilterValid 
		, 0 AS EXT_idfWCSecurityKey		
		, 0	AS HDR_idfRQTypeKey
		,NULL AS HDR_idfPTICurrencyKey		
		,NULL AS HDR_idfWCAddressKeyBillTo	
		,NULL AS HDR_idfWCDeptKey			
		,NULL AS HDR_idfAmtDiscount			
		,NULL AS HDR_idfAmtFreight			
		,NULL AS HDR_idfAmtMisc				
		,NULL AS HDR_idfAmtTax				
		,NULL AS HDR_idfAmtExtended			
		,NULL AS HDR_idfWCPaymentTermKey	
		,NULL AS HDR_idfWCShippingMethodKey	
		,NULL AS HDR_idfWCAddressKeyShipTo	
		,NULL AS HDR_idfAPVendorKey			
		,NULL AS HDR_idfCreatedBySource	
		,#spEXPValidateWork.idfWCUDFListDtlKey02 AS HDR_idfWCUDFListDtlKey02	
		,NULL AS HDR_idfWCFOBKey			
		,NULL AS HDR_idfWCAddressKeyBranch	
		,NULL AS HDR_idfWCOrganizationKey	
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField01             
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField02                     
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField03                     
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField04                     
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField05                     
		,' '  AS HDR_udfLargeTextField01                
		,' '  AS HDR_udfLargeTextField02                
		,' '  AS HDR_udfLargeTextField03              
		,0	  AS HDR_udfNumericField01                 
		,0	  AS HDR_udfNumericField02                  
		,0	  AS HDR_udfNumericField03                  
		,0	  AS HDR_udfNumericField04                  
		,0	  AS HDR_udfNumericField05                  
		,0	  AS HDR_udfNumericField06                  
		,0	  AS HDR_udfNumericField07                  
		,0	  AS HDR_udfNumericField08                  
		,0	  AS HDR_udfNumericField09                  
		,0	  AS HDR_udfNumericField10                  
		,' '  AS HDR_udfTextField01                     
		,' '  AS HDR_udfTextField02                     
		,' '  AS HDR_udfTextField03                     
		,' '  AS HDR_udfTextField04        
		,' '  AS HDR_udfTextField05                     
		,' '  AS HDR_udfTextField06                     
		,' '  AS HDR_udfTextField07                     
		,' '  AS HDR_udfTextField08                     
		,' '  AS HDR_udfTextField09                     
		,' '  AS HDR_udfTextField10
	INTO #spWCFilterValidateEXP
	FROM #spEXPValidateWork 
		INNER JOIN (SELECT SUM(edfAmtHomeExtended) AS edfAmtHomeExtended
						,SUM(edfAmtAprExtended) AS edfAmtAprExtended
						,SUM(idfAmtSubTotalApr) AS idfAmtSubTotalApr
						,SUM(idfAmtFreightApr) AS idfAmtFreightApr
						,SUM(idfAmtMiscApr) AS idfAmtMiscApr
						,SUM(idfAmtTaxApr) AS idfAmtTaxApr
						,SUM(idfAmtTaxIncludedApr) AS idfAmtTaxIncludedApr
						FROM #spEXPValidateWork) AS AmtSum ON 1=1
		INNER JOIN BUDHeader (NOLOCK) ON #spEXPValidateWork.vdfBudgetID = BUDHeader.idfBudgetID
	WHERE BUDHeader.idfWCFilterHdrKey <> 0 AND #spEXPValidateWork.idfEXPSessionKey <> 170

	-- Validate that Budget can be applied to line items.
	EXEC spWCFilterValidateEXP @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,0,0,1,0

	EXEC sp_executesql N'UPDATE #spEXPValidateWork SET vdfBudgetValid = #spWCFilterValidateEXP.vdfFilterValid 
	FROM #spEXPValidateWork
		INNER JOIN #spWCFilterValidateEXP ON #spWCFilterValidateEXP.idfRowKey = #spEXPValidateWork.idfRowKey'

	DROP TABLE #spWCFilterValidateEXP
-- ------------------------------------------------------------------------------------------------------------------------	

-- ------------------------------------------------------------------------------------------------------------------------	
-- Validate Budget Filter
-- ------------------------------------------------------------------------------------------------------------------------	
	UPDATE #spEXPValidateWork SET vdfBudgetValid = 0 
	FROM #spEXPValidateWork R
		INNER JOIN BUDHeader H WITH (NOLOCK) ON R.vdfBudgetID = H.idfBudgetID
		LEFT OUTER JOIN WCListDtl L WITH (NOLOCK) ON L.idfWCListHdrKey = H.idfGLRestrictValue AND (R.edfGL = L.idfCodeKey OR R.vdfGL LIKE L.idfCodeID) 
		WHERE 
      ((H.idfGLRestrictType = 'L' AND L.idfWCListDtlKey IS NULL)
      OR (H.idfGLRestrictType = 'N' AND L.idfWCListDtlKey IS NOT NULL)
      OR (H.idfGLRestrictType = 'K' AND H.idfGLRestrictValue <> R.edfGL))
-- ------------------------------------------------------------------------------------------------------------------------	

-- ------------------------------------------------------------------------------------------------------------------------
-- Validate GL Segment
-- ------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------	

-- ------------------------------------------------------------------------------------------------------------------------	
-- Balance Attendee Amount based on SS
-- ------------------------------------------------------------------------------------------------------------------------	
IF EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPATTENDEEAUTOEQ' AND idfValue = 1)
BEGIN
	IF (@xstrSource IN ('ENTRY'))
		EXEC sp_executesql N'
		INSERT INTO #AttendeeTable (idfAmountTotal, idfAmount, idfAmountRem, idfSourceKey, idfRowKey)		
		SELECT 
		  MAX(TMP.edfAmtExtended)
		, ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision)
		, MAX(TMP.edfAmtExtended) - (ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision) * COUNT(*))
		, ATT.idfEXPExpenseSheetDtlKey
		, MIN(idfEXPExpenseSheetDtlAttendeeKey) 
		FROM #spEXPValidateWork TMP
		INNER JOIN dbo.EXPExpenseSheetDtlAttendee ATT WITH (NOLOCK) ON ATT.idfEXPExpenseSheetDtlKey = TMP.idfTableLinkKey
		INNER JOIN DYNAMICS.dbo.PTICurrency C (NOLOCK) ON C.idfPTICurrencyKey = TMP.idfPTICurrencyKey
		GROUP BY ATT.idfEXPExpenseSheetDtlKey, C.idfPrecision

		'

	IF (@xstrSource IN ('ATTENDEE_ENTRY'))
		EXEC sp_executesql N'
		INSERT INTO #AttendeeTable (idfAmountTotal, idfAmount, idfAmountRem, idfSourceKey, idfRowKey)		
		SELECT 
		  MAX(TMP.edfAmtExtended)
		, ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision)
		, MAX(TMP.edfAmtExtended) - (ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision) * COUNT(*))
		, ATT.idfEXPExpenseSheetDtlKey
		, MIN(ATT.idfRowKey) 
		FROM #EXPExpenseSheetDtlAttendee ATT WITH (NOLOCK) 
		INNER JOIN dbo.EXPExpenseSheetDtl TMP WITH (NOLOCK) ON TMP.idfEXPExpenseSheetDtlKey = ATT.idfEXPExpenseSheetDtlKey
		INNER JOIN DYNAMICS.dbo.PTICurrency C (NOLOCK) ON C.idfPTICurrencyKey = TMP.idfPTICurrencyKey
		WHERE ATT.idfRowAction NOT IN (''DL'')
		GROUP BY ATT.idfEXPExpenseSheetDtlKey, C.idfPrecision
		'

	IF (@xstrSource IN ('APPROVAL'))
		EXEC sp_executesql N'
		INSERT INTO #AttendeeTable (idfAmountTotal, idfAmount, idfAmountRem, idfSourceKey, idfRowKey)		
		SELECT 
		  MAX(TMP.edfAmtExtended)
		, ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision)
		, MAX(TMP.edfAmtExtended) - (ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision) * COUNT(*))
		, ATT.idfEXPAprDtlKey
		, MIN(idfEXPAprDtlAttendeeKey) 
		FROM #spEXPValidateWork TMP
		INNER JOIN dbo.EXPAprDtlAttendee ATT WITH (NOLOCK) ON ATT.idfEXPAprDtlKey = TMP.idfTableLinkKey
		INNER JOIN DYNAMICS.dbo.PTICurrency C (NOLOCK) ON C.idfPTICurrencyKey = TMP.idfPTICurrencyKey
		GROUP BY ATT.idfEXPAprDtlKey, C.idfPrecision
		'

	IF (@xstrSource IN ('ATTENDEE_APPROVAL'))
	EXEC sp_executesql N'
		INSERT INTO #AttendeeTable (idfAmountTotal, idfAmount, idfAmountRem, idfSourceKey, idfRowKey)		
		SELECT 
		  MAX(TMP.edfAmtExtended)
		, ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision)
		, MAX(TMP.edfAmtExtended) - (ROUND(MAX(TMP.edfAmtExtended) / COUNT(*), C.idfPrecision) * COUNT(*))
		, ATT.idfEXPAprDtlKey
		, MIN(ATT.idfRowKey) 
		FROM #EXPAprDtlAttendee ATT
		INNER JOIN dbo.EXPAprDtl TMP WITH (NOLOCK) ON TMP.idfEXPAprDtlKey = ATT.idfEXPAprDtlKey
		INNER JOIN DYNAMICS.dbo.PTICurrency C (NOLOCK) ON C.idfPTICurrencyKey = TMP.idfPTICurrencyKey
		WHERE ATT.idfRowAction NOT IN (''DL'')
		GROUP BY ATT.idfEXPAprDtlKey, C.idfPrecision
		'
END

-- ------------------------------------------------------------------------------------------------------------------------	
 --Validate all rows
DECLARE curspEXPValidate INSENSITIVE CURSOR
FOR SELECT
	 idfRowKey
	,idfComment
	,idfDay
	,#spEXPValidateWork.idfDescription
	,idfQuantity
	,idfEXPEventKey
	,idfEXPExpenseSheetHdrKey
	,idfEXPPaymentKey
	,idfEXPTypeKey
	,idfWCDeptKey
	,idfWCUDFListDtlKey02
	,edf1099Amount
	,edfAmtAprExtended
	,edfAmtExtended
	,edfAmtHomeExtended
	,idfAmtExtendedReceipt
	,edfAmtReimExtended
	,edfFreight
	,edfMiscCharges
	,edfPrice
	,edfTax
	,idfAmtTax
	,vdfTaxScheduleID
	,vdfCountryID
	,idfFlagImported
	,idfFlagManualDist
	,idfImportedRefNo
	,idfWCImportMapKey
	,edfBillType
	,edfCardName
	,edfCurrency
	,edfPAProjectL1
	,edfPAProjectL1Class
	,edfPAProjectL2
	,edfPAProjectL2Class
	,edfPAProjectL3
	,edfPAProjectL3Class
	,edfWSProductIndicator
	,edfShippingMethod
	,edfTaxSchedule
	,edfUOM
	,vdfGL
	,edfFacilityID
	,vdfEventID
	,vdfPaymentID
	,vdfTypeID
	,vdfID
	,vdfDeptID
	,idfWCSecurityKey
	,edfGL
	,vdfVendorID
	,idfAPVendorKey
	,vdfCurrencyIDReim
	,vdfCurrencyIDReceipt
	,idfEXPExpenseSheetDtlKey
	,idfRowAction
	,idfWCICCompanyKeySource
	,idfWCICCompanyKeyTarget
	,vdfCompanyCodeTarget
	,idfEXPSessionKey
	,idfEXPExpenseSheetDtlKeyTravel		
	,idfBUDHeaderKey
	,idfBudgetApplyDate
	,vdfBudgetID	
	,idfCodeApr
	,vdfBudgetValid
	,idfGLPeriodKey
FROM #spEXPValidateWork
LEFT OUTER JOIN dbo.GLPeriod GP	WITH (NOLOCK) ON #spEXPValidateWork.idfDay BETWEEN GP.idfPeriodBegin AND GP.idfPeriodEnd 
															AND GP.idfPeriodID > 0 AND ISNULL(#spEXPValidateWork.idfWCICCompanyKeyTarget,0) = ISNULL(GP.idfWCICCompanyKey,0)

OPEN curspEXPValidate

FETCH curspEXPValidate INTO
	 @n__idfRowKey
	,@stridfComment
	,@dt_idfDay
	,@stridfDescription
	,@n__idfQuantity
	,@nidfEXPEventKey
	,@n__idfEXPExpenseSheetHdrKey
	,@n__idfEXPPaymentKey
	,@n__idfEXPTypeKey
	,@n__idfWCDeptKey
	,@n__idfWCUDFListDtlKey02
	,@n__edf1099Amount
	,@n__edfAmtAprExtended
	,@n__edfAmtExtended
	,@n__edfAmtHomeExtended
	,@nidfAmtExtendedReceipt
	,@nedfAmtReimExtended
	,@n__edfFreight
	,@n__edfMiscCharges
	,@n__edfPrice
	,@stredfTax
	,@n__idfAmtTax
	,@strvdfTaxScheduleID
	,@strvdfCountryID
	,@nidfFlagImported
	,@nidfFlagManualDist
	,@stridfImportedRefNo
	,@nidfWCImportMapKey
	,@stredfBillType
	,@stredfCardName
	,@stredfCurrency
	,@stredfPAProjectL1
	,@stredfPAProjectL1Class
	,@stredfPAProjectL2
	,@stredfPAProjectL2Class
	,@stredfPAProjectL3
	,@stredfPAProjectL3Class
	,@nedfWSProductIndicator
	,@stredfShippingMethod
	,@stredfTaxSchedule
	,@stredfUOM
	,@strvdfGL
	,@stredfFacilityID
	,@strvdfEventID
	,@strvdfPaymentID
	,@strvdfTypeID
	,@strvdfID
	,@strvdfDeptID
	,@nEmployee__idfWCSecurityKey
	,@edfGL
	,@strvdfVendorID	
	,@nidfAPVendorKey
	,@strvdfCurrencyIDReim
	,@strvdfCurrencyIDReceipt
	,@nidfEXPExpenseSheetDtlKey
	,@stridfRowAction
	,@nidfWCICCompanyKeySource
	,@nidfWCICCompanyKeyTarget
	,@strvdfCompanyCodeTarget
	,@nidfEXPSessionKey
	,@nidfEXPExpenseSheetDtlKeyTravel	
	,@nidfBUDHeaderKey
	,@dtidfBudgetApplyDate
	,@strvdfBudgetID
	,@stridfCodeApr
	,@nvdfBudgetValid
	,@nidfGLPeriodKey
WHILE @@fetch_status <> -1
BEGIN
	IF @@fetch_status <> -2
	BEGIN
		--------------------------------------------------------------------------------------------------------------------


	--Budget Apply Date is required with a budget. 
	IF ISNULL(@dtidfBudgetApplyDate,0) = 0 AND ISNULL(@strvdfBudgetID,'') <> '' AND @xstrSource <> 'UDFTEMPLATE'
			BEGIN
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -194, 'spEXPValidate'
				IF @xonErrNum <> 0
				BEGIN
					CLOSE curspRQDetail 
					DEALLOCATE curspRQDetail 
					RETURN @xonErrNum
				END
			END	

	--Budget is invalid
	IF (@strvdfBudgetID > '' AND (@nidfBUDHeaderKey IS NULL OR @nvdfBudgetValid = 0))
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -191, 'spEXPValidate'

	--Budget Date is invalid
	IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.BUDPeriod WITH (NOLOCK) 
					   WHERE @nidfBUDHeaderKey = BUDPeriod.idfBUDHeaderKey 
					   AND @dtidfBudgetApplyDate >= BUDPeriod.idfPeriodBegin 
					   AND @dtidfBudgetApplyDate <= BUDPeriod.idfPeriodEnd
				  ) AND @dtidfBudgetApplyDate IS NOT NULL AND @nidfBUDHeaderKey IS NOT NULL
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -192, 'spEXPValidate'
		--Vendor is required
		IF (ISNULL(@nidfAPVendorKey,0) = 0) AND @xstrSource NOT IN ('UDFTEMPLATE','ATTENDEE_ENTRY','ATTENDEE_APPROVAL')
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -187, 'spEXPValidate'

		IF (ISNULL(@n__idfEXPPaymentKey,0) = 0) AND @xstrSource NOT IN ('UDFTEMPLATE','ATTENDEE_ENTRY','ATTENDEE_APPROVAL')
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -188, 'spEXPValidate'
		--********************************************************************* TRAVEL REQUEST VAL ******************************************************************************************
		DECLARE @nTravelDtlKey INT,@nTravelHdrKey INT
		SELECT @nTravelDtlKey = idfEXPExpenseSheetDtlKey,@nTravelHdrKey = idfEXPExpenseSheetHdrKey FROM dbo.EXPExpenseSheetDtl WITH (NOLOCK) 
		WHERE idfEXPExpenseSheetDtlKeyTravel = ISNULL(@nidfEXPExpenseSheetDtlKeyTravel,0) AND idfEXPExpenseSheetHdrKey <> @n__idfEXPExpenseSheetHdrKey AND ISNULL(@nidfEXPExpenseSheetDtlKeyTravel,0) > 0
		IF ((ISNULL(@nTravelDtlKey,0) > 0) AND (@nEXPALLOWMULTIPLETRAVEL = 0))
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -173, 'spEXPValidate',0,'',NULL,@nTravelHdrKey
		
		IF EXISTS (SELECT TOP 1 1 FROM dbo.EXPExpenseSheetDtl WITH (NOLOCK) WHERE idfEXPExpenseSheetDtlKey = ISNULL(@nidfEXPExpenseSheetDtlKeyTravel,0) AND idfEXPSessionKey < 130)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -174, 'spEXPValidate',0,'',NULL,@nTravelHdrKey

		IF EXISTS (SELECT TOP 1 1 FROM #spEXPValidateWork WITH (NOLOCK) WHERE idfEXPExpenseSheetDtlKeyTravel = ISNULL(@nidfEXPExpenseSheetDtlKeyTravel,0) AND idfRowKey <> @n__idfRowKey AND ISNULL(@nidfEXPExpenseSheetDtlKeyTravel,0) > 0) AND (@nEXPALLOWMULTIPLETRAVEL = 0)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -173, 'spEXPValidate'


		IF (@nidfFlagImported = 1 OR @nidfFlagImported = 3) AND EXISTS (SELECT TOP 1 1 FROM dbo.EXPExpenseSheetDtl WITH (NOLOCK) WHERE idfImportedRefNo = @stridfImportedRefNo AND idfWCImportMapKey = @nidfWCImportMapKey) AND @stridfRowAction = 'IN'
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -172, 'spEXPValidate'
			

		IF @nBREAKONEXCHRATE = 1 
			SELECT @dt_EXidfDay = @dt_idfDay
		ELSE 
			SELECT @dt_EXidfDay = NULL
		IF (@stredfCardName > '') AND NOT EXISTS (SELECT TOP 1 1 FROM dbo.SY03100 WITH (NOLOCK) WHERE CARDNAME = @stredfCardName)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -162, 'spEXPValidate'
	
		IF (@stredfCardName = '') AND EXISTS (SELECT TOP 1 1 FROM dbo.EXPPayment WITH (NOLOCK) WHERE idfPaymentID = @strvdfPaymentID AND idfFlagCardNameRequired = 1)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -163, 'spEXPValidate'

		IF (@strvdfCountryID > '') AND NOT EXISTS (SELECT TOP 1 1 FROM dbo.WCCountry WITH (NOLOCK) WHERE idfCountryID = @strvdfCountryID)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -171, 'spEXPValidate'

		IF (@strvdfTaxScheduleID > '') AND NOT EXISTS (SELECT TOP 1 1 FROM dbo.WCTaxScheduleHdr WITH (NOLOCK) WHERE idfTaxScheduleID = @strvdfTaxScheduleID)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -164, 'spEXPValidate'

		IF ((@strvdfTypeID > '') AND (@strvdfTaxScheduleID = ''))
			UPDATE #spEXPValidateWork  SET idfWCTaxScheduleHdrKey = EXPType.idfWCTaxScheduleHdrKey 
			FROM #spEXPValidateWork 
			INNER JOIN EXPType WITH (NOLOCK) ON idfTypeID = @strvdfTypeID AND EXPType.idfFlagActive = 1  
			WHERE  idfRowKey = @n__idfRowKey

		-- If header key was passed then validate the date against the period.
		IF ((@dt_idfDay IS NULL OR @dt_idfDay = '1900-01-01') AND (@xstrSource NOT IN ('UDFTEMPLATE','ATTENDEE_ENTRY','ATTENDEE_APPROVAL')))
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -148, 'spEXPValidate'

		IF (@dt_idfDay IS NOT NULL AND @dt_idfDay <> '1900-01-01'  AND @n__idfEXPExpenseSheetHdrKey IS NOT NULL AND @n__idfEXPExpenseSheetHdrKey > 0 ) BEGIN
			-- get time period date range.
				SELECT 	 @dtTETimePeriod_idfPeriodBegin = P.idfPeriodBegin
						,@dtTETimePeriod_idfPeriodEnd	= P.idfPeriodEnd
				FROM EXPExpenseSheetHdr H (NOLOCK)
					INNER JOIN TETimePeriod P (NOLOCK) ON H.idfTETimePeriodKey = P.idfTETimePeriodKey
				WHERE idfEXPExpenseSheetHdrKey = @n__idfEXPExpenseSheetHdrKey
			IF ((@dt_idfDay < @dtTETimePeriod_idfPeriodBegin) AND (@nEXPLINESOUTSIDETIME = 0))
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -149, 'spEXPValidate'
			IF ((@dt_idfDay > @dtTETimePeriod_idfPeriodEnd) AND (@nEXPLINESOUTSIDETIME = 0))
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -150, 'spEXPValidate'
		END
		-- Validate Department.	
		IF (@strvdfDeptID <> '' AND @n__idfWCDeptKey IS NULL)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -144, 'spEXPValidate'
		ELSE IF (@xstrSource <> 'UDFTEMPLATE' AND @n__idfWCDeptKey IS NULL) -- Require Department
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -156, 'spEXPValidate'
		ELSE IF (@strvdfDeptID = '')
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -156, 'spEXPValidate'

		
		-- Validate UDF 02 Field.
		IF (@strvdfID <> '' AND @n__idfWCUDFListDtlKey02 IS NULL)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -142, 'spEXPValidate'

		IF @n__idfEXPPaymentKey IS NULL AND @strvdfPaymentID <> ''
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -102, 'spEXPValidate'

		IF @n__idfEXPTypeKey IS NULL AND @strvdfTypeID <> ''
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -103, 'spEXPValidate'

		-- CDB 5/11/07: Make sure quantity is specified.
		IF (@xstrSource <> 'UDFTEMPLATE' AND @n__idfQuantity = 0)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -157, 'spEXPValidate'

		IF (@stredfCurrency <> '' AND NOT EXISTS (SELECT TOP 1 1 FROM vwFNACurrency WHERE edfCurrencyID = @stredfCurrency)) BEGIN
			SELECT @stredfCurrency = '' -- set currency to empty so conversion routines don't fire.
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -146, 'spEXPValidate'
		END


		-- If not called from UDFTEMPLATE then very required field rules.
		IF (@xstrSource <> 'UDFTEMPLATE') BEGIN
			IF @strvdfPaymentID = ''
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -104, 'spEXPValidate'
		END		
			

	IF @nidfEXPEventKey IS NULL AND @strvdfEventID <> '' AND @xstrSource NOT IN ('ATTENDEE_ENTRY','ATTENDEE_APPROVAL')
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -200, 'spEXPValidate'	
	
		-- OVERLAYS ARE ONLY USED FOR NON PROJECT SERIES
		SET @nvdfGLExists = 0
		IF (@xstrSource <> 'UDFTEMPLATE') BEGIN
			--If a value is passed in set as existing otherwise if the overlay doesnt return an account this will clear the value.
			IF (@strvdfGL > '')
				SET @nvdfGLExists = 1
			-- ------------------------------------------------------------------------------------------------------------------------
			-- Apply DEPARTMENT Overlay Mask
			-- ------------------------------------------------------------------------------------------------------------------------
			SELECT @n__OVERLAY_NewGL = null, @strOVERLAY_OverlayString = null, @strOVERLAY_GLString = null
			
			SELECT @strOVERLAY_OverlayString = idfGLOverlayMask FROM WCDept (NOLOCK) WHERE idfWCDeptKey = @n__idfWCDeptKey AND WCDept.idfFlagActive = 1
			
			EXEC dbo.spFNAApplyOverlay @strvdfGL, @strOVERLAY_OverlayString, @strOVERLAY_GLString OUTPUT
			SELECT @n__OVERLAY_NewGL = GL00105.ACTINDX 
			FROM GL00105 (NOLOCK) 
			INNER JOIN dbo.GL00100 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
			WHERE GL00105.ACTNUMST = @strOVERLAY_GLString AND GL00100.ACTIVE = 1

			IF (@strOVERLAY_GLString > '')
				SELECT @strvdfGL = @strOVERLAY_GLString

			IF @n__OVERLAY_NewGL IS NOT NULL
			BEGIN
				SELECT @edfGL = @n__OVERLAY_NewGL

				UPDATE #spEXPValidateWork 
				SET edfGL = @n__OVERLAY_NewGL, vdfGL = @strOVERLAY_GLString
				WHERE idfRowKey = @n__idfRowKey
			END

			--Company Target is not Related to the source company
			IF ((@strvdfCompanyCodeTarget > '') AND (NOT EXISTS (SELECT TOP 1 1 FROM dbo.WCICCompanyRel WITH (NOLOCK) WHERE WCICCompanyRel.idfWCICCompanyKeySource = @nidfWCICCompanyKeySource AND WCICCompanyRel.idfWCICCompanyKeyTarget = @nidfWCICCompanyKeyTarget)))

				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -176, 'spEXPValidate'

			-- ------------------------------------------------------------------------------------------------------------------------
			-- Apply EXPENSE TYPE Overlay Mask
			-- ------------------------------------------------------------------------------------------------------------------------
			-- SELECT * FROM EXPType
			IF (@n__idfEXPTypeKey IS NOT NULL) BEGIN
				IF (@strOVERLAY_GLString > '')
					SELECT @strvdfGL = @strOVERLAY_GLString

				SELECT @n__OVERLAY_NewGL = null, @strOVERLAY_OverlayString = null, @strOVERLAY_GLString = null
				
				SELECT @strOVERLAY_OverlayString = idfGLOverlayMask FROM EXPType (NOLOCK) WHERE idfTypeID = @strvdfTypeID
				
				EXEC spFNAApplyOverlay @strvdfGL, @strOVERLAY_OverlayString, @strOVERLAY_GLString OUTPUT
				
				SELECT @n__OVERLAY_NewGL = GL00105.ACTINDX 
				FROM GL00105 (NOLOCK) 
				INNER JOIN dbo.GL00100 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
				WHERE GL00105.ACTNUMST = @strOVERLAY_GLString AND GL00100.ACTIVE = 1

				IF @n__OVERLAY_NewGL IS NOT NULL
				BEGIN
					SELECT @edfGL = @n__OVERLAY_NewGL

					UPDATE #spEXPValidateWork 
					SET edfGL = @n__OVERLAY_NewGL, vdfGL = @strOVERLAY_GLString
					WHERE idfRowKey = @n__idfRowKey
				END
			END

			-- ------------------------------------------------------------------------------------------------------------------------
			-- Apply EVENT Overlay Mask
			-- ------------------------------------------------------------------------------------------------------------------------
			IF (@nidfEXPEventKey IS NOT NULL) BEGIN
				IF (@strOVERLAY_GLString > '')
					SELECT @strvdfGL = @strOVERLAY_GLString

				SELECT @n__OVERLAY_NewGL = null, @strOVERLAY_OverlayString = null, @strOVERLAY_GLString = null
				
				SELECT @strOVERLAY_OverlayString = idfGLOverlayMask FROM dbo.EXPEvent WITH (NOLOCK) WHERE idfEventID = @strvdfEventID
				
				EXEC spFNAApplyOverlay @strvdfGL, @strOVERLAY_OverlayString, @strOVERLAY_GLString OUTPUT
			END

			IF (@strOVERLAY_GLString > '')
				SELECT @strvdfGL = @strOVERLAY_GLString

				SELECT @n__OVERLAY_NewGL = NULL
				SELECT @n__OVERLAY_NewGL = GL00105.ACTINDX 
				FROM GL00105 (NOLOCK) 
				INNER JOIN dbo.GL00100 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
				WHERE GL00105.ACTNUMST = @strvdfGL AND GL00100.ACTIVE = 1

				IF @n__OVERLAY_NewGL IS NOT NULL
				BEGIN
					SELECT @edfGL = @n__OVERLAY_NewGL

					UPDATE #spEXPValidateWork 
					SET edfGL = @n__OVERLAY_NewGL, vdfGL = @strvdfGL
					WHERE idfRowKey = @n__idfRowKey
				END

			-- ------------------------------------------------------------------------------------------------------------------------
			-- Apply Attendee Type Overlay Mask
			-- ------------------------------------------------------------------------------------------------------------------------
			--Not Supported for Split Until Distribution is Added
			IF EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPATTENDEEAUTOGL' AND idfValue = 1)
			BEGIN
				DELETE FROM #AttendeeTableDist
				TRUNCATE TABLE #DtlDistribution

				SELECT @nidfFlagPrimary = 1

				IF (@xstrSource IN ('ENTRY'))
					EXEC sp_executesql N'
					INSERT INTO #AttendeeTableDist (idfGLOverlayMask,idfAmount,idfPercent,idfCount,idfSourceKey,idfRowKey)
					SELECT ISNULL(EXPAttendeeExpType.idfGLOverlayMask,'''') AS idfGLOverlayMask, SUM(idfAmount) AS idfAmount, SUM(idfPercent) AS idfPercent, COUNT(*) AS idfCount,EXPExpenseSheetDtlAttendee.idfEXPExpenseSheetDtlKey,MIN(EXPExpenseSheetDtlAttendee.idfEXPExp
enseSheetDtlAttendeeKey)
					FROM #spEXPValidateWork
					INNER JOIN dbo.EXPExpenseSheetDtlAttendee WITH (NOLOCK) ON EXPExpenseSheetDtlAttendee.idfEXPExpenseSheetDtlKey = #spEXPValidateWork.idfTableLinkKey
					LEFT OUTER JOIN dbo.EXPAttendeeExpType WITH (NOLOCK) ON EXPAttendeeExpType.idfEXPAttendeeExpTypeKey = EXPExpenseSheetDtlAttendee.idfEXPAttendeeExpTypeKey
					WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey
					GROUP BY EXPAttendeeExpType.idfGLOverlayMask, EXPExpenseSheetDtlAttendee.idfEXPExpenseSheetDtlKey
				
					UPDATE #AttendeeTableDist SET idfTotalCount = TMP.idfCount
					FROM (SELECT COUNT(*) AS idfCount 
										FROM #spEXPValidateWork
										INNER JOIN dbo.EXPExpenseSheetDtlAttendee WITH (NOLOCK) ON EXPExpenseSheetDtlAttendee.idfEXPExpenseSheetDtlKey = #spEXPValidateWork.idfTableLinkKey
										WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey) TMP'
					,N'@n__idfRowKey INT',@n__idfRowKey

				IF (@xstrSource IN ('ATTENDEE_ENTRY'))
					EXEC sp_executesql N'
					INSERT INTO #AttendeeTableDist (idfGLOverlayMask,idfAmount,idfPercent,idfCount,idfSourceKey,idfRowKey)
					SELECT ISNULL(EXPAttendeeExpType.idfGLOverlayMask,'''') AS idfGLOverlayMask, SUM(idfAmount) AS idfAmount, SUM(idfPercent) AS idfPercent, COUNT(*) AS idfCount,EXPExpenseSheetDtlAttendee.idfEXPExpenseSheetDtlKey,MIN(idfRowKey)
					FROM #EXPExpenseSheetDtlAttendee EXPExpenseSheetDtlAttendee WITH (NOLOCK) 
					LEFT OUTER JOIN dbo.EXPAttendeeExpType WITH (NOLOCK) ON EXPAttendeeExpType.idfEXPAttendeeExpTypeKey = EXPExpenseSheetDtlAttendee.idfEXPAttendeeExpTypeKey
					WHERE EXPExpenseSheetDtlAttendee.idfRowAction NOT IN (''DL'')
					GROUP BY EXPAttendeeExpType.idfGLOverlayMask, EXPExpenseSheetDtlAttendee.idfEXPExpenseSheetDtlKey

					UPDATE #AttendeeTableDist SET idfTotalCount = TMP.idfCount
					FROM (SELECT COUNT(*) AS idfCount 
										FROM #spEXPValidateWork
										INNER JOIN #EXPExpenseSheetDtlAttendee EXPExpenseSheetDtlAttendee WITH (NOLOCK) ON EXPExpenseSheetDtlAttendee.idfEXPExpenseSheetDtlKey = #spEXPValidateWork.idfTableLinkKey
										WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey AND EXPExpenseSheetDtlAttendee.idfRowAction NOT IN (''DL'')) TMP'
					,N'@n__idfRowKey INT',@n__idfRowKey

				IF (@xstrSource IN ('APPROVAL'))
					EXEC sp_executesql N'
					INSERT INTO #AttendeeTableDist (idfGLOverlayMask,idfAmount,idfPercent,idfCount,idfSourceKey,idfRowKey)
					SELECT ISNULL(EXPAttendeeExpType.idfGLOverlayMask,'''') AS idfGLOverlayMask, SUM(idfAmount) AS idfAmount, SUM(idfPercent) AS idfPercent, COUNT(*) AS idfCount,EXPAprDtlAttendee.idfEXPAprDtlKey,MIN(EXPAprDtlAttendee.idfEXPAprDtlAttendeeKey)
					FROM #spEXPValidateWork
					INNER JOIN dbo.EXPAprDtlAttendee WITH (NOLOCK) ON EXPAprDtlAttendee.idfEXPAprDtlKey = #spEXPValidateWork.idfTableLinkKey
					LEFT OUTER JOIN dbo.EXPAttendeeExpType WITH (NOLOCK) ON EXPAttendeeExpType.idfEXPAttendeeExpTypeKey = EXPAprDtlAttendee.idfEXPAttendeeExpTypeKey
					WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey
					GROUP BY EXPAttendeeExpType.idfGLOverlayMask, EXPAprDtlAttendee.idfEXPAprDtlKey					

					UPDATE #AttendeeTableDist SET idfTotalCount = TMP.idfCount
					FROM (SELECT COUNT(*) AS idfCount 
										FROM #spEXPValidateWork
										INNER JOIN dbo.EXPAprDtlAttendee WITH (NOLOCK) ON EXPAprDtlAttendee.idfEXPAprDtlKey = #spEXPValidateWork.idfTableLinkKey
										WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey) TMP'
					,N'@n__idfRowKey INT',@n__idfRowKey

				IF (@xstrSource IN ('ATTENDEE_APPROVAL'))
					EXEC sp_executesql N'
					INSERT INTO #AttendeeTableDist (idfGLOverlayMask,idfAmount,idfPercent,idfCount,idfSourceKey, idfRowKey)
					SELECT ISNULL(EXPAttendeeExpType.idfGLOverlayMask,'''') AS idfGLOverlayMask, SUM(idfAmount) AS idfAmount, SUM(idfPercent) AS idfPercent, COUNT(*) AS idfCount,EXPAprDtlAttendee.idfEXPAprDtlKey,MIN(idfRowKey)
					FROM #EXPAprDtlAttendee EXPAprDtlAttendee WITH (NOLOCK) 
					LEFT OUTER JOIN dbo.EXPAttendeeExpType WITH (NOLOCK) ON EXPAttendeeExpType.idfEXPAttendeeExpTypeKey = EXPAprDtlAttendee.idfEXPAttendeeExpTypeKey
					WHERE EXPAprDtlAttendee.idfRowAction NOT IN (''DL'')
					GROUP BY EXPAttendeeExpType.idfGLOverlayMask, EXPAprDtlAttendee.idfEXPAprDtlKey					

					UPDATE #AttendeeTableDist SET idfTotalCount = TMP.idfCount
					FROM (SELECT COUNT(*) AS idfCount 
										FROM #spEXPValidateWork
										INNER JOIN #EXPAprDtlAttendee EXPAprDtlAttendee WITH (NOLOCK) ON EXPAprDtlAttendee.idfEXPAprDtlKey = #spEXPValidateWork.idfTableLinkKey
										WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey AND EXPAprDtlAttendee.idfRowAction NOT IN (''DL'')) TMP'
					,N'@n__idfRowKey INT',@n__idfRowKey

				DECLARE curCalcAttendeeDist INSENSITIVE CURSOR FOR
				SELECT idfGLOverlayMask,idfAmount,idfPercent,idfCount,vwFNACurrency.edfPrecision,idfTotalCount,idfSourceKey
				FROM #AttendeeTableDist
				INNER JOIN vwFNACurrency ON edfCurrencyID = @stredfCurrency
				ORDER BY idfRowKey
	
				OPEN curCalcAttendeeDist
		
				FETCH NEXT FROM curCalcAttendeeDist INTO @strOVERLAY_OverlayString, @nidfAmount, @nidfPercent, @nidfCount, @nedfPrecision, @nidfTotalCount, @nidfSourceKey
				WHILE (@@fetch_status <> -1) BEGIN
					IF (@@fetch_status <> -2) 
					BEGIN
						IF EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPATTENDEEAUTOEQ' AND idfValue = 1)
						BEGIN
							SELECT @nidfAmount = ROUND(@n__edfAmtExtended / @nidfTotalCount,@nedfPrecision) * @nidfCount
							SELECT @nidfPercent =  ROUND((@nidfAmount / @n__edfAmtExtended)*100,2)
							
							IF (@nidfFlagPrimary = 1)
							BEGIN
								SELECT @nidfAmount = @nidfAmount + (@n__edfAmtExtended - ROUND(@n__edfAmtExtended / @nidfTotalCount,@nedfPrecision) * @nidfTotalCount)
								SELECT @nidfPercent = ROUND((@nidfAmount / @n__edfAmtExtended)*100,2)
							END
						END

						IF (@strOVERLAY_OverlayString='')
							SELECT @strOVERLAY_GLString = @strvdfGL	
						ELSE
							EXEC spFNAApplyOverlay @strvdfGL, @strOVERLAY_OverlayString, @strOVERLAY_GLString OUTPUT

						SELECT @nidfGL = NULL
						SELECT @nidfGL = GLAccount.idfGLAccountKey
						FROM dbo.GLAccount WITH (NOLOCK) 
						INNER JOIN dbo.WCICCompanyTableLinkType LT WITH (NOLOCK) ON LT.idfModule = 'GLOBAL' AND idfTableName = 'GLAccount'
						WHERE GLAccount.idfGLID  = @strOVERLAY_GLString AND GLAccount.idfFlagActive = 1
						AND (GLAccount.idfWCICCompanyKey IS NULL
						OR (LT.idfLinkType='SOURCE' AND GLAccount.idfWCICCompanyKey = @nidfWCICCompanyKeySource)
						OR (LT.idfLinkType='TARGET' AND GLAccount.idfWCICCompanyKey = @nidfWCICCompanyKeyTarget))

						IF (@strOVERLAY_GLString <> '' AND @nidfGL IS NULL)
							EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -154, 'spEXPValidate',@xstrParam1=@strOVERLAY_GLString,@xstrParam2=@strOVERLAY_OverlayString

						IF (@nidfGL IS NOT NULL)
						BEGIN
							INSERT INTO dbo.WCTEMPPTIConvertCurrencyExt
							(
								 idfOwnerSPID                
								,idfOwnerCreated             
								,idfOwnerProcess             
								,idfAmountFrom               
								,idfAmountToApr				
								,idfAmountToHome				
								,idfRowKey                   
								,idfPTICurrencyKeyFrom       
								,idfPTICurrencyRateDtlKeyApr	
								,idfPTICurrencyRateDtlKeyHome
								,idfDateConvert
								,idfTag
								,idfType
							)
							SELECT
								 @@SPID						--idfOwnerSPID                
								,GETDATE()					--idfOwnerCreated             
								,'spEXPValidate'			--idfOwnerProcess             
								,@nidfAmount				--idfAmountFrom               
								,NULL						--idfAmountApr				
								,NULL						--idfAmountHome				
								,@n__idfRowKey				--idfRowKey                   
								,@nidfPTICurrencyKey		--idfPTICurrencyKeyFrom       
								,NULL						--idfPTICurrencyRateDtlKeyApr	
								,NULL						--idfPTICurrencyRateDtlKeyHome
								,ISNULL(@dt_idfDay,getdate()) --idfDateConvert
								,@n__idfRowKey				--idfSourceKey
								,'HOME'						--idfType

							EXEC dbo.spPTIConvertCurrencyExt @xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT,NULL,'EXPExpenseSheetDtl','AP'

							SELECT 	@nidfAmountHome = idfAmountToHomeRounded FROM dbo.WCTEMPPTIConvertCurrencyExt WHERE idfOwnerSPID = @@SPID

							DELETE WCTEMPPTIConvertCurrencyExt FROM dbo.WCTEMPPTIConvertCurrencyExt WHERE idfOwnerSPID = @@SPID

							INSERT INTO #DtlDistribution
							(
								  idfAmtExtended        
								, idfAmtExtendedHome    
								, idfFlagPrimary        
								, idfPercent                  
								, idfGLAccountKey       
								, idfSourceKey											
							)
							VALUES
							(
								  @nidfAmount		--idfAmtExtended        
								, @nidfAmountHome	--idfAmtExtendedHome    
								, @nidfFlagPrimary	--idfFlagPrimary        
								, @nidfPercent		--idfPercent                
								, @nidfGL			--idfGLAccountKey       
								, @nidfSourceKey	--idfSourceKey			
							)
						END

						IF (@nidfFlagPrimary = 1)
							IF (@strOVERLAY_GLString > '')
								SELECT @strvdfGL = @strOVERLAY_GLString

						SELECT @nidfFlagPrimary = 0
					END
					FETCH NEXT FROM curCalcAttendeeDist INTO @strOVERLAY_OverlayString, @nidfAmount, @nidfPercent, @nidfCount, @nedfPrecision, @nidfTotalCount, @nidfSourceKey
				END
		
				CLOSE curCalcAttendeeDist
				DEALLOCATE curCalcAttendeeDist

				IF (@xstrSource IN ('ENTRY','ATTENDEE_ENTRY'))
					EXEC sp_executesql N'
					DECLARE @nDistKey INT, @nCount INT
					SELECT @nCount = COUNT(*) FROM #DtlDistribution

					-- Remove Current Distributions
					DELETE EXPExpenseSheetDtlDistribution 
					FROM #spEXPValidateWork
					INNER JOIN dbo.EXPExpenseSheetDtlDistribution WITH (NOLOCK) ON EXPExpenseSheetDtlDistribution.idfEXPExpenseSheetDtlKey = #spEXPValidateWork.idfTableLinkKey
					WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey AND @nCount > 0

					EXEC spWCGetNextPK ''EXPExpenseSheetDtlDistribution'',@nDistKey OUTPUT,@nCount
					INSERT INTO EXPExpenseSheetDtlDistribution
					(
						idfEXPExpenseSheetDtlDistributionKey
						,idfAmtExtended
						,idfAmtExtendedHome
						,idfFlagPrimary
						,idfPercent
						,idfDateApply
						,idfDateCreated
						,idfDateModified
						,idfGLAccountKey
						,idfEXPExpenseSheetDtlKey
						,idfWCICCompanyKey
						,idfPTICurrencyKey
					)
					SELECT 
						 idfKey	+ @nDistKey					--idfEXPExpenseSheetDtlDistributionKey
						,idfAmtExtended						--idfAmtExtended
						,idfAmtExtendedHome					--idfAmtExtendedHome
						,idfFlagPrimary						--idfFlagPrimary
						,idfPercent							--idfPercent
						,ISNULL(@dt_idfDay,getdate())		--idfDateApply
						,getdate()							--idfDateCreated
						,getdate()							--idfDateModified
						,idfGLAccountKey					--idfGLAccountKey
						,idfSourceKey						--idfEXPExpenseSheetDtlKey
						,@nidfWCICCompanyKeySource
						,@nidfPTICurrencyKey
					FROM #DtlDistribution
					',N'			
					 @dt_idfDay				DATETIME				
					,@nidfWCICCompanyKeySource INT
					,@nidfPTICurrencyKey	INT
					,@nidfGLPeriodKey		INT
					,@n__idfRowKey			INT
					'				
					,@dt_idfDay
					,@nidfWCICCompanyKeySource
					,@nidfPTICurrencyKey
					,@nidfGLPeriodKey
					,@n__idfRowKey

				IF (@xstrSource IN ('APPROVAL','ATTENDEE_APPROVAL'))
					EXEC sp_executesql N'
					DECLARE @nDistKey INT, @nCount INT
					SELECT @nCount = COUNT(*) FROM #DtlDistribution

					-- Remove Current Distributions
					DELETE EXPAprDtlDistribution 
					FROM #spEXPValidateWork
					INNER JOIN dbo.EXPAprDtlDistribution WITH (NOLOCK) ON EXPAprDtlDistribution.idfEXPAprDtlKey = #spEXPValidateWork.idfTableLinkKey
					WHERE #spEXPValidateWork.idfRowKey = @n__idfRowKey

					EXEC spWCGetNextPK ''EXPAprDtlDistribution'',@nDistKey OUTPUT, @nCount
					INSERT INTO EXPAprDtlDistribution
					(
						idfEXPAprDtlDistributionKey
						,idfAmtExtended
						,idfAmtExtendedHome
						,idfFlagPrimary
						,idfPercent
						,idfDateApply
						,idfDateCreated
						,idfDateModified
						,idfGLAccountKey
						,idfEXPAprDtlKey
						,idfWCICCompanyKey
						,idfPTICurrencyKey
					)
					SELECT 
						 idfKey + @nDistKey					--idfEXPAprDtlDistributionKey
						,idfAmtExtended						--idfAmtExtended
						,idfAmtExtendedHome					--idfAmtExtendedHome
						,idfFlagPrimary						--idfFlagPrimary
						,idfPercent							--idfPercent
						,ISNULL(@dt_idfDay,getdate())		--idfDateApply
						,getdate()							--idfDateCreated
						,getdate()							--idfDateModified
						,idfGLAccountKey					--idfGLAccountKey
						,idfSourceKey						--idfEXPAprDtlKey
						,@nidfWCICCompanyKeySource
						,@nidfPTICurrencyKey
					FROM #DtlDistribution
					',N'			
					 @dt_idfDay				DATETIME				
					,@nidfWCICCompanyKeySource INT
					,@nidfPTICurrencyKey	INT
					,@nidfGLPeriodKey		INT
					,@n__idfRowKey			INT
					'				
					,@dt_idfDay
					,@nidfWCICCompanyKeySource
					,@nidfPTICurrencyKey
					,@nidfGLPeriodKey
					,@n__idfRowKey
			END

			IF (NOT EXISTS (SELECT TOP 1 1 FROM dbo.GLAccount WITH (NOLOCK) WHERE idfGLID = @strvdfGL) AND (@nvdfGLExists=0))
				SELECT @strvdfGL = ''

			UPDATE #spEXPValidateWork 
				SET vdfGL = @strvdfGL
				WHERE idfRowKey = @n__idfRowKey	

			--GL Account
			
		UPDATE #spEXPValidateWork SET
		idfGLAccountKey = GLAccount.idfGLAccountKey
		FROM #spEXPValidateWork WITH (NOLOCK )
		INNER JOIN dbo.WCICCompanyTableLinkType LT WITH (NOLOCK) ON LT.idfModule = 'GLOBAL' AND idfTableName = 'GLAccount'
		LEFT OUTER JOIN dbo.GLAccount WITH (NOLOCK) ON #spEXPValidateWork.vdfGL = GLAccount.idfGLID AND GLAccount.idfFlagActive = 1
		AND (GLAccount.idfWCICCompanyKey IS NULL
		OR (LT.idfLinkType='SOURCE' AND GLAccount.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeySource)
		OR (LT.idfLinkType='TARGET' AND GLAccount.idfWCICCompanyKey = #spEXPValidateWork.idfWCICCompanyKeyTarget))
		WHERE 1=1
		OPTION (FORCE ORDER, KEEPFIXED PLAN)
	

			SELECT @nidfGLAccountKey = idfGLAccountKey FROM #spEXPValidateWork WHERE idfRowKey = @n__idfRowKey	
		END


		--Validate GL Mask.
		IF @strvdfGL <> '' AND (NOT EXISTS(SELECT 1 FROM WCDept (NOLOCK) WHERE (@strvdfGL LIKE WCDept.idfGLMask OR @strvdfGL LIKE WCDept.idfGLMask2) AND idfWCDeptKey = @n__idfWCDeptKey AND WCDept.idfFlagActive = 1) AND @n__idfWCDeptKey IS NOT NULL)
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -155, 'spEXPValidate',@xstrParam1=@strvdfGL

		IF (@strvdfGL <> '' AND @edfGL IS NULL)

			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -154, 'spEXPValidate',@xstrParam1=@strvdfGL

		IF (@xstrSource <> 'UDFTEMPLATE') BEGIN
			IF (@stredfCurrency = '')
				EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -147, 'spEXPValidate'
			ELSE BEGIN
				-- If source is not UDFTEMPLATE then round and calculate ext amounts.
				-- ----------------------------------------------------------------------------------------------------------------------------
				-- Round and calculate NATURAL currency
				-- ----------------------------------------------------------------------------------------------------------------------------				
				SELECT @n__edfAmtExtended = (@n__edfPrice * @n__idfQuantity) + ISNULL(@n__edf1099Amount,0) + ISNULL(@n__edfFreight,0) + ISNULL(@n__edfMiscCharges,0) + ISNULL(@n__idfAmtTax,0)
				SELECT @n__edfAmtExtendedUnRound = @n__edfAmtExtended
				
				EXEC spFNARoundCurrency '',0,'', @stredfCurrency, @n__edfAmtExtended	, @n__edfAmtExtended	OUTPUT

				
				SELECT @nidfPTICurrencyKeyReceipt = idfPTICurrencyKey FROM dbo.vwFNACurrency WITH (NOLOCK) WHERE edfCurrencyID = @strvdfCurrencyIDReceipt
				SELECT @nidfPTICurrencyKey = idfPTICurrencyKey FROM dbo.vwFNACurrency WITH (NOLOCK) WHERE edfCurrencyID = @stredfCurrency
				SELECT @nidfPTICurrencyKeyHome = idfPTICurrencyKey, @strvdfCurrencyIDHome = edfCurrencyID FROM dbo.vwFNACurrency WITH (NOLOCK) WHERE edfFunctional = 1
				
				IF (@n__edfPrice = 0 AND @nidfAmtExtendedReceipt <> 0)
				BEGIN
					IF @nidfPTICurrencyKeyReceipt <> @nidfPTICurrencyKey
					BEGIN
						--Go from Rct curr  to Func
						
						EXEC spFNAConvertCur '',0,'', @strvdfCurrencyIDReceipt, 1, @nidfAmtExtendedReceipt	, @n__edfAmtExtended	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
						insert into test_exchange values (@strvdfCurrencyIDReceipt,1,@nidfAmtExtendedReceipt,@n__edfAmtExtended	,@nvdfExchangeRate ,@strvdfRateType ,@strvdfRateTable ,@nvdfRateCal ,@strvdfRateDate ,@strvdfRateTime ,@dt_EXidfDay)
						EXEC spFNARoundCurrency '',0,'', '', @n__edfAmtExtended, @n__edfAmtExtended OUTPUT
						-- if line currency is different from Func
						IF @nidfPTICurrencyKey <> @nidfPTICurrencyKeyHome 

						BEGIN
							
							EXEC spFNAConvertCur '',0,'', @stredfCurrency, 2, @n__edfAmtExtended	, @n__edfAmtExtended	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
							insert into test_exchange values (@stredfCurrency,2,@n__edfAmtExtended	,@n__edfAmtExtended	,@nvdfExchangeRate ,@strvdfRateType ,@strvdfRateTable ,@nvdfRateCal ,@strvdfRateDate,@strvdfRateTime ,@dt_EXidfDay)
							EXEC spFNARoundCurrency '',0,'', @stredfCurrency, @n__edfAmtExtended, @n__edfAmtExtended OUTPUT
							SELECT @n__edfPrice = @n__edfAmtExtended / @n__idfQuantity
							--EXEC spFNARoundCurrency '',0,'', @stredfCurrency, @n__edfPrice, @n__edfPrice OUTPUT
						END
						ELSE
						BEGIN 
							SELECT @n__edfPrice = @n__edfAmtExtended / @n__idfQuantity
							--EXEC spFNARoundCurrency '',0,'', '', @n__edfPrice, @n__edfPrice OUTPUT
						END
					END
					ELSE 
					BEGIN
						SELECT @n__edfAmtExtended = @nidfAmtExtendedReceipt
						SELECT @n__edfPrice = @n__edfAmtExtended / CASE WHEN ISNULL(@n__idfQuantity,0) = 0 THEN 1 ELSE @n__idfQuantity END
					END
				END
				IF @nidfAmtExtendedReceipt = 0
				BEGIN 
					UPDATE #spEXPValidateWork SET vdfCurrencyIDReceipt = @stredfCurrency,idfPTICurrencyKeyReceipt = @nidfPTICurrencyKey,idfAmtExtendedReceipt = @n__edfAmtExtended WHERE idfRowKey = @n__idfRowKey	
				END
				--IF (@n__edfPrice <> 0 AND @nidfAmtExtendedReceipt = 0 AND @nidfPTICurrencyKeyReceipt <> @nidfPTICurrencyKey)
				--BEGIN
				--	-- Going from UnFunc curr on line to Func Curr on RCT
				--	IF @nidfPTICurrencyKeyReceipt = @nidfPTICurrencyKeyHome AND @nidfPTICurrencyKey <> @nidfPTICurrencyKeyHome
				--	BEGIN 
				--		EXEC spFNAConvertCur '',0,'', @stredfCurrency, 1, @n__edfAmtExtended	, @nidfAmtExtendedReceipt	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				--		EXEC spFNARoundCurrency '',0,'', '', @nidfAmtExtendedReceipt, @nidfAmtExtendedReceipt OUTPUT
				--	END
				--	-- Going from UnFunc curr on line to diff UnFunc Curr on RCT
				--	IF @nidfPTICurrencyKeyReceipt <> @nidfPTICurrencyKeyHome AND @nidfPTICurrencyKey <> @nidfPTICurrencyKeyHome
				--	BEGIN 
					
				--		EXEC spFNAConvertCur '',0,'', @stredfCurrency, 1, @n__edfAmtExtended	, @nidfAmtExtendedReceipt	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				--		EXEC spFNARoundCurrency '',0,'', '', @nidfAmtExtendedReceipt, @nidfAmtExtendedReceipt OUTPUT
						
				--		EXEC spFNAConvertCur '',0,'', @strvdfCurrencyIDReceipt, 2, @nidfAmtExtendedReceipt	, @nidfAmtExtendedReceipt	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				--		EXEC spFNARoundCurrency '',0,'', '', @nidfAmtExtendedReceipt, @nidfAmtExtendedReceipt OUTPUT
				--	END

				--	-- Going from Func curr on line to UnFunc Curr on RCT
				--	IF @nidfPTICurrencyKeyReceipt <> @nidfPTICurrencyKeyHome AND @nidfPTICurrencyKey = @nidfPTICurrencyKeyHome
				--	BEGIN 
				--		EXEC spFNAConvertCur '',0,'', @strvdfCurrencyIDReceipt, 2, @n__edfAmtExtended	, @nidfAmtExtendedReceipt	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				--		EXEC spFNARoundCurrency '',0,'', '', @nidfAmtExtendedReceipt, @nidfAmtExtendedReceipt OUTPUT
				--	END

				--	UPDATE #spEXPValidateWork SET idfAmtExtendedReceipt = @nidfAmtExtendedReceipt FROM #spEXPValidateWork DTL WHERE DTL.idfRowKey = @n__idfRowKey	
				--END
				-- ----------------------------------------------------------------------------------------------------------------------------
				-- Round and calculate HOME currency
				-- ----------------------------------------------------------------------------------------------------------------------------
				EXEC spFNAConvertCur '',0,'', @stredfCurrency, 1, @n__edf1099Amount	, @n__edf1099AmountHome	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				EXEC spFNAConvertCur '',0,'', @stredfCurrency, 1, @n__edfFreight	, @n__edfFreightHome	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				EXEC spFNAConvertCur '',0,'', @stredfCurrency, 1, @n__edfMiscCharges	, @n__edfMiscChargesHome OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				EXEC spFNAConvertCur '',0,'', @stredfCurrency, 1, @n__edfPrice		, @n__edfPriceHome	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay


				SELECT @n__edfAmtHomeExtended = (@n__edfPriceHome * @n__idfQuantity) + @n__edf1099AmountHome + @n__edfFreightHome + @n__edfMiscChargesHome
				SELECT @n__edfAmtHomeExtendedUnRound = @n__edfAmtHomeExtended
								
				EXEC spFNARoundCurrency '',0,'', '', @n__edfAmtHomeExtended, @n__edfAmtHomeExtended OUTPUT

				IF ((ISNULL(@nvdfExchangeRate,1) = 1) AND (@stredfCurrency <> @strvdfCurrencyIDHome))
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -189, 'spEXPValidate',@xstrParam1=@stredfCurrency,@xstrParam2=@strvdfCurrencyIDHome	
				--Check that a valid exchange rate can be found for the currency.
				IF(ISNULL(@nvdfExchangeRate, 0) = 0)
				BEGIN
					EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -201, 'spEXPValidate'
				END
				-- ----------------------------------------------------------------------------------------------------------------------------
				-- Round and calculate APPROVAL currency
				-- ----------------------------------------------------------------------------------------------------------------------------
				EXEC spFNAConvertCur '',0,'', @strWCSystem_edfCurrencyApproval, 2, @n__edf1099AmountHome	, @n__edf1099AmountApr	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				EXEC spFNAConvertCur '',0,'', @strWCSystem_edfCurrencyApproval, 2, @n__edfFreightHome		, @n__edfFreightApr	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				EXEC spFNAConvertCur '',0,'', @strWCSystem_edfCurrencyApproval, 2, @n__edfMiscChargesHome	, @n__edfMiscChargesApr OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
				EXEC spFNAConvertCur '',0,'', @strWCSystem_edfCurrencyApproval, 2, @n__edfPriceHome		, @n__edfPriceApr	OUTPUT, @nvdfExchangeRate OUTPUT, @strvdfRateType OUTPUT, @strvdfRateTable OUTPUT, @nvdfRateCal OUTPUT, @strvdfRateDate OUTPUT, @strvdfRateTime OUTPUT,NULL,@dt_EXidfDay
		
				SELECT @n__edfAmtAprExtended = (@n__edfPriceApr * @n__idfQuantity) + @n__edf1099AmountApr + @n__edfFreightApr + @n__edfMiscChargesApr
			
				EXEC spFNARoundCurrency '',0,'', @strWCSystem_edfCurrencyApproval, @n__edfAmtAprExtended, @n__edfAmtAprExtended OUTPUT

				-- ----------------------------------------------------------------------------------------------------------------------------
				-- Round and calculate Reimbursement currency
				-- ----------------------------------------------------------------------------------------------------------------------------
				IF (ISNULL(@nEXPREIMBURSEMENTCURR,0) <> 0)
				BEGIN
					IF (@strReimCurrencyID = @stredfCurrency)
						SELECT @nedfAmtReimExtended = @n__edfAmtExtendedUnRound
					ELSE IF (@strHomeCurrencyID = @strReimCurrencyID)
						SELECT @nedfAmtReimExtended = @n__edfAmtHomeExtendedUnRound
					ELSE 
						EXEC spFNAConvertCur 
							 ''
							,0
							,''
							, @strReimCurrencyID 
							, 2
							, @n__edfAmtHomeExtendedUnRound	
							, @nedfAmtReimExtended	OUTPUT
							, @nvdfExchangeRate OUTPUT
							, @strvdfRateType OUTPUT
							, @strvdfRateTable OUTPUT
							, @nvdfRateCal OUTPUT
							, @strvdfRateDate OUTPUT
							, @strvdfRateTime OUTPUT
							,NULL
							,@dt_EXidfDay
				
					EXEC spFNARoundCurrency '',0,'', '', @nedfAmtReimExtended, @nedfAmtReimExtended OUTPUT,2
				END
				-- ----------------------------------------------------------------------------------------------------------------------------

				UPDATE #spEXPValidateWork
				SET 	  edfPrice 				= ISNULL(@n__edfPrice,0)
						, edfAmtExtended 		= ISNULL(@n__edfAmtExtended,0)
						, edfAmtHomeExtended 	= ISNULL(@n__edfAmtHomeExtended,0)
						, edfAmtAprExtended		= ISNULL(@n__edfAmtAprExtended,0)
						, idfAmtFreightApr		= ISNULL(@n__edfFreightApr,0)	
						, idfAmtFreightHome		= ISNULL(@n__edfFreightHome,0)
						, idfAmtMiscApr			= ISNULL(@n__edfMiscChargesApr,0)
						, idfAmtMiscHome		= ISNULL(@n__edfMiscChargesHome,0)
				--		, idfAmtExtendedReceipt	= CASE WHEN vdfCurrencyIDReceipt = vdfCurrencyID THEN @n__edfAmtExtended ELSE idfAmtExtendedReceipt END	
						, edfAmtReimExtended	= CASE WHEN EXPPayment.idfEXPPaymentKey IS NOT NULL AND (WCSecurity.idfWCSecurityKey IS NOT NULL OR EXPPayment.idfAPVendorKey IS NULL) THEN CASE WHEN ISNULL(@nEXPREIMBURSEMENTCURR,0) <> 0 THEN @nedfAmtReimExtended ELSE ISNULL(@n__edfAmtExtended,0) END ELSE @n__edfAmtExtended END
				FROM #spEXPValidateWork DTL
				LEFT OUTER JOIN dbo.EXPPayment WITH (NOLOCK) ON EXPPayment.idfEXPPaymentKey = DTL.idfEXPPaymentKey AND EXPPayment.idfFlagReimburse = 1
				LEFT OUTER JOIN dbo.WCSecurity WITH (
				NOLOCK) ON WCSecurity.idfWCSecurityKey = DTL.idfWCSecurityKey AND WCSecurity.idfAPVendorKey = EXPPayment.idfAPVendorKey
				WHERE DTL.idfRowKey = @n__idfRowKey
	/*	*/
	
	IF (EXISTS (SELECT TOP 1 1 FROM dbo.EXPType WITH (NOLOCK) WHERE idfEXPTypeKey = @n__idfEXPTypeKey AND idfFlagCreateCM = 1) AND @n__edfAmtExtended < 0)
		EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -197, 'spEXPValidate'	
		
---- ----------------------------------------------------------------------------------------------------------------------------		
			END
		END
	END
	FETCH curspEXPValidate INTO
		 @n__idfRowKey
		,@stridfComment
		,@dt_idfDay
		,@stridfDescription
		,@n__idfQuantity
		,@nidfEXPEventKey
		,@n__idfEXPExpenseSheetHdrKey
		,@n__idfEXPPaymentKey
		,@n__idfEXPTypeKey
		,@n__idfWCDeptKey
		,@n__idfWCUDFListDtlKey02
		,@n__edf1099Amount
		,@n__edfAmtAprExtended
		,@n__edfAmtExtended
		,@n__edfAmtHomeExtended
		,@nidfAmtExtendedReceipt
		,@nedfAmtReimExtended
		,@n__edfFreight
		,@n__edfMiscCharges
		,@n__edfPrice
		,@stredfTax
		,@n__idfAmtTax
		,@strvdfTaxScheduleID
		,@strvdfCountryID
		,@nidfFlagImported
		,@nidfFlagManualDist
		,@stridfImportedRefNo
		,@nidfWCImportMapKey
		,@stredfBillType
		,@stredfCardName
		,@stredfCurrency
		,@stredfPAProjectL1
		,@stredfPAProjectL1Class
		,@stredfPAProjectL2
		,@stredfPAProjectL2Class
		,@stredfPAProjectL3
		,@stredfPAProjectL3Class
		,@nedfWSProductIndicator
		,@stredfShippingMethod
		,@stredfTaxSchedule
		,@stredfUOM
		,@strvdfGL
		,@stredfFacilityID
		,@strvdfEventID
		,@strvdfPaymentID
		,@strvdfTypeID
		,@strvdfID
		,@strvdfDeptID
		,@nEmployee__idfWCSecurityKey
		,@edfGL
		,@strvdfVendorID
		,@nidfAPVendorKey
		,@strvdfCurrencyIDReim
		,@strvdfCurrencyIDReceipt
		,@nidfEXPExpenseSheetDtlKey
		,@stridfRowAction
		,@nidfWCICCompanyKeySource
		,@nidfWCICCompanyKeyTarget
		,@strvdfCompanyCodeTarget
		,@nidfEXPSessionKey
		,@nidfEXPExpenseSheetDtlKeyTravel		
		,@nidfBUDHeaderKey
		,@dtidfBudgetApplyDate
		,@strvdfBudgetID
		,@stridfCodeApr
		,@nvdfBudgetValid
		,@nidfGLPeriodKey
END --@@fetch_status <> -1
CLOSE curspEXPValidate
DEALLOCATE curspEXPValidate

-- ------------------------------------------------------------------------------------------------------------------------
-- Validate GL Segment GL to ID
-- ------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------	

		-- GL Account Restriction By Indv
			EXEC sp_executesql N'INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber)		
			SELECT DTL.idfRowKey,-198
			FROM #spEXPValidateWork DTL
				INNER JOIN dbo.PAProject WITH (NOLOCK) ON PAProject.idfPAProjectKey = DTL.idfPAProjectKey AND PAProject.idfGLRestrictType = ''K'' AND PAProject.idfGLRestrictValue <> DTL.vdfGL
				'

		-- GL Account Restriction By List
			EXEC sp_executesql N'
		INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber)		
			SELECT DTL.idfRowKey,-198
			FROM #spEXPValidateWork DTL
				INNER JOIN dbo.PAProject WITH (NOLOCK) ON PAProject.idfPAProjectKey = DTL.idfPAProjectKey AND PAProject.idfGLRestrictType = ''L'' AND PAProject.idfGLRestrictValue > ''''
			LEFT OUTER JOIN 
			(
				SELECT DTL.idfRowKey
				FROM #spEXPValidateWork DTL
					INNER JOIN dbo.PAProject WITH (NOLOCK) ON PAProject.idfPAProjectKey = DTL.idfPAProjectKey AND PAProject.idfGLRestrictType = ''L''
				INNER JOIN dbo.WCListHdr WITH (NOLOCK) ON WCListHdr.idfListID = PAProject.idfGLRestrictValue AND WCListHdr.idfWCListTypeKey = 2
				INNER JOIN dbo.WCListDtl WITH (NOLOCK) ON WCListDtl.idfWCListHdrKey = WCListHdr.idfWCListHdrKey AND WCListDtl.idfCodeKey = DTL.idfGLAccountKey
			) TMP ON TMP.idfRowKey = DTL.idfRowKey
			WHERE TMP.idfRowKey IS NULL
				OPTION (KEEP PLAN, KEEPFIXED PLAN)'

		-- GL Account Restriction By Not in List
			EXEC sp_executesql N'
		INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber)
			SELECT DTL.idfRowKey,-198
				FROM #spEXPValidateWork DTL
					INNER JOIN dbo.PAProject WITH (NOLOCK) ON PAProject.idfPAProjectKey = DTL.idfPAProjectKey AND PAProject.idfGLRestrictType = ''N''
				INNER JOIN dbo.WCListHdr WITH (NOLOCK) ON WCListHdr.idfListID = PAProject.idfGLRestrictValue AND WCListHdr.idfWCListTypeKey = 2
				INNER JOIN dbo.WCListDtl WITH (NOLOCK) ON WCListDtl.idfWCListHdrKey = WCListHdr.idfWCListHdrKey AND WCListDtl.idfCodeKey = DTL.idfGLAccountKey'

	EXEC sp_executesql N'UPDATE #spWCValDtl SET idfErrNum = ErrorNumber, idfOBJName = CASE WHEN ISNULL(idfOBJName,'''') = '''' THEN ''spEXPValidate'' ELSE idfOBJName END OPTION (KEEP PLAN)'
	EXEC spWCValDtl @xchAction = 'IN', @xonWCValHdrKey = @nWCValHdrKey OUTPUT

-- ------------------------------------------------------------------------------------------------------------------------
-- Validate Budget
-- ------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------	


 --Validate all rows
DECLARE curspEXPValidatePerDiem INSENSITIVE CURSOR
FOR SELECT
	 idfRowKey
	,idfEXPExpenseSheetDtlKey
	,idfEXPTypeKey
	,idfDay
	,idfWCSecurityKey	
FROM #spEXPValidateWork

OPEN curspEXPValidatePerDiem

FETCH curspEXPValidatePerDiem INTO
	 @n__idfRowKey
	,@nidfEXPExpenseSheetDtlKey
	,@n__idfEXPTypeKey
	,@dt_idfDay
	,@nEmployee__idfWCSecurityKey
WHILE @@fetch_status <> -1
BEGIN
	IF @@fetch_status <> -2
	BEGIN	
		-- ----------------------------------------------------------------------------------------------------------------------------
		-- Expense Type Per Diem
		-- ----------------------------------------------------------------------------------------------------------------------------					
		SELECT @nidfDailyPerDiem = idfDailyPerDiem FROM EXPType WITH (NOLOCK) WHERE idfEXPTypeKey = @n__idfEXPTypeKey
		SELECT @nidfDailyPerDiemSUM = SUM(edfAmtReimExtended) FROM (
				SELECT ISNULL(SUM(EXPExpenseSheetDtl.edfAmtReimExtended),0) AS edfAmtReimExtended 
				FROM EXPExpenseSheetDtl	WITH (NOLOCK)
				INNER JOIN dbo.EXPExpenseSheetHdr WITH (NOLOCK) ON EXPExpenseSheetHdr.idfEXPExpenseSheetHdrKey = EXPExpenseSheetDtl.idfEXPExpenseSheetHdrKey
				LEFT OUTER JOIN #spEXPValidateWork OTH ON OTH.idfEXPExpenseSheetDtlKey = EXPExpenseSheetDtl.idfEXPExpenseSheetDtlKey
				WHERE EXPExpenseSheetHdr.idfEXPEntryTypeKey <> 2
				AND OTH.idfEXPExpenseSheetDtlKey IS NULL
				AND EXPExpenseSheetDtl.idfEXPSessionKey <> 120 
				AND EXPExpenseSheetDtl.idfEXPTypeKey  = @n__idfEXPTypeKey 
				AND EXPExpenseSheetDtl.idfDay = @dt_idfDay 
				AND EXPExpenseSheetHdr.idfWCSecurityKey = @nEmployee__idfWCSecurityKey
			UNION ALL 
				SELECT ISNULL(SUM(#spEXPValidateWork.edfAmtReimExtended),0) AS edfAmtReimExtended 
				FROM #spEXPValidateWork	WITH (NOLOCK) 
				WHERE #spEXPValidateWork.idfEXPEntryTypeKey <> 2 AND #spEXPValidateWork.idfEXPTypeKey = @n__idfEXPTypeKey AND #spEXPValidateWork.idfDay = @dt_idfDay AND #spEXPValidateWork.idfWCSecurityKey = @nEmployee__idfWCSecurityKey			UNION ALL 
			SELECT ISNULL(SUM(EXPAprDtl.edfAmtReimExtended),0) AS edfAmtReimExtended 
				FROM EXPAprDtl WITH (NOLOCK) 
				INNER JOIN dbo.EXPAprDtlEXPExpenseSheetHdr WITH (NOLOCK) ON EXPAprDtlEXPExpenseSheetHdr.idfEXPAprDtlEXPExpenseSheetHdrKey = EXPAprDtl.idfEXPAprDtlEXPExpenseSheetHdrKey
				LEFT OUTER JOIN #spEXPValidateWork OTH ON OTH.idfEXPExpenseSheetDtlKey = EXPAprDtl.idfEXPExpenseSheetDtlKey
				WHERE EXPAprDtlEXPExpenseSheetHdr.idfEXPEntryTypeKey <> 2 
				AND OTH.idfEXPExpenseSheetDtlKey IS NULL
				AND EXPAprDtl.idfEXPTypeKey = @n__idfEXPTypeKey 
				AND EXPAprDtl.idfDay = @dt_idfDay 
				AND EXPAprDtlEXPExpenseSheetHdr.idfWCSecurityKey = @nEmployee__idfWCSecurityKey
			UNION ALL 
			SELECT ISNULL(SUM(EXPExpenseSheetDtlHist.edfAmtReimExtended),0) AS edfAmtReimExtended 
				FROM EXPExpenseSheetDtlHist  WITH (NOLOCK)
				INNER JOIN dbo.EXPExpenseSheetHdrHist WITH (NOLOCK) ON EXPExpenseSheetHdrHist.idfEXPExpenseSheetHdrHistKey = EXPExpenseSheetDtlHist.idfEXPExpenseSheetHdrHistKey
				WHERE EXPExpenseSheetHdrHist.idfEXPEntryTypeKey <> 2 AND EXPExpenseSheetDtlHist.idfEXPTypeKey = @n__idfEXPTypeKey AND EXPExpenseSheetDtlHist.idfDay = @dt_idfDay AND EXPExpenseSheetHdrHist.idfWCSecurityKey = @nEmployee__idfWCSecurityKey) TBL

		IF ((@nidfDailyPerDiem > 0) AND (@nidfDailyPerDiem < @nidfDailyPerDiemSUM))
			EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @xonWCValHdrKey OUTPUT, @n__idfRowKey, -170, 'spEXPValidate'
		END
	FETCH curspEXPValidatePerDiem INTO
		 @n__idfRowKey
		,@nidfEXPExpenseSheetDtlKey
		,@n__idfEXPTypeKey
		,@dt_idfDay
		,@nEmployee__idfWCSecurityKey
END --@@fetch_status <> -1
CLOSE curspEXPValidatePerDiem
DEALLOCATE curspEXPValidatePerDiem


---------------------------------------------------------------------------------------------
-- Validate Budgets Over
---------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT TOP 1 1 FROM #spEXPValidateWork WHERE idfBUDHeaderKey IS NOT NULL)
BEGIN

	SELECT SUM(idfAmtHomeExtOld) AmtOld, P.idfBUDPeriodKey
	INTO #BUDPeriodOld
	FROM #spEXPValidateWork V
	INNER JOIN dbo.BUDPeriod P	 WITH (NOLOCK) ON P.idfBUDHeaderKey = V.idfBUDHeaderKeyOld AND V.idfBudgetApplyDateOld BETWEEN P.idfPeriodBegin AND P.idfPeriodEnd
	GROUP BY P.idfBUDPeriodKey
	OPTION (KEEPFIXED PLAN)

	SELECT SUM(EXPExpenseSheetDtl.edfAmtExtended) AmtOld, P.idfBUDPeriodKey
	INTO #BUDPeriodTravelAmt
	FROM #spEXPValidateWork V
	INNER JOIN dbo.EXPExpenseSheetDtl WITH (NOLOCK) ON EXPExpenseSheetDtl.idfEXPExpenseSheetDtlKey = V.idfEXPExpenseSheetDtlKeyTravel
	INNER JOIN dbo.BUDPeriod P	 WITH (NOLOCK) ON P.idfBUDHeaderKey = EXPExpenseSheetDtl.idfBUDHeaderKey AND EXPExpenseSheetDtl.idfBudgetApplyDate BETWEEN P.idfPeriodBegin AND P.idfPeriodEnd
	WHERE idfRowAction = 'IN' --AND V.idfEXPExpenseSheetDtlKeyTravel = @nidfEXPExpenseSheetDtlKeyTravel
	GROUP BY P.idfBUDPeriodKey
	OPTION (KEEPFIXED PLAN)

	SELECT SUM(edfAmtHomeExtended) Amt, P.idfBUDPeriodKey
	INTO #BUDPeriodNew
	FROM #spEXPValidateWork V
	INNER JOIN dbo.BUDPeriod P	 WITH (NOLOCK) ON P.idfBUDHeaderKey = V.idfBUDHeaderKey AND V.idfBudgetApplyDate BETWEEN P.idfPeriodBegin AND P.idfPeriodEnd
	GROUP BY P.idfBUDPeriodKey

	SELECT N.Amt - ISNULL(O.AmtOld,0) - ISNULL(T.AmtOld,0) AS 'DiffCost', N.idfBUDPeriodKey
	INTO #BUDValidate
	FROM #BUDPeriodNew N
		LEFT OUTER JOIN #BUDPeriodOld O ON N.idfBUDPeriodKey = O.idfBUDPeriodKey
		LEFT OUTER JOIN #BUDPeriodTravelAmt T ON N.idfBUDPeriodKey = T.idfBUDPeriodKey

	--Validate the BUDPeriod amounts
	EXEC sp_executesql N'INSERT INTO #spWCValDtl(idfRowKey,ErrorNumber,idfRowAction)
				SELECT idfRowKey,-193,''IN''
				FROM #spEXPValidateWork R
				INNER JOIN dbo.BUDPeriod P WITH (NOLOCK) ON P.idfBUDHeaderKey = R.idfBUDHeaderKey AND R.idfBudgetApplyDate BETWEEN P.idfPeriodBegin AND P.idfPeriodEnd
				INNER JOIN #BUDValidate V WITH (NOLOCK) ON V.idfBUDPeriodKey = P.idfBUDPeriodKey
				INNER JOIN BUDPeriod B WITH (NOLOCK) ON B.idfBUDPeriodKey = V.idfBUDPeriodKey
				INNER JOIN BUDHeader H WITH (NOLOCK) ON H.idfBUDHeaderKey = B.idfBUDHeaderKey AND H.idfFlagExceed = 0
				WHERE B.idfAmtRemaining - V.DiffCost < 0'

	EXEC sp_executesql N'UPDATE #spWCValDtl SET idfErrNum = ErrorNumber, idfOBJName = CASE WHEN idfOBJName = '''' THEN ''spEXPValidate'' ELSE idfOBJName END OPTION (KEEP PLAN)'
	EXEC spWCValDtl @xchAction = 'IN', @xonWCValHdrKey = @nWCValHdrKey OUTPUT

	DELETE FROM #spWCValDtl

	--Return Errors
	SELECT @xonErrNum = ISNULL(@nWCValHdrKey,0) 
	IF (@xonErrNum <> 0)
		RETURN @xonErrNum
END
---------------------------------------------------------------------------------------------	

EXEC spEXPValidateCustom '',0,''

EXEC spWCValDtl  @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,'IN', @nWCValHdrKey OUTPUT

DROP TABLE #spWCValDtl

--Return Errors
SELECT @xonErrNum = ISNULL(@nWCValHdrKey,0) 
IF (@xonErrNum <> 0)
	RETURN @xonErrNum

-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- START: Validate Against UDF Field Templates.
-- ---------------------------------------------------------------------------------------------------------------------------------------------
IF (@xstrSource <> 'UDFTEMPLATE') BEGIN
	SELECT #spEXPValidateWork.* 
				,PAPhaseActivity.idfPAActivityKey AS idfPAActivityKey
	INTO #spWCUDFTemplateValidate 
	FROM #spEXPValidateWork 
	LEFT OUTER JOIN dbo.PAPhaseActivity WITH (NOLOCK) ON PAPhaseActivity.idfPAPhaseActivityKey = #spEXPValidateWork.idfPAPhaseActivityKey
	WHERE ((@strRemoveAprVal = 'FALSE' AND idfEXPSessionKey = 120) OR ISNULL(idfEXPSessionKey,0) <> 120)
	
	SELECT @nidfWCUDFTemplateKey = idfWCUDFTemplateKey FROM WCSecurity (NOLOCK) WHERE idfWCSecurityKey = @xnidfWCSecurityKey


	EXEC spWCUDFTemplateValidate @xochErrSP OUTPUT, @xonErrNum OUTPUT, @xostrErrInfo OUTPUT, @xonWCValHdrKey OUTPUT, @nidfWCUDFTemplateKey, 'EXPENSE',0,'EXPExpenseSheetDtl'

	IF (@xonErrNum < 0)
		RETURN @xonErrNum
END
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- END: Validate Against UDF Field Templates.
-- ---------------------------------------------------------------------------------------------------------------------------------------------


EXEC sp_executesql N'
DELETE #spEXPValidate
INSERT INTO #spEXPValidate
(
	idfEXPExpenseSheetDtlKey,idfAmtExtendedReceipt,idfAmtExtendedTravelAllocated,idfAmtFreightApr,idfAmtFreightHome,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,idfAmtTax,idfAmtTaxApr,idfAmtTaxHome,idfAmtTaxIncluded,idfAmtTaxIncludedApr,
	idfAmtTaxIncludedHome,idfBudgetApplyDate,idfComment,idfCurrLineUpSeq,idfDay,idfDescription,idfFlagImported,idfFlagManualDist,idfFlagOutsidePeriod,idfFlagSplit,idfImportedRefNo,idfLine,idfQuantity,idfRateHome,idfRateReimCalc,idfRateReimSystem,
	idfDateCreated,idfDateModified,idfAPVendorKey,idfAPVoucherDtlKeyCM,idfBUDHeaderKey,idfEXPCreditCardKey,idfEXPExpenseSheetDtlKeyTravel,idfEXPExpenseSheetHdrKey,idfEXPPaymentKey,idfEXPSessionKey,idfEXPTypeKey,idfGLAccountKey,idfPABillTypeKey,idfPAPhaseActivityKey,
	idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyKeyReceipt,idfSessionLinkKey,idfWCCountryKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCImportMapKey,idfWCLineUpKey,idfWCRRGroupLineUpKey,idfWCShippingMethodKey,
	idfWCTaxScheduleHdrKey,edf1099Amount,edfAmtAprExtended,edfAmtExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,edfFreight,edfMiscCharges,edfPrice,edfTax,edfBillType,edfCardName,edfCurrency,edfDocLine,edfDocNo,edfFacilityID,
	edfGL,edfPAProjectL1,edfPAProjectL2,edfPAProjectL3,edfShippingMethod,edfTaxSchedule,edfUOM,edfWSProductIndicator,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,
	udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,
	udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfEXPEventKey,vdfEXPExpenseSheetDtlKeyDuplicatedFrom,vdfEXPMobileExpenseKey,vdfCurrencyID,vdfCurrencyIDReceipt,vdfCurrencyIDReim,vdfBudgetID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfCountryID,
	vdfDeptID,vdfEventID,vdfPaymentID,vdfShippingMethodID,vdfTaxScheduleID,vdfGL,vdfTypeID,vdfVendorID,idfRowKey
	,idfRowAction
	,idfTETimePeriodKey			
	,idfWCUDFListDtlKey02	
	,idfWCSecurityKey	
	,edfPAProjectL1Class		
	,edfPAProjectL2Class		
	,edfPAProjectL3Class		
	,vdfID
	,idfEXPEntryTypeKey
	,HDR_idfWCSecurityKeyCreated
	,idfCodeApr
	,idfAmtHomeExtOld
	,idfBUDHeaderKeyOld
	,idfBudgetApplyDateOld
,idfTableLinkKey
)
SELECT
	idfEXPExpenseSheetDtlKey,idfAmtExtendedReceipt,idfAmtExtendedTravelAllocated,idfAmtFreightApr,idfAmtFreightHome,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,idfAmtTax,idfAmtTaxApr,idfAmtTaxHome,idfAmtTaxIncluded,
	idfAmtTaxIncludedApr,idfAmtTaxIncludedHome,idfBudgetApplyDate,idfComment,idfCurrLineUpSeq,idfDay,idfDescription,idfFlagImported,idfFlagManualDist,idfFlagOutsidePeriod,idfFlagSplit,idfImportedRefNo,idfLine,idfQuantity,idfRateHome,idfRateReimCalc,idfRateReimSystem,
	idfDateCreated,idfDateModified,idfAPVendorKey,idfAPVoucherDtlKeyCM,idfBUDHeaderKey,idfEXPCreditCardKey,idfEXPExpenseSheetDtlKeyTravel,idfEXPExpenseSheetHdrKey,idfEXPPaymentKey,idfEXPSessionKey,idfEXPTypeKey,idfGLAccountKey,idfPABillTypeKey,idfPAPhaseActivityKey,
	idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyKeyReceipt,idfSessionLinkKey,idfWCCountryKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCImportMapKey,idfWCLineUpKey,idfWCRRGroupLineUpKey,idfWCShippingMethodKey,
	idfWCTaxScheduleHdrKey,edf1099Amount,edfAmtAprExtended,edfAmtExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,edfFreight,edfMiscCharges,edfPrice,edfTax,edfBillType,edfCardName,edfCurrency,edfDocLine,edfDocNo,edfFacilityID,
	edfGL,edfPAProjectL1,edfPAProjectL2,edfPAProjectL3,edfShippingMethod,edfTaxSchedule,edfUOM,edfWSProductIndicator,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,
	udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,
	udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfEXPEventKey,vdfEXPExpenseSheetDtlKeyDuplicatedFrom,vdfEXPMobileExpenseKey,vdfCurrencyID,vdfCurrencyIDReceipt,vdfCurrencyIDReim,vdfBudgetID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfCountryID,
	vdfDeptID,vdfEventID,vdfPaymentID,vdfShippingMethodID,vdfTaxScheduleID,vdfGL,vdfTypeID,vdfVendorID,idfRowKey
	,idfRowAction
	,idfTETimePeriodKey			
	,idfWCUDFListDtlKey02	
	,idfWCSecurityKey	
	,edfPAProjectL1Class		
	,edfPAProjectL2Class		
	,edfPAProjectL3Class		
	,vdfID
	,idfEXPEntryTypeKey
	,HDR_idfWCSecurityKeyCreated
	,idfCodeApr
	,idfAmtHomeExtOld
	,idfBUDHeaderKeyOld
	,idfBudgetApplyDateOld
,idfTableLinkKey
FROM #spEXPValidateWork'

	SELECT W.*
		, AmtSum.edfAmtHomeExtended		AS HDR_edfAmtHomeExtended
		, AmtSum.edfAmtAprExtended		AS HDR_edfAmtAprExtended
		, idfWCSecurityKey				AS HDR_idfWCSecurityKey
		, 0								AS HDR_idfAmtDiscountApr 
		, dbo.fnWCSubtotalCalc(AmtSum.idfAmtSubTotalApr,AmtSum.idfAmtTaxIncludedApr) AS HDR_idfAmtSubTotalApr 
		, AmtSum.idfAmtFreightApr		AS HDR_idfAmtFreightApr     
		, AmtSum.idfAmtMiscApr			AS HDR_idfAmtMiscApr          
		, AmtSum.idfAmtTaxApr			AS HDR_idfAmtTaxApr       
		, SR.idfWCFilterHdrKey			AS idfWCFilterHdrKey
		,'Rule'								AS idfSourceTable
		,ISNULL(W.idfEXPExpenseSheetDtlKey,W.idfRowKey)			AS idfSourceKey
		, 0 AS vdfFilterValid 
		, 0 AS EXT_idfWCSecurityKey		
		, 0	AS HDR_idfRQTypeKey
		,NULL AS HDR_idfPTICurrencyKey		
		,NULL AS HDR_idfWCAddressKeyBillTo	
		,NULL AS HDR_idfWCDeptKey			
		,NULL AS HDR_idfAmtDiscount			
		,NULL AS HDR_idfAmtFreight			
		,NULL AS HDR_idfAmtMisc				
		,NULL AS HDR_idfAmtTax				
		,NULL AS HDR_idfAmtExtended			
		,NULL AS HDR_idfWCPaymentTermKey	
		,NULL AS HDR_idfWCShippingMethodKey	
		,NULL AS HDR_idfWCAddressKeyShipTo	
		,NULL AS HDR_idfAPVendorKey			
		,NULL AS HDR_idfCreatedBySource		
		,idfWCUDFListDtlKey02 AS HDR_idfWCUDFListDtlKey02
		,NULL AS HDR_idfWCFOBKey			
		,NULL AS HDR_idfWCAddressKeyBranch	
		,NULL AS HDR_idfWCOrganizationKey	
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField01             
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField02                     
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField03                     
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField04                     
		,CONVERT (DATETIME,NULL) AS HDR_udfDateField05                     
		,' '  AS HDR_udfLargeTextField01                
		,' '  AS HDR_udfLargeTextField02                
		,' '  AS HDR_udfLargeTextField03              
		,0	  AS HDR_udfNumericField01                 
		,0	  AS HDR_udfNumericField02                  
		,0	  AS HDR_udfNumericField03                  
		,0	  AS HDR_udfNumericField04                  
		,0	  AS HDR_udfNumericField05                  
		,0	  AS HDR_udfNumericField06                  
		,0	  AS HDR_udfNumericField07                  
		,0	  AS HDR_udfNumericField08                  
		,0	  AS HDR_udfNumericField09                  
		,0	  AS HDR_udfNumericField10                  
		,' '  AS HDR_udfTextField01                     
		,' '  AS HDR_udfTextField02                     
		,' '  AS HDR_udfTextField03                     
		,' '  AS HDR_udfTextField04                     
		,' '  AS HDR_udfTextField05                     
		,' '  AS HDR_udfTextField06                     
		,' '  AS HDR_udfTextField07                     
		,' '  AS HDR_udfTextField08                     
		,' '  AS HDR_udfTextField09                     
		,' '  AS HDR_udfTextField10		
	INTO #spWCRuleValidate
	FROM #spEXPValidate W 
		INNER JOIN (SELECT SUM(edfAmtHomeExtended) AS edfAmtHomeExtended,SUM(edfAmtAprExtended) AS edfAmtAprExtended,SUM(idfAmtSubTotalApr) AS idfAmtSubTotalApr,SUM(idfAmtFreightApr) AS idfAmtFreightApr
						,SUM(idfAmtMiscApr) AS idfAmtMiscApr,SUM(idfAmtTaxApr) AS idfAmtTaxApr,SUM(idfAmtTaxIncludedApr) AS idfAmtTaxIncludedApr	FROM #spEXPValidate) AS AmtSum ON 1=1
		LEFT OUTER JOIN (SELECT idfRowKey,SR.idfWCFilterHdrKey 
						 FROM #spEXPValidate W 
							INNER JOIN dbo.WCSecRole         WITH (NOLOCK) ON WCSecRole.idfWCSecurityKey = W.idfWCSecurityKey
							INNER JOIN dbo.WCFilterHdrSec SR WITH (NOLOCK) ON SR.idfWCRoleKey = WCSecRole.idfWCRoleKey
						 GROUP BY idfRowKey,SR.idfWCFilterHdrKey
						 UNION 
						 SELECT idfRowKey,SS.idfWCFilterHdrKey 
						 FROM #spEXPValidate W 
							INNER JOIN dbo.WCFilterHdrSec SS WITH (NOLOCK) ON SS.idfWCSecurityKey = W.idfWCSecurityKey
						 GROUP BY idfRowKey,SS.idfWCFilterHdrKey) SR ON SR.idfRowKey = W.idfRowKey
	WHERE SR.idfWCFilterHdrKey <> 0 AND W.idfEXPSessionKey <> 170

	EXEC spWCRuleValidate @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT,@xonWCValHdrKey OUTPUT,'EXPENSE','ERROR'

	DROP TABLE #spWCRuleValidate

IF @@ERROR <> 0 
	RAISERROR ('spEXPValidate:300',1,1)
	-- ------------------------------------------------------------------------------------------------------------------------	

-- ------------------------------------------------------------------------------------------------------------------------	
-- Balance Attendee Amount based on SS
-- ------------------------------------------------------------------------------------------------------------------------	
IF ISNULL(@xonErrNum,0) = 0 AND @xonWCValHdrKey IS NULL AND EXISTS (SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'EXPATTENDEEAUTOEQ' AND idfValue = 1)
BEGIN
	IF (@xstrSource IN ('ENTRY'))
		EXEC sp_executesql N'
		UPDATE EXPExpenseSheetDtlAttendee SET idfAmount = TMP.idfAmount, idfPercent = ROUND((TMP.idfAmount / idfAmountTotal)*100,2)
		FROM dbo.EXPExpenseSheetDtlAttendee ATT WITH (NOLOCK) 
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPExpenseSheetDtlKey
		
		UPDATE EXPExpenseSheetDtlAttendee SET idfAmount = TMP.idfAmount + idfAmountRem, idfPercent = ROUND(((TMP.idfAmount + idfAmountRem) / idfAmountTotal)*100,2)
		FROM dbo.EXPExpenseSheetDtlAttendee ATT WITH (NOLOCK) 
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPExpenseSheetDtlKey AND TMP.idfRowKey = ATT.idfEXPExpenseSheetDtlAttendeeKey
		'

	IF (@xstrSource IN ('ATTENDEE_ENTRY'))
		EXEC sp_executesql N'
		UPDATE #EXPExpenseSheetDtlAttendee SET idfRowAction = CASE WHEN idfRowAction = ''IN'' THEN ''IN'' ELSE ''UP'' END, idfAmount = TMP.idfAmount, idfPercent = ROUND((TMP.idfAmount / idfAmountTotal)*100,2)
		FROM #EXPExpenseSheetDtlAttendee ATT
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPExpenseSheetDtlKey
		WHERE ATT.idfRowAction NOT IN (''DL'') 
		
		UPDATE #EXPExpenseSheetDtlAttendee SET idfAmount = TMP.idfAmount + idfAmountRem, idfPercent = ROUND(((TMP.idfAmount + idfAmountRem) / idfAmountTotal)*100,2)
		FROM #EXPExpenseSheetDtlAttendee ATT 
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPExpenseSheetDtlKey AND TMP.idfRowKey = ATT.idfRowKey
		WHERE ATT.idfRowAction NOT IN (''DL'')
		'

	IF (@xstrSource IN ('APPROVAL'))
		EXEC sp_executesql N'
		UPDATE EXPAprDtlAttendee SET idfAmount = TMP.idfAmount, idfPercent = ROUND((TMP.idfAmount / idfAmountTotal)*100,2)
		FROM dbo.EXPAprDtlAttendee ATT WITH (NOLOCK) 
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPAprDtlKey
		
		UPDATE EXPAprDtlAttendee SET idfAmount = TMP.idfAmount + idfAmountRem, idfPercent = ROUND(((TMP.idfAmount + idfAmountRem) / idfAmountTotal)*100,2)
		FROM dbo.EXPAprDtlAttendee ATT WITH (NOLOCK) 
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPAprDtlKey AND TMP.idfRowKey = ATT.idfEXPAprDtlAttendeeKey
		'

	IF (@xstrSource IN ('ATTENDEE_APPROVAL'))
	EXEC sp_executesql N'
		UPDATE #EXPAprDtlAttendee SET idfRowAction = CASE WHEN idfRowAction = ''IN'' THEN ''IN'' ELSE ''UP'' END, idfAmount = TMP.idfAmount, idfPercent = ROUND((TMP.idfAmount / idfAmountTotal)*100,2)
		FROM #EXPAprDtlAttendee ATT
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPAprDtlKey
		WHERE ATT.idfRowAction NOT IN (''DL'')

		UPDATE #EXPAprDtlAttendee SET idfAmount = TMP.idfAmount + idfAmountRem, idfPercent = ROUND(((TMP.idfAmount + idfAmountRem) / idfAmountTotal)*100,2)
		FROM #EXPAprDtlAttendee ATT 
		INNER JOIN #AttendeeTable TMP ON TMP.idfSourceKey = ATT.idfEXPAprDtlKey AND TMP.idfRowKey = ATT.idfRowKey
		WHERE ATT.idfRowAction NOT IN (''DL'')
		'
END
-- ------------------------------------------------------------------------------------------------------------------------	

	DROP TABLE #AttendeeTable
	DROP TABLE #DtlDistribution 

IF @xonErrNum IS NULL OR @xonErrNum = 0
BEGIN
	IF @xonWCValHdrKey IS NULL
		SELECT @xonErrNum = 0
     	ELSE
  		SELECT @xonErrNum = @xonWCValHdrKey
END

RETURN (0)

