delete from WCEAICQueue
--select * from APVoucher where idfDocument01='RCT006177'
--update APVoucher set idfDatePosted='2019-12-16'  where idfDocument01='RCT006177'

begin tran
delete vdt
from APVoucherDtlTax vdt
inner join APVoucherDtl vd on vdt.idfAPVoucherDtlKey=vd.idfAPVoucherDtlKey
inner join APVoucher V on v.idfAPVoucherKey=vd.idfAPVoucherKey
where v.idfDocument01='RCT006177'

delete vd
from APVoucher V inner join APVoucherDtl vd
on v.idfAPVoucherKey=vd.idfAPVoucherKey
where v.idfDocument01='RCT006177'

delete APVoucher where idfDocument01='RCT006177'

delete vdt
from RCVDetailTaxHist vdt
inner join RCVDetailHIst vd on vdt.idfRCVDetailHistKey=vd.idfRCVDetailHistKey
inner join RCVHeaderHist V on v.idfRCVHeaderHistKey=vd.idfRCVHeaderHistKey
where v.idfRCTNumber='RCT006177'

delete vd
from RCVHeaderHist V inner join RCVDetailHIst vd
on v.idfRCVHeaderHistKey=vd.idfRCVHeaderHistKey
where v.idfRCTNumber='RCT006177'

delete RCVHeaderHist where idfRCTNumber='RCT006177'


commit tran