select idfEXPSessionKey,* from EXPExpenseSheetDtl where idfEXPExpenseSheetHdrKey=2165 --16488
select idfEXPSessionKey,* from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=2165 --16488
select idfEXPSessionKey,* from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=2106--16000
select * from EXPRevDtl order by idfEXPExpenseSheetDtlKey desc
select idfSecurityID,* from WCSecurity where idfDescription like '%Rasha%'
select * from EXPAprDtl where idfEXPExpenseSheetDtlKey=16488
select * from EXPAprDtlHist where idfEXPExpenseSheetDtlKey=16488

-- First Investigate
--select  distinct idfEXPExpenseSheetHdrHistKey,idfEXPSessionKey,idfDay
declare @EXPKey INT 
declare curExpense cursor for  
select  distinct a.idfEXPExpenseSheetHdrHistKey
from EXPExpenseSheetDtlHist a (NOLOCK)
inner join EXPExpenseSheetHdrHist b (NOLOCK) on a.idfEXPExpenseSheetHdrHistKey=b.idfEXPExpenseSheetHdrHistKey
WHERE a.idfEXPExpenseSheetDtlHistKey not in (select idfEXPExpenseSheetDtlKey from EXPRevDtl)

open curExpense
FETCH curExpense into @EXPKey
WHILE @@FETCH_STATUS<>-1
BEGIN
--begin tran
  -- select 'Hist',* from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=2194 --16488
   exec spEXPMoveFromHistory @xnidfEXPExpenseSheetHdrHistKey	=@EXPKey
   --select 'Hist',* from EXPExpenseSheetDtlHist where idfEXPExpenseSheetHdrHistKey=2194 --16488
   --select 'Open',* from EXPExpenseSheetDtl where idfEXPExpenseSheetHdrKey=@EXPKey 
   SELECT  'Expense Move to Open '+convert(varchar,@EXPKey)
--rollback tran
FETCH curExpense into @EXPKey
END
close curExpense
deallocate curExpense



begin tran

Declare @p1 varchar(32),@p2 INt, @p3 varchar(255),@p5 varchar(255)
exec spEXPBatchProcess  @xochErrSP=@p1 OUTPUT,@xonErrNum=@p2 OUTPUT,@xostrErrInfo=@p3 OUTPUT,@xnidfWCSecurityKey=81
,@xonidfEXPRevHdrKey=@p5 OUTPUT,@xstrLD_idfSecurityID_From='CANARIE\rasha.tadros',@xstrLD_idfSecurityID_To='CANARIE\rasha.tadros'
,@xstridfBatchID=''
select @p1,@p2,@p3,@p5

rollback tran



select idfAmtExtendedTravelAllocated,* from EXPExpenseSheetDtl 
select idfSecurityID,* from WCSecurity where idfDescription like 'Rasha%'

select  * from EXPExpenseSheetDtlLog where idfEXPExpenseSheetDtlKey in (16488)
select * from EXPExpenseSheetDtlLogHist where idfEXPExpenseSheetDtlHistKey in (16488)
select * from WCAprPath where idfLinkTableName='EXPExpenseSheetDtl' and idfLinkTableKey in (16488,16000)

declare @nNewKey INT
EXEC spWCGetNextPK 'EXPExpenseSheetDtlLog',@nNewKey OUTPUT

insert into EXPExpenseSheetDtlLog (idfEXPExpenseSheetDtlLogKey,idfLogEntry,idfLogEntryExtended,idfLogEntryInt,idfDateCreated,idfEXPExpenseSheetDtlKey,idfWCLogTypeKey,idfWCSecurityKey)
select @nNewKey,idfLogEntry,idfLogEntryExtended,idfLogEntryInt,idfDateCreated,idfEXPExpenseSheetDtlHistKey,idfWCLogTypeKey,idfWCSecurityKey
 from CANA1_BAK..EXPExpenseSheetDtlLogHist where idfEXPExpenseSheetDtlHistKey in (16488)
and idfEXPExpenseSheetDtlLogHistKey=72546

exec spPTIFixPrimaryKey
select * from CANA1_BAK..EXPExpenseSheetDtlLogHist where idfEXPExpenseSheetDtlHistKey in (16488)
select * from EXPExpenseSheetDtlLogHist where idfEXPExpenseSheetDtlHistKey in (16488)

