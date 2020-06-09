select * from WCSystemSetting  where idfSettingID like '%Rec%'
select * from WCLanguageResourceD where idfDescription like '%Recall%'
select idfDatabaseName,idfLog,idfLogMessage,idfServerName,idfVersion,idfDateCreated,idfDateModified 
from WCInstall

select idfPTICompanyKey,idfDbName,edfCompanyCode from PTIMaster..PTICompany

SELECT idfWCSecurityKey,idfFlagActive,idfSecurityID ,idfPTICompanyKey 
FROM WCSecurity 
where idfSecurityID='tbristow'

select idfFlagReceive,* from RCVAutoRcvDtl where idfRCVAutoRcvHdrKey = 1
SELECT idfFlagProcessed,* FROM RCVAutoRcvHdr  WHERE idfRCVAutoRcvHdrKey=1
delete RCVAutoRcvDtl where edfPONumber='PO1006'

UPDATE RCVAutoRcvHdr   SET idfFlagProcessed=1  WHERE idfRCVAutoRcvHdrKey=3

select * from RCVDetail
select * from RCVDetailHist

