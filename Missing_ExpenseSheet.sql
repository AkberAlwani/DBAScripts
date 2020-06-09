BEGIN TRAN

DECLARE @KeyList TABLE
(
idfEXPExpenseSheetHdrKey INT
)
DECLARE @KeyListFilter TABLE
(
idfEXPExpenseSheetHdrKey INT
)

INSERT INTO @KeyList (idfEXPExpenseSheetHdrKey)
SELECT DISTINCT idfEXPExpenseSheetHdrKey FROM EXPExpenseSheetDtl WHERE idfEXPSessionKey in ( 130,140)

INSERT INTO @KeyListFilter (idfEXPExpenseSheetHdrKey)
SELECT DISTINCT EXPExpenseSheetDtl.idfEXPExpenseSheetHdrKey FROM EXPExpenseSheetDtl 
INNER JOIN @KeyList TMP ON TMP.idfEXPExpenseSheetHdrKey = EXPExpenseSheetDtl.idfEXPExpenseSheetHdrKey 
WHERE idfEXPSessionKey = 170
--AND EXPExpenseSheetDtl.idfEXPExpenseSheetHdrKey in (13824 ,13781 )

--30
--SELECT * FROM @KeyList

--6
SELECT * FROM @KeyListFilter

EXEC spEXPBatchProcess '',0,''

SELECT idfAPVoucherKey,idfInvoiceNumber, * FROM APVoucher
WHERE APVoucher.idfAPVoucherKey > 22460


ROLLBACK TRAN

--SELECT MAX(idfAPVoucherKey) FROM APVoucher

--sp_helptext spEXPBatchProcess
