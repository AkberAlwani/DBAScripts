select * from WPEControl..PTIcurrency where idfCurrencyID='GBP'
select * from WPEControl..PTIcurrency where idfCurrencyID='USD'

select * from WPEControl..PTICurrencyRateHdr where idfPTICurrencyKeyFrom =

(select idfPTICurrencyKey from WPEControl..PTIcurrency where idfCurrencyID='GBP')

SELECT * from WPEControl..PTICurrencyRateDtl  where idfPTICurrencyRateDtlKey=60
where idfPTICurrencyRateHdrKey in (SELECT idfPTICurrencyRateHdrKey from WPEControl..PTICurrencyRateHdr where idfPTICurrencyKeyFrom =
(select idfPTICurrencyKey from WPEControl..PTIcurrency where idfCurrencyID='GBP'))
--select *  from WPEControl..PTICurrencyRateType 
delete WPEControl..PTICurrencyRateType  where idfPTICompanyKey is null
 
 select * from vwFNACurrency 
 select * FROM dbo.WCTEMPPTIConvertCurrencyExt WITH (NOLOCK INDEX=idfRowKey)  
 LEFT OUTER JOIN vwFNACurrency OPER ON OPER.idfPTICurrencyKey = WCTEMPPTIConvertCurrencyExt.idfPTICurrencyKeyFrom  
 LEFT OUTER JOIN vwFNACurrency HOME ON HOME.idfPTICurrencyKey = 97    
 --WHERE idfOwnerSPID = @@SPID AND idfAmountToHome IS NULL  
--OPTION (KEEP PLAN)',N'@xostrTableName VARCHAR(60),@nHomeCurrency INT',@xostrTableName,@nHomeCurrency  

select idfAPVendorKey,idfAddressID ,Count(*)  TotCount
from APAddress
Group by idfAPVendorKey,idfAddressID 
Having Count(*)>1

select * from WPEControl..PTICurrency
update WPEControl..PTICurrency set idfPTICurrencyKey=97 where idfPTICurrencyKey=9



SELECT * from APAddress where idfEAICLink =''
select * from APVendor
UPDATE APVendor  set idfFlagActive= IIF(Blocked=0,0,1)
FROM [NAVDB].[dbo].[NAVCompany$Vendor]
INNER JOIN ON idfVendorID=No_
