----Run against WPECSF to set starting numbers for requisitions & expense reports

----REQUISITION
IF EXISTS (SELECT TOP 1 1 FROM sys.sequences WHERE name = 'RQHeaderPK')
ALTER SEQUENCE RQHeaderPK RESTART WITH 100000 
ELSE
UPDATE WCPrimaryKey SET idfNextKey = 100000 WHERE idfTableName = 'RQHeader'
GO
IF EXISTS (SELECT TOP 1 1 FROM sys.sequences WHERE name = 'RQAprHdrPK')
ALTER SEQUENCE RQAprHdrPK RESTART WITH 700000 
ELSE
UPDATE WCPrimaryKey SET idfNextKey = 700000 WHERE idfTableName = 'RQAprHdr'
GO
IF EXISTS (SELECT TOP 1 1 FROM sys.sequences WHERE name = 'RQRevHdrPK')
ALTER SEQUENCE RQRevHdrPK RESTART WITH 800000 
ELSE
UPDATE WCPrimaryKey SET idfNextKey = 800000 WHERE idfTableName = 'RQRevHdr'
GO

----EXPENSE
IF EXISTS (SELECT TOP 1 1 FROM sys.sequences WHERE name = 'EXPExpenseSheetHdrPK')
ALTER SEQUENCE EXPExpenseSheetHdrPK RESTART WITH 200000 
ELSE
UPDATE WCPrimaryKey SET idfNextKey = 200000 WHERE idfTableName = 'EXPExpenseSheetHdr'
GO
IF EXISTS (SELECT TOP 1 1 FROM sys.sequences WHERE name = 'EXPAprHdrPK')
ALTER SEQUENCE EXPAprHdrPK RESTART WITH 900000 
ELSE
UPDATE WCPrimaryKey SET idfNextKey = 900000 WHERE idfTableName = 'EXPAprHdr'
GO


