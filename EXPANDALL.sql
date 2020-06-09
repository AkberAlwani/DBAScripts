

------------Enable Expand All view in Approval and Review--------------

--1. Run the following statement on the SQL Server against the company database


DELETE WCSystemSetting WHERE idfSettingID IN ('RQEXPANDALLAPR','RQEXPANDALLREV')
INSERT INTO [dbo].[WCSystemSetting]([idfWCSystemSettingKey],[idfLicenseAttribute],[idfSettingID],[idfShowAtSection],[idfShowAtTab],[idfSortOrder],[idfValue],[idfWCFormDtlKey])
VALUES (0,'','RQEXPANDALLAPR','','Requisition','4200','1',1002170)
INSERT INTO [dbo].[WCSystemSetting]([idfWCSystemSettingKey],[idfLicenseAttribute],[idfSettingID],[idfShowAtSection],[idfShowAtTab],[idfSortOrder],[idfValue],[idfWCFormDtlKey])
VALUES (0,'','RQEXPANDALLREV','','Requisition','4300','1',1002171)

--2. On the WorkPlace web server reset iis to reload setting cache.

--TO TURN OFF
--Run the following statement on the SQL Server against the company database

--Update WCSystemSetting set idfValue =0 where idfSettingID in('RQEXPANDALLAPR','RQEXPANDALLREV')

--On the WorkPlace web server reset iis to reload setting cache.