select * from WCEmailQueue
select * from WCSecurity


select * from WCSystemSetting WHERE idfSettingID = 'LASTTESUBMITREMINDERSENT'
select * from WCSecuritySetting  WHERE idfName='USERPREF_EmailSendLast'
select idfWCSecuritykey,idfDescription,idfDateModified,idfSecurityID,idfEmail from WCSecurity where idfSecurityID='User2'
select * from WCSecuritySetting D with (NOLOCK) where idfName='USERPREF_EmailSendInterval' and idfWCSecurityKey=3

UPDATE WCSystemSetting SET idfValue = getdate()-1
FROM dbo.WCSystemSetting D WITH (NOLOCK) WHERE idfSettingID = 'LASTTESUBMITREMINDERSENT'
update WCSecuritySetting set idfValue='20180925 10:57:00' WHERE idfName='USERPREF_EmailSendLast'

UPDATE EXPExpenseSheetDtl SET idfDateModified = 'XX' WHERE idfEXPExpenseSheetHdrKey = 18
select idfDateModified,* from EXPExpenseSheetDtl WHERE idfEXPExpenseSheetHdrKey = 18


select * from WCUDFTemplateDtl where idfWCUDFTemplateFieldKey=36

