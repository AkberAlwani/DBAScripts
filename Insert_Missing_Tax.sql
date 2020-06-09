--select * from RCVDetailHist where idfRCVHeaderHistKey in (select idfRCVHeaderHistKey from RCVHeaderHist where idfRCTNumber='REC0000553')
--select * from RCVDetailTaxHist where idfRCVDetailHistKey in (396,397)
--As Tx was missing in RQDetailTax and we unable to know what is the reason, only doubt that during approval some tax get remove auotmatiocally or line being duplciated which may cause this issue


--SELECT idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,rt.idfDateCreated,rt.idfDateModified,
--idfUserCreated,idfUserModified,rt.idfGLAccountKey,rd.idfRQDetailKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded
--insert into RQDetailTax
--(idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfDateCreated,idfDateModified,
--idfUserCreated,idfUserModified,idfGLAccountKey,idfRQDetailKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded)

--select rd.*
--from RQDetail rd  with (NOLOCK)
--left outer join RQDetailTax rt with (NOLOCK) on rd.idfRQDetailKey=rt.idfRQDetailKey 
--where idfRQHeaderKey=194

--select * from WCTax where idfWCTaxKey=10



begin tran
declare @RQHeader int,@ReceiptNo Varchar(200)
set @ReceiptNo='REC0000558'

select top 1 @RQHeader=idfRQHeaderKey 
from RQDetail rd with (NOLOCK)
inner join RCVDetailHist rvd with (NOLOCK) on rd.idfRCVDetailKey=rvd.idfRCVDetailHistKey
inner join RCVHeaderHist rvh with (NOLOCK)  on rvd.idfRCVHeaderHistKey=rvh.idfRCVHeaderHistKey
where idfRCTNumber=@ReceiptNo
SELECT @RQHeader


SELECT idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,rt.idfDateCreated,rt.idfDateModified,
idfUserCreated,idfUserModified,rt.idfGLAccountKey,rvd.idfRCVDetailHistKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded
from RQDetailTax rt with (NOLOCK)
inner join RQDetail rd  with (NOLOCK) on rd.idfRQDetailKey=rt.idfRQDetailKey 
left outer join (select idfRCVDetailHistKey from RCVDetailHist with (NOLOCK)) rvd on rd.idfRCVDetailKey=rvd.idfRCVDetailHistKey
left outer join (select idfRCVDetailHistKey,idfRCVDetailTaxHistKey from RCVDetailTaxHist with (NOLOCK)) rvt on rd.idfRCVDetailKey=rvt.idfRCVDetailHistKey
where idfRQHeaderKey=@RQHeader
--and rvt.idfRCVDetailHistKey is null

insert into APVoucherDtlTax 
(idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfDateCreated,idfDateModified,
idfUserCreated,idfUserModified,idfGLAccountKey,idfAPVoucherDtlKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded)

SELECT idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,rt.idfDateCreated,rt.idfDateModified,
idfUserCreated,idfUserModified,rt.idfGLAccountKey,avd.idfAPVoucherDtlKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded
from RQDetailTax rt with (NOLOCK)
inner join RQDetail rd  with (NOLOCK) on rd.idfRQDetailKey=rt.idfRQDetailKey 
left outer join (select idfRCVDetailHistKey from RCVDetailHist with (NOLOCK)) rvd on rd.idfRCVDetailKey=rvd.idfRCVDetailHistKey
left outer join (select idfRCVDetailHistKey,idfRCVDetailTaxHistKey from RCVDetailTaxHist with (NOLOCK)) rvt on rd.idfRCVDetailKey=rvt.idfRCVDetailHistKey
inner join (select idfAPVoucherDtlKey,idfTableLinkKey from APVoucherDtl with (NOLOCK) WHERE idfTableLinkName='RCVDetail') avd on rd.idfRCVDetailKey=avd.idfTableLinkKey 
where idfRQHeaderKey=@RQHeader
and rvt.idfRCVDetailHistKey is null

select adt.* 
from APVoucher a with (NOLOCK)
inner join APVoucherDtl ad with (NOLOCK)on a.idfAPVoucherKey=ad.idfAPVoucherKey
left outer join APVoucherDtlTax adt with (NOLOCK) on ad.idfAPVoucherDtlKey=adt.idfAPVoucherDtlKey
where a.idfDocument01=@ReceiptNo

--Insert Tax on Histry Table RCV
insert into RCVDetailTaxHist (
idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfDateCreated,idfDateModified,
idfUserCreated,idfUserModified,idfGLAccountKey,idfRCVDetailHistKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded)

SELECT idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,rt.idfDateCreated,rt.idfDateModified,
idfUserCreated,idfUserModified,rt.idfGLAccountKey,rvd.idfRCVDetailHistKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded
from RQDetailTax rt with (NOLOCK)
inner join RQDetail rd  with (NOLOCK) on rd.idfRQDetailKey=rt.idfRQDetailKey 
left outer join (select idfRCVDetailHistKey from RCVDetailHist with (NOLOCK)) rvd on rd.idfRCVDetailKey=rvd.idfRCVDetailHistKey
left outer join (select idfRCVDetailHistKey,idfRCVDetailTaxHistKey from RCVDetailTaxHist with (NOLOCK)) rvt on rd.idfRCVDetailKey=rvt.idfRCVDetailHistKey
where idfRQHeaderKey=@RQHeader
and rvt.idfRCVDetailHistKey is null


SELECT idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,rt.idfDateCreated,rt.idfDateModified,
idfUserCreated,idfUserModified,rt.idfGLAccountKey,rvd.idfRCVDetailHistKey,idfWCTaxKey,idfWCTaxClassKeyParent,idfWCTaxClassKeyChild,idfFlagTaxIncluded
from RQDetailTax rt with (NOLOCK)
inner join RQDetail rd  with (NOLOCK) on rd.idfRQDetailKey=rt.idfRQDetailKey 
left outer join (select idfRCVDetailHistKey from RCVDetailHist with (NOLOCK)) rvd on rd.idfRCVDetailKey=rvd.idfRCVDetailHistKey
left outer join (select idfRCVDetailHistKey,idfRCVDetailTaxHistKey from RCVDetailTaxHist with (NOLOCK)) rvt on rd.idfRCVDetailKey=rvt.idfRCVDetailHistKey
where idfRQHeaderKey=@RQHeader
--select * from RCVDetailTaxHist where idfRCVDetailHistKey in (396,397)

--INSERT THE MISSING TAX in APVoucher
commit tran


