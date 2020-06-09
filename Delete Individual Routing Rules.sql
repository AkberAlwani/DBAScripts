truncate table WCRRGroupSec  
truncate table WCRRGroupLineUp  
delete from  WCRRGroupSec  where not exists 
(select WCRRGroup.idfWCRRGroupKey from WCRRGroup
where  WCRRGroup.idfWCRRGroupKey = WCRRGroupSec.idfWCRRGroupKey)
delete from   WCRRGroupLineUp  where not exists 
(select WCRRGroup.idfWCRRGroupKey from WCRRGroup
where  WCRRGroup.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey)


Select *  from  WCRRGroupSec  where not exists 
(select WCRRGroup.idfWCRRGroupKey from WCRRGroup
where  WCRRGroup.idfWCRRGroupKey = WCRRGroupSec.idfWCRRGroupKey)

Select * from   WCRRGroupLineUp  where not exists 
(select WCRRGroup.idfWCRRGroupKey from WCRRGroup
where  WCRRGroup.idfWCRRGroupKey = WCRRGroupLineUp.idfWCRRGroupKey)

truncate table WCRRGroupSec  
truncate table WCRRGroupLineUp  