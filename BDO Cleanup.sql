SELECT        WCListHdr.idfDescription, WCListDtl.idfWCListDtlKey, WCListDtl.idfTimestamp, WCListDtl.idfCodeID, WCListDtl.idfCodeIDExclude, WCListDtl.idfDateCreated, WCListDtl.idfDateModified, WCListDtl.idfCodeKey, 
                         WCListDtl.idfWCListHdrKey
FROM            WCListDtl INNER JOIN
                         WCListHdr ON WCListDtl.idfWCListHdrKey = WCListHdr.idfWCListHdrKey
WHERE        (WCListDtl.idfWCListHdrKey = 6)

select * from DYNAMICS..SY01500

select * from GLJournalHdr order by 1 desc
select * from GLJournalDtl order by 1 desc 


delete from PODetailHist where idfRQDetailKey in (
select idfRQDetailKey from RQDetail where idfAPVendorKey in (select idfAPVendorKey from APVendor where idfEAICLink like '%BDOAU%'))
delete from RQDetail where idfAPVendorKey in (select idfAPVendorKey from APVendor where idfEAICLink like '%BDOAU%')
delete from RQRevDtl where idfAPVendorKey in (select idfAPVendorKey from APVendor where idfEAICLink like '%BDOAU%')
select idfSecurityID,* from WCSecurity where idfAPVendorKey in (select idfAPVendorKey from APVendor where idfEAICLink like '%BDOAU%') --BDOAU\Steve.Rodionoff Venbdor ABCO1 BDOAU
delete from APVendor where idfEAICLink like '%BDOAU%'
delete from APVendorClass where idfEAICLink like '%BDOAU%'
delete from EXPExpenseSheetDtlTaxHist where idfGLAccountKey in ( select idfGLAccountKey from GLAccount where idfEAICLink like '%BDOAU%')
delete from GLJournalDtl where idfGLAccountKey in ( select idfGLAccountKey from GLAccount where idfEAICLink like '%BDOAU%')
delete from PODetailDistributionHist where idfGLAccountKey in ( select idfGLAccountKey from GLAccount where idfEAICLink like '%BDOAU%')
delete from RCVAutoRcvDtlDistributionHist where idfGLAccountKey in ( select idfGLAccountKey from GLAccount where idfEAICLink like '%BDOAU%')
delete from RCVAutoRcvDtlHist where idfGLAccountKeyPurch in ( select idfGLAccountKey from GLAccount where idfEAICLink like '%BDOAU%')
delete from RCVDetailDistributionHist where idfGLAccountKey in ( select idfGLAccountKey from GLAccount where idfEAICLink like '%BDOAU%')
delete from RCVDetailHist where idfGLAccountKeyPurch in ( select idfGLAccountKey from GLAccount where idfEAICLink like '%BDOAU%')
delete from GLAccount where idfEAICLink like '%BDOAU%'
delete from GLBudgetHdr where idfEAICLink like '%BDOAU%'
delete from GLJournalHdr where idfWCICCompanyKey =1
delete from GLPeriod where idfWCICCompanyKey =1
delete from GLPostCodeDtl where idfWCICCompanyKey =1
delete  from PAPhaseActivity where idfPAActivityKey in (select idfPAActivityKey from PAActivity where  idfWCICCompanyKey =1)
delete from PAActivity where  idfWCICCompanyKey =1
delete PAProjectPhase where idfPAProjectKey in (select idfPAProjectKey from PAProject where idfWCICCompanyKey =1)
delete from PAProject where idfWCICCompanyKey =1
delete from RQAprDtlRQHeader where idfWCICCompanyKeySource =1 and idfWCICCompanyKeyTarget=1
delete from RQHeader where idfWCICCompanyKeySource =1 and idfWCICCompanyKeyTarget=1
delete from RQRevDtlRQHeader where idfWCICCompanyKeySource =1 and idfWCICCompanyKeyTarget=1
delete from RCVHeader where idfWCPaymentTermKey in (select idfWCPaymentTermKey from WCPaymentTerm where idfEAICLink like '%BDOAU%')
delete from RCVHeaderHist where idfWCPaymentTermKey in (select idfWCPaymentTermKey from WCPaymentTerm where idfEAICLink like '%BDOAU%')
delete from WCPaymentTerm where idfEAICLink like '%BDOAU%'
delete from WCShippingMethod where idfEAICLink like '%BDOAU%'
delete from EXPType  where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr where idfEAICLink like '%BDOAU%')
delete from WCTaxScheduleHdr where idfEAICLink like '%BDOAU%'
delete EXPAprDtlHist where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))
delete EXPAprDtl where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))
delete EXPAprDtlSplitHist where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))
delete EXPExpenseSheetDtlHist where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))
delete EXPExpenseSheetDtl where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))
delete EXPExpenseSheetDtlSplitHist where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))
delete EXPExpenseSheetDtlSplit where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))
delete from EXPExpenseSheetDtl where idfPAPhaseActivityKey in
(select idfPAPhaseActivityKey  from PAPhaseActivity where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' )))

delete from PAPhaseActivity where idfEXPTypeKey in
(select idfEXPTypeKey from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' ))


delete from EXPType where idfWCTaxScheduleHdrKey in (select idfWCTaxScheduleHdrKey from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' )
delete from WCTaxScheduleHdr  where idfEAICLink like '%BDOAU%' 

delete from WCICCompany where idfCompanyCode='BDOAU'
select * from WCICCompany where idfCompanyCode='BDOAU'
