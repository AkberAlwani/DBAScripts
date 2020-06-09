--delete from WCLanguageResource where idfResourceID in ('11351','RCVNAME','RQNAME') and idfWCLanguageKey=1
--delete from WCLanguageResourceD where idfResourceID in ('11351','RCVNAME','RQNAME') and idfWCLanguageKey=1
select * from WCLanguageResourceD where idfResourceID in ('11351','RCVNAME','RQNAME') and idfWCLanguageKey=1
select count(*) from ZTEST..WCLanguageResourceD
select count(*) from TWO..WCLanguageResourceD

select * from WCLanguageSQL where idfResourceID in ('11351','RCVNAME','RQNAME') 
select * from WCLanguage
select * from WCMenu where idfCaption in ('11351','RCVNAME','RQNAME') 
select * from WCMimeType

select * from WCRole
select * from WCLanguageResourceD where idfDescription like 'PO Number is not valid for selected pay%'

select * from WCUDFListDtl
select * from WCUDFTemplateDtl
select * from WCUDFListHdr

delete from test_exchange
select * from test_exchange

select * from WCEmailQueue

Select idfVersion,idfDateCreated from WCInstall order by idfDateCreated desc
Select * from WCInstall order by idfDateCreated desc

select idfDateModified from WCSecurity where idfSecurityID='ali'
select * from PTIMaster..PTINETSessionDtl  where idfPTINetSessionHdrKey in ( select idfPTINetSessionHdrKey from PTIMaster..PTINETSessionHdr where idfUserName='ali')
select idfLastAccess,idfDateCreated,idfDateModified from PTIMaster..PTINETSessionHdr where idfUserName='ali'

select idfRCVHeaderKey,idfRCVSessionKey,* from RCVDetail
select idfRCVHeaderKey,* from RCVHeader

select * from RQAprDtl

select RQDetail.idfRQSessionKey,* from RQDetail
WHERE RQDetail.idfRQHeaderKey = 55

select * from EXPMobileExpense

select * from WCEAICQueueWC

select * from RQHeader 
update RQDetail set idfRQSessionKey=145 where idfRQHeaderKey=6497

SELECT idfValue FROM WCSecuritySetting WITH (NOLOCK) WHERE idfName='ZOOM_LOCKINFO_LOCK_1002393' AND idfWCSecurityKey = fnWCSecurity('KEY')