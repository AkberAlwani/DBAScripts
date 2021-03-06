USE [TWO]
GO
/****** Object:  StoredProcedure [dbo].[spPORPTByDept]    Script Date: 4/7/2020 2:43:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spPORPTByDept]
 @xstridfSecurityIDCurrent	VARCHAR(255)= NULL
,@xnidfDeptID				VARCHAR(20)	= NULL
,@xdtFromSubmitted			DATETIME	= NULL
,@xdtUpToSubmitted			DATETIME	= NULL
,@xnidfDateFormat INT = NULL
,@xnidfCaption				INT = NULL
,@xnidfData					INT = NULL
AS
DECLARE
 @nVar					INT
,@nDisplayFunctional	INT
,@strCurrency2Display	VARCHAR(20)
,@nidfWCLanguageKey		INT
,@strDeptIDLabel		VARCHAR(25)
,@strDateLabel			VARCHAR(20)
,@strTimeLabel			VARCHAR(20)
,@strPageLabel			VARCHAR(10)
,@strOFLabel			VARCHAR(10)
,@strPO#Label			VARCHAR(25)
,@strVendorLabel		VARCHAR(15)
,@strItemNumLabel		VARCHAR(20)
,@strDescRefLabel		VARCHAR(35)
,@strOrderLabel			VARCHAR(10)
,@strUnitPriceLabel		VARCHAR(20)
,@strTaxLabel			VARCHAR(10)
,@strOrderTotalLabel	VARCHAR(20)
,@strExtPriceLabel      VARCHAR(20)
,@strPObyDeptLabel		VARCHAR(35)
,@strDescLabel			VARCHAR(30)
,@strItemDescLabel		VARCHAR(20)
,@strDeptLabel			VARCHAR(15)
,@strEquipIDLabel		VARCHAR(20)
,@strWorkOrdLabel		VARCHAR(20)
,@strCostCodeLabel		VARCHAR(20)
,@strCommAmtLabel		VARCHAR(20)


SET NOCOUNT ON

IF (@xnidfCaption = 1)
BEGIN

SELECT @nidfWCLanguageKey = idfWCLanguageKey FROM dbo.WCSecurity WITH (NOLOCK) WHERE idfSecurityID = @xstridfSecurityIDCurrent

SELECT	 @strDeptIDLabel	= '::vdfDeptID::'
		,@strDateLabel 		= '::11735::'
		,@strTimeLabel 		= '::11353::'
		,@strPageLabel 		= '::12901::'
		,@strOFLabel   		= '::12902::'
		,@strPO#Label		= '::12192::'
		,@strVendorLabel	= '::10073::'
		,@strItemNumLabel	= '::11612::'
		,@strDescRefLabel	= '::13398::'
		,@strOrderLabel		= '::12644::'
		,@strUnitPriceLabel	= '::12468::'
		,@strExtPriceLabel	= '::13400::'
		,@strOrderTotalLabel= '::13405::'
		,@strPObyDeptLabel	= '::13502::'
		,@strDescLabel		= '::10331::'
		,@strItemDescLabel	= '::edfItemDesc::'
		,@strDeptLabel		= '::10071:::'
		,@strEquipIDLabel	= ''
		,@strWorkOrdLabel	= ''
		,@strCostCodeLabel	= ''
		,@strCommAmtLabel	= ''
		
		
EXEC spWCLanguageDecode @strDeptIDLabel		OUTPUT,@nidfWCLanguageKey		
EXEC spWCLanguageDecode @strDateLabel 		OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strTimeLabel 		OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strPageLabel 		OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strOFLabel   		OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strPO#Label		OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strVendorLabel	 	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strItemNumLabel	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strDescRefLabel	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strOrderLabel		OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strUnitPriceLabel	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strExtPriceLabel	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strOrderTotalLabel	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strPObyDeptLabel	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strDescLabel		OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strItemDescLabel	OUTPUT,@nidfWCLanguageKey
EXEC spWCLanguageDecode @strDeptLabel		OUTPUT,@nidfWCLanguageKey

--CDB 9/19/07: Uncomment for versions prior to WP 10x.
--SELECT	 @strDeptIDLabel	= 'DeptID'
--		,@strDateLabel 		= 'Date'
--		,@strTimeLabel 		= 'Time'
--		,@strPageLabel 		= 'Page'
--		,@strOFLabel   		= ''
--		,@strPO#Label		= 'PO #'
--		,@strVendorLabel	= 'Vendor'
--		,@strItemNumLabel	= 'Item Number'
--		,@strDescRefLabel	= 'Description/Reference Number'
--		,@strOrderLabel		= 'Order'
--		,@strUnitPriceLabel	= 'Unit Price'
--		,@strExtPriceLabel	= 'Ext. Price'
--		,@strOrderTotalLabel= 'Ordered'
--		,@strPObyDeptLabel	= 'Purchase Orders By Department'
--		,@strDescLabel		= 'Description'
--		,@strItemDescLabel	= 'Item Description'
--		,@strDeptLabel		= 'Department:'

SELECT  @strDeptIDLabel			AS DeptIDLabel
		,@strDateLabel			AS DateLabel 
		,@strTimeLabel 			AS TimeLabel
		,@strPageLabel 			AS PageLabel  
		,@strOFLabel			AS OFLabel
		,@strPO#Label			AS PO#Label
		,@strVendorLabel		AS VendorLabel		
		,@strItemNumLabel		AS ItemNumLabel	
		,@strDescRefLabel		AS DescRefLabel		
		,@strOrderLabel			AS OrderLabel		
		,@strUnitPriceLabel		AS UnitPriceLabel
		,@strExtPriceLabel	    AS ExtPriceLabel
		,@strOrderTotalLabel    AS OrderTotalLabel
		,@strPObyDeptLabel		AS PurchaseOrdersByDepartmentLabel
		,@strDescLabel			AS DescLabel
		,@strItemDescLabel		AS ItemDescLabel
		,@strDeptLabel			AS DeptLabel
		,''						AS EquipIDLabel
		,''						AS WorkOrdLabel
		,''						AS CostCodeLabel
		,''						AS CommAmtLabel
		,1 AS LinkKey
END

IF(@xnidfData = 1)
BEGIN	
	DECLARE @tblReport TABLE 
	(
		 idfDeptID		VARCHAR(20)
		,PONUMBER		VARCHAR(17)
		,ORD			INT
		,VNDITDSC		VARCHAR(101)
		,idfDescription	VARCHAR(60)
		,strDOCDATE		VARCHAR(20)
		,VENDNAME		VARCHAR(65)
		,QTYORDER		VARCHAR(30)
		,UNITCOST		VARCHAR(30)
		,EXTDCOST		VARCHAR(30)
		,LinkKey		INT
		,edfCurrency	VARCHAR(15)
		,edfPricePrec	INT
	)
	
	INSERT INTO @tblReport
	SELECT DISTINCT WCDept.idfDeptID
	,H.PONUMBER
	,D.ORD
	,D.VNDITDSC
	,WCDept.idfDescription
	,CONVERT(VARCHAR(20),H.DOCDATE,@xnidfDateFormat) AS strDOCDATE
	,H.VENDNAME
	,D.QTYORDER
	,D.ORUNTCST
	,D.OREXTCST
	,1 AS LinkKey
	,RD.edfCurrency
	,RD.edfPricePrec
	FROM dbo.POP10100 H WITH (NOLOCK)
		INNER JOIN dbo.POP10110 D WITH (NOLOCK)			ON D.PONUMBER = H.PONUMBER
		INNER JOIN dbo.RQDetail RD WITH (NOLOCK)		ON D.PONUMBER = RD.edfPONumber AND D.ORD = RD.edfPOLine
		INNER JOIN dbo.WCDept	WCDept	WITH (NOLOCK)	ON RD.idfWCDeptKey = WCDept.idfWCDeptKey
		INNER JOIN dbo.WCSecurity S WITH (NOLOCK)		ON S.idfSecurityID = @xstridfSecurityIDCurrent 
		LEFT OUTER JOIN dbo.WCSecDept SD WITH (NOLOCK)	ON S.idfWCSecurityKey = SD.idfWCSecurityKey
	WHERE (RD.idfWCDeptKey = S.idfWCDeptKey OR RD.idfWCDeptKey = SD.idfWCDeptKey)
		AND (ISNULL(@xnidfDeptID, '') = '' OR WCDept.idfDeptID = @xnidfDeptID)
		AND (ISNULL(@xdtFromSubmitted, '1/1/1900') = '1/1/1900'  OR H.DOCDATE >= @xdtFromSubmitted)
		AND (ISNULL (@xdtUpToSubmitted, '1/1/1900') = '1/1/1900' OR H.DOCDATE <= @xdtUpToSubmitted)
	UNION ALL
	SELECT DISTINCT WCDept.idfDeptID
	,H.PONUMBER
	,D.ORD
	,D.VNDITDSC
	,WCDept.idfDescription
	,CONVERT(VARCHAR(20),H.DOCDATE,@xnidfDateFormat) AS strDOCDATE
	,H.VENDNAME
	,D.QTYORDER
	,D.ORUNTCST
	,D.OREXTCST
	,1 AS LinkKey
	,RD.edfCurrency
	,RD.edfPricePrec
	FROM dbo.POP30100 H WITH (NOLOCK)
		INNER JOIN dbo.POP30110 D WITH (NOLOCK)			ON D.PONUMBER = H.PONUMBER
		INNER JOIN dbo.RQDetail RD WITH (NOLOCK)		ON D.PONUMBER = RD.edfPONumber AND D.ORD = RD.edfPOLine
		INNER JOIN dbo.WCDept	WCDept	WITH (NOLOCK)	ON RD.idfWCDeptKey = WCDept.idfWCDeptKey
		INNER JOIN dbo.WCSecurity S WITH (NOLOCK)		ON S.idfSecurityID = @xstridfSecurityIDCurrent 
		LEFT OUTER JOIN dbo.WCSecDept SD WITH (NOLOCK)	ON S.idfWCSecurityKey = SD.idfWCSecurityKey
	WHERE (RD.idfWCDeptKey = S.idfWCDeptKey OR RD.idfWCDeptKey = SD.idfWCDeptKey)
		AND (ISNULL(@xnidfDeptID, '') = '' OR WCDept.idfDeptID = @xnidfDeptID)
		AND (ISNULL(@xdtFromSubmitted, '1/1/1900') = '1/1/1900'  OR H.DOCDATE >= @xdtFromSubmitted)
		AND (ISNULL (@xdtUpToSubmitted, '1/1/1900') = '1/1/1900' OR H.DOCDATE <= @xdtUpToSubmitted)
	ORDER BY WCDept.idfDeptID ASC, H.PONUMBER DESC, D.VNDITDSC ASC
	
	-- CDB 9/14/07: Format numeric values.	
	DECLARE curReport CURSOR FOR SELECT
		 QTYORDER
		,UNITCOST
		,EXTDCOST
		,edfCurrency
		,edfPricePrec
	FROM @tblReport
	FOR UPDATE OF QTYORDER,UNITCOST,EXTDCOST

	DECLARE
	 @strQTYORDER		VARCHAR(30)
	,@strUNITCOST		VARCHAR(30)
	,@strEXTDCOST		VARCHAR(30)
	,@stredfCurrency	VARCHAR(15)
	,@stredfPricePrec	INT
			
	OPEN curReport
	FETCH NEXT FROM curReport INTO @strQTYORDER,@strUNITCOST,@strEXTDCOST,@stredfCurrency,@stredfPricePrec

	WHILE (@@fetch_status <> -1) BEGIN
		IF (@@fetch_status <> -2) BEGIN
			-- --------------------------------------------------------------------------------------------------------------
			-- Format Qty.
			-- --------------------------------------------------------------------------------------------------------------
			DECLARE 
			 @n__Format_Decimal	INT
			,@strFormat_IntVal	VARCHAR(30)
			,@strFormat_DecVal	VARCHAR(30)
			,@n__Format_Ctr		INT

			SET @n__Format_Decimal	= CHARINDEX ('.',@strQTYORDER)
			SET @strFormat_IntVal   = SUBSTRING(@strQTYORDER,1,@n__Format_Decimal - 1)
			SET @strFormat_DecVal	= SUBSTRING(@strQTYORDER,@n__Format_Decimal+1,LEN(@strQTYORDER) - @n__Format_Decimal)
		    
			-- Remove Ending Zeros until number other than zero is hit.
			SET @n__Format_Ctr		= LEN(@strFormat_DecVal)
			WHILE (@n__Format_Ctr >0) BEGIN
				IF SUBSTRING(@strFormat_DecVal,@n__Format_Ctr,1) <> '0'
					BREAK

				SET @n__Format_Ctr = @n__Format_Ctr - 1
			END

			SET @strFormat_DecVal=SUBSTRING(@strFormat_DecVal,1,@n__Format_Ctr)
			SET @strQTYORDER = @strFormat_IntVal + CASE WHEN LEN(@strFormat_DecVal)=0 THEN '' ELSE '.' END + @strFormat_DecVal

			-- --------------------------------------------------------------------------------------------------------------
			-- Format Unit Cost and Extended.
			-- --------------------------------------------------------------------------------------------------------------
			EXEC spFNAFormatCurrency 
				 @xstrCurrency			= @stredfCurrency
				,@xnAmount				= @strUNITCOST   
				,@xnPrecision			= @stredfPricePrec
				,@xostrFormattedCurrency= @strUNITCOST OUTPUT

			EXEC spFNAFormatCurrency 
				 @xstrCurrency			= @stredfCurrency
				,@xnAmount				= @strEXTDCOST   
				,@xostrFormattedCurrency= @strEXTDCOST OUTPUT


			UPDATE @tblReport 
			SET  QTYORDER	= @strQTYORDER 
				,UNITCOST	= @strUNITCOST
				,EXTDCOST	= @strEXTDCOST
			WHERE CURRENT OF curReport
			
		END
		FETCH NEXT FROM curReport INTO @strQTYORDER,@strUNITCOST,@strEXTDCOST,@stredfCurrency,@stredfPricePrec
	END

	CLOSE curReport
	DEALLOCATE curReport
	

	SELECT R.* 
		,'' AS udfTextField01_EQ,'' AS udfTextField02_EQ,'' AS udfTextField03_EQ,'' AS idfAmount_EQ
		,CONVERT(VARCHAR(20),GETDATE(),@xnidfDateFormat) AS idfCurrentDate
	FROM @tblReport R
END
RETURN (0)