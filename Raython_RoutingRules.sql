select * from WCRRGroupLineUp_1
select * from WCRRGroupLineUp
update WCListDtl_1 set idfCodeKey=null where idfCodeKey='NULL'
update WCListDtl_1 set idfCodeIDExclude=null where idfCodeIDExclude='NULL'
update WCListDtl_1 set idfCodeID=null where idfCodeID='NULL'
UPdate WCRRGroupLineUp_1 set idfWCRRSecurityKey=null where idfWCRRSecurityKey='NULL'
UPdate WCRRGroupLineUp_1 set idfTypeLinkKey=null where idfTypeLinkKey='NULL'
Select * from WCListDtl
select * from WCListType a 
inner join WCListType_1  b on a.idfTableName=b.idfTableName and a.idfSelectCaption=b.idfSelectCaption and a.idfWCListTypeKey=b.idfWCListTypeKey
exec spPTIFixPrimaryKey
exec spPTIFixPrimaryKeySequence 1


select * from WCUDFTemplateDtl

select * from WCListHDR_1 where idfDescription='' or idfDescription is null
SELECT * from WCListDtl_1 where idfCodeID='' or idfCodeID is null

INSERT INTO [dbo].[WCListHdr]
           ([idfWCListHdrKey],[idfListID],[idfDescription],[idfFlagInternal],[idfDateCreated],[idfDateModified],[idfPTICompanyKey],[idfWCListTypeKey])
SELECT      [idfWCListHdrKey],[idfListID],ISNULl([idfDescription],''),[idfFlagInternal],[idfDateCreated],[idfDateModified],[idfPTICompanyKey],[idfWCListTypeKey]
from WCListHDR_1

USE [TWO]
GO

INSERT INTO [dbo].[WCListDtl]
           ([idfWCListDtlKey],[idfCodeID],[idfCodeIDExclude],[idfDateCreated],[idfDateModified],[idfCodeKey],[idfWCListHdrKey])
SELECT [idfWCListDtlKey],ISNULl([idfCodeID],''),[idfCodeIDExclude],[idfDateCreated],[idfDateModified],[idfCodeKey],[idfWCListHdrKey]
from WCListDtl_1

USE [TWO]
GO

INSERT INTO [dbo].[WCRRGroup]
           ([idfWCRRGroupKey],[idfDescription],[idfFlagInternal],[idfDateCreated],[idfDateModified],[idfPTICompanyKey])
select [idfWCRRGroupKey],[idfDescription],[idfFlagInternal],[idfDateCreated],[idfDateModified],[idfPTICompanyKey]
from WRRGroup_1


USE [TWO]
GO

INSERT INTO [dbo].[WCLineUp]
           ([idfWCLineUpKey],[idfDescription],[idfFlagInternal],[idfFlagParallelApr],[idfLineUpID],[idfMaxSequence],[idfMinAprRequired],[idfDateCreated],[idfDateModified],[idfPTICompanyKey])
SELECT [idfWCLineUpKey],[idfDescription],[idfFlagInternal],[idfFlagParallelApr],[idfLineUpID],[idfMaxSequence],[idfMinAprRequired],[idfDateCreated],[idfDateModified],[idfPTICompanyKey]
from WCLineUp_1
		   

		   USE [TWO]
GO

INSERT INTO [dbo].[WCRRGroupLineUp]
           ([idfWCRRGroupLineUpKey],[idfAPVRuleSQL],[idfAPVRuleStoredProc],[idfESRuleSQL],[idfESRuleStoredProc],[idfFieldCount],[idfFlagAprViewAllReadOnly],[idfFlagAPV],[idfFlagES],[idfFlagPAPRJ],[idfFlagPO]
           ,[idfFlagRCV],[idfFlagRQ],[idfFlagTS],[idfPAPRJRuleSQL],[idfPAPRJRuleStoredProc],[idfPORuleSQL],[idfPORuleStoredProc],[idfPrecedence],[idfRCVRuleSQL],[idfRCVRuleStoredProc],[idfRQRuleSQL],[idfRQRuleStoredProc]
           ,[idfTSRuleSQL],[idfTSRuleStoredProc],[idfType],[idfWCRRTemplateSPID],[idfWCRRTemplateSPParams],[idfDateCreated],[idfDateModified],[idfTypeLinkKey],[idfWCLineUpKey],[idfWCRRGroupKey],[idfWCRRSecurityKey])
SELECT [idfWCRRGroupLineUpKey],[idfAPVRuleSQL],isNULL([idfAPVRuleStoredProc],''),[idfESRuleSQL],ISNULL([idfESRuleStoredProc],''),[idfFieldCount],[idfFlagAprViewAllReadOnly],[idfFlagAPV],[idfFlagES],[idfFlagPAPRJ],[idfFlagPO]
           ,[idfFlagRCV],[idfFlagRQ],[idfFlagTS],[idfPAPRJRuleSQL],ISNULL([idfPAPRJRuleStoredProc],''),[idfPORuleSQL],ISNULL([idfPORuleStoredProc],''),[idfPrecedence],[idfRCVRuleSQL],ISNULL([idfRCVRuleStoredProc],''),[idfRQRuleSQL],ISNULL([idfRQRuleStoredProc],'')
           ,[idfTSRuleSQL],ISNULL([idfTSRuleStoredProc],''),[idfType],[idfWCRRTemplateSPID],[idfWCRRTemplateSPParams],[idfDateCreated],[idfDateModified],[idfTypeLinkKey],[idfWCLineUpKey],[idfWCRRGroupKey],[idfWCRRSecurityKey]
FROM WCRRGroupLineUp_1		        


