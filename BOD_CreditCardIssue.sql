--193594
select idfImportedRefNo,idfEXPExpenseSheetHdrHistKey,edfDocument01,idfDateCreated,idfDateModified,* 
from EXPExpenseSheetDtlHist WITH (NOLOCK) where idfImportedRefNo in 
     (select idfImportedRefNo from EXPExpenseSheetDtlHist WITH (NOLOCK) group by idfImportedRefNo having count(idfImportedRefNo)>1)
and idfImportedRefNo<>''

-- Check the Expense process and Credit Card transaction still in EXPCreditCard
BEGIN TRAN
UPDATE C set C.idfEXPExpenseSheetDtlKey=e.idfEXPExpenseSheetDtlHistKey
FROM EXPExpenseSheetDtlHist E WITH (NOLOCK) 
INNER JOIN EXPCreditCard C WITH (NOLOCK) ON E.idfImportedRefNo=c.idfImportedRefNo

SELECT e.idfImportedRefNo,idfEXPExpenseSheetHdrHistKey,edfDocument01,e.idfEXPExpenseSheetDtlHistKey,e.idfDateCreated,e.idfDateModified,c.idfEXPExpenseSheetDtlKey,c.*
FROM EXPExpenseSheetDtlHist E WITH (NOLOCK) 
INNER JOIN EXPCreditCard C WITH (NOLOCK) ON E.idfImportedRefNo=c.idfImportedRefNo
ROLLBACK TRAN


-- Check Expense which are not process
select idfImportedRefNo,idfEXPExpenseSheetHdrKey,edfDocument01,idfDateCreated,idfDateModified,* 
from EXPExpenseSheetDtl WITH (NOLOCK) where idfImportedRefNo in 
     (select idfImportedRefNo from EXPExpenseSheetDtl WITH (NOLOCK) group by idfImportedRefNo having count(idfImportedRefNo)>1)
and idfImportedRefNo<>''

--Check if any of the Imported CC are duplicated from Open table
select idfImportedRefNo from EXPCreditCard WITH (NOLOCK)
where idfImportedRefNo in (select idfImportedRefNo from EXPCreditCard WITH (NOLOCK) group by idfImportedRefNo having count(*)>1 union
select idfImportedRefNo from EXPCreditCardHist WITH (NOLOCK) group by idfImportedRefNo having count(*)>1)

--Check if any of the Imported CC are duplicated from Posted table.
-- CC Open and Expense in Histyory
select cc.idfEXPCreditCardKey,cc.idfImportedRefNo,cc.idfPrice,cc.idfComment,cc.idfEXPExpenseSheetDtlKey,cc.idfDateModified,cc.idfDateCreated,ed.idfEXPExpenseSheetHdrHistKey,ed.* 
from EXPCreditCard cc WITH (NOLOCK)
inner join EXPExpenseSheetDtlHist ed WITH (NOLOCK) on cc.idfImportedRefNo =ed.idfImportedRefNo
--12-20-2018 9:07 am
UPDATE EXPCreditCard set idfEXPExpenseSheetDtlKey=7936 where idfImportedRefNo='74557028337010907351437' and idfEXPCreditCardKey=4870 
UPDATE EXPCreditCard set idfEXPExpenseSheetDtlKey=6185 where idfImportedRefNo='74557028304031036574037' and idfEXPCreditCardKey=2453
---CC Open and Expense Open with missing ExpenseSheetDtlKey
select cc.idfEXPCreditCardKey,cc.idfImportedRefNo,cc.idfPrice,cc.idfComment,cc.idfEXPExpenseSheetDtlKey,cc.idfDateModified,cc.idfDateCreated,ed.idfEXPExpenseSheetHdrKey,ed.* 
from EXPCreditCard cc WITH (NOLOCK)
inner join EXPExpenseSheetDtl ed WITH (NOLOCK) on cc.idfImportedRefNo =ed.idfImportedRefNo and cc.idfEXPExpenseSheetDtlKey is NULL

--CC closed but Expense Open
select cc.idfEXPCreditCardHistKey,cc.idfImportedRefNo,cc.idfPrice,cc.idfComment,cc.idfEXPExpenseSheetDtlHistKey,cc.idfDateModified,cc.idfDateCreated,ed.idfEXPExpenseSheetHdrKey,ed.* 
from EXPCreditCardHist cc WITH (NOLOCK)
inner join EXPExpenseSheetDtl ed WITH (NOLOCK) on cc.idfImportedRefNo =ed.idfImportedRefNo 


select idfImportedRefNo from EXPCreditCardHist WITH (NOLOCK)
where idfImportedRefNo in (select idfImportedRefNo from EXPCreditCard WITH (NOLOCK) group by idfImportedRefNo having count(*)>1 
union
select idfImportedRefNo from EXPCreditCardHist WITH (NOLOCK) group by idfImportedRefNo having count(*)>1)


select h.idfImportedRefNo,h.idfWCSecurityKey,s.idfSecurityID,s.idfDescription,d.idfEXPExpenseSheetHdrHistKey,*
from EXPCreditCardHist h
inner join WCSecurity s on h.idfWCSecurityKey=s.idfWCSecurityKey
inner join EXPExpenseSheetDtlHist d on d.idfEXPExpenseSheetDtlHistKey=h.idfEXPExpenseSheetDtlHistKey
where h.idfImportedRefNo in (select idfImportedRefNo from EXPExpenseSheetDtlHist group by idfImportedRefNo having count(idfImportedRefNo)>1)

select idfImportedRefNo,* from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=387 or idfAmtSubTotal=31.82
select idfImportedRefNo,* from EXPExpenseSheetDtl where idfEXPExpenseSheetHdrKey=387 or idfAmtSubTotal=31.82

--12-13-2018 10:53 am
select * from EXPCreditCard where idfImportedRefNo='74557028281010905789980' or idfPrice=31.82
select * from EXPCreditCardHist where idfImportedRefNo='74557028281010905789980' or idfPrice=31.82
update EXPCreditCardHist  set idfEXPExpenseSheetDtlHistKey=758 where idfImportedRefNo='74557028281010905789980' or idfPrice=31.82
select * from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=387

DECLARE @xochErrSP char(32)
DECLARE @xonErrNum int
DECLARE @xostrErrInfo varchar(255)
DECLARE @xnidfEXPCreditCardKey nvarchar(255)

set @xnidfEXPCreditCardKey= 2453
--894,4080,4081,4082,4376,4659,4625,4660,4967,4968,4626,4083,
EXECUTE [dbo].[spEXPCreditCardMoveToHistory]     @xochErrSP OUTPUT  ,@xonErrNum OUTPUT  ,@xostrErrInfo OUTPUT  ,@xnidfEXPCreditCardKey
GO


