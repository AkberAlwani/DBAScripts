BEGIN TRAN

SELECT * FROM APVoucherDtl 

INSERT INTO dbo.EXPExpenseSheetDtlTaxHist
(
	idfAmountTax        
	,idfAmountTaxable    
	,idfAmountTaxableHome
	,idfAmountTaxHome    
	,idfAmountType           
	,idfGLAccountKey     
	,idfEXPExpenseSheetDtlHistKey  
	,idfWCTaxKey 
	,idfWCTaxClassKeyParent
	,idfWCTaxClassKeyChild 
	,idfFlagTaxIncluded         
)
SELECT
	 APVoucherDtlTax.idfAmountTax        
	,APVoucherDtlTax.idfAmountTaxable    
	,APVoucherDtlTax.idfAmountTaxableHome
	,APVoucherDtlTax.idfAmountTaxHome    
	,APVoucherDtlTax.idfAmountType           
	,APVoucherDtlTax.idfGLAccountKey     
	,EXPExpenseSheetDtlHist.idfEXPExpenseSheetDtlHistKey
	,APVoucherDtlTax.idfWCTaxKey 
	,APVoucherDtlTax.idfWCTaxClassKeyParent
	,APVoucherDtlTax.idfWCTaxClassKeyChild 
	,APVoucherDtlTax.idfFlagTaxIncluded 
FROM dbo.APVoucherDtlTax WITH (NOLOCK)
INNER JOIN dbo.APVoucherDtl WITH (NOLOCK) ON APVoucherDtl.idfAPVoucherDtlKey = APVoucherDtlTax.idfAPVoucherDtlKey
INNER JOIN dbo.EXPExpenseSheetDtlHist WITH (NOLOCK) ON EXPExpenseSheetDtlHist.idfEXPExpenseSheetDtlHistKey = APVoucherDtl.idfTableLinkKey 
LEFT OUTER JOIN dbo.EXPExpenseSheetDtlTaxHist WITH (NOLOCK) ON EXPExpenseSheetDtlTaxHist.idfEXPExpenseSheetDtlHistKey = EXPExpenseSheetDtlHist.idfEXPExpenseSheetDtlHistKey
WHERE APVoucherDtl.idfTableLinkName = 'EXPExpenseSheetDtl' AND EXPExpenseSheetDtlTaxHist.idfEXPExpenseSheetDtlHistKey IS NULL

SELECT * FROM EXPExpenseSheetDtlTaxHist 

ROLLBACK TRAN

