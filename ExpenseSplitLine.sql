SELECT * FROM WCSystemSetting WHERE idfSettingId LIKE '%EXP%' AND idfSEttingID LIKE '%TAX%'
SELECT * FROM WCFormDtl WHERE idfWCFormDtlKey=1003098

DECLARE @ID INT
SELECT @ID=MAX(idfWCSystemSettingKey) FROM WCSystemSetting 
INSERT INTO WCSystemSetting (idfWCSystemSettingKey,idfLicenseAttribute,idfSettingID,idfShowAtSection,idfShowAtTab,idfSortOrder,idfvalue,idfValueText,idfWCFormtDtlKey)
VALUES 
(@Id,'','EXPENABLEADVTAX',11470,'EXP',340,0,'',1003098)
