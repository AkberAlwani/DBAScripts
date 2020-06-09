
-- This script will Update the Vendor Info Table (WCVendorInfo) with Email Address 
-- and also check the Automatically Email PO to Vendor when Created from Review for vendors that DO NOT EXIST in this table already

--  The bottom part if needed will check the Auto Process from Approval for the vendors updated above


--Make a copy of the tables: 

Select * into WCVendorInfo_org from WCVendorInfo
Select * into APVendor_org from APVendor



DECLARE @nidfPTICompanyKey INT
SELECT @nidfPTICompanyKey = idfPTICompanyKey FROM PTIMaster..PTICompany (NOLOCK) WHERE idfDBName = db_name()

DECLARE @WCVendorInfo TABLE
(
        idfKey                                            int IDENTITY(0,1)                    
        ,idfcXMLFlagORIOUseDefaultXML        int              
        ,idfcXMLFlagORUseDefaultMap          int              
        ,idfcXMLFlagORUseDefaultXML          int              
        ,idfcXMLFlagSRUseDefaultXML          int              
        ,idfcXMLImageURL                     varchar(256)     
        ,idfcXMLOrderRequestURL              varchar(128)     
        ,idfcXMLORIOXML                      text             
        ,idfcXMLORMap                        text             
        ,idfcXMLORToIdentity                 varchar(128)     
        ,idfcXMLORXML                        text             
        ,idfcXMLSecProtoType                 int              
        ,idfcXMLSendAfterDate                datetime         
        ,idfcXMLSRFromIdentity               varchar(128)     
        ,idfcXMLSRSenderIdentity             varchar(128)     
        ,idfcXMLSRSharedSecret               varchar(128)     
        ,idfcXMLSRSupplierSetupURL           varchar(128)     
        ,idfcXMLSRXML                        text             
        ,idfcXMLTransport                    varchar(10)      
        ,idfEmailBCC                         varchar(1024)    
        ,idfEmailCC                          varchar(1024)    
        ,idfEmailFormat                      char(4)          
        ,idfEmailTo                          varchar(1024)    
        ,idfFlagEmailPO                      int              
        ,idfFlagPunchOut                     int              
        ,idfFlagRFQ                          int              
        ,idfLoginName                        varchar(512)     
        ,idfLoginPassword                    varchar(512)     
        ,idfDateCreated                      datetime         
        ,idfDateModified                     datetime              
        ,edfVendor                           varchar(15)  
        ,idfPTICompanyKey                               INT  
)  
INSERT INTO @WCVendorInfo
(      
        idfcXMLFlagORIOUseDefaultXML     
        ,idfcXMLFlagORUseDefaultMap 
        ,idfcXMLFlagORUseDefaultXML 
        ,idfcXMLFlagSRUseDefaultXML 
        ,idfcXMLImageURL     
        ,idfcXMLOrderRequestURL    
        ,idfcXMLORIOXML      
        ,idfcXMLORMap 
        ,idfcXMLORToIdentity 
        ,idfcXMLORXML 
        ,idfcXMLSecProtoType 
        ,idfcXMLSendAfterDate      
        ,idfcXMLSRFromIdentity     
        ,idfcXMLSRSenderIdentity   
        ,idfcXMLSRSharedSecret     
        ,idfcXMLSRSupplierSetupURL 
        ,idfcXMLSRXML 
        ,idfcXMLTransport    
        ,idfEmailBCC  
        ,idfEmailCC   
        ,idfEmailFormat      
        ,idfEmailTo   
        ,idfFlagEmailPO      
        ,idfFlagPunchOut     
        ,idfFlagRFQ   
        ,idfLoginName 
        ,idfLoginPassword    
        ,edfVendor    
        ,idfPTICompanyKey    
)
SELECT  
        0--idfcXMLFlagORIOUseDefaultXML  
        ,0--idfcXMLFlagORUseDefaultMap    
        ,0--idfcXMLFlagORUseDefaultXML    
        ,0--idfcXMLFlagSRUseDefaultXML    
        ,''--idfcXMLImageURL 
        ,''--idfcXMLOrderRequestURL 
        ,''--idfcXMLORIOXML  
        ,''--idfcXMLORMap    
        ,''--idfcXMLORToIdentity   
        ,''--idfcXMLORXML    
        ,0--idfcXMLSecProtoType    
        ,NULL--idfcXMLSendAfterDate 
        ,''--idfcXMLSRFromIdentity 
        ,''--idfcXMLSRSenderIdentity      
        ,''--idfcXMLSRSharedSecret 
        ,''--idfcXMLSRSupplierSetupURL    
        ,''--idfcXMLSRXML    
        ,'URLFORMENC'                     --idfcXMLTransport   
        ,''--idfEmailBCC     
        ,''--idfEmailCC      
        ,'HTML'                                         --idfEmailFormat     
        ,INET1                                   --idfEmailTo  
        ,1--idfFlagEmailPO   
        ,0--idfFlagPunchOut  
        ,0--idfFlagRFQ       
        ,''--idfLoginName    
        ,''--idfLoginPassword      
        ,Master_ID                               --edfVendor   
        ,@nidfPTICompanyKey               --idfPTICompanyKey   
FROM dbo.SY01200 WITH (NOLOCK)
LEFT OUTER JOIN dbo.WCVendorInfo WITH (NOLOCK) ON WCVendorInfo.edfVendor = SY01200.Master_ID
WHERE Master_Type = 'VEN' AND INET1 <> '' AND WCVendorInfo.idfWCVendorInfoKey IS NULL
AND ADRSCODE='PRIMARY'  --- REPLACE with what address you need

DECLARE @nNextPKRows INT, @nNextPKSeed INT
SELECT @nNextPKRows = COUNT(*) FROM @WCVendorInfo
EXEC dbo.spWCGetNextPK 'WCVendorInfo',@nNextPKSeed OUTPUT,@nNextPKRows
       
INSERT INTO WCVendorInfo
(
        idfWCVendorInfoKey  
        ,idfcXMLFlagORIOUseDefaultXML     
        ,idfcXMLFlagORUseDefaultMap 
        ,idfcXMLFlagORUseDefaultXML 
        ,idfcXMLFlagSRUseDefaultXML 
        ,idfcXMLImageURL     
        ,idfcXMLOrderRequestURL    
        ,idfcXMLORIOXML      
        ,idfcXMLORMap 
        ,idfcXMLORToIdentity 
        ,idfcXMLORXML 
        ,idfcXMLSecProtoType 
        ,idfcXMLSendAfterDate      
        ,idfcXMLSRFromIdentity     
        ,idfcXMLSRSenderIdentity   
        ,idfcXMLSRSharedSecret     
        ,idfcXMLSRSupplierSetupURL 
        ,idfcXMLSRXML 
        ,idfcXMLTransport    
        ,idfEmailBCC  
        ,idfEmailCC   
        ,idfEmailFormat      
        ,idfEmailTo   
        ,idfFlagEmailPO      
        ,idfFlagPunchOut     
        ,idfFlagRFQ   
        ,idfLoginName 
        ,idfLoginPassword    
        ,edfVendor    
        ,idfPTICompanyKey    
)
SELECT  
        @nNextPKSeed + idfKey     --idfWCVendorInfoKey 
        ,idfcXMLFlagORIOUseDefaultXML     
        ,idfcXMLFlagORUseDefaultMap 
        ,idfcXMLFlagORUseDefaultXML 
        ,idfcXMLFlagSRUseDefaultXML 
        ,idfcXMLImageURL     
        ,idfcXMLOrderRequestURL    
        ,idfcXMLORIOXML      
        ,idfcXMLORMap 
        ,idfcXMLORToIdentity 
        ,idfcXMLORXML 
        ,idfcXMLSecProtoType 
        ,idfcXMLSendAfterDate      
        ,idfcXMLSRFromIdentity     
        ,idfcXMLSRSenderIdentity   
        ,idfcXMLSRSharedSecret     
        ,idfcXMLSRSupplierSetupURL 
        ,idfcXMLSRXML 
        ,idfcXMLTransport    
        ,idfEmailBCC  
        ,idfEmailCC   
        ,idfEmailFormat      
        ,idfEmailTo   
        ,idfFlagEmailPO      
        ,idfFlagPunchOut     
        ,idfFlagRFQ   
        ,idfLoginName 
        ,idfLoginPassword    
        ,edfVendor    
        ,idfPTICompanyKey    
FROM @WCVendorInfo

UPDATE APVendor      SET 
        idfFlagAutoCreatePO = 1
FROM dbo.APVendor WITH (NOLOCK)
INNER JOIN @WCVendorInfo TMP ON TMP.edfVendor = APVendor.idfVendorID

EXEC dbo.spPTIFixPrimaryKey
EXEC dbo.spPTIFixPrimaryKeySequence 1

