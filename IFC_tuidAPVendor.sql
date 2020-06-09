-- Paramount Technologies, Inc. $Version: WorkPlace_08.01.00 $  - $Revision: 17 $ $Modtime: 03/02/09 12:00a $  
ALTER TRIGGER IFC_tuidAPVendor ON PM00200 FOR INSERT, UPDATE, DELETE  
AS  
 DECLARE   
    @nCount    INT  
  , @nNextKey    INT  
  , @nidfPTICompanyKey INT  
  , @nTEN99Current  INT  
  , @nTEN99BoxCurrent  INT  
  , @nidfRowKey   INT  
  , @nidfAPTaxTypeKey  INT  
  , @nidfAPTaxTypeDtlKey INT  
  
 SELECT @nidfPTICompanyKey = idfPTICompanyKey FROM DYNAMICS.dbo.vwWCCompany  WHERE idfDBName =DB_NAME()  
   
 SELECT VENDORID,VENDNAME,CURNCYID,VENDSTTS,TEN99TYPE,TEN99BOXNUMBER,TXIDNMBR,TXRGNNUM,WithholdingEntityType,(PPSTAXRT * .01) AS PPSTAXRT  
     ,APVendorClass.idfAPVendorClassKey AS idfAPVendorClassKey  
     ,WCPaymentTerm.idfWCPaymentTermKey AS idfWCPaymentTermKey  
     ,WCShippingMethod.idfWCShippingMethodKey AS idfWCShippingMethodKey  
     ,WCTaxScheduleHdr.idfWCTaxScheduleHdrKey AS idfWCTaxScheduleHdrKey  
     ,idfRowAction = CASE WHEN c.idfVendorID is null THEN 'IN' ELSE 'UP' END  
     ,0 AS idfAppConnCreated,getdate() AS idfAppConnCreatedDate,'' AS idfAppConnError  
 INTO #APVendorWork  
 FROM inserted i  
 LEFT OUTER JOIN dbo.APVendor c WITH (NOLOCK INDEX=PKidfVendorID) ON c.idfVendorID = i.VENDORID   
 LEFT OUTER JOIN dbo.APVendorClass WITH (NOLOCK) ON APVendorClass.idfVendorClassID = i.VNDCLSID  
 LEFT OUTER JOIN dbo.WCPaymentTerm WITH (NOLOCK) ON WCPaymentTerm.idfPaymentTermID = i.PYMTRMID  
 LEFT OUTER JOIN dbo.WCShippingMethod WITH (NOLOCK) ON WCShippingMethod.idfShippingMethodID = i.SHIPMTHD  
 LEFT OUTER JOIN dbo.WCTaxScheduleHdr WITH (NOLOCK) ON WCTaxScheduleHdr.idfTaxScheduleID = i.TAXSCHID  
  AND c.idfPTICompanyKey = @nidfPTICompanyKey  
  
 ALTER TABLE #APVendorWork ADD idfRowKey INT IDENTITY(1,1), idfAPTaxTypeKey INT, idfAPTaxTypeDtlKey INT  
  
 DECLARE curTaxTypeKeys CURSOR FOR  
 SELECT TEN99TYPE,TEN99BOXNUMBER,idfRowKey  
 FROM #APVendorWork  
  
 OPEN curTaxTypeKeys  
  
 FETCH NEXT FROM curTaxTypeKeys INTO @nTEN99Current,@nTEN99BoxCurrent,@nidfRowKey  
 WHILE (@@fetch_status <> -1) BEGIN  
  IF (@@fetch_status <> -2) BEGIN  
   SELECT @nidfAPTaxTypeKey = idfAPTaxTypeKey  
   FROM dbo.APTaxType WITH (NOLOCK)   
   WHERE udfNumericField01 = @nTEN99Current  
  
   SELECT @nidfAPTaxTypeDtlKey = idfAPTaxTypeDtlKey
   FROM dbo.APTaxTypeDtl D WITH (NOLOCK)  
   INNER JOIN dbo.APTaxType H WITH (NOLOCK) ON H.idfAPTaxTypeKey = D.idfAPTaxTypeKey  
   WHERE D.udfNumericField01 = @nTEN99BoxCurrent AND H.udfNumericField01 = @nTEN99Current  

   UPDATE #APVendorWork  
   SET idfAPTaxTypeKey = @nidfAPTaxTypeKey, idfAPTaxTypeDtlKey = @nidfAPTaxTypeDtlKey  
   WHERE idfRowKey = @nidfRowKey  
   
   -- Add : Reset the variable values as what if @nidfAPTaxTypeDtlKey  does not get any value but stil hold previous value

   SELECT @nidfAPTaxTypeKey=0,@nidfAPTaxTypeDtlKey  =0
   
  END  
  FETCH NEXT FROM curTaxTypeKeys INTO @nTEN99Current,@nTEN99BoxCurrent,@nidfRowKey  
 END  
 CLOSE curTaxTypeKeys  
 DEALLOCATE curTaxTypeKeys  
 
 SELECT IDENTITY(int,0,1) idfKey,VENDORID INTO #APVendorKey  
 FROM #APVendorWork WHERE idfRowAction = 'IN'  
 SELECT 1, * from   #APVendorWork   
 SELECT @nCount = COUNT(1) FROM #APVendorKey  
 IF @nCount>0  
 BEGIN  
  EXEC spWCGetNextPK 'APVendor',@nNextKey OUTPUT,@nCount  
    
 END  
  
 UPDATE #APVendorWork SET idfAppConnCreated = 0,idfAppConnCreatedDate = GETDATE()  
 
 INSERT INTO dbo.APVendor  
 (  
       idfAPVendorKey   
  , idfComment  
  , idfDatePromisedOffset                        
  , idfEAICLink  
  , idfFlagActive              
  , idfName    
  , idfRank   
  , idfFlagWithholding               
  , idfVendorID     
  , idfWithholdingRate                      
  , idfAPAddressKey             
  , idfAPAddressKeyRemitTo     
  , idfAPVendorClassKey    
  , idfAPVendorSessionKey       
  , idfPTICompanyKey            
  , idfWCFOBKey                 
  , idfWCPaymentTermKey         
  , idfWCShippingMethodKey       
  , idfPTICurrencyKey     
  , idfAPAddressKeyPurch  
  , idfWCAddressKeyBranch  
  , idfWCSecurityKey  
  , idfWCTaxScheduleHdrKey  
  , idfAPTaxTypeDtlKey  
  , idfAPTaxTypeKey     
  , idfFlagMinOrderAmtNotExceed  
  , idfMinOrdAmt  
  , idfFlagAutoCreatePO  
  , idfAppConnCreated  
  , idfAppConnCreatedDate  
  , idfAppConnError  
  , idfAmountBalance    , idfGLSegmentID01  
  , idfGLSegmentID02  
  , idfGLSegmentID03  
  , idfGLSegmentID04  
  , idfGLSegmentID05  
  , idfGLSegmentID06  
  , idfGLSegmentID07  
  , idfGLSegmentID08  
  , idfGLSegmentID09  
  , idfGLSegmentID10  
  , idfGLSegmentID11  
  , idfGLSegmentID12  
  , idfGLSegmentID13  
  , idfGLSegmentID14  
  , idfGLSegmentID15  
  , idfTaxID  
  , idfTaxReg  
 )  
 SELECT  
    idfKey + @nNextKey  --idfAPVendorKey   
  , ' '      --idfComment  
  , 0       --idfDatePromisedOffset      
  , ''      --idfEAICLink  
  , CASE WHEN c.VENDSTTS IN (1,3) THEN 1 ELSE 0 END  --idfFlagActive              
  , VENDNAME     --idfName  
  , 0       --idfRank   
  , WithholdingEntityType  --idfFlagWithholding               
  , c.VENDORID    --idfVendorID            
  , c.PPSTAXRT    --idfWithholdingRate                                    
  , 0       --idfAPAddressKey             
  , 0       --idfAPAddressKeyRemitTo   
  , idfAPVendorClassKey  --idfAPVendorClassKey     
  , 140      --idfAPVendorSessionKey      
  , P.idfPTICompanyKey  --idfPTICompanyKey            
  , 0       --idfWCFOBKey                 
  , idfWCPaymentTermKey  --idfWCPaymentTermKey         
  , idfWCShippingMethodKey --idfWCShippingMethodKey   
  , ISNULL(CUR.idfPTICurrencyKey,vwCUR.idfPTICurrencyKey)  --idfPTICurrencyKey     
  , 0       --idfAPAddressKeyPurch  
  , 0       --idfWCAddressKeyBranch  
  , 0       --idfWCSecurityKey  
  , idfWCTaxScheduleHdrKey --idfWCTaxScheduleHdrKey  
  , c.idfAPTaxTypeDtlKey  --idfAPTaxTypeDtlKey  
  , c.idfAPTaxTypeKey   --idfAPTaxTypeKey   
  , 0 --idfFlagMinOrderAmtNotExceed  
  , 0 --idfMinOrdAmt  
  , 0 --idfFlagAutoCreatePO  
  , c.idfAppConnCreated  
  , c.idfAppConnCreatedDate  
  , c.idfAppConnError  
  , 0 --idfAmountBalance  
  , '' --idfGLSegmentID01  
  , '' --idfGLSegmentID02  
  , '' --idfGLSegmentID03  
  , '' --idfGLSegmentID04  
  , '' --idfGLSegmentID05  
  , '' --idfGLSegmentID06  
  , '' --idfGLSegmentID07  
  , '' --idfGLSegmentID08  
  , '' --idfGLSegmentID09  
  , '' --idfGLSegmentID10  
  , '' --idfGLSegmentID11  
  , '' --idfGLSegmentID12  
  , '' --idfGLSegmentID13  
  , '' --idfGLSegmentID14  
  , '' --idfGLSegmentID15  
  , ISNULL(c.TXIDNMBR,'')  
  , ISNULL(c.TXRGNNUM,'')  
 FROM #APVendorWork c  
 INNER JOIN #APVendorKey k ON k.VENDORID = c.VENDORID  
 LEFT OUTER JOIN DYNAMICS.dbo.vwPTICurrency CUR WITH (NOLOCK) ON CUR.idfCurrencyID = c.CURNCYID  
 LEFT OUTER JOIN dbo.vwFNACurrency vwCUR ON vwCUR.edfFunctional=1  
 INNER JOIN DYNAMICS.dbo.vwWCCompany P ON P.idfDBName = db_name()  
 WHERE idfRowAction = 'IN'  
 ORDER BY c.VENDORID  
  
 UPDATE dbo.APVendor  
 SET       idfFlagActive    = CASE WHEN t.VENDSTTS IN (1,3) THEN 1 ELSE 0 END    --  VENDSTTS Vendor status 1) Active 3) Temporary     
   , idfName      = VENDNAME  
   , idfDateModified   = getdate()    
   , idfPTICurrencyKey   = ISNULL(CUR.idfPTICurrencyKey,vwCUR.idfPTICurrencyKey)     
   , idfFlagWithholding  = t.WithholdingEntityType          
   , idfWithholdingRate  = t.PPSTAXRT     
   , idfAPVendorClassKey     = t.idfAPVendorClassKey        
   , idfWCPaymentTermKey  = t.idfWCPaymentTermKey     
   , idfWCShippingMethodKey = t.idfWCShippingMethodKey   
   , idfWCTaxScheduleHdrKey = t.idfWCTaxScheduleHdrKey  
   , idfAPTaxTypeDtlKey  = t.idfAPTaxTypeDtlKey  
   , idfAPTaxTypeKey   = t.idfAPTaxTypeKey  
   , idfAppConnCreated   = t.idfAppConnCreated  
   , idfAppConnCreatedDate  = t.idfAppConnCreatedDate  
   , idfAppConnError   = t.idfAppConnError  
   , idfTaxID     = t.TXIDNMBR  
   , idfTaxReg     = t.TXRGNNUM  
 FROM dbo.APVendor c WITH (NOLOCK INDEX=PKidfVendorID)  
 INNER JOIN #APVendorWork t ON c.idfVendorID = t.VENDORID  
 LEFT OUTER JOIN DYNAMICS.dbo.vwPTICurrency CUR WITH (NOLOCK) ON CUR.idfCurrencyID = t.CURNCYID  
 LEFT OUTER JOIN dbo.vwFNACurrency vwCUR ON vwCUR.edfFunctional=1  
 WHERE t.idfRowAction = 'UP'  
  AND idfPTICompanyKey = @nidfPTICompanyKey  
    
 -- Make sure the vendor address info is updated since some vendor fields are on the address level in GRP  
 UPDATE PM00300 SET VENDORID = PM00300.VENDORID    
 FROM PM00300 WITH (NOLOCK)  
 INNER JOIN inserted i on PM00300.VENDORID = i.VENDORID    