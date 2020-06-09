select * from WCSecuritySetting where idfWCSecurityKey=1
insert into WCSecuritySetting  (idfWCSecuritySettingKey,idfName,idfValue,idfValueText,idfDateCreated,idfDateModified,idfWCSecurityKey)
values (38,'PTITabbedPanel_11000_DtlTabPanel','EXPExpenseSheetHdr','',getdate(),getdate(),1)

delete WCSecuritySetting where idfName='PTITabbedPanel_11000_DtlTabPanel' and idfValue='EXPExpenseSheetHdr'

select max(idfWCSecuritySettingKey) from WCSecuritySetting