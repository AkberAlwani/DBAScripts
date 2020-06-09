begin tran
declare @EXPExpenseHdrKey INT
set @EXPExpenseHdrKey =2519

delete t
--select t.*
from APVoucherDtlTax t
inner join APVoucherDtl d on t.idfAPVoucherDtlKey=d.idfAPVoucherDtlKey
inner join APVoucher h on d.idfAPVoucherKey=h.idfAPVoucherKey
where h.idfDocument01 like 'EXPHDR:'+convert(varchar,@EXPExpenseHdrKey)

delete d
--select d.*
from APVoucherDtl d
inner join APVoucher h on d.idfAPVoucherKey=h.idfAPVoucherKey
where h.idfDocument01 like 'EXPHDR:'+convert(varchar,@EXPExpenseHdrKey)

--delete APVoucher where idfDocument01 like 'EXPHDR:'+convert(varchar,@EXPExpenseHdrKey)
--select * from APVoucher where idfDocument01 like 'EXPHDR:'+convert(varchar,@EXPExpenseHdrKey)
print 'Voucher'
delete APVoucher where idfDocument01 like 'EXPHDR:'+convert(varchar,@EXPExpenseHdrKey)

print 'EXP Tax'
delete t
from EXPExpenseSheetDtlTaxHist t
inner join EXPExpenseSheetDtlHist d on t.idfEXPExpenseSheetDtlHistKey=d.idfEXPExpenseSheetDtlHistKey
where d.idfEXPExpenseSheetHdrHistKey=@EXPExpenseHdrKey

print 'EXP DTL'
delete from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=@EXPExpenseHdrKey
print 'EXP HDR'
delete from EXPExpenseSheetHdrHist where idfEXPExpenseSheetHdrHistKey=@EXPExpenseHdrKey
rollback tran
