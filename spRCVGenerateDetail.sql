DROP PROCEDURE spRCVGenerateDetail
GO
-- Paramount Technologies, Inc. $Version: WorkPlace_08.02.00 $  - $Revision: 56 $ $Modtime: 1/03/06 1:55p $
CREATE PROCEDURE spRCVGenerateDetail
 @xochErrSP			CHAR(32)      	= ''	OUTPUT
,@xonErrNum			INT          	= 0	OUTPUT
,@xostrErrInfo			VARCHAR(255) 	= ''	OUTPUT
,@xstrRCVNumber			CHAR(17)	= ''
,@nRCVLineNumber	INT	OUTPUT	
,@xstrPONumber			CHAR(17)	= ''
,@xstrPOLine			INT		= 0
,@xstrItem			CHAR(51)	= ''
,@xstrItemDesc			CHAR(101)	= ''
,@xstrVendorItem		CHAR(51)	= ''
,@xstrUOM			CHAR(9)		= ''
,@xstrLocation			CHAR(15)	= ''
,@xnPrice			NUMERIC(19,5)	= 0
,@xnAmtExtended			NUMERIC(19,5)	= 0
,@xnQtyInvoiced			NUMERIC(19,5)	= 0
,@xnQtyRejected			NUMERIC(19,5)	= 0
,@xnQtyShipped			NUMERIC(19,5)	= 0
,@xnGLIndex			INT		= 0
,@xnGLUnrlzPurchPriceVar	INT		= 0
,@xstrCommentID			CHAR(15)	= ''
,@xdtDateActual			DATETIME	= '1900-01-01'
,@xstrTranType			CHAR(3)		= ''	-- Identifies if transaction if for Project Series (PA) or Standard (STD) Purchasing/Inventory
,@xstrBOLProNumber		CHAR(31)	= ''
,@xnProductIndicator		INT		= 1	-- 1)Dynamics 2)Job Cost 3)Service Management 
,@xnReceiveType			INT		= 0	-- 1) Shipment 2) Invoice 3) Shipment/Invoice
,@xnidfRCVHeaderKey				 INT
,@xnudfNumericField01		NUMERIC(19,5)
,@xstrudfTextField01              varchar(60)
,@xstrudfTextField02              varchar(60)
,@xstrudfTextField03              varchar(60)
,@xstrudfTextField04              varchar(60)
,@nRCVDetail_idfRCVDetailKey	 INT
,@xnPurchase_IV_Item_Taxable	 INT	  = 2
,@xstrPurchase_Item_Tax_Schedu	 CHAR(15) = ''
,@xstrPurchase_Site_Tax_Schedu	 CHAR(15) = ''
AS
DECLARE
 @nNextLineNumber		INT
,@nIsMiscIVItem			INT
,@strUOMSCHDL			VARCHAR(51)
,@nQtyBaseUOM			NUMERIC(19,5)
,@nQtyPer			INT
,@nFunctionalAmtExtended	NUMERIC(19,5)
,@nFunctionalPrice		NUMERIC(19,5)
,@nDecimalPlacesO		INT
,@nDecimalPlacesF		INT
,@nXchRate			NUMERIC(19,5)
,@nXchRateType 			VARCHAR(255)
,@strXchRateTable		VARCHAR(255)
,@nXchExpression 		INT
,@strXchDate 			VARCHAR(15)
,@strXchTime 			VARCHAR(15)
,@strHDR_CURNCYID	CHAR(15)
,@nHDR_CURRNIDX		INT
,@strHDR_VENDORID		CHAR(15)
,@strHDR_BCHSOURC		CHAR(15)
,@strHDR_BACHNUMB		CHAR(15)
,@nIV00101_ITMTRKOP		INT
,@nIV00101_VCTNMTHD		INT
,@nIV00101_NOTEINDX		INT
,@nIV00101_STNDCOST		NUMERIC(19,5)
,@nIV40700_NOTEINDX		INT
,@nGL00100_NOTEINDX		INT
,@nSY04200_NOTEINDX		INT
,@nPOHDR_PONOTIDS_1		INT
,@nLineQty_APPYTYPE		INT
,@nLineQty_RUPPVAMT		NUMERIC(19,5)
,@nLineQty_OSTDCOST		NUMERIC(19,5)
,@nLineQty_NOTEINDX		INT
-- Great Plains Columns
,@strPACONTNUMBER       VARCHAR(50)
,@nPAProjectType        INT
,@nPAAcctgMethod        INT
,@strPApurordnum        VARCHAR(50)
,@nPAbllngtype          INT
,@strPACOSTCATID    VARCHAR(15)
,@strPACOSTCATNME    VARCHAR(31)
,@nPATU    INT
,@nPAIV_Item_Checkbox    INT
,@nDECPLQTY    INT
,@nDECPLCUR    INT
,@nPAPurchase_Tax_Options    INT
,@strPAUD1    VARCHAR(21)
,@strPAUD2    VARCHAR(21)
,@nPAbillnoteidx    NUMERIC(19,5)
,@nPAOverheaPercentage    NUMERIC(19,5)
,@nPOTYPE    INT
,@nTRDISAMT    NUMERIC(19,5)
,@strITMTSHID    VARCHAR(15)
,@nTAXAMNT    NUMERIC(19,5)
,@nPABase_Unit_Cost    NUMERIC(19,5)
,@nPABase_Qty    NUMERIC(19,5)
,@strPRICELVL    VARCHAR(15)
,@nPACogs_Idx    INT
,@nPACGBWIPIDX    INT
,@nBCKTXAMT    NUMERIC(19,5)
,@nORTDISAM    NUMERIC(19,5)
,@nORTAXAMT    NUMERIC(19,5)
,@nOBTAXAMT    NUMERIC(19,5)
,@n__PAORIGBILLRATE		NUMERIC(19,5)
,@n__PABILRATE			NUMERIC(19,5)
,@n__PA_Base_Billing_Rat	NUMERIC(19,5)
,@n__PAORIACCRREV		NUMERIC(19,5)
,@n__PAACREV 			NUMERIC(19,5)
,@n__PAUnbilled_AR_Idx		INT
,@n__PAUnbilled_Proj_Rev_Idx	INT
,@n__PAMARKPERCENT		NUMERIC(19,5)
,@n__PAProfitType		INT
,@n__PABilling_StatusN		INT
,@strMatchRCVNumber	CHAR(17)
,@nMatchRCVLine		INT
,@nQtyMatched		NUMERIC(19,5)
,@nTotalMatched		NUMERIC(19,5)
,@nMatchReceiptCost	NUMERIC(19,5)
,@nMatchReceiptCostExt	NUMERIC(19,5)
,@nWCSystem_idfModuleRegisteredMC	INT  
,@strPM00200_SHIPMTHD		VARCHAR(15)
,@strLanded_Cost_Group_ID	CHAR(15)
,@nRCVUSEDATEANDRATEFORRCV	INT 
,@nPOSTBEFOREINVOICING INT
,@nForceGivenRate INT
,@dtidfDateReceipt DATETIME
,@nPPVGLIndex INT
,@nDPCYear INT
,@nQtyShippedEXT			NUMERIC(19,5)
,@nedfPALineItemSeq INT
 
SELECT @nForceGivenRate = 0
SELECT @nRCVUSEDATEANDRATEFORRCV = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'RCVUSEDATEANDRATEFORRCV'
SELECT @nPOSTBEFOREINVOICING = idfValue FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID = 'POSTBEFOREINVOICING'

SELECT @nWCSystem_idfModuleRegisteredMC = idfModuleRegisteredMC FROM WCSystem (NOLOCK)

SELECT 
     @strPACONTNUMBER       = ''
    ,@nPAProjectType        = 0
    ,@nPAAcctgMethod        = 0
    ,@strPApurordnum        = ''
    ,@nPAbllngtype          = 3
    ,@strPACOSTCATID    = ''
    ,@strPACOSTCATNME    = ''
    ,@nPATU    = 0
    ,@nPAIV_Item_Checkbox    = 0
    ,@nDECPLQTY    = 0
    ,@nDECPLCUR    = 0
    ,@nPAPurchase_Tax_Options    = 0
    ,@strPAUD1    = ''
    ,@strPAUD2    = ''
    ,@nPAbillnoteidx    = 0
    ,@nPAOverheaPercentage    = 0
    ,@nPOTYPE    = 0
    ,@nTRDISAMT    = 0
    ,@strITMTSHID    = ''
    ,@nTAXAMNT    = 0
    ,@nPABase_Unit_Cost    = 0
    ,@nPABase_Qty    = 0
    ,@strPRICELVL    = ''
    ,@nPACogs_Idx    = 0
    ,@nPACGBWIPIDX    = 0
    ,@nBCKTXAMT    = 0
    ,@nORTDISAM    = 0
    ,@nORTAXAMT    = 0
    ,@nOBTAXAMT    = 0
	,@n__PAORIGBILLRATE		= 0
	,@n__PABILRATE			= 0
	,@n__PA_Base_Billing_Rat	= 0
	,@n__PAORIACCRREV		= 0
	,@n__PAACREV 			= 0
	,@n__PAUnbilled_AR_Idx		= 0
	,@n__PAUnbilled_Proj_Rev_Idx	= 0
	,@n__PAMARKPERCENT		= 0
	,@n__PAProfitType		= 0
	,@n__PABilling_StatusN		= 4


SELECT @xochErrSP	= 'spRCVGenerateDetail'
SELECT @xonErrNum	= 0
SELECT @xostrErrInfo	= ''
-- SELECT * FROM PA10701
IF NOT EXISTS(SELECT 1 FROM POP10300 (NOLOCK) 
    WHERE POPRCTNM = @xstrRCVNumber)
BEGIN
	SELECT @xonErrNum = -101,@xostrErrInfo = idfResourceID FROM WCLanguageSQL (NOLOCK) WHERE idfOBJName = 'spRCVGenerateDetail' AND idfErrNum = -101
	RETURN (-101)
END
IF (@xstrItem = '') AND (@xstrVendorItem = '')
BEGIN
	SELECT @xonErrNum = -102,@xostrErrInfo = idfResourceID FROM WCLanguageSQL (NOLOCK) WHERE idfOBJName = 'spRCVGenerateDetail' AND idfErrNum = -102
	RETURN (-102)
END
IF (@xstrItem = '')
	SELECT @xstrItem = @xstrVendorItem
IF (@xstrVendorItem = '')
	SELECT @xstrVendorItem = @xstrItem
IF (@xdtDateActual IS NULL)
	SELECT @xdtDateActual = '1900-01-01'
ELSE
	SELECT @xdtDateActual = CONVERT(DATETIME,CONVERT(VARCHAR(10),@xdtDateActual,112),112)
IF (@xnGLIndex IS NULL) OR NOT EXISTS(SELECT TOP 1 1 FROM GL00100 (NOLOCK) WHERE ACTINDX = @xnGLIndex)
BEGIN
	SELECT @xonErrNum = -103,@xostrErrInfo = idfResourceID FROM WCLanguageSQL (NOLOCK) WHERE idfOBJName = 'spRCVGenerateDetail' AND idfErrNum = -103
	RETURN (-103)
END
IF (EXISTS(SELECT TOP 1 1 FROM WCSystem (NOLOCK) WHERE idfModuleRegisteredIV = 1)) BEGIN
	IF (@xstrLocation = '')
	BEGIN
		IF 1=1
		BEGIN
			SELECT @xonErrNum = -104,@xostrErrInfo = idfResourceID FROM WCLanguageSQL (NOLOCK) WHERE idfOBJName = 'spRCVGenerateDetail' AND idfErrNum = -104
			RETURN (-104)
		END
	END
END
IF @xnReceiveType NOT IN (1,2,3 )
BEGIN
	SELECT @xonErrNum = -106,@xostrErrInfo = idfResourceID FROM WCLanguageSQL (NOLOCK) WHERE idfOBJName = 'spRCVGenerateDetail' AND idfErrNum = -106
	RETURN (-106)
END
-- These System options are checked in spRCVValidate
-- POP40100.POPALWOP_1 - Allow Receiving Without A Purchase Order.
-- POP40100.POPALWOP_2 - Change Site ID in Receiving.
-- POP40100.POPALWOP_4 - Allow Editing of Costs in Receiving.

----------------------------------------------------------------------------------------------
-- START:
----------------------------------------------------------------------------------------------

-- Get last line number.

IF ((ISNULL(@nRCVLineNumber,'') = '') OR (EXISTS (SELECT TOP 1 1 FROM dbo.POP10310 WITH (NOLOCK) WHERE POPRCTNM = @xstrRCVNumber AND RCPTLNNM = @nRCVLineNumber)))
	SELECT @nNextLineNumber = ISNULL(MAX(RCPTLNNM),0) + 16384 FROM POP10310 (NOLOCK) WHERE POPRCTNM = @xstrRCVNumber
ELSE
	SELECT @nNextLineNumber = @nRCVLineNumber

----------------------------------------------------------------------------------------------
-- START: Get Inventory Item Information.
----------------------------------------------------------------------------------------------
--Find out if item is miscellanious.
IF EXISTS(SELECT TOP 1 1 FROM IV00101 (NOLOCK) WHERE ITEMNMBR = @xstrItem)
	SELECT @nIsMiscIVItem = 0
ELSE
	SELECT @nIsMiscIVItem = 1

-- Get information about Inventory Item.
SELECT @nIV00101_STNDCOST = 0,@nLineQty_NOTEINDX = 0

IF (@nIsMiscIVItem = 0) 
BEGIN
	-- If Item is an inventory type then make sure that the Unrealized Purchase Price Variance Account is set.
	SELECT @nIV00101_STNDCOST = STNDCOST * ISNULL(UOM.QTYBSUOM,1)
	FROM dbo.IV00101 IV00101 WITH (NOLOCK) 
		LEFT OUTER JOIN dbo.IV00106 UOM WITH (NOLOCK) ON UOM.ITEMNMBR = IV00101.ITEMNMBR AND UOM.UOFM = @xstrUOM
	WHERE IV00101.ITEMNMBR = @xstrItem
	
	IF (@xnGLUnrlzPurchPriceVar = 0 OR @xnGLUnrlzPurchPriceVar IS NULL)
	BEGIN
		-- Retrieve default from Inventory.
		SELECT @xnGLUnrlzPurchPriceVar = ISNULL(UPPVIDX,0) FROM IV00101 (NOLOCK) WHERE ITEMNMBR = @xstrItem
		
		-- Get Note Index for GL Account.
		SELECT @nLineQty_NOTEINDX = ISNULL(NOTEINDX,0) FROM GL00100 (NOLOCK) WHERE ACTINDX = @xnGLUnrlzPurchPriceVar  
	END

END



SELECT	 @nQtyBaseUOM		= 1
	,@strUOMSCHDL		= ''
	,@nQtyPer 		= NULL
	,@nIV00101_ITMTRKOP 	= 0
	,@nIV00101_VCTNMTHD	= 0
	,@nIV00101_NOTEINDX	= 0

IF (@nIsMiscIVItem = 0)
BEGIN
	SELECT	 @strUOMSCHDL		= ISNULL(UOMSCHDL,'')
		,@nIV00101_ITMTRKOP	= ISNULL(ITMTRKOP,0)	
		,@nIV00101_VCTNMTHD	= ISNULL(VCTNMTHD,0)
		,@nIV00101_NOTEINDX	= ISNULL(NOTEINDX,0)
	FROM IV00101 (NOLOCK) WHERE ITEMNMBR = @xstrItem
	SELECT @nQtyBaseUOM	= ISNULL(QTYBSUOM,1)	FROM IV40202 (NOLOCK) WHERE UOMSCHDL = @strUOMSCHDL AND UOFM = @xstrUOM
	SELECT @nQtyPer 	= UMDPQTYS		FROM IV40201 (NOLOCK) WHERE UOMSCHDL = @strUOMSCHDL
END

IF @nQtyPer IS NULL
BEGIN
	SELECT @nQtyPer = DECPLQTY FROM dbo.POP40100 WITH (NOLOCK)
END 
----------------------------------------------------------------------------------------------
-- END: Get Inventory Item Information.
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
-- START: Round Currencies.
----------------------------------------------------------------------------------------------
IF (@nRCVUSEDATEANDRATEFORRCV = 1)
BEGIN
	SELECT @nForceGivenRate = 1 
	SELECT @dtidfDateReceipt = idfDateReceipt, @nXchRate = idfRateHome FROM RCVHeader WITH (NOLOCK) WHERE idfRCVHeaderKey = @xnidfRCVHeaderKey
END
ELSE
	SELECT @dtidfDateReceipt = NULL

SELECT	 @strHDR_CURNCYID	= CURNCYID
	,@nHDR_CURRNIDX 	= CURRNIDX
	,@strHDR_VENDORID	= VENDORID
	,@strHDR_BCHSOURC	= BCHSOURC
	,@strHDR_BACHNUMB	= BACHNUMB
FROM POP10300 (NOLOCK) WHERE POPRCTNM = @xstrRCVNumber
EXEC spRQFNARoundCurrency	@xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xstrTranType		, @strHDR_CURNCYID, @xnPrice, @xnPrice OUTPUT, @xstrItem, @nDecimalPlacesO OUTPUT
EXEC spFNAConvertCur 		
	  @xochErrSP OUTPUT
	, @xonErrNum OUTPUT
	, @xostrErrInfo OUTPUT
	, @strHDR_CURNCYID	
	, 1
	, @xnPrice
	, @nFunctionalPrice		OUTPUT
	, @nXchRate				OUTPUT
	, @nXchRateType			OUTPUT
	, @strXchRateTable		OUTPUT
	, @nXchExpression		OUTPUT
	, @strXchDate			OUTPUT
	, @strXchTime			OUTPUT
	, @xnForceGivenRate		= @nForceGivenRate
	, @xodtXchRateDate		= @dtidfDateReceipt

EXEC spRQFNARoundCurrency	@xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xstrTranType		, '', @nFunctionalPrice, @nFunctionalPrice OUTPUT, @xstrItem, @nDecimalPlacesF OUTPUT

EXEC spFNAConvertCur		@xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @strHDR_CURNCYID	, 1, @xnAmtExtended, @nFunctionalAmtExtended OUTPUT, @nXchRate OUTPUT, @nXchRateType OUTPUT, @strXchRateTable OUTPUT, @nXchExpression OUTPUT, 
@strXchDate OUTPUT, @strXchTime OUTPUT, @xnForceGivenRate	= @nForceGivenRate, @xodtXchRateDate = @dtidfDateReceipt
-- Rounding amount extended with uses the currency for rounding, not items percision, so passing in NULL for item
EXEC spRQFNARoundCurrency	@xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xstrTranType		, NULL, @nFunctionalAmtExtended, @nFunctionalAmtExtended OUTPUT, NULL
----------------------------------------------------------------------------------------------
-- END: Round Currencies.
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
-- START: Get Note Indexes.
----------------------------------------------------------------------------------------------
SELECT   @nIV40700_NOTEINDX	= 0
	,@nGL00100_NOTEINDX	= 0
	,@nSY04200_NOTEINDX	= 0
	,@nPOHDR_PONOTIDS_1	= 0

SELECT @nIV40700_NOTEINDX = ISNULL(NOTEINDX,0) FROM IV40700 (NOLOCK) WHERE LOCNCODE = @xstrLocation AND IV40700.INACTIVE = 0
SELECT @nGL00100_NOTEINDX = ISNULL(NOTEINDX,0) FROM GL00100 (NOLOCK) WHERE ACTINDX = @xnGLIndex 

IF (@xstrCommentID <> '')
	SELECT @nSY04200_NOTEINDX = ISNULL(NOTEINDX,0) FROM SY04200 (NOLOCK) WHERE COMMNTID = @xstrCommentID

IF (@xstrPONumber <> '')
	SELECT @nPOHDR_PONOTIDS_1 = PONOTIDS_1 FROM POP10100 (NOLOCK) WHERE PONUMBER = @xstrPONumber

----------------------------------------------------------------------------------------------
-- END: Get Note Indexes.
----------------------------------------------------------------------------------------------

BEGIN TRANSACTION
	----------------------------------------------------------------------------------------------
	-- START: Make sure that Vendor Item Record Exists, if not then create.
	----------------------------------------------------------------------------------------------
	-- Look to see if Vendor/Item combination is available,
	-- if yes then get VNDITNUM and VNDITDSC
	IF EXISTS(SELECT TOP 1 1 FROM IV00101 (NOLOCK) WHERE ITEMNMBR = @xstrItem) AND NOT(EXISTS(SELECT 1 FROM IV00103 (NOLOCK) WHERE ITEMNMBR = @xstrItem AND VENDORID = @strHDR_VENDORID))
	BEGIN
		INSERT INTO IV00103 (
			ITEMNMBR,VENDORID,ITMVNDTY,VNDITNUM,QTYRQSTN,QTYONORD,QTY_Drop_Shipped,
			LSTORDDT,LSORDQTY,LRCPTQTY,LSRCPTDT,LRCPTCST,AVRGLDTM,NORCTITM,MINORQTY,
			MAXORDQTY,ECORDQTY,VNDITDSC,Last_Originating_Cost,Last_Currency_ID,
			FREEONBOARD,PRCHSUOM,CURRNIDX,PLANNINGLEADTIME)
		VALUES (
			 @xstrItem	-- ITEMNMBR
			,@strHDR_VENDORID	-- VENDORID
			,2		-- ITMVNDTY
			,@xstrVendorItem -- VNDITNUM
			,0 -- QTYRQSTN
			,0 -- QTYONORD
			,0 -- QTY_Drop_Shipped
			,'1900-01-01' -- LSTORDDT
			,0 -- LSORDQTY
			,0 -- LRCPTQTY
			,'1900-01-01' -- LSRCPTDT
			,0 -- LRCPTCST
			,0 -- AVRGLDTM
			,0 -- NORCTITM
			,0 -- MINORQTY
			,0 -- MAXORDQTY
			,0 -- ECORDQTY
			,@xstrItemDesc -- VNDITDSC
			,@xnPrice -- Last_Originating_Cost
			,@strHDR_CURNCYID -- Last_Currency_ID
			,1 -- FREEONBOARD
			,@xstrUOM -- PRCHSUOM
			,@nHDR_CURRNIDX -- CURRNIDX
			,0 -- PLANNINGLEADTIME
		)
	END
	----------------------------------------------------------------------------------------------
	-- END: Make sure that Vendor Item Record Exists, if not then create.
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	-- START: Insert Purchasing Receipt Line Record.
	----------------------------------------------------------------------------------------------
	SELECT @strLanded_Cost_Group_ID = Landed_Cost_Group_ID FROM IV00102 WITH (NOLOCK) WHERE ITEMNMBR = @xstrItem AND LOCNCODE = @xstrLocation
	
/*
-- CDB 3/13/08: If vendor is a 1099 type and the type of transaction is an invoice or shipment/invoice then update the amount on the header.
-- @xnReceiveType = 0	-- 1) Shipment 2) Invoice 3) Shipment/Invoice
	IF (@xnReceiveType IN (2,3)) AND EXISTS(SELECT TOP 1 1 FROM dbo.PM00200 WITH (NOLOCK) WHERE VENDORID=@strHDR_VENDORID AND TEN99TYPE > 1) AND 
		EXISTS (SELECT TOP 1 1 FROM dbo.RCVDetail WITH (NOLOCK) WHERE idfRCVDetailKey = @nRCVDetail_idfRCVDetailKey AND idfAPTaxTypeDtlKey IS NOT NULL)
		UPDATE POP10300
		SET  TEN99AMNT	= TEN99AMNT + @nFunctionalAmtExtended
			,OR1099AM	= OR1099AM + @xnAmtExtended
		FROM POP10300
		WHERE POPRCTNM = @xstrRCVNumber
*/

	SELECT @strPM00200_SHIPMTHD = SHIPMTHD FROM dbo.PM00200 WITH (NOLOCK) WHERE VENDORID = @strHDR_VENDORID AND VENDSTTS <> 2


	IF EXISTS (SELECT TOP 1 1 FROM dbo.IV00101 WITH(NOLOCK) WHERE ITEMNMBR = @xstrItem)
	BEGIN	
		-- ITEM		  
		SELECT @nPPVGLIndex = CASE WHEN ITEMTYPE NOT IN (1,2) THEN  ISNULL(PURPVIDX,0) ELSE CASE WHEN ISNULL(POP10110.INVINDX,0) > 0 THEN POP10110.INVINDX ELSE ISNULL(IVIVINDX,0) END END 
		FROM dbo.IV00101 WITH(NOLOCK)
			LEFT OUTER JOIN dbo.POP10110 WITH (NOLOCK) ON PONUMBER = @xstrPONumber AND ORD = @xstrPOLine 
		WHERE IV00101.ITEMNMBR = @xstrItem
		
		IF @nPPVGLIndex = 0	
			SELECT @nPPVGLIndex = ISNULL(ACTINDX,0) FROM dbo.SY01100 (NOLOCK) WHERE SERIES=5 AND SEQNUMBR=1200
	END
	ELSE 
	BEGIN   -- MISC ITEM
		SELECT @nPPVGLIndex = ISNULL(PURPVIDX,0) FROM dbo.PM00200 WITH(NOLOCK) INNER JOIN dbo.RCVHeader WITH(NOLOCK) ON VENDORID = edfVendor WHERE idfRCVHeaderKey = @xnidfRCVHeaderKey 
		IF @nPPVGLIndex = 0	
			SELECT @nPPVGLIndex = ISNULL(ACTINDX,0) FROM dbo.SY01100 WITH(NOLOCK) WHERE SERIES=4 AND SEQNUMBR=1400
		IF @nPPVGLIndex = 0
			SELECT @nPPVGLIndex = ISNULL(INVINDX,0) FROM dbo.POP10110 WITH(NOLOCK) WHERE  PONUMBER = @xstrPONumber
	END

	INSERT INTO POP10310
	(
		POPRCTNM,RCPTLNNM,PONUMBER,Landed_Cost_Group_ID
        ,ITEMNMBR
        ,ITEMDESC,VNDITNUM,VNDITDSC,UMQTYINB,ACTLSHIP,COMMNTID,INVINDX,
		UOFM,UNITCOST,EXTDCOST,LOCNCODE,RcptLineNoteIDArray_1,RcptLineNoteIDArray_2,RcptLineNoteIDArray_3,
		RcptLineNoteIDArray_4,RcptLineNoteIDArray_5,NONINVEN,DECPLCUR,DECPLQTY,ITMTRKOP,VCTNMTHD,TRXSORCE,
		JOBNUMBR,COSTCODE,COSTTYPE,CURNCYID
		,CURRNIDX,XCHGRATE
		,RATECALC,DENXRATE
		,ORUNTCST,OREXTCST,ODECPLCU,BOLPRONUMBER,Capital_Item,Product_Indicator
		,ProjNum
		,CostCatID
		,Purchase_IV_Item_Taxable,Purchase_Item_Tax_Schedu,Purchase_Site_Tax_Schedu,SHIPMTHD,PURPVIDX
 -- SELECT * FROM PA10702
	)
	VALUES
	(
		 @xstrRCVNumber		-- POPRCTNM	char 17,0,0
		,@nNextLineNumber		-- RCPTLNNM	int 4,10,0
		,@xstrPONumber			-- PONUMBER	char 17,0,0
		,ISNULL(@strLanded_Cost_Group_ID,'') --Landed_Cost_Group_ID
		,SUBSTRING(@xstrItem, 1, 30)	-- ITEMNMBR	char 31,0,0
		,@xstrItemDesc			-- ITEMDESC	char 101,0,0
		,@xstrVendorItem		-- VNDITNUM	char 31,0,0
		,@xstrItemDesc			-- VNDITDSC	char 101,0,0
		,@nQtyBaseUOM			-- UMQTYINB	numeric 9,19,5
		,@xdtDateActual			-- ACTLSHIP	datetime 8,23,3
		,@xstrCommentID			-- COMMNTID	char 15,0,0
		,@xnGLIndex			-- INVINDX	int 4,10,0
		,@xstrUOM			-- UOFM	char 9,0,0
		,@nFunctionalPrice		-- UNITCOST	numeric 9,19,5
		,@nFunctionalAmtExtended	-- EXTDCOST	numeric 9,19,5
		,@xstrLocation			-- LOCNCODE	char 11,0,0
		,@nIV00101_NOTEINDX		-- RcptLineNoteIDArray_1	numeric 9,19,5
		,@nIV40700_NOTEINDX		-- RcptLineNoteIDArray_2	numeric 9,19,5
		,@nGL00100_NOTEINDX		-- RcptLineNoteIDArray_3	numeric 9,19,5
		,@nSY04200_NOTEINDX		-- RcptLineNoteIDArray_4	numeric 9,19,5
		,@nPOHDR_PONOTIDS_1		-- RcptLineNoteIDArray_5	numeric 9,19,5
		,@nIsMiscIVItem			-- NONINVEN	smallint 2,5,0
		,@nDecimalPlacesF + 7		-- DECPLCUR	smallint 2,5,0
		,@nQtyPer			-- DECPLQTY	smallint 2,5,0
		,@nIV00101_ITMTRKOP		-- ITMTRKOP	smallint 2,5,0
		,@nIV00101_VCTNMTHD		-- VCTNMTHD	smallint 2,5,0
		,''						-- TRXSORCE	char 13,0,0
		,''		-- JOBNUMBR
		,''		-- COSTCODE
		,0			-- COSTTYPE
		,CASE WHEN @nWCSystem_idfModuleRegisteredMC = 1 THEN @strHDR_CURNCYID ELSE '' END	-- CURNCYID	char 15,0,0
		,CASE WHEN @nWCSystem_idfModuleRegisteredMC = 1 THEN @nHDR_CURRNIDX	ELSE 0 END	-- CURRNIDX	smallint 2,5,0
		,CASE WHEN RTRIM(@strXchRateTable) = '' THEN 0 ELSE @nXchRate	END 			-- XCHGRATE	numeric 9,19,7
		,@nXchExpression		-- RATECALC	smallint 2,5,0
		,0				-- DENXRATE	numeric 9,19,7
		,@xnPrice			-- ORUNTCST	numeric 9,19,5
		,@xnAmtExtended			-- OREXTCST	numeric 9,19,5
		,@nDecimalPlacesO		-- ODECPLCU	smallint 2,5,0
		,@xstrBOLProNumber		-- BOLPRONUMBER	char 31,0,0
		,0				-- Capital_Item	tinyint 1,3,0
		,@xnProductIndicator		-- Product_Indicator	smallint 2,5,0 -- 1)Dynamics 2)Job Cost 3)Service Management 
		,''
		,''
		,@xnPurchase_IV_Item_Taxable	
		,@xstrPurchase_Item_Tax_Schedu
		,@xstrPurchase_Site_Tax_Schedu
		,ISNULL(@strPM00200_SHIPMTHD,'')
		,@nPPVGLIndex
	)
	----------------------------------------------------------------------------------------------
	-- END: Insert Purchasing Receipt Line Record.
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	-- START: Insert Serial/Lot
	----------------------------------------------------------------------------------------------
	IF ((@nIV00101_ITMTRKOP = 2) OR (@nIV00101_ITMTRKOP = 3))
	BEGIN
		DECLARE @nSerialLotInsert TABLE
		(
			 idfKey INT IDENTITY (1,1)
			,idfIVItemSiteStockWorkKey INT
		)

		INSERT INTO @nSerialLotInsert (idfIVItemSiteStockWorkKey) 
		SELECT idfIVItemSiteStockWorkKey 
		FROM dbo.IVItemSiteStockWork WITH (NOLOCK) 
		WHERE idfTableLinkName = 'RCVDetail' AND idfTableLinkKey = @nRCVDetail_idfRCVDetailKey

		INSERT INTO POP10330
		(
			 ITMTRKOP
			,POPRCTNM
			,RCPTLNNM
			,SLTSQNUM
			,ITEMNMBR
			,SERLTNUM
			,SERLTQTY
			,TRXSORCE
			,DATERECD
			,DTSEQNUM
			,UNITCOST
			,QTYTYPE
			,BIN
			,MFGDATE
			,EXPNDATE
		)
		SELECT 
			 @nIV00101_ITMTRKOP			--ITMTRKOP
			,@xstrRCVNumber				--POPRCTNM
			,@nNextLineNumber			--RCPTLNNM
			,TMP.idfKey					--SLTSQNUM
			,@xstrItem					--ITEMNMBR
			,DTL.idfSerialLot			--SERLTNUM
			,DTL.idfQty					--SERLTQTY
			,''							--TRXSORCE
			,'1900-01-01 00:00:00.000'	--DATERECD
			,0							--DTSEQNUM
			,0							--UNITCOST
			,1							--QTYTYPE
			,DTL.idfBin					--BIN
			,'1900-01-01 00:00:00.000'	--MFGDATE
			,'1900-01-01 00:00:00.000'	--EXPNDATE
		FROM dbo.IVItemSiteStockWork DTL WITH (NOLOCK)
		INNER JOIN @nSerialLotInsert TMP ON TMP.idfIVItemSiteStockWorkKey = DTL.idfIVItemSiteStockWorkKey
	END
	----------------------------------------------------------------------------------------------
	-- START: Insert Project Budget Update.
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	-- END: Insert PA01301 or PA01303 - Cost Category Budget.
	----------------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------------
	-- START: Insert POP10500 - Purchasing Receipt Line Quantities Record.
	----------------------------------------------------------------------------------------------
	IF (@xnReceiveType = 3)
		SELECT @nLineQty_APPYTYPE = 1
	ELSE IF (@xnReceiveType = 2)
		SELECT @nLineQty_APPYTYPE = 3
	ELSE
		SELECT @nLineQty_APPYTYPE = @xnReceiveType
	
	IF (@nIsMiscIVItem = 0)
	BEGIN
		-- Convert Standard Cost to Originating Currency.
		EXEC spFNAConvertCur 		@xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @strHDR_CURNCYID	, 2, @nIV00101_STNDCOST, @nLineQty_OSTDCOST OUTPUT, @xodtXchRateDate = @dtidfDateReceipt, @xnForceGivenRate	= @nForceGivenRate,@xonXchRate = @nXchRate
		-- Round New Standard Cost.
		EXEC spRQFNARoundCurrency	@xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xstrTranType	, @strHDR_CURNCYID, @nLineQty_OSTDCOST, @nLineQty_OSTDCOST OUTPUT, @xstrItem
		
		-- 1/17/2005: Only Set UPPV Amount if the Valuation Method Is NOT 1-FIFO Perpetual, 2-LIFO Perpetual, 
		-- or 3-Average Perpetual then don't do the unrealized ppv.
		IF (@nIV00101_VCTNMTHD = 0 OR @nIV00101_VCTNMTHD = 1 OR @nIV00101_VCTNMTHD = 2 OR @nIV00101_VCTNMTHD = 3 OR @nIV00101_VCTNMTHD IS NULL)
			SELECT @nLineQty_RUPPVAMT = 0
		ELSE BEGIN
			-- Compute UPPV.
			SELECT @nLineQty_RUPPVAMT 	= (@xnPrice - @nLineQty_OSTDCOST) * @xnQtyShipped
			-- Round new value.
			EXEC spRQFNARoundCurrency	@xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @xstrTranType	, NULL, @nLineQty_RUPPVAMT, @nLineQty_RUPPVAMT OUTPUT, NULL
		END
	END
	ELSE	
		SELECT @nLineQty_RUPPVAMT = 0,@nLineQty_OSTDCOST = 0
-- SELECT * FROM PA10721
	INSERT INTO POP10500
	(
		PONUMBER,POLNENUM,POPRCTNM,RCPTLNNM
        
		,QTYSHPPD,QTYINVCD,QTYREJ,QTYMATCH,UMQTYINB,JOBNUMBR,
		COSTCODE,COSTTYPE,ORCPTCOST,OSTDCOST,POPTYPE,TRXLOCTN,DATERECD,RCTSEQNM,
		SPRCTSEQ,PCHRPTCT,SPRCPTCT
		,OREXTCST,RUPPVAMT,ACPURIDX,INVINDX,UPPVIDX,NOTEINDX,CURNCYID,CURRNIDX,XCHGRATE,
		RATECALC,DENXRATE,RATETPID,EXGTBLID,Capital_Item,Product_Indicator
		,Status,APPYTYPE,VENDORID,ITEMNMBR,UOFM
	)
	VALUES
	(
		 @xstrPONumber			-- PONUMBER	char 17,0,0
		,@xstrPOLine			-- POLNENUM	int 4,10,0
		,@xstrRCVNumber			-- POPRCTNM	char 17,0,0
		,@nNextLineNumber		-- RCPTLNNM	int 4,10,0		
		,@xnQtyShipped			-- QTYSHPPD	numeric 9,19,5
		,@xnQtyInvoiced			-- QTYINVCD	numeric 9,19,5
		,@xnQtyRejected			-- QTYREJ	numeric 9,19,5
		,0				-- QTYMATCH	numeric 9,19,5
		,@nQtyBaseUOM			-- UMQTYINB	numeric 9,19,5
		,''		-- JOBNUMBR
		,''		-- COSTCODE
		,0				-- COSTTYPE
		,@xnPrice			-- ORCPTCOST	numeric 9,19,5
		,@nLineQty_OSTDCOST		-- OSTDCOST	numeric 9,19,5
		,@xnReceiveType			-- POPTYPE	smallint 2,5,0
		,@xstrLocation			-- TRXLOCTN	char 11,0,0
		,'1900-01-01'			-- DATERECD	datetime 8,23,3
		,0				-- RCTSEQNM	smallint 2,5,0
		,0				-- SPRCTSEQ	smallint 2,5,0
		,0				-- PCHRPTCT	numeric 9,19,5
		,0				-- SPRCPTCT	numeric 9,19,5
		,CASE WHEN @xnReceiveType = 3 THEN 0 ELSE @xnAmtExtended END			-- OREXTCST	numeric 9,19,5
		,@nLineQty_RUPPVAMT		-- RUPPVAMT	numeric 9,19,5
		,0				-- ACPURIDX	int 4,10,0
		,@xnGLIndex			-- INVINDX	int 4,10,0
		,@xnGLUnrlzPurchPriceVar	-- UPPVIDX	int 4,10,0
		,@nLineQty_NOTEINDX		-- NOTEINDX	numeric 9,19,5
		,CASE WHEN @nWCSystem_idfModuleRegisteredMC = 1 THEN @strHDR_CURNCYID ELSE '' END		-- CURNCYID	char 15,0,0
		,CASE WHEN @nWCSystem_idfModuleRegisteredMC = 1 THEN @nHDR_CURRNIDX ELSE 0 END			-- CURRNIDX	smallint 2,5,0
		,CASE WHEN @strXchRateTable = '' THEN 0 ELSE @nXchRate	END				-- XCHGRATE	numeric 9,19,7
		,@nXchExpression		-- RATECALC	smallint 2,5,0
		,0				-- DENXRATE	numeric 9,19,7
		,@nXchRateType			-- RATETPID
		,@strXchRateTable		-- EXGTBLID
		,0				-- Capital_Item	tinyint 1,3,0
		,@xnProductIndicator		-- Product_Indicator	smallint 2,5,0 -- 1)Dynamics 2)Job Cost 3)Service Management 
		,0				-- Status	smallint 2,5,0
		,@nLineQty_APPYTYPE		-- APPYTYPE	smallint 2,5,0 	1) Shipment or Shipment/Invoice 3) Invoice
		,@strHDR_VENDORID		-- VENDORID	char 15,0,0
		,@xstrItem			-- ITEMNMBR	char 31,0,0
		,@xstrUOM			-- UOFM	char 9,0,0
	)
	----------------------------------------------------------------------------------------------
	-- END: Insert POP10500 - Purchasing Receipt Line Quantities Record.
	----------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------------
	-- Insert Purchasing Landing Cost Record.
	----------------------------------------------------------------------------------------------
	IF (ISNULL(@strLanded_Cost_Group_ID,' ') > ' ')
	BEGIN 
		SELECT @nXchRate = idfRateHome FROM RCVHeader WITH (NOLOCK) WHERE idfRCVHeaderKey = @xnidfRCVHeaderKey
		EXEC spRCVGenerateLandingCost 
			 @xstrRCVNumber	   = @xstrRCVNumber				
			,@xnNextLineNumber = @nNextLineNumber
			,@xdtidfDateReceipt = @dtidfDateReceipt
			,@xnidfRateHome	   = @nXchRate			

	END
	----------------------------------------------------------------------------------------------
		
 	----------------------------------------------------------------------------------------------
	-- START: Insert POP10340 - Purchasing Receipt Bin Quantities Record.
	-- 
	-- Only insert bin record if multi-bin is enabled and there is a default bin setup for item/site
	----------------------------------------------------------------------------------------------
	IF (EXISTS(SELECT TOP 1 1 FROM dbo.IV40100 WITH (NOLOCK) WHERE ENABLEMULTIBIN = 1))
	BEGIN
		DECLARE @nBINInsert TABLE
		(
			 idfKey INT IDENTITY (1,1)
			,idfIVItemSiteStockWorkKey INT
		)

		INSERT INTO @nBINInsert (idfIVItemSiteStockWorkKey) 
		SELECT idfIVItemSiteStockWorkKey 
		FROM dbo.IVItemSiteStockWork WITH (NOLOCK) 
		WHERE idfTableLinkName = 'RCVDetail' AND idfTableLinkKey = @nRCVDetail_idfRCVDetailKey

		IF EXISTS (SELECT TOP 1 1 FROM @nBINInsert)
		BEGIN
			INSERT INTO [dbo].[POP10340]
					   ([POPRCTNM]
					   ,[RCPTLNNM]
					   ,[SEQNUMBR]
					   ,[ITEMNMBR]
					   ,[LOCNCODE]
					   ,[BIN]
					   ,[QTYTYPE]
					   ,[QUANTITY])
			SELECT
						@xstrRCVNumber			
					   ,@nNextLineNumber
					   ,16384 * idfKey
					   ,@xstrItem
					   ,@xstrLocation
					   ,DTL.idfBin	
					   ,1
					   ,DTL.idfQty
			FROM dbo.IVItemSiteStockWork DTL WITH (NOLOCK)
			INNER JOIN @nBINInsert TMP ON TMP.idfIVItemSiteStockWorkKey = DTL.idfIVItemSiteStockWorkKey
		END
		ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.IV00102 WITH (NOLOCK) WHERE LOCNCODE= @xstrLocation AND ITEMNMBR=@xstrItem AND PORECEIPTBIN > '')
		BEGIN
			INSERT INTO [dbo].[POP10340]
					   ([POPRCTNM]
					   ,[RCPTLNNM]
					   ,[SEQNUMBR]
					   ,[ITEMNMBR]
					   ,[LOCNCODE]
					   ,[BIN]
					   ,[QTYTYPE]
					   ,[QUANTITY])
			SELECT
						@xstrRCVNumber			
					   ,@nNextLineNumber
					   ,16384
					   ,@xstrItem
					   ,@xstrLocation
					   ,I.PORECEIPTBIN
					   ,1
					   ,@xnQtyShipped*@nQtyBaseUOM 
			 FROM dbo.IV00102 I WITH (NOLOCK) 
			 WHERE  I.LOCNCODE= @xstrLocation AND I.ITEMNMBR=@xstrItem

			 
			INSERT INTO IVItemSiteStockWork (     
				 idfBin                                                       
				,idfDateExpiration       
				,idfQty                                  
				,idfSerialLot                                                 
				,idfTableLinkName                                                                                                                                                                                  
				,idfIVItemSiteKey 
				,idfTableLinkKey
			)
			SELECT       
				 I.PORECEIPTBIN					--idfBin                                                       
				,null							--idfDateExpiration       
				,@xnQtyShipped*@nQtyBaseUOM 	--idfQty                                  
				,''								--idfSerialLot                                                 
				,'RCVDetail'					--idfTableLinkName                                                                                                                                                                                 
				,IVItemSite.idfIVItemSiteKey	--idfIVItemSiteKey 
				,@nRCVDetail_idfRCVDetailKey	--idfTableLinkKey
			 FROM dbo.IV00102 I WITH (NOLOCK) 
			 INNER JOIN dbo.IVItem WITH (NOLOCK) ON IVItem.idfItemID = @xstrItem
			 INNER JOIN dbo.IVSite WITH (NOLOCK) ON IVSite.idfSiteID = @xstrLocation
			 INNER JOIN dbo.IVItemSite WITH (NOLOCK) ON IVItemSite.idfIVItemKey = IVItem.idfIVItemKey AND IVItemSite.idfIVSiteKey = IVSite.idfIVSiteKey
			 WHERE  I.LOCNCODE= @xstrLocation AND I.ITEMNMBR=@xstrItem
		END
		-- SELECT * FROM POP10340
	END
 	----------------------------------------------------------------------------------------------
	-- END: Insert POP10340 - Purchasing Receipt Bin Quantities Record.
	----------------------------------------------------------------------------------------------
 	----------------------------------------------------------------------------------------------
	-- START: Insert POP10600 - Purchasing Shipment Invoice Apply Record.
	----------------------------------------------------------------------------------------------
	IF @xnReceiveType = 2 AND @xnQtyInvoiced <> 0
	BEGIN
	DECLARE  @nQTYINVCD   NUMERIC(19,5)
			,@nMatchReceiptCostTEMP NUMERIC(19,5)

		SELECT @nQTYINVCD = @xnQtyInvoiced
		SELECT @nTotalMatched = 0
		DECLARE curAvailableRecepts INSENSITIVE CURSOR FOR
		SELECT 
			POPRCTNM,RCPTLNNM
			
			,QTYSHPPD - QTYMATCH - QTYINVCD - QTYREJ
		    ,ORCPTCOST	
			,OREXTCST		
		FROM  POP10500 (NOLOCK) 
		WHERE PONUMBER = @xstrPONumber AND POLNENUM = @xstrPOLine   
			  
			AND QTYSHPPD - QTYMATCH - QTYINVCD - QTYREJ> 0
			AND ((@nPOSTBEFOREINVOICING = 0) OR (@nPOSTBEFOREINVOICING = 1 AND POP10500.Status = 1))
		ORDER BY  PONUMBER,POLNENUM
			

		OPEN curAvailableRecepts
	
		FETCH NEXT FROM curAvailableRecepts INTO 
			 @strMatchRCVNumber	
			,@nMatchRCVLine		
			,@nQtyMatched		
			,@nMatchReceiptCost	
			,@nMatchReceiptCostExt
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN

				IF @nRCVUSEDATEANDRATEFORRCV = 1
					EXEC spFNAConvertCur @xochErrSP	OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT,@strHDR_CURNCYID,1 ,@nMatchReceiptCost,@nMatchReceiptCostTEMP	OUTPUT,@xnForceGivenRate = @nForceGivenRate,@xodtXchRateDate = @dtidfDateReceipt,@xonXchRate = @nXchRate
				ELSE
					EXEC spFNAConvertCur @xochErrSP	OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT,@strHDR_CURNCYID,1 ,@nMatchReceiptCost,@nMatchReceiptCostTEMP	OUTPUT,@xnForceGivenRate = @nForceGivenRate,@xodtXchRateDate = @dtidfDateReceipt
					

				EXEC spFNARoundCurrency @xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT
					,@strHDR_CURNCYID
					,@nMatchReceiptCostTEMP
					,@nMatchReceiptCostTEMP OUTPUT
				
	  	--		IF EXISTS (SELECT TOP 1 1 FROM dbo.IV00101 WITH(NOLOCK) WHERE ITEMNMBR = @xstrItem)
				--BEGIN	-- ITEM		  
				--	SELECT @nPPVGLIndex = ISNULL(PURPVIDX,0) FROM dbo.IV00101 WITH(NOLOCK) 
				--	WHERE ITEMNMBR = @xstrItem

				--	IF @nPPVGLIndex = 0	
				--		SELECT @nPPVGLIndex = ISNULL(ACTINDX,0) FROM dbo.SY01100 (NOLOCK) WHERE SERIES=5 AND SEQNUMBR=1200
				--END
				--ELSE 
				--BEGIN   -- MISC ITEM
				--	SELECT @nPPVGLIndex = ISNULL(PURPVIDX,0) FROM dbo.PM00200 WITH(NOLOCK) 
				--	INNER JOIN dbo.RCVHeader WITH(NOLOCK) ON VENDORID = edfVendor  
				--	WHERE idfRCVHeaderKey = @xnidfRCVHeaderKey 
				   
				--	IF @nPPVGLIndex = 0	
				--		SELECT @nPPVGLIndex = ISNULL(ACTINDX,0) FROM dbo.SY01100 WITH(NOLOCK) WHERE SERIES=4 AND SEQNUMBR=1400
				--	IF @nPPVGLIndex = 0
				--		SELECT @nPPVGLIndex = ISNULL(INVINDX,0) FROM dbo.POP10110 WITH(NOLOCK) WHERE  PONUMBER = @xstrPONumber
				--END
				DECLARE @nItemType INT
				SELECT  @nItemType = ITEMTYPE FROM dbo.IV00101 WITH (NOLOCK) WHERE ITEMNMBR = @xstrItem
				INSERT INTO POP10600
				(
					 POPIVCNO
					,IVCLINNO
					,POPRCTNM
					,RCPTLNNM
					,LCLINENUMBER
					,QTYINVRESERVE
					,Revalue_Inventory
					,PPVTotal
					,Status
					,QTYINVCD
					,ORUNTCST
					,RCPTCOST
					,ORCPTCOST
					,ACPURTOT
					,UPPVTOTL
					,PURPVIDX
					,PCHRPTCT
					,SPRCPTCT
					,CURNCYID
					,CURRNIDX
					,XCHGRATE
					,RATECALC
					,DENXRATE
				)
				VALUES
				(
					 @xstrRCVNumber      -- POPIVCNO
					,@nNextLineNumber        -- IVCLINNO
					,@strMatchRCVNumber       -- POPRCTNM
					,@nMatchRCVLine        -- RCPTLNNM
					,0        -- LCLINENUMBER
					,0        -- QTYINVRESERVE
					,CASE WHEN @xnPrice <>  @nMatchReceiptCost AND  @nItemType IN (1,2) THEN 1 ELSE 0 END    -- Revalue_Inventory
					,CASE WHEN @nQTYINVCD > @nQtyMatched THEN (@nQtyMatched * @xnPrice) - (@nQtyMatched * @nMatchReceiptCost)
															   ELSE (@nQTYINVCD * @xnPrice) - (@nQTYINVCD * @nMatchReceiptCost) END        -- PPVTotal
					,0        -- Status
					,CASE WHEN @nQTYINVCD > @nQtyMatched THEN @nQtyMatched ELSE @nQTYINVCD END          -- QTYINVCD
					,@xnPrice -- ORUNTCST
					,@nMatchReceiptCostTEMP -- RCPTCOST
					,@nMatchReceiptCost -- ORCPTCOST
					,CASE WHEN @nQTYINVCD > @nQtyMatched  THEN @nQtyMatched * @nMatchReceiptCost ELSE @nQTYINVCD * @nMatchReceiptCost END -- ACPURTOT
					,0        -- UPPVTOTL
					,@nPPVGLIndex -- PURPVIDX
					,0        -- PCHRPTCT
					,0        -- SPRCPTCT
					,CASE WHEN @nWCSystem_idfModuleRegisteredMC = 1 THEN @strHDR_CURNCYID ELSE '' END   	-- CURNCYID
					,CASE WHEN @nWCSystem_idfModuleRegisteredMC = 1 THEN @nHDR_CURRNIDX ELSE 0 END       	-- CURRNIDX
					,CASE WHEN @strXchRateTable = '' THEN 0 ELSE @nXchRate	END	-- XCHGRATE
					,@nXchExpression        -- RATECALC
					,0        -- DENXRATE
				)
				UPDATE POP10500 SET  QTYMATCH = QTYMATCH + CASE WHEN @nQtyMatched > @nQTYINVCD THEN @nQTYINVCD ELSE @nQtyMatched END
									,OREXTCST = OREXTCST - ((QTYMATCH + CASE WHEN @nQtyMatched > @nQTYINVCD THEN @nQTYINVCD ELSE @nQtyMatched END) * ORCPTCOST)
				WHERE POPRCTNM = @strMatchRCVNumber AND RCPTLNNM = @nMatchRCVLine						

				SELECT @nTotalMatched = @nTotalMatched + @nQtyMatched
				
				SELECT @nQTYINVCD = @nQTYINVCD - @nQtyMatched
				
				IF @nTotalMatched >= @xnQtyInvoiced
					BREAK
		  	FETCH NEXT FROM curAvailableRecepts INTO 
				 @strMatchRCVNumber	
				,@nMatchRCVLine		
				,@nQtyMatched		
				,@nMatchReceiptCost	
				,@nMatchReceiptCostExt
		END
		END
		CLOSE curAvailableRecepts
		DEALLOCATE curAvailableRecepts
	END
  
   	----------------------------------------------------------------------------------------------
	-- END: Insert POP10600 - Purchasing Shipment Invoice Apply Record.
	----------------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------------
	-- START: Update SY00500 - Batch Header / Posting Definitions Master Record.
	----------------------------------------------------------------------------------------------
	
	UPDATE SY00500
		SET BCHTOTAL = BCHTOTAL + @nFunctionalAmtExtended
			,MODIFDT = CONVERT(VARCHAR,GETDATE(),112)
	WHERE 	BCHSOURC = @strHDR_BCHSOURC	
		AND BACHNUMB = @strHDR_BACHNUMB

	SELECT @nRCVLineNumber = @nNextLineNumber
	----------------------------------------------------------------------------------------------
	-- START: Call Stub Stored Procedure for User Customizations.
	----------------------------------------------------------------------------------------------
	EXEC spRCVGenerateDetailAfter  @xochErrSP OUTPUT,@xonErrNum OUTPUT,@xostrErrInfo OUTPUT,
		 @xstrRCVNumber	,@nNextLineNumber,@xstrPONumber,@xstrPOLine,'STD'
		 ,@xstrudfTextField01	
		 ,@xstrudfTextField02	
		 ,@xstrudfTextField03	
		 ,@xstrudfTextField04
		 ,@xnudfNumericField01	
		 ,@xnidfRCVHeaderKey		
		 ,@dtidfDateReceipt	
		 ,@xnReceiveType
		 ,@xdtDateActual
	----------------------------------------------------------------------------------------------
	-- END: Call Stub Stored Procedure for User Customizations.
	----------------------------------------------------------------------------------------------

--Update Field For Purchase Order Header to match what GP does when you invoice
	IF (@xnReceiveType IN (2,3))
	BEGIN 
		UPDATE POP10100 SET REMSUBTO = REMSUBTO - (@xnQtyInvoiced * POP10110.UNITCOST)
		,OREMSUBT  = OREMSUBT  - (@xnQtyInvoiced * POP10110.UNITCOST) 
		FROM dbo.POP10100 WITH (NOLOCK)
		INNER JOIN dbo.POP10110 WITH (NOLOCK) ON POP10110.PONUMBER = POP10100.PONUMBER AND POP10110.ORD = @xstrPOLine
		WHERE POP10100.PONUMBER = @xstrPONumber
	END
COMMIT TRANSACTION
----------------------------------------------------------------------------------------------
-- END:
----------------------------------------------------------------------------------------------

RETURN (0)
