-- INSERT MASTER JOB ID RECORDS
INSERT INTO [dbo].[WMI00100]
	([dJOBID]
	,[dJOBDESCR]
	,[dSYSTEMIDJOB]
	,[dSTARTYEAR]
	,[dLASTYEAR]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,'WorkTech Job 1'
	,1
	,2014
	,2017
	,204
	)
GO
INSERT INTO [dbo].[WMI00100]
	([dJOBID]
	,[dJOBDESCR]
	,[dSYSTEMIDJOB]
	,[dSTARTYEAR]
	,[dLASTYEAR]
	,[ACTINDX])
VALUES
	(
	'JOB02'
	,'WorkTech Job 2'
	,2
	,2014
	,2014
	,224
	)
GO

-- INSERT MASTER ACTIVITY ID RECORDS

INSERT INTO [dbo].[WMI00200]
	([dACTIVITYID]
	,[dACTIVITYDESC]
	,[dSYSTEMIDACT])
VALUES
	(
	'ACT01'
	,'WorkTech Activity One'
	,10
	)
GO

INSERT INTO [dbo].[WMI00200]
	([dACTIVITYID]
	,[dACTIVITYDESC]
	,[dSYSTEMIDACT])
VALUES
	(
	'ACT02'
	,'WorkTech Activity Two'
	,11
	)
GO

INSERT INTO [dbo].[WMI00200]
	([dACTIVITYID]
	,[dACTIVITYDESC]
	,[dSYSTEMIDACT])
VALUES
	(
	'ACT03'
	,'WorkTech Activity Three'
	,12
	)
GO

-- INSERT MASTER OBJECT ID RECORDS

INSERT INTO [dbo].[WMI00300]
	([dOBJECTID]
	,[dOBJECTDESCR]
	,[dSYSTEMIDOBJ])
VALUES
	(
	'OBJ01'
	,'WorkTech Object One'
	,30
	)
GO

INSERT INTO [dbo].[WMI00300]
	([dOBJECTID]
	,[dOBJECTDESCR]
	,[dSYSTEMIDOBJ])
VALUES
	(
	'OBJ02'
	,'WorkTech Object Two'
	,31
	)
GO

INSERT INTO [dbo].[WMI00300]
	([dOBJECTID]
	,[dOBJECTDESCR]
	,[dSYSTEMIDOBJ])
VALUES
	(
	'OBJ03'
	,'WorkTech Object Three'
	,32
	)
GO

-- INSERT MASTER WORK ORDER NUMBER RECORDS


INSERT INTO [dbo].[WMI00600]
	([dMETADATAWONO]
	,[SBJT]
	,[Series_WO]
	,[Done]
	,[Closed])
VALUES
	(
	'WO000001'
	,'Work Order One Description'
	,''
	,1
	,0
	)
GO

INSERT INTO [dbo].[WMI00600]
	([dMETADATAWONO]
	,[SBJT]
	,[Series_WO]
	,[Done]
	,[Closed])
VALUES
	(
	'WO000002'
	,'Work Order Two is Closed'
	,''
	,1
	,1
	)
GO

INSERT INTO [dbo].[WMI00600]
	([dMETADATAWONO]
	,[SBJT]
	,[Series_WO]
	,[Done]
	,[Closed])
VALUES
	(
	'WO000003'
	,'Work Order Three cannot be selected'
	,''
	,2
	,1
	)
GO

-- INSERT JOB OBJECT RELATIONSHIP RECORDS

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2014
	,'OBJ01'
	,1
	,30
	,40
	,245
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2014
	,'OBJ02'
	,1
	,31
	,41
	,273
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB02'
	,2014
	,'OBJ02'
	,2
	,31
	,42
	,300
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2015
	,'OBJ01'
	,1
	,30
	,43
	,274
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2015
	,'OBJ02'
	,1
	,31
	,44
	,246
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2016
	,'OBJ01'
	,1
	,30
	,45
	,225
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2016
	,'OBJ02'
	,1
	,31
	,46
	,205
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2017
	,'OBJ01'
	,1
	,30
	,47
	,206
	)
GO

INSERT INTO [dbo].[WMI00400]
	([dJOBID]
	,[dYEAR]
	,[dOBJECTID]
	,[dSYSTEMIDJOB]
	,[dSYSTEMIDOBJ]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2017
	,'OBJ02'
	,1
	,31
	,48
	,226
	)
GO


-- INSERT JOB CATEGORY RELATIONSHIP RECORDS

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2014
	,'ACT01'
	,10
	,1
	,50
	,320
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2014
	,'ACT02'
	,11
	,1
	,51
	,321
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB02'
	,2014
	,'ACT02'
	,11
	,2
	,52
	,301
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2015
	,'ACT01'
	,10
	,1
	,53
	,247
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2015
	,'ACT02'
	,11
	,1
	,54
	,275
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2016
	,'ACT01'
	,10
	,1
	,55
	,302
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2016
	,'ACT02'
	,11
	,1
	,56
	,322
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2017
	,'ACT01'
	,10
	,1
	,57
	,323
	)
GO

INSERT INTO [dbo].[WMI00500]
	([dJOBID]
	,[dYEAR]
	,[dACTIVITYID]
	,[dSYSTEMIDACT]
	,[dSYSTEMIDJOB]
	,[dSYSTEMID]
	,[ACTINDX])
VALUES
	(
	'JOB01'
	,2017
	,'ACT02'
	,11
	,1
	,58
	,303
	)
GO


INSERT INTO [dbo].[WMI50000]
([dYEAR]
,[dJOBID]
,[dACTIVITYID]
,[dOBJECTID]
,[BUDGETAMT]
,[Actual_Amount]
,[PRCHAMNT]
,[dWPREQAMT]
,[ACTIVE])
VALUES
(
2018 --[dYEAR]
,'JOB01' --[dJOBID]
,'ACT02' --[dACTIVITYID]
,'OBJ01' --[dOBJECTID]
,199.99 --[BUDGETAMT]
,150.98 -- [Actual_Amount]
,9.99 -- [PRCHAMNT]
,0 -- [dWPREQAMT]
,0 -- [ACTIVE]
)
GO
