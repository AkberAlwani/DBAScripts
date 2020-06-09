--Case 192215
select idfRQTypeKey,* from RQHeader where idfRQHeaderKey=52879

select idfRCVDetailKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,* 
from RQDetail WITH (NOLOCK) where idfRQHeaderKey=52879

select idfWCTaxKey,* 
from RQDetailTax t WITH (NOLOCK) 
inner join RQDetail d WITH (NOLOCK) on t.idfRQDetailKey=d.idfRQDetailKey
where idfRQHeaderKey=52879

--select * from WCTax with (NOLOCK) where idfWCTaxKey in (2,144)
--select idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,* from RQHeader where idfRQHeaderKey=52879

select idfRCTNumber,idfWCTaxScheduleHdrKey, * from RCVHeaderhist where idfRCVHeaderHistKey=60739
select idfRCVHeaderHistKey,* 
from RCVDetailHist WITH (NOLOCK) where idfRCVDetailHistKey in (select idfRCVDetailKey from RQDetail where idfRQHeaderKey=52879)
select t.* 
from RCVDetailTAxHist t WITH (NOLOCK) 
inner join RCVDetailHist d WITH (NOLOCK)  on t.idfRCVDetailHistKey=d.idfRCVDetailHistKey
where idfRCVHeaderHistKey=60739

select * from RCVDetailDistributionHist
--UPDATE RCVDetailTaxHist set idfAmountTax=123.25,idfAmountTaxable=1232.50,idfAmountTaxableHome=1232.50,idfAmountTaxHome=123.25,idfGLAccountKey=4039 where idfRCVDetailTaxHistKey=80855 
--UPDATE RQDetailTax set idfAmountTax=123.25,idfAmountTaxable=1250.5,idfAmountTaxableHome=1232.5,idfAmountTaxHome=123.25 WHERE idfRQDetailTaxKey=301491 --1711.57,17115.70
--UPDATE RQDetailTax  set idfWCTaxKey=2
--from RQDetailTax WITH (NOLOCK) where idfRQDetailKey in (select idfRQDetailKey  from RQDetail WITH (NOLOCK) where idfRQHeaderKey=52879)

--UPDATE RCVDetailTAxHist  set idfWCTaxKey=2
--from RCVDetailTAxHist t WITH (NOLOCK) 
--inner join RCVDetailHist d WITH (NOLOCK)  on t.idfRCVDetailHistKey=d.idfRCVDetailHistKey
--where idfRCVHeaderHistKey=60739

select * from APVoucher with (NOLOCK) where idfDocument01='RCT0058438'
select tax.* from APVoucherDtl dtl  with (NOLOCK) 
inner join APVoucherDtlTax tax  with (NOLOCK) on dtl.idfAPVoucherDtlKey=tax.idfAPVoucherDtlKey
inner join APVoucher hdr  with (NOLOCK) on hdr.idfAPVoucherKey=dtl.idfAPVoucherKey
where hdr.idfDocument01='RCT0058438'

--update APVoucherDtlTax  set idfWCTaxKey=2
--from APVoucherDtl dtl  with (NOLOCK) 
--inner join APVoucherDtlTax tax  with (NOLOCK) on dtl.idfAPVoucherDtlKey=tax.idfAPVoucherDtlKey
--inner join APVoucher hdr  with (NOLOCK) on hdr.idfAPVoucherKey=dtl.idfAPVoucherKey
--where hdr.idfDocument01='RCT0058438'

UPDATE APVoucherDtlTax set  idfAmountTax=123.25,idfAmountTaxable=1232.50,idfAmountTaxableHome=1232.50,idfAmountTaxHome=123.25,idfGLAccountKey=4039 where idfAPVoucherDtlTaxKey=80729  --1711.57000	17115.70000	17115.70000	1711.57000,80509
SELECT D.*,idfGLID
             FROM dbo.APVoucherDtlDistribution D WITH (NOLOCK) 
				INNER JOIN dbo.APVoucherDtl  dtl WITH (NOLOCK) ON D.idfAPVoucherDtlKey = dtl.idfAPVoucherDtlKey
				INNER JOIN dbo.GLAccount	   A WITH (NOLOCK) ON D.idfGLAccountKey	   = A.idfGLAccountKey
			 WHERE dtl.idfAPVoucherKey = 51344
--select * from GLAccount where idfGLAccountKey in (84304,4039,84615,--80509)

SELECT D.*
             FROM dbo.RCVDetailDistributionHist D WITH (NOLOCK) 
				INNER JOIN dbo.RCVDetailHist dtl WITH (NOLOCK) ON D.idfRCVDetailHistKey= dtl.idfRCVDetailHistKey
				--INNER JOIN dbo.GLAccount	   A WITH (NOLOCK) ON D.idfGLAccountKey	   = A.idfGLAccountKey
			 WHERE dtl.idfRCVHeaderHistKey = 60739

UPdate APVoucherDtlDistribution set idfAmtExtended=1232.5,idfAmtExtendedHome=1232.5 where idfAPVoucherDtlDistributionKey=112919 ---355.82000	-355.82000
UPdate APVoucherDtlDistribution set idfAmtExtended=123.25,idfAmtExtendedHome=123.25,idfGLAccountKey=4039 where idfAPVoucherDtlDistributionKey=112921  --1711.57000	1711.57000,80509
UPDATE RCVDetailDistributionHist set idfAmtExtended=1232.50,idfAmtExtendedHome=1232.5  where idfRCVDetailDistributionHistKey=67678 ---355.82000	-355.82000




select * FROM YMCA..pm10500 WITH (nolocK) WHERE VCHRNMBR='V0144945'

--select * into WCEAICQueue_bak from WCEAICQueue 
delete from WCEAICQueue where idfParam02='RCT0058438'
select * from WCEAICQueue with (NOLOCK) 
select * from WCEAICQueue_bak with (NOLOCK) 
 
 INSERT INTO [dbo].[WCEAICQueue]
           (
		    [idfBatchStart] ,[idfDescription],[idfLinkTableName],[idfParam01]
           ,[idfParam02],[idfParam03],[idfParamText01],[idfPriority],[idfProcessAttempts]
           ,[idfProcessedLast],[idfProcessErrorLast],[idfType]
           ,[idfDateCreated],[idfDateModified],[idfBatchKey],[idfLinkTableKey])

SELECT   [idfBatchStart],[idfDescription],[idfLinkTableName],[idfParam01],[idfParam02]
           ,[idfParam03],[idfParamText01],[idfPriority],[idfProcessAttempts],[idfProcessedLast],[idfProcessErrorLast]
           ,[idfType],[idfDateCreated],[idfDateModified],[idfBatchKey],[idfLinkTableKey]
FROM WCEAICQueue_bak where idfParam02='RCT0058438'


