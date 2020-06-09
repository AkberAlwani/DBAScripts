select * from TWO..WCSystemSEtting where WCSystemSetting.idfSettingID like '%MAP%'

update WCSystemSEtting  set idfValue=1 where WCSystemSetting.idfSettingID='EXPENABLEADVTAX'
update WCSystemSEtting  set idfValue='AlyzaSyBYDNcMhz3wneNid' where WCSystemSetting.idfSettingID='GOOGLEMAPKEY'

select * from dbo.WCSystemSetting  
Where  idfSEttingID like '%DEP%'
order by idfDateModified
select * from TWO..WCSystemSetting order by idfDateModified

update WCSystemSetting set idfValue=0 where WCSystemSetting.idfSettingID='RQAUTOPROCESS'
update WCSystemSetting set idfValue=0 where WCSystemSetting.idfSettingID='RQCHKREQDFLTDOCDATE'
update WCSystemSetting set idfValue=0 where WCSystemSetting.idfSettingID='RQCONTROLTOTAL'
update WCSystemSetting set idfValue=0 where WCSystemSetting.idfSettingID='idfFlagDeptHdr'
update WCSystemSetting set idfValue=0 where WCSystemSetting.idfSettingID='EXPOVRPRICEWITHRCT'
select * from RQDetail where edfItem='401'

select * from WCSystemSEtting where idfSettingID like 'EXP%' order by WCSystemSetting.idfDateModified desc