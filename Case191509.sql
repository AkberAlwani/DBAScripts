select idfWCSecurityKey ,* from PAProject where idfProjectID in ('2080022','1170342001')
select * from PAProjectPhase where idfPAProjectKey=74916765

select idfSEcurityId,idfDescription,idfWCSecurityKey from WCSecurity where idfDescription like 'KIM%'
select idfSEcurityId,idfDescription from WCSecurity where idfWCSecurityKey=1401
select idfSEcurityId,idfDescription from WCSecurity where idfWCSecurityKey=2945
select idfSEcurityId,idfDescription from WCSecurity where idfWCSecurityKey=2947
select * from WCLineUpSec where idfWCLineUpKey in (263,454)
select * from WCLineUp  where idfLineUpID like '%1401%'
select * from WCLineUp  where idfLineUpID like '%2945%'
--update WCLineUpSec Set idfWCSecurityKey=1401 where idfWCLineUpKey=263

SELECT idfTETimeSheetHdrKey,idfWCRRGroupLineUpKey,* from TETimeSheetDtl where idfPAProjectKey in (74916765)
select * from TETimeSheetHdr where idfTETimeSheetHdrKey=190421
select idfWCLineUpKey,* from TETimeSheetDtl where idfTETimeSheetHdrKey=190421 and idfPAProjectKey=74916765

select * from TEAprDtl where idfTETimeSheetDtlKey in (
select idfTETimeSheetDtlKey from TETimeSheetDtl where idfTETimeSheetHdrKey=190421)

select * from WCAprPath where idfLinkTableName='TETimeSheetDtl'
and idfLinkTableKey in (1895640,1895641)
select* from WCRRGroupLineUp where idfWCRRTemplateSPID like '%1401%' or idfWCLineUpKey=263
select* from WCRRGroupLineUp where idfWCRRTemplateSPID like '%1401%' or idfWCLineUpKey=454

SELECT p.idfWCRRGroupLineUpKey,g.idfWCLineUpKey 
								FROM WPECompany..WCAprPath p (NOLOCK)
										INNER JOIN WCRRGroupLineUp g (NOLOCK) ON p.idfWCRRGroupLineUpKey = g.idfWCRRGroupLineUpKey
								WHERE idfLinkTableKey = 1895640 AND idfLinkTableName = 'TETimeSheetDtl' ORDER BY idfWCAprPathKey
								
select * FROM WCRRGroup R
INNER JOIN WCRRGroupLineUp rl on r.idfWCRRGroupKey=rl.idfWCRRGroupKey
inner join WCLineUp wc on rl.idfWCLineUpKey=wc.idfWCLineUpKey
WHERE r.idfDescription LIKE '%1401%' and r.idfFlagInternal=1
select * FROM WCRRGroup R
INNER JOIN WCRRGroupLineUp rl on r.idfWCRRGroupKey=rl.idfWCRRGroupKey
inner join WCLineUp wc on rl.idfWCLineUpKey=wc.idfWCLineUpKey
WHERE r.idfDescription LIKE '%2945%' and r.idfFlagInternal=1

--backkup the auto rules
begin tran t1
 --delete from WCRRGroupLineUp where idfWCRRGroupLineUpKey=157
 --delete from WCRRGroup 
rollback tran t1
--


select * from 
(select '*APR_'+cast(idfWCSEcurityKey as varchar) Approval,idfSEcurityID,idfWCSEcurityKey,idfEmployeeID 
from WCSecurity
where idfEmployeeID <>'' and idfFlagActive=1) t1
where idfEmployeeID='900885'
--where Approval not in (select idfLineUPID from WCLineUp)
--6/29/2018
--Steven
select * from WCLineUp where idfLineUpID like '%*APR_1401%' 
select * from WCRRGroup where idfDescription like '%_1401%'
select * from WCListHdr where idfListID like '%_1401%'
select * from WCListDtl where idfWCListHdrKey=157

select * from WCLineUpSec where idfWCSecurityKey =1401
select * from WCRRGroupLineUp where idfWCLineUpKey =263

--Detail Missing for the NFL
select idfPAProjectPhaseKey,* from PAProjectPhase
where idfPAProjectPhaseKey in (
select idfCodeKey from WCListDtl where idfWCListHdrKey=157)
and idfPAProjectKey in (select idfPAProjectKey from PAProject where idfProjectID='1170342001')
and idfWCLineUpKey IS NULL 

select * into WCListDtl_1401 from WCListDtl where idfWCListHdrKey=157 
and idfCodeKey in (select idfPAProjectPhaseKey from PAProjectPhase 
where idfPAProjectKey in (select idfPAProjectKey from PAProject where idfProjectID='1170342001')
and idfWCLineUpKey IS NULL )

delete from WCListDtl where idfWCListHdrKey=157 
and idfCodeKey in (select idfPAProjectPhaseKey from PAProjectPhase 
where idfPAProjectKey in (select idfPAProjectKey from PAProject where idfProjectID='1170342001')
and idfWCLineUpKey IS NULL )


select * from WCLineUp where idfLineUpID like '%*APR_2945%' order by 5
select * from WCRRGroup where idfDescription like '%_2945%'
select * from WCListHdr where idfListID like '%_2945%'
select * from WCLineUpSec where idfWCSecurityKey =2945
select * from WCRRGroupLineUp where idfWCLineUpKey=454
select * from WCListDtl where idfWCListHdrKey=273


select idfPAProjectPhaseKey,273 from PAProjectPhase
where idfPAProjectPhaseKey not in (
select idfCodeKey from WCListDtl where idfWCListHdrKey=273)
and idfPAProjectKey in (select idfPAProjectKey from PAProject where idfProjectID='1170342001')
and idfWCLineUpKey IS NULL 

select * from WCListDtl where idfWCListHdrKey=273

select * from WCPrimaryKey where idfTableName='WCListDtl'

select PhaseList.* from PAProjectPhase Detail
JOIN WCListDtl PhaseList (NOLOCK) ON PhaseList.idfWCListHdrKey = 273 AND Detail.idfPAProjectPhaseKey = PhaseList.idfCodeKey  WHERE Detail.idfWCLineUpKey IS NULL 
and idfEAICLink like '%-1170342001%'
--select * from WCPrimaryKey where idfTableName='WCListDtl'
--exec spPTIFixPrimaryKey
--select * from WCPrimaryKey where idfTableName='WCListDtl'

select * from PAProjectPhase Detail where idfEAICLink like '%-1170342001%' --863322058
select * from PAProject where idfProjectID='1170342001'



select * from WCLineUp where idfLineUpID like '%_19' order by 5
select * from WCRRGroup where idfDescription like '%_19%'
select * from WCListHdr where idfListID like '%_2945%'


select idfEmployeeID ,COUNT(*)
from WCSecurity
where idfEmployeeID <>''
group by idfEmployeeID 
having COUNT(*)>1