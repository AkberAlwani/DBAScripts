--update WCAppConnectorSetting set udfUserDefField2='SANDMAN135'
truncate table WCTaxScheduleHdr
truncate table WCTaxScheduleDtl
truncate table WCTax
truncate table WCTaxClass
truncate table WCTaxClassRate
truncate table GLAccount
truncate table APVendorClass
truncate table APVendorClassTaxClass
truncate table APVendor
truncate table APAddress
truncate table APVendorTaxClass
truncate table APVendorClass
truncate table APVendorSiteAccount
truncate table GLBudgetDtl
truncate table GLBudgetHdr
truncate table GLAccountGroup
truncate table GLPeriod
truncate table WCAddress
truncate table WCPaymentTerm
truncate table WCShippingMethod
truncate table WCICCompany
truncate table GLSegmentIC 
truncate table GLSegmentHdr
truncate table GLSegmentDtl
truncate table GLSegmentHdrCombination
DBCC CHECKIDENT ('GLSegmentHdr', RESEED, 0)
TRUNCATE table IVItem
truncate table IVSite
truncate table IVItemSite
truncate table PAProject
truncate table PAProjectPhase
truncate table PAPhaseActivity
exec spPTIFixDB
exec spPTIFixPrimaryKey
exec spPTIFixPrimaryKeySequence 1


truncate table WPEControl..PTICurrencyRateType
truncate table WPEControl..PTICurrencyRateHdr
truncate table WPEControl..PTICurrencyRateDtl
truncate table WPEControl..PTICurrencyAccess
truncate table WPEControl..PTICurrency

--EXEC dbo.spPTIPurgeTableData
select idfWCTaxScheduleHdrKey,* from APVendor_1
where idfWCTaxScheduleHdrKey not in (select idfWCTaxScheduleHdrKey  from WCTaxScheduleHdr)

exec spPTIFixdb
exec spPTIFixPrimaryKey
update GLAccount set idfEAICLink= REPLACE ( idfEAICLink, 'UATDAT', 'CNORTH')
update WCTaxScheduleHdr set idfEAICLink= REPLACE ( idfEAICLink, 'UATDAT', 'CNORTH')
update APVendorClass set idfEAICLink= REPLACE ( idfEAICLink, 'UATDAT', 'CNORTH')
update APVendor set idfEAICLink= REPLACE ( idfEAICLink, 'UATDAT', 'CNORTH')
update APAddress set idfEAICLink= REPLACE ( idfEAICLink, 'UATDAT', 'CNORTH')
update APVendorTaxClass set idfEAICLink= REPLACE ( idfEAICLink, 'UATDAT', 'CNORTH')
exec spPTIFixPrimaryKey
exec spPTIFixPrimaryKeySequence 1