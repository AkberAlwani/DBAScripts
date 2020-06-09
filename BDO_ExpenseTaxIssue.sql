select * from GLAccount where idfGLID like '05-550%'
select * from BDOGH..GL00105 where ACTNUMST like '05-550%'

select * from GLAccount where idfGLID='01-100-53-310-5635'
select * from BDOGH..GL00105 where ACTNUMST='01-100-53-310-5635'
UPDATE GLAccount set idfEAICLink='3258BDOGH' where idfGLID='01-100-53-310-5635'

select * from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=15976

select sum(t.idfAmountTax),sum(t.idfAmountTaxable) 

from EXPExpenseSheetDtlTaxHist T (NOLOCK)
INNER JOIN EXPExpenseSheetDtlHist  E (NOLOCK) on T.idfEXPExpenseSheetDtlHistKey=E.idfEXPExpenseSheetDtlHistKey
where idfEXPExpenseSheetHdrHistKey=15976

select E.idfAmtTax,E.idfAmtTaxIncluded,E.*
from EXPExpenseSheetDtlTaxHist T (NOLOCK)
INNER JOIN EXPExpenseSheetDtlHist  E (NOLOCK) on T.idfEXPExpenseSheetDtlHistKey=E.idfEXPExpenseSheetDtlHistKey
where idfEXPExpenseSheetHdrHistKey=15976
and (E.idfAmtTax+E.idfAmtTaxIncluded)<>T.idfAmountTax

UPDATE E set E.idfAmtTaxIncluded=E.idfAmtTaxIncludedApr
 --set idfAmtTaxIncluded=Case WHEN T.idfFlagTaxIncluded=1 THEN T.idfAmountTax Else 0 END
from EXPExpenseSheetDtlTaxHist T (NOLOCK)
INNER JOIN EXPExpenseSheetDtlHist  E (NOLOCK) on T.idfEXPExpenseSheetDtlHistKey=E.idfEXPExpenseSheetDtlHistKey
where idfEXPExpenseSheetHdrHistKey=15976
and (E.idfAmtTax+E.idfAmtTaxIncluded)<>T.idfAmountTax

select * 
from EXPCreditCardHist E (NOLOCK)
inner join EXPtype T (NOLOCK) on E.idfEXPTypeKey=T.idfEXPTypeKey
where idfImportedRefNo='74619700056000077162218'

select * from APVoucher where idfDocument01 like '%15976%'
UPDATE E
  set E.idfAmountTaxIncluded=E.idfAmountTaxIncludedApr
--SElect *
from ApVoucherDtlTax T (NOLOCK)
INNER JOIN APVoucherDtl E (NOLOCK) on T.idfAPVoucherDtlKey=E.idfAPVoucherDtlKey
where idfAPVoucherKey=25422
and (E.idfAmountTaxIncluded<>E.idfAmountTaxIncludedApr)



select idfSEcurityID,* 
from EXPCreditCard E
inner join WCSEcurity S on E.idfWCSecurityKey=S.idfWCSecurityKey
and E.idfEXPExpenseSheetDtlKey is null
