select idfDocument01,idfVendorID,ap.* 
from APVoucher ap
inner join APVendor v on  ap.idfAPVendorKey=v.idfAPVendorkey
where idfDocument01 like 'EXPHDR%' and
substring(idfDocument01,8,3) in (795,885,889,896,900,901,903)

select * from GLAccount where idfGLAccountKey in 
(select distinct idfGLAccountKey from APVoucherDtl where idfAPVoucherKey in (3677,3678,3679))
order by idfGLID

SELECT * from [NAV].[dbo].[Compass Research, LLC$G_L Account] 
where [No_]
in (select idfGLID collate Latin1_General_100_CS_AS from GLAccount where idfGLAccountKey in 
(select distinct idfGLAccountKey from APVoucherDtl where idfAPVoucherKey in (3677,3678,3679)))





SELECT * from [NAV].[dbo].[Compass Research, LLC$Vendor]
where [No_] in ('BAEZ010','CAJA010','GIBS010','POHL010','KRAU010','MOOR020')

SELECT * from [NAV].[dbo].[Compass Research, LLC$WPPurchInvoice]
where [Vendor Invoice No_] in('EX00000795','EX00000885','EX00000889','EX00000896','EX00000900','EX00000901','EX00000903')

SELECT * from [NAV].[dbo].[Compass Research, LLC$WPPurchInvoice]
where WPAPVoucherKey >=3675



select * from EXPRevHdr where idfEXPRevHdrKey=252
select * from EXPRevDtl where idfEXPExpenseSheetDtlKey in (
select idfEXPExpenseSheetDtlHistKey from EXPExpenseSheetDtlHist
where idfEXPExpenseSheetHdrHistKey in (795,885,889))
select * from EXPAprDtl where idfEXPExpenseSheetDtlKey in (
select idfEXPExpenseSheetDtlHistKey from EXPExpenseSheetDtlHist
where idfEXPExpenseSheetHdrHistKey in (795,885,889))
select * from APVoucher where idfAppConnCreated=0

