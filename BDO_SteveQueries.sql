BEGIN TRAN
select '1'
Select * From EXPExpenseSheetDtlTax
EXEC spEXPExpenseSheetHdrSubmit '',0,'',862

select '2'
--SELECT idfEXPSessionKey,* FROM EXPExpenseSheetDtl WHERE idfEXPExpenseSheetHdrKey = 862
--SELECT * FROM EXPExpenseSheetDtlTax  WHERE idfEXPExpenseSheetDtlKey = 1870
Select * From EXPExpenseSheetDtlTax

EXEC spEXPBatchProcess '',0,''

select '3'
--SELECT idfEXPSessionKey,* FROM EXPExpenseSheetDtlHist WHERE idfEXPExpenseSheetHdrhistKey = 862
--SELECT * FROM EXPExpenseSheetDtlTaxHist  WHERE idfEXPExpenseSheetDtlHistKey = 1870
select 'final'
Select * From EXPExpenseSheetDtlTax

ROLLBack tran

--sp_helptext tuEXPExpenseSheetDtl


Select DISTINCT EXPExpenseSheetHdrHist.idfEXPExpenseSheetHdrHistKey
FROM EXPExpenseSheetDtlHist
INNER JOIN dbo.EXPExpenseSheetHdrHist ON EXPExpenseSheetHdrHist.idfEXPExpenseSheetHdrHistKey = EXPExpenseSheetDtlHist.idfEXPExpenseSheetHdrHistKey
INNER JOIN APVoucherDtl ON APVoucherDtl.idfTableLinkKey = EXPExpenseSheetDtlHist.idfEXPExpenseSheetDtlHistKey
INNER JOIN APVoucherDtlTax ON APVoucherDtlTax.idfAPVoucherDtlKey = APVoucherDtl.idfAPVoucherDtlKey
LEFT OUTER JOIN EXPExpenseSheetDtlTaxHist ON EXPExpenseSheetDtlTaxHist.idfEXPExpenseSheetDtlHistKey = EXPExpenseSheetDtlHist.idfEXPExpenseSheetDtlHistKey
WHERE idfTableLinkName = 'EXPExpenseSheetDtl' AND EXPExpenseSheetDtlTaxHist.idfEXPExpenseSheetDtlHistKey IS NULL 
AND (EXPExpenseSheetDtlHist.idfAmtTax > 0 OR EXPExpenseSheetDtlHist.idfAmtTaxIncluded > 0)



SELECT * FROM EXPExpenseSheetDtlHist WHERE idfEXPExpenseSheetHdrHistKey = 817

Select DISTINCT EXPExpenseSheetDtl.idfEXPExpenseSheetHdrKey
 From EXPExpenseSheetDtl
LEFT OUTER JOIN EXPExpenseSheetDtlTax ON EXPExpenseSheetDtlTax.idfEXPExpenseSheetDtlKey = EXPExpenseSheetDtl.idfEXPExpenseSheetDtlKey
WHERE  EXPExpenseSheetDtlTax.idfEXPExpenseSheetDtlKey IS NULL 
AND (EXPExpenseSheetDtl.idfAmtTax > 0 OR EXPExpenseSheetDtl.idfAmtTaxIncluded > 0)



select e.*,h.*
from EXPType  e
inner join WCTaxScheduleHdr h on e.idfWCTaxScheduleHdrKey=h.idfWCTaxScheduleHdrKey
where idfTypeID like 'Ent%'

select * from WCICCompany where idfWCICCompanyKey=12

---------------
BEGIN TRAN

DECLARE @HistoryKeys TABLE(
	 HeaderKey INT 
)

INSERT INTO @HistoryKeys(HeaderKey)
SELECT H.idfEXPExpenseSheetHdrKey
FROM EXPExpenseSheetHdr H (NOLOCK)
WHERE idfEXPExpenseSheetHdrKey = 862

DELETE FROM dbo.EXPExpenseSheetDtlTax
FROM dbo.EXPExpenseSheetDtlSplit Dtl WITH (NOLOCK)
INNER JOIN dbo.EXPExpenseSheetDtlSplitTax Dist WITH (NOLOCK) ON Dtl.idfEXPExpenseSheetDtlSplitKey = Dist.idfEXPExpenseSheetDtlSplitKey
INNER JOIN dbo.EXPExpenseSheetDtl D WITH (NOLOCK) ON D.idfEXPExpenseSheetDtlKey = Dtl.idfEXPExpenseSheetDtlKey
INNER JOIN @HistoryKeys K ON K.HeaderKey = D.idfEXPExpenseSheetHdrKey

SELECT * FROM EXPExpenseSheetDtlTax

ROLLBACK TRAN


------------------------
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

---------------------
select idfDocument02,idfInvoiceNumber,idfAmountExtended ,PRCHAMNT,TRXDSCRN,(round(abs(idfAmountExtended),0)-round(DOCAMNT,0))
from APVoucher ap
left outer join 
(select VCHNUMWK,DOCAMNT,PRCHAMNT,TRXDSCRN,DOCDATE from BDOGH..PM10000) t1 on ap.idfDocument02=t1.VCHNUMWK
where idfDatePosted >='2018-10-24'
and idfInvoiceNumber like 'EX%'
and (round(abs(idfAmountExtended),0)-round(DOCAMNT,0))<>0


---
SELECT        EDH.idfEXPExpenseSheetHdrHistKey,EDH.idfEXPExpenseSheetDtlHistKey, EDH.idfAmtTaxIncluded, EDH.idfDescription, EDH.idfFlagImported, 
                         EDH.idfImportedRefNo, EDH.idfQuantity, EDH.idfLine, EDH.idfDateCreated, EDH.idfEXPPaymentKey, 
                         EDH.idfGLAccountKey, EDH.idfPAPhaseActivityKey AS [Disbursement Type], EDH.idfPAProjectKey AS Client, 
                         EDH.idfPAProjectPhaseKey AS Matter, EDH.edfAmtExtended, AP.idfName AS [Venodr Name], WCDept.idfDeptID AS [Department ID], 
                         GLAccount.idfDescription AS [Account Description], EXPPayment.idfDescription AS [Payment Method], GLAccount_1.idfGLID,
						 EXPLog.LogDate,EXPLog.UserName,EXPLog.LogEntry
FROM  EXPExpenseSheetDtlHist EDH
      LEFT JOIN APVendor AP ON EDH.idfAPVendorKey = AP.idfAPVendorKey 
      LEFT JOIN WCDept ON EDH.idfWCDeptKey = WCDept.idfWCDeptKey 
      LEFT JOIN GLAccount ON EDH.idfGLAccountKey = GLAccount.idfGLAccountKey 
      LEFT JOIN EXPPayment ON EDH.idfEXPPaymentKey = EXPPayment.idfEXPPaymentKey 
      LEFT JOIN GLAccount AS GLAccount_1 ON EDH.idfGLAccountKey = GLAccount_1.idfGLAccountKey
	  LEFT JOIN  (SELECT EH.idfEXPExpenseSheetHdrHistKey,EL.idfEXPExpenseSheetDtlHistKey ,
		            EL.idfDateCreated AS LogDate
					, CASE WHEN EL.idfWCSecurityKey > 0 THEN idfNameLast + ', ' + idfNameFirst ELSE WCRole.idfRoleID END	AS UserName
					, ISNULL(WCLogType.idfDescription,'') + ' ' + REPLACE(idfLogEntry,'16550','ALTERNATE') AS LogEntry		
			FROM dbo.EXPExpenseSheetDtlLogHist		EL WITH (NOLOCK)
			LEFT OUTER JOIN dbo.WCSecurity	   WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey	= EL.idfWCSecurityKey
			LEFT OUTER JOIN dbo.WCRole		   WITH (NOLOCK) ON WCRole.idfWCRoleKey			= EL.idfWCSecurityKey * -1
			INNER JOIN dbo.EXPExpenseSheetDtlHist ED WITH (NOLOCK) ON ED.idfEXPExpenseSheetDtlHistKey = EL.idfEXPExpenseSheetDtlHistKey
			INNER JOIN dbo.EXPExpenseSheetHdrHist	EH WITH (NOLOCK) ON EH.idfEXPExpenseSheetHdrHistKey = ED.idfEXPExpenseSheetHdrHistKey
	  LEFT OUTER JOIN dbo.WCLogType		   WITH (NOLOCK) ON WCLogType.idfWCLogTypeKey	= EL.idfWCLogTypeKey
	WHERE EL.idfWCLogTypeKey=130) EXPLog ON EDH.idfEXPExpenseSheetDtlHistKey=EXPLog.idfEXPExpenseSheetDtlHistKey


