select * from RCVHeaderHist where idfRCTNumber='RCT000292'
select * from RCVDetailHist where idfRCVHeaderHistKey=207
select * from RCVDetailTaxHist where idfRCVDetailHistKey in (select idfRCVDetailHistKey from RCVDetailHist where idfRCVHeaderHistKey=207)

select * from RCVDetailHist 
where idfRCVHeaderHistKey=207
and idfRCVDetailHistKey  not in (select idfRCVDetailHistKey from RCVDetailTaxHist )

insert into RCVDetailTaxHist 
(idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfFlagTaxIncluded,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified
,idfGLAccountKey,idfRCVDetailHistKey,idfWCTaxClassKeyChild,idfWCTaxClassKeyParent,idfWCTaxKey)
select 0,idfAmtExtendedApr,idfAmtExtendedHome,0,'::TAXDETAIL_TOTAL::',1,idfDateCreated,idfDateModified,'WPShared','WPShared',28,idfRCVDetailHistKey,4,2,1
 from RCVDetailHist 
where idfRCVHeaderHistKey=207
and idfRCVDetailHistKey  not in (select idfRCVDetailHistKey from RCVDetailTaxHist )


select * from APVoucherDtl where idfAPVoucherKey in (select idfAPVoucherKey  from APVoucher where idfDocument01='RCT000292')
select * from APVoucherDtlTax 
where idfAPVoucherDtlKey in (select idfAPVoucherDtlKey from APVoucherDtl where idfAPVoucherKey in (select idfAPVoucherKey  from APVoucher where idfDocument01='RCT000292'))
select * from APVoucherDtl 
where idfAPVoucherKey in (select idfAPVoucherKey  from APVoucher where idfDocument01='RCT000292')
and idfAPVoucherDtlKey  not in (select idfAPVoucherDtlKey from APVoucherDtlTax )

insert into APVoucherDtlTax (idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfFlagTaxIncluded,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,
idfAPVoucherDtlKey,idfGLAccountKey,idfWCTaxClassKeyChild,idfWCTaxClassKeyParent,idfWCTaxKey)
select 0,idfAmountExtended,idfAmountExtendedHome,0,'::TAXDETAIL_TOTAL::',1,idfDateCreated,idfDateModified,'WPShared','WPShared',idfAPVoucherDtlKey,28,4,2,1
from APVoucherDtl 
where idfAPVoucherKey in (select idfAPVoucherKey  from APVoucher where idfDocument01='RCT000292')
and idfAPVoucherDtlKey  not in (select idfAPVoucherDtlKey from APVoucherDtlTax )



