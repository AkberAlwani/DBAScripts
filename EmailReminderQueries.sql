
SELECT * FROM dbo.WCSystemSetting D WITH (NOLOCK) WHERE idfSettingID = 'LASTTESUBMITREMINDERSENT'
SELECT * FROM dbo.WCSystemSetting D WITH (NOLOCK) WHERE idfSettingID = 'LASTWPAGENTSENTTIME'
select idfWCSecurityKey,idfDescription,idfDateModified,idfSecurityID,idfEmail from WCSecurity where idfSecurityID='User2'
select * from WCSecuritySetting D with (NOLOCK) where idfName='USERPREF_EmailSendInterval' and idfWCSecurityKey=3
Select * FROM WCSecuritySetting D WITH (NOLOCK) WHERE idfName='USERPREF_EmailSendLast'  and idfWCSecurityKey=3
select es.*,ed.*
From WCEmailQueueSent es
inner join WCEmailDocDtl ed on es.idfWCEmailDocDtlKey=ed.idfWCEmailDocDtlKey
inner join WCEmailDocHdr eh on ed.idfWCEmailDocHdrKey=ed.idfWCEmailDocHdrKey
where idfSendToKey=3
and eh.idfDescription like '%Disapproved%'
and idfTableLinkKey in (select idfRQDEtailKey from RQDEtail where idfRQHeaderKey=70)
and eh.idfWCEmailDocHdrKey=1

select idfDescription,* from WCSecurity where idfDescription like '%Peter%'
select * from WCLineUpSecAltr where idfWCLineUpSecKey=8
select * from WCLineUpSec where idfWCSecurityKey=13
select idfSecurityID,* from WCSecurity where idfWCSecurityKey=17



select dateadd(day,-2,getdate()),idfDateModified,* from EXPExpenseSheetDtl where idfEXPExpenseSheetHdrKey=67
ALTER TABLE EXPExpenseSheetDtl DISABLE trigger [tuEXPExpenseSheetDtl] 
Update EXPExpenseSheetDtl set idfDateModified=dateadd(day,-1,getdate()) where idfEXPExpenseSheetHdrKey=67
ALTER TABLE EXPExpenseSheetDtl ENABLE trigger [tuEXPExpenseSheetDtl] 

ALTER TABLE RQDetail DISABLE trigger [tuidRQDetail] 
Update RQDetail set idfDateModified=dateadd(day,-1,getdate()) where idfRQSessionKey<>170
ALTER TABLE RQDetail ENABLE trigger [tuidRQDetail]


select e.*,s.idfSecurityID 
from WCEmailQueue e
inner join WCSecurity s on e.idfSendToKey=s.idfWCSecurityKey

UPDATE WCSystemSetting SET idfValue = getdate()-1
--SELECT * FROM dbo.WCSystemSetting D WITH (NOLOCK)
WHERE idfSettingID = 'LASTTESUBMITREMINDERSENT'

UPDATE WCSystemSetting SET idfValue = getdate()-1 
--SELECT *
FROM dbo.WCSystemSetting D WITH (NOLOCK)
WHERE idfSettingID = 'LASTWPAGENTSENTTIME'

Select * FROM WCSecuritySetting 
WHERE idfName='USERPREF_EmailSendLast' 
AND idfWCSecurityKey = 3

Update WCSecuritySetting SET idfValue = '20200501 01:52:46'
WHERE idfName='USERPREF_EmailSendLast' 

select * from WCEmailQueue

