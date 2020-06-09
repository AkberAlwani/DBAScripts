select idfAPVoucherDtlKey,idfAmountExtended,idfAmountExtendedApr,idfAmountExtendedHome,idfAmountSubTotal,idfAmountSubTotalApr,idfPrice,idfQty,idfDocument01
from APVoucherDtl
Where idfAPVoucherKey  = (Select idfAPVoucherKey from APVoucher where idfDocument01='RCT012100')

select * from APVoucher

update APVoucher set idfAppConnError='' where idfDocument01='RCT014327'

select * from WCSecurity
select * from GLJournalDtl

select idfAmount,idfAmountHome, idfDescription,idfDocument01,idfTableLinkName,idfDateCreated
from GLJournalDtl
WHERE idfDocument01='RCT012100' or idfDocument01='PO111111'
select * from GLJournalDtl
select * from GLAccount where idfGLAccountKey in (5,261)

