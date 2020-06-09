--select idfPTICompanyKey,idfSecurityID,* from WCSecurity where idfSecurityID='LBJTMC\paramount.workplace'

--select idfSecurityID,* from WCsecurity where idfDescription like '%Shon%'

begin tran
declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
exec WPELive..spRQRevPost @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnidfRQRevHdrKey='9'
select @p1, @p2, @p3
rollback tran 


select * from RCVHeaderHist where idfRCTNumber='RCT000306'
update RCVheaderHist set idfDatePost=idfDateReceipt where idfRCTNumber='RCT000306'
update APVoucher set idfDatePosted=idfDateTransaction where idfDocument01='RCT000306'
select * from APVoucher where idfDocument01='RCT000306'

select * from GLJournalHdr where idfJournalNumber in (select idfParam01 from WCEAICQueue)
begin tran
UPDATE GLJournalHdr set idfDatePost=idfDateReceipt
from RCVHeaderHist r 
inner join GLJournalHdr G on g.idfDocument02=r.idfRCTNumber
where idfJournalNumber in (select idfParam01 from WCEAICQueue)

UPDATE GLJournalHdr set idfDatePost=idfDateReceipt
--select g.* 
from RCVHeaderHist r 
inner join GLJournalHdr G on g.idfDocument01=r.idfRCTNumber
where idfJournalNumber in ('GLJRNL00687','GLJRNL00720')

rollback tran

select * from GLJournalHdr where idfJournalNumber in ('GLJRNL00687','GLJRNL00720')

select * from RCVHeaderHist where idfRCTNumber in ('RCT000550','RCT000248','RCT000203')

--5:49 am Pago 

select h.idfRCTNumber,h.idfRCVHeaderKey, rdd.idfAmtExtended,rdd.idfAmtExtendedHome,d.idfAmtExtendedHome,d.idfAmtExtended, d.idfPOLine,d.idfPONumber,d.idfItemDesc,d.idfPriceHome,d.*
from RCVAprDtl rd
inner join RCVDetail D on rd.idfRCVDetailKey=d.idfRCVDetailKey
inner join RCVHeader h on d.idfRCVHeaderKey=h.idfRCVHeaderKey
inner join RCVDetailDistribution rdd on d.idfRCVDetailKey=rdd.idfRCVDetailKey
inner join (SELECT PH.idfPONumber,PD.* from PODetail PD inner join POHeader PH on pd.idfPOHeaderKey=ph.idfPOHeaderKey) PD
on d.idfPOLine=pd.idfLine and d.idfPONumber=Pd.idfPONumber
where idfRCVAprHdrKey=314 and rdd.idfAmtExtendedHome<>d.idfAmtExtendedHome


select idfQtyShipped,edfPrice,* from RCVDetail 
--WHERE  idfQtyShipped*edfPrice<>idfAmtExtended
where idfRCVHeaderKey=557
--or edfPrice<>idfPriceApr

Begin tran
UPDATE RCVDetail set idfAmtExtendedApr=d.idfAmtExtended,idfAmtExtendedHome=d.idfAmtExtended,idfPriceApr=d.edfPrice,idfPriceHome=d.edfPrice,edfAmtHomeExtended=d.edfAmtExtended
---select * 
from RCVAprDtl rd
inner join RCVAprHdr rh on rd.idfRCVAprHdrKey=rh.idfRCVAprHdrKey
inner join RCVDetail D on rd.idfRCVDetailKey=d.idfRCVDetailKey
inner join RCVHeader h on d.idfRCVHeaderKey=h.idfRCVHeaderKey
inner join RCVDetailDistribution rdd on d.idfRCVDetailKey=rdd.idfRCVDetailKey
inner join (SELECT PH.idfPONumber,PD.* from PODetail PD inner join POHeader PH on pd.idfPOHeaderKey=ph.idfPOHeaderKey) PD on d.idfPOLine=pd.idfLine and d.idfPONumber=Pd.idfPONumber
where d.edfPrice<>d.idfPriceApr and rh.idfFlagProcessed=0

--where idfRCVAprHdrKey=314  and d.edfPrice<>d.idfPriceApr
UPDATE RCVDetailDistribution  set idfAmtExtended=d.idfAmtExtended,idfAmtExtendedHome=d.idfAmtExtendedHome
--select rdd.*
from RCVAprDtl rd
inner join RCVAprHdr rh on rd.idfRCVAprHdrKey=rh.idfRCVAprHdrKey
inner join RCVDetail D on rd.idfRCVDetailKey=d.idfRCVDetailKey
inner join RCVHeader h on d.idfRCVHeaderKey=h.idfRCVHeaderKey
inner join RCVDetailDistribution rdd on d.idfRCVDetailKey=rdd.idfRCVDetailKey
inner join (SELECT PH.idfPONumber,PD.* from PODetail PD inner join POHeader PH on pd.idfPOHeaderKey=ph.idfPOHeaderKey) PD
on d.idfPOLine=pd.idfLine and d.idfPONumber=Pd.idfPONumber
where rdd.idfAmtExtendedHome<>d.idfAmtExtendedHome and rh.idfFlagProcessed=0
--where idfRCVAprHdrKey=314 and rdd.idfAmtExtendedHome<>d.idfAmtExtendedHome

select h.idfRCTNumber,h.idfRCVHeaderKey, rdd.idfAmtExtended,rdd.idfAmtExtendedHome,d.idfAmtExtendedHome,d.idfAmtExtended, d.idfPOLine,d.idfPONumber,d.idfItemDesc,d.idfPriceHome,d.*
from RCVAprDtl rd
inner join RCVDetail D on rd.idfRCVDetailKey=d.idfRCVDetailKey
inner join RCVHeader h on d.idfRCVHeaderKey=h.idfRCVHeaderKey
inner join RCVDetailDistribution rdd on d.idfRCVDetailKey=rdd.idfRCVDetailKey
inner join (SELECT PH.idfPONumber,PD.* from PODetail PD inner join POHeader PH on pd.idfPOHeaderKey=ph.idfPOHeaderKey) PD
on d.idfPOLine=pd.idfLine and d.idfPONumber=Pd.idfPONumber
where idfRCVAprHdrKey=314 

rollback tran
--8/9/2019 8:47
--select h.idfRCTNumber,h.idfRCVHeaderKey, rdd.idfAmtExtended,rdd.idfAmtExtendedHome,d.idfAmtExtendedHome,d.idfAmtExtended, d.idfPOLine,d.idfPONumber,d.idfItemDesc,d.idfPriceHome,d.*
UPDATE RCVDetailDistribution  set idfAmtExtended=d.idfAmtExtended,idfAmtExtendedHome=d.idfAmtExtendedHome
from RCVAprDtl rd
inner join RCVAprHdr rh on rd.idfRCVAprHdrKey=rh.idfRCVAprHdrKey
inner join RCVDetail D on rd.idfRCVDetailKey=d.idfRCVDetailKey
inner join RCVHeader h on d.idfRCVHeaderKey=h.idfRCVHeaderKey
inner join RCVDetailDistribution rdd on d.idfRCVDetailKey=rdd.idfRCVDetailKey
inner join (SELECT PH.idfPONumber,PD.* from PODetail PD inner join POHeader PH on pd.idfPOHeaderKey=ph.idfPOHeaderKey) PD
on d.idfPOLine=pd.idfLine and d.idfPONumber=Pd.idfPONumber
where rdd.idfAmtExtendedHome<>d.idfAmtExtendedHome and rh.idfFlagProcessed=0

--Case 196348
select idfRevision,* from POHeader where idfPONumber='PO100026'

begin tran

DECLARE @xochErrSP char(32)
DECLARE @xonErrNum int
DECLARE @xostrErrInfo varchar(255)
DECLARE @xnidfPOHeaderKey int
DECLARE @xstrAction varchar(20)
--EXECUTE [dbo].[spPOHeaderMoveFromHistory]     @xochErrSP OUTPUT  ,@xonErrNum OUTPUT  ,@xostrErrInfo OUTPUT, @xnidfPOHeaderKey=371
--PO100026  @xnidfPOHeaderKey=29,222
--PO100201 @xnidfPOHeaderKey=371 , RCT000536,RCT000470 recall and deleted by mistake 371 was revision 1 so I moved that so I corrected revision 0 to 1 and history change 1 to 0
--PO100256  @xnidfPOHeaderKey=305 RCT000782
EXECUTE [dbo].[spPOHeaderMoveToHistory]    @xochErrSP OUTPUT  ,@xonErrNum OUTPUT  ,@xostrErrInfo OUTPUT  ,@xnidfPOHeaderKey=241
GO

select idfRevision,* from POHeader where idfPONumber='PO100201'

rollback tran

select idfRevision,* from POHeaderHist where idfPONumber='PO100256'
select idfRevision,* from POHeader where idfPONumber='PO100256'
---Not run-update POHeader set idfRevision=1,idfAmtExtended=570.88,idfAmtExtendedApr=570.88,idfAmtExtendedHome=570.88,idfAmtSubTotal where idfPONumber='PO100201'
---Not runupdate POheaderHIst set idfRevision=0,idfAmtExtended=569.65,idfAmtExtendedApr=569.65,idfAmtExtendedHome=569.65 where idfPONumber='PO100201'

select * into RCVDetail_0809 from RCVDetail where idfRCVHeaderKey not in (select idfRCVHeaderKey from RCVHeader)
delete from RCVDetail where idfRCVHeaderKey not in (select idfRCVHeaderKey from RCVHeader)
delete from RCVAutoRcvHdr where idfRCVAutoRcvHdrKey=43


--Check if still exists POheader multiple time
--Recall
SELECT idfPONumber,count(*) from POheader group by idfPONumber having count(*)>1

select idfRCVAutoRcvHdrKey,* from RCVAutoRcvDtl where   idfPONumber='PO100256'
select h.idfRCTNumber,h.idfRCVHeaderKey,d.* 
from RCVDetail d
inner join RCVHeader h on d.idfRCVHeaderKey=h.idfRCVHeaderKey
where   idfPONumber='PO100256'

select h.idfRCTNumber,h.idfRCVHeaderHistKey,d.* 
from RCVDetailHist d
inner join RCVHeaderHist h on d.idfRCVHeaderHistKey=h.idfRCVHeaderHistKey
where   idfPONumber='PO100256'

