SELECT * 
FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey
	INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey = WCRRGroupSec.idfWCRRGroupKey

EXEC spWCRPTRoutingRuleGroup '', 1, @xnidfData=1


select * from WCRRGroupSec
select * from WCSecRole

--select * from WCRRGroupLineUp_1
--select * from WCLineUP_1
--select * from WCRRTemplateDtl
--select * from WCRRTemplate

EXEC spWCRPTRoutingRuleGroup '', 1, @xnidfData=1

SELECT * 
FROM dbo.WCRRGroupLineUp WITH (NOLOCK)
	INNER JOIN dbo.WCRRGroupSec WITH (NOLOCK) ON WCRRGroupSec.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey
	INNER JOIN dbo.WCRRGroup	WITH (NOLOCK) ON WCRRGroup.idfWCRRGroupKey = WCRRGroupSec.idfWCRRGroupKey

select * from WCRRGroupSec
select top 2 * from WCRRGroup
Declare @nNextKey INT, @nCount INT
EXEC spWCGetNextPK 'WCRRGroupSec',@nNextKey OUTPUT, @nCount

insert into WCRRGroupSec (idfWCRRGroupSecKey,idfWCRoleKey,idfWCRRGroupKey)
select @nNextKey+ ROW_NUMBER() OVER(Partition By idfPTICompanyKey ORDER BY idfWCRRGroupKey) ,7,idfWCRRGroupKey from WCRRGroup

select ROW_NUMBER() OVER (Partition By idfPTICompanyKey Order by idfWCRRGroupKey) ID ,idfWCRRGroupKey from WCRRGroup