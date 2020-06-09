SELECT EXPExpenseSheetDtlSplit.idfDateCreated,* FROM EXPExpenseSheetDtlSplit 
INNER JOIN EXPExpenseSheetDtlSplitTax ON EXPExpenseSheetDtlSplitTax.idfEXPExpenseSheetDtlSplitKey = EXPExpenseSheetDtlSplit.idfEXPExpenseSheetDtlSplitKey
INNER JOIN WCTax ON WCTax.idfWCTaxKey = EXPExpenseSheetDtlSplitTax.idfWCTaxKey
WHERE WCTax.idfWCICCompanyKey = 12

SELECT EXPExpenseSheetDtlSplitTaxHist.idfDateCreated,EXPExpenseSheetDtlSplitHist.idfDateModified,* FROM EXPExpenseSheetDtlSplitHist 
INNER JOIN EXPExpenseSheetDtlSplitTaxHist ON EXPExpenseSheetDtlSplitTaxHist.idfEXPExpenseSheetDtlSplitHistKey = EXPExpenseSheetDtlSplitHist.idfEXPExpenseSheetDtlSplitHistKey
INNER JOIN WCTax ON WCTax.idfWCTaxKey = EXPExpenseSheetDtlSplitTaxHist.idfWCTaxKey
WHERE WCTax.idfWCICCompanyKey = 12

SELECT * FROM EXPExpenseSheetDtlSplitHist --3374

sELECT d.idfDateCreated,d.idfEXPExpenseSheetHdrKey,* 
from EXPExpenseSheetDtl d
left outer join EXPExpenseSheetDtlTax  t on d.idfEXPExpenseSheetDtlKey=t.idfEXPExpenseSheetDtlKey
where t.idfEXPExpenseSheetDtlTaxKey IS NULL
AND (d.idfAmtTax>0 or d.idfAmtTaxIncluded>0) 
order by 1 desc


BEGIN TRAN


sELECT d.idfDateCreated,d.idfEXPExpenseSheetHdrKey,* 
from EXPExpenseSheetDtl d
left outer join EXPExpenseSheetDtlTax  t on d.idfEXPExpenseSheetDtlKey=t.idfEXPExpenseSheetDtlKey
where t.idfEXPExpenseSheetDtlTaxKey IS NULL
AND (d.idfAmtTax>0 or d.idfAmtTaxIncluded>0) 
order by 1 desc

	DECLARE @xnidfTableLinkKey INT,@nCount INT
	SET @nCount = 0
	DECLARE zcurspRCVHeaderIN INSENSITIVE CURSOR 
	FOR sELECT d.idfEXPExpenseSheetDtlKey
from EXPExpenseSheetDtl d
left outer join EXPExpenseSheetDtlTax  t on d.idfEXPExpenseSheetDtlKey=t.idfEXPExpenseSheetDtlKey
where t.idfEXPExpenseSheetDtlTaxKey IS NULL
AND (d.idfAmtTax>0 or d.idfAmtTaxIncluded>0) 
order by 1 desc


	OPEN zcurspRCVHeaderIN

	FETCH zcurspRCVHeaderIN INTO @xnidfTableLinkKey

	WHILE @@fetch_status <> -1
	BEGIN
		IF @@fetch_status <> -2
		BEGIN
EXEC spWCTaxDetailRecalculate '',0,'','EXPExpenseSheetDtl',@xnidfTableLinkKey
SELECT @nCount= @nCount +1
		END -- @@fetch_status <> -2

		FETCH zcurspRCVHeaderIN INTO @xnidfTableLinkKey

	END --@@fetch_status <> -1
	CLOSE zcurspRCVHeaderIN
	DEALLOCATE zcurspRCVHeaderIN

	SELECT @nCount

sELECT d.idfDateCreated,d.idfEXPExpenseSheetHdrKey,* 
from EXPExpenseSheetDtl d
left outer join EXPExpenseSheetDtlTax  t on d.idfEXPExpenseSheetDtlKey=t.idfEXPExpenseSheetDtlKey
where d.idfEXPExpenseSheetDtlKey = 1929
-- t.idfEXPExpenseSheetDtlTaxKey IS NULL
--AND (d.idfAmtTax>0 or d.idfAmtTaxIncluded>0) 
order by 1 desc


ROLLBACK TRAN
