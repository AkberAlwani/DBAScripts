use WorkPlaceLive_EMS
--TEST Case
select * from RCVHeaderHist where idfRCTNumber='RCT500196'
select idfPOLine,idfPONumber,* from RCVDetailHist where idfRCVHeaderHistKey=196
select * from RCVDetailDistributionHist where idfRCVDetailHistKey in (select idfRCVDetailHistKey from RCVDetailHist where idfRCVHeaderHistKey=196)
select pdd.* from PODetailDistributionHist pdd
 inner join PODetailHist pd on pd.idfPODetailHistKey =pdd.idfPODetailHistKey 
 inner join POHeaderHist ph on ph.idfPOHeaderHistKey=pd.idfPOHeaderHistKey
where idfPONumber='12400186'

--7-3-2018 11:34am

begin tran t1  
   update RCVDetailDistributionHist set idfAmtExtended=(rd.idfAmtExtended-rd.idfAmtTax),idfAmtExtendedHome=(rd.idfAmtExtendedHome-rd.idfAmtTaxHome)
   from RCVDetailHist Rd
   inner join RCVDetailDistributionHist  rdd on rd.idfRCVDetailHistKey=rdd.idfRCVDetailHistKey
   where idfRCVHeaderHistKey=196
   select * from RCVDetailDistributionHist where idfRCVDetailHistKey in (select idfRCVDetailHistKey from RCVDetailHist where idfRCVHeaderHistKey=196)
rollback tran t1
begin tran t2
    update RCVDetailDistributionHist set idfAmtExtended=(rd.idfAmtExtended-rd.idfAmtTax),idfAmtExtendedHome=(rd.idfAmtExtendedHome-rd.idfAmtTaxHome)
    from RCVDetailDistributionHist rdd 
	inner join RCVDetailHist rd on rd.idfRCVDetailHistKey=rdd.idfRCVDetailHistKey
	inner join RCVHeaderHist rh on rd.idfRCVHeaderHistKey=rh.idfRCVHeaderHistKey
    where rdd.idfAmtExtended <=-1 
	and rh.idfRCTNumber in ('RCT500209','RCT500210','RCT500211','RCT500217')

	select rh.idfRCTNumber,rdd.* ,rd.*
	from RCVDetailDistributionHist rdd 
	inner join RCVDetailHist rd on rd.idfRCVDetailHistKey=rdd.idfRCVDetailHistKey
	inner join RCVHeaderHist rh on rd.idfRCVHeaderHistKey=rh.idfRCVHeaderHistKey
	WHERE rh.idfRCTNumber in ('RCT500209','RCT500210','RCT500211','RCT500217')
rollback tran t2

select idfRCVDetailKey,* from RCVDetailDistribution where idfAmtExtended <=-1 or idfAmtExtendedHome<=-1
--select * into RCVDetailDistributionHist_070318 from RCVDetailDistributionHist where idfAmtExtended <=-1 or idfAmtExtendedHome<=-1
select idfRCVDetailHistKey,* from RCVDetailDistributionHist where idfAmtExtended <=-1 or idfAmtExtendedHome<=-1

select rh.idfRCTNumber,rdd.* ,rd.*
from RCVDetailDistributionHist rdd 
inner join RCVDetailHist rd on rd.idfRCVDetailHistKey=rdd.idfRCVDetailHistKey
inner join RCVHeaderHist rh on rd.idfRCVHeaderHistKey=rh.idfRCVHeaderHistKey
--where rdd.idfAmtExtended <=-1 --RCT500209,RCT500210,RCT500211,RCT500217
WHERE rh.idfRCTNumber in ('RCT500209','RCT500210','RCT500211','RCT500217')


select rh.idfRCTNumber,(rd.idfAmtExtendedHome-rd.idfAmtTaxHome),rdd.* ,rd.*
from RCVDetailDistributionHist rdd 
inner join RCVDetailHist rd on rd.idfRCVDetailHistKey=rdd.idfRCVDetailHistKey
inner join RCVHeaderHist rh on rd.idfRCVHeaderHistKey=rh.idfRCVHeaderHistKey
where rdd.idfAmtExtendedHome<=-1


select idfRCTNumber from RCVHeaderHist 
where idfRCVHeaderHistKey in (select idfRCVHeaderHistKey from RCVDetailHist where idfRCVDetailHistKey in (select idfRCVDetailHistKey from RCVDetailDistributionHist where idfAmtExtended <=-1 ))
select * from RCVDetailHist where idfRCVDetailHistKey in (select idfRCVDetailHistKey from RCVDetailDistributionHist where idfAmtExtended <=-1 )

select * from vwFNACurrency
select * from WorkPlaceControl..PTICurrency
select * from WorkPlaceControl..PTICurrencyRateDtl where idfPTICurrencyRateHdrKey=1 order by 4 desc -- USD Divide Rate
select * from WorkPlaceControl..PTICurrencyRateDtl where idfPTICurrencyRateHdrKey=8 order by 4 desc -- ZAR Divide Rate
