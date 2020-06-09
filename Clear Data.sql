/* The sp is spPTIPurgeTableData and it takes the following optional parameters.  If you run with no parameters on the company db it will truncate all the transaction tables only (basically what you have been doing).
*/
Declare 
@xDatabase  VARCHAR(60)  = null  -- CONTROL, COMPANY, PTIMaster  
,@xPurgeSetup INT    = 0  -- If set to 1 then the setup tables will be cleared as well.  
,@xOutputOnly INT    = 0  -- If set to 1 then the truncate statements will be returned only.  
,@xModule  VARCHAR(255) = null -- AP,AR,BUD,CAT,EXP,GL,IFC,IV,PA,PM,PO,PTI,RCV,RFQ,RQ,TE,VC,WC /*


exec spPTIPurgeTableData   

exec spPTIFixPrimaryKey

truncate table WPEControl..PTICurrency
truncate table  WCAddress
truncate table  WCPaymentTerm
truncate table WCEFT
truncate table APVendor

 SET FMTONLY OFF; SET NO_BROWSETABLE ON;use PTIMaster
SELECT CM.*,idfAddressID as vdfAddressID,C.idfCurrencyID AS vdfCurrencyID,CM.edfCompanyCode AS vdfCompanyCode
                ,R.idfRateTypeID    AS vdfRateTypeID
                ,RAR.idfRateTypeID  AS vdfRateTypeIDAR
                ,RAP.idfRateTypeID  AS vdfRateTypeIDAP
                FROM PTIMaster.dbo.PTICompany CM (NOLOCK)
                    INNER JOIN WPEControl.dbo.WCCompany WCCompany WITH (NOLOCK)            ON CM.idfPTICompanyKey = WCCompany.idfPTICompanyKey
                    LEFT OUTER JOIN WPEControl.dbo.PTICurrencyRateType R WITH (NOLOCK)     ON CM.idfPTICurrencyRateTypeKey = R.idfPTICurrencyRateTypeKey
                    LEFT OUTER JOIN WPEControl.dbo.PTICurrencyRateType RAP WITH (NOLOCK)   ON CM.idfPTICurrencyRateTypeKeyAP = RAP.idfPTICurrencyRateTypeKey
                    LEFT OUTER JOIN WPEControl.dbo.PTICurrencyRateType RAR WITH (NOLOCK)   ON CM.idfPTICurrencyRateTypeKeyAR = RAR.idfPTICurrencyRateTypeKey
                    LEFT OUTER JOIN WPECompany.dbo.WCAddress WCA WITH (NOLOCK)             ON WCA.idfWCAddressKey = CM.idfWCAddressKey 
                    LEFT OUTER JOIN WPEControl.dbo.PTICurrencyAccess CA WITH (NOLOCK)      ON WCCompany.idfPTICompanyKey = CA.idfPTICompanyKey AND idfFlagFunctional = 1
                    LEFT OUTER JOIN WPEControl.dbo.PTICurrency C WITH (NOLOCK)             ON CA.idfPTICurrencyKey = C.idfPTICurrencyKey
                 SET NO_BROWSETABLE OFF;

select * from PTIMaster.dbo.PTICompany 
select * from WPECompany.dbo.WCAddress 
delete from WPEControl.dbo.PTICurrencyAccess where idfPTICurrencyKey not in (select idfPTICurrencyKey from WPEControl..PTICurrency)
