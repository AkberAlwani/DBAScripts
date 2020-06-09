DECLARE @RCTNumber VARCHAR(50)
set @RCTNumber='RCT0009818'

--select d.idfAmtExtended,t.*,d.* from RCVDetailTaxHist t
update t set t.idfAmountTaxable= d.idfAmtExtended-d.idfAmtTax,
      t.idfAmountTaxableHome=d.idfAmtExtendedHome-d.idfAmtTaxHome
from RCVDetailTaxHist t
inner join RCVDetailHist d on t.idfRCVDetailHistKey=d.idfRCVDetailHistKey 
where d.idfRCVHeaderHistKey in 
(select idfRCVHeaderHistKey  from RCVHeaderHist where idfRCTNumber=@RCTNumber)
and t.idfAmountTaxable<>(d.idfAmtExtended-idfAmtTax)

update t set t.idfAmountTaxable= d.idfAmountExtended-d.idfAmountTax,
      t.idfAmountTaxableHome=d.idfAmountExtendedHome-d.idfAmountTaxHome
from APVoucherDtlTax t 
inner join APVoucherDtl d on t.idfAPVoucherDtlKey=d.idfAPVoucherDtlKey
where idfAPVoucherKey in (select idfAPVoucherKey from APVoucher where idfDocument01=@RCTNumber)
and t.idfAmountTaxable<>(d.idfAmountExtended-d.idfAmountTax)



-- For Expense
DECLARE @ExpKey INT 
set @ExpKey =1060

SELECT * FROM APVoucherDtl
SELECT * FROM APVoucherDtlTax


