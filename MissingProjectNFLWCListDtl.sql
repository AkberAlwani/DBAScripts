
---missing record for one project NFL
--6/29/2018
declare @lastkey int
declare @PhaseKey int
select @lastkey =idfNextKey from WCPrimaryKey where idfTableName='WCListDtl'

declare curWCList CURSOR FOR
select idfPAProjectPhaseKey from PAProjectPhase
where idfPAProjectPhaseKey not in (
select idfCodeKey from WCListDtl where idfWCListHdrKey=157)
and idfPAProjectKey in (select idfPAProjectKey from PAProject where idfProjectID='1170342001')
and idfWCLineUpKey IS NULL 
--begin tran t1
OPEN curWCList
FETCH curWCList INTO @PhaseKey
WHILE @@FETCH_STATUS<>-1
BEGIN
  Print @PhaseKey 
  
   insert into WCListDtl (idfWCListDtlKey,idfCodeID,idfCodeKey,idfWCListHdrKey)
   values (@lastkey,'',@PhaseKey,273)
   set @lastkey=@lastkey+1
   FETCH curWCList INTO @PhaseKey
END
CLOSE curWCList
DEALLOCATE curWCList
--ROLLBACK TRAN t1




--select * from WCListDtl where idfWCListHdrKey=273
--select * from WCPrimaryKey where idfTableName='WCListDtl'