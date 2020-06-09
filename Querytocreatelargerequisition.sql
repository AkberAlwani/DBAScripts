SET NOCOUNT ON
GO
------------------------------------------------------------------------------------
-- START: RQHeader
-- SELECT  COUNT(*) FROM WCAttach WITH (NOLOCK)
------------------------------------------------------------------------------------
/*
spPTIPurgeTableData
*/
DECLARE 
 @nRQHeader2Add            INT
,@nRQHeaderCtr                    INT
,@nRQDetail2Add            INT
,@nRQDetailCtr                    INT
,@nidfRQHeaderKey          INT
,@nidfPTICompanyKey        INT
,@nidfWCSecurityKey        INT
,@nidfPTICurrencyKey INT
,@nSubmitReq               INT 
,@nidfRQDetailKey          INT
,@nidfRQSessionKey         INT
,@stridfSecurityID         VARCHAR(60) = 'testuser'

SET @nRQHeader2Add                = 100
SET @nRQHeaderCtr                 = 0
SET @nRQDetail2Add                = 25
SET @nRQDetailCtr                 = 0
SET @nSubmitReq                          = 1
SET @nidfRQSessionKey             = 100

--ALTER TABLE RQDetail DISABLE TRIGGER ALL
--ALTER TABLE RQHeader DISABLE TRIGGER ALL

SELECT @nidfPTICompanyKey  = idfPTICompanyKey FROM PTIMaster.dbo.PTICompany WHERE idfDBName=DB_NAME()
SELECT @nidfPTICurrencyKey = idfPTICurrencyKey FROM vwFNACurrency WHERE edfFunctional=1


WHILE @nRQHeaderCtr < @nRQHeader2Add BEGIN
       SELECT @nidfWCSecurityKey = idfWCSecurityKey FROM dbo.WCSecurity WITH (NOLOCK) WHERE idfWCSecurityKey > ISNULL(@nidfWCSecurityKey,0) AND idfSecurityID = @stridfSecurityID

       EXEC spWCGetNextPK 'RQHeader',@nidfRQHeaderKey OUTPUT

       INSERT INTO [dbo].[RQHeader]
           ([idfRQHeaderKey]
		   ,idfAmtControlTotal
 ,idfAmtDiscount
,idfAmtDiscountApr
,idfAmtDiscountHome
,idfAmtFreight
,idfAmtFreightApr
,idfAmtFreightHome
,idfAmtMisc
,idfAmtMiscApr
,idfAmtMiscHome
,idfAmtSubTotal
,idfAmtSubTotalApr
,idfAmtSubTotalHome
,idfAmtTax
,idfAmtTaxApr
,idfAmtTaxHome
,idfBlanketInvAmt
,idfBlanketInvPer
,idfComment
,idfCustAddr1
,idfCustAddr2
,idfCustAddr3
,idfCustAddr4
,idfCustAddr5
,idfCustAddr6
,idfCustAltPhone1
,idfCustAltPhone2
,idfCustAltPhoneExt1
,idfCustAltPhoneExt2
,idfCustAttention
,idfCustCity
,idfCustCountry
,idfCustEmail
,idfCustFax
,idfCustState
,idfCustZipCode
,idfDatePost
,idfDelegateNote
,idfDescription
,idfFlagBlanketInvAmtOverride
,idfFlagKeepTogether
,idfFlagProcessed
,idfFlagSubmitted
,idfLastLine
,idfRateHome
,idfRQDate
,idfRQNumber
,idfVendorDocNum
,idfDateCreated
,idfDateModified
,idfAPAddressKeyPurch
,idfAPTaxTypeDtlKey
,idfAPVendorKey
,idfARCustomerAddressKey
,idfARCustomerKey
,idfPAPhaseActivityKey
,idfPAProjectKey
,idfPAProjectPhaseKey
,idfPTICompanyKey
,idfPTICurrencyKey
,idfRQTypeKey
,idfWCDeptKey
,idfWCICCompanyKeySource
,idfWCICCompanyKeyTarget
,idfWCOrganizationKey
,idfWCPaymentTermKey
,idfWCSecurityKey
,idfWCSecurityKeyCreated
,idfWCSecurityKeyDelegate
,idfWCTaxScheduleHdrKey
,edfAmtAprExtended
,edfAmtHomeExtended
,edfDocumentID
,edfFacilityID
,edfFacilityIDFrom
,udfDateField01
,udfDateField02
,udfDateField03
,udfDateField04
,udfDateField05
,udfLargeTextField01
,udfLargeTextField02
,udfLargeTextField03
,udfNumericField01
,udfNumericField02
,udfNumericField03
,udfNumericField04
,udfNumericField05
,udfNumericField06
,udfNumericField07
,udfNumericField08
,udfNumericField09
,udfNumericField10
,udfTextField01
,udfTextField02
,udfTextField03
,udfTextField04
,udfTextField05
,udfTextField06
,udfTextField07
,udfTextField08
,udfTextField09
,udfTextField10
           )
     VALUES
           (@nidfRQHeaderKey
		   ,0-- idfAmtControlTotal
                     ,0     -- idfAmtDiscount     
                     ,0     -- idfAmtDiscountApr  
                     ,0     -- idfAmtDiscountHome 
                     ,0     -- idfAmtFreight      
                     ,0     -- idfAmtFreightApr   
                     ,0     -- idfAmtFreightHome  
                     ,0     -- idfAmtMisc         
                     ,0     -- idfAmtMiscApr      
                     ,0     -- idfAmtMiscHome     
                     ,0     -- idfAmtSubTotal     
                     ,0     -- idfAmtSubTotalApr  
                     ,0     -- idfAmtSubTotalHome 
                     ,0     -- idfAmtTax          
                     ,0     -- idfAmtTaxApr       
                     ,0     -- idfAmtTaxHome
                     ,0     --idfBlanketInvAmt
                     ,0     --idfBlanketInvPer      
                     ,'comment'
                     ,''           -- idfCustAddr1       
                     ,''           -- idfCustAddr2       
                     ,''           -- idfCustAddr3       
                     ,''           -- idfCustAddr4       
                     ,''           -- idfCustAddr5       
                     ,''           -- idfCustAddr6       
                     ,''           -- idfCustAltPhone1   
                     ,''           -- idfCustAltPhone2   
                     ,''           -- idfCustAltPhoneExt1
                     ,''           -- idfCustAltPhoneExt2
                     ,''           -- idfCustAttention   
                     ,''           -- idfCustCity        
                     ,''           -- idfCustCountry     
                     ,''           -- idfCustEmail       
                     ,''           -- idfCustFax         
                     ,''           -- idfCustState       
                     ,''           -- idfCustZipCode
                     ,GETDATE() -- idfDatePost     
           ,'DelegateNote'
           ,'Desc'
,0 --idfFlagBlanketInvAmtOverride
           ,0 --<idfFlagKeepTogether, int,>
           ,0 --<idfFlagProcessed, bit,>
           ,0 --<idfFlagSubmitted, bit,>
          ,@nRQDetail2Add  --<idfLastLine, int,>
          ,1  --idfRateHome
                    ,GETDATE()    --idfRQDate            
                     ,CONVERT(VARCHAR(10),@nidfRQHeaderKey)   --idfRQNumber 
,'' -- idfVendorDocNumber 
,GETDATE()    --idfDateCreated
,GETDATE()    --idfDateModified
,null -- idfAPAddressKeyPurch
,null --idfAPTaxTypeDtlKey
,null --idfAPVendorKey
,null --idfARCustomerAddressKey
,null --idfARCustomerKey
,null -- idfPAPhaseActivityKey
,null --idfPAProjectKey
,null --idfPAProjectPhaseKey
,'1' --idfPTICompanyKey
,'1' -- idfPTICurrencyKey
,'1' -- idfRQTypeKey         
 ,'1' --          idfWCDeptKey
,null --idfWCICCompanyKeySource
,null --idfWCICCompanyKeyTarget
,null --idfWCOrganizationKey
,null --idfWCPaymentTermKey
,'2' --idfWCSecurityKey
,'2' --idfWCSecurityKeyCreated
,null -- idfWCSecurityKeyDelegate
,null -- idfWCTaxScheduleHdrKey
,300000 --edfAmtAprExtended
,30000  --edfAmtHomeExtended
,'' --edfDocumentID
,'' -- edfFacilityID
,'' --edfFacilityIDFrom
                                ,null -- udfDateField01      
                     ,null -- udfDateField02      
                     ,null -- udfDateField03      
                     ,null -- udfDateField04      
                     ,null -- udfDateField05      
                     ,''    -- udfLargeTextField01 
                     ,''    -- udfLargeTextField02 
                     ,''    -- udfLargeTextField03 
                     ,0     -- udfNumericField01   
                     ,0     -- udfNumericField02   
                     ,0     -- udfNumericField03   
                     ,0     -- udfNumericField04   
                     ,0     -- udfNumericField05   
                     ,0     -- udfNumericField06   
                     ,0     -- udfNumericField07   
                     ,0     -- udfNumericField08   
                     ,0     -- udfNumericField09   
                     ,0     -- udfNumericField10   
                     ,''    -- udfTextField01      
                     ,''    -- udfTextField02      
                     ,''    -- udfTextField03      
                     ,''    -- udfTextField04      
                     ,''    -- udfTextField05      
                     ,''    -- udfTextField06      
                     ,''    -- udfTextField07      
                     ,''    -- udfTextField08      
                     ,''    -- udfTextField09      
                     ,''    --udfTextField10 
					 )     
                   
           

       SET @nRQDetailCtr = 0
       WHILE @nRQDetailCtr < @nRQDetail2Add BEGIN
              EXEC spWCGetNextPK 'RQDetail',@nidfRQDetailKey OUTPUT
              INSERT INTO [dbo].[RQDetail]
                              ([idfRQDetailKey]
                              ,idfAmtDiscount
,idfAmtDiscountApr
,idfAmtDiscountHome
,idfAmtFreight
,idfAmtFreightApr
,idfAmtFreightHome
,idfAmtMisc
,idfAmtMiscApr
,idfAmtMiscHome
,idfAmtSubTotal
,idfAmtSubTotalApr
,idfAmtSubTotalHome
,idfAmtTax
,idfAmtTaxApr
,idfAmtTaxHome
,idfBudgetApplyDate
,idfCommentInternal
,idfCurrLineUpSeq
,idfDatePromised
,idfDateRequired
,idfFlagBlanketPO
,idfFlagManualDist
,idfFlagReversal
,idfFlagVCOverride
,idfFulfillType
,idfGeneratedDocument
,idfLine
,idfQty
,idfQtyChangeOrderMin
,idfQtyPrec
,idfRateHome
,idfShipToAddr1
,idfShipToAddr2
,idfShipToAddr3
,idfShipToAltPhone1
,idfShipToAltPhone2
,idfShipToAltPhoneExt1
,idfShipToAltPhoneExt2
,idfShipToCity
,idfShipToContact
,idfShipToCountry
,idfShipToFax
,idfShipToName
,idfShipToState
,idfShipToZipCode
,idfURLReference
,idfVCOverrideNote
,idfDateCreated
,idfDateModified
,idfAPTaxTypeDtlKey
,idfBUDPeriodKey
,idfEXPTypeKey
,idfGLReferenceKey
,idfLogKey
,idfPTICompanyKey
,idfPTICurrencyRateDtlKeyApr
,idfPTICurrencyRateDtlKeyHome
,idfRCVDetailKey
,idfRQDetailKeyChangeSource
,idfRQHeaderKey
,idfRQMemoKey
,idfRQPriorityKey
,idfRQSessionKey
,idfSessionLinkKey
,idfVCHeaderKey
,idfWCDeptKey
,idfWCICCompanyKeySource
,idfWCICCompanyKeyTarget
,idfWCLineUpKey
,idfWCRRGroupLineUpKey
,idfWCSecurityDelegateKey
,idfWCTaxScheduleHdrKey
,edfAmtAprExtended
,edfAmtExtended
,edfAmtHomeExtended
,edfPrice
,edfPricePrec
,edfAnalysisGroup
,edfBillTo
,edfBuyer
,edfCurrency
,edfDocumentID
,edfDropShip
,edfDropShipCustomer
,edfENCBreakDown
,edfENCGrantID
,edfENCProjectID
,edfENCUserDefined1
,edfENCUserDefined2
,edfENCUserDefined3
,edfENCUserDefined4
,edfENCUserDefined5
,edfENCUserDefined6
,edfENCUserDefined7
,edfFacilityID
,edfFacilityIDFrom
,edfGL
,edfItem
,edfItemDesc
,edfLocation
,edfLocationFrom
,edfManuItem
,edfPABudgetAuthCost
,edfPABudgetAuthQty
,edfPALineItemSeq
,edfPAProjectL1
,edfPAProjectL2
,edfPAProjectL3
,edfPaymentTerm
,edfPOLine
,edfPONumber
,edfShipMethod
,edfShipTo
,edfTranType
,edfUOM
,edfVendor
,edfVendorAddrID
,edfVendorDocNum
,edfVendorItem
,edfWSProductIndicator
,udfDateField01
,udfDateField02
,udfDateField03
,udfDateField04
,udfDateField05
,udfLargeTextField01
,udfLargeTextField02
,udfLargeTextField03
,udfNumericField01
,udfNumericField02
,udfNumericField03
,udfNumericField04
,udfNumericField05
,udfNumericField06
,udfNumericField07
,udfNumericField08
,udfNumericField09
,udfNumericField10
,udfTextField01
,udfTextField02
,udfTextField03
,udfTextField04
,udfTextField05
,udfTextField06
,udfTextField07
,udfTextField08
,udfTextField09
,udfTextField10
                              )
                     VALUES
                              (@nidfRQDetailKey
                                  ,0     -- idfAmtDiscount     
                                  ,0     -- idfAmtDiscountApr  
                                  ,0     -- idfAmtDiscountHome 
                                  ,0     -- idfAmtFreight      
                                  ,0     -- idfAmtFreightApr   
                                  ,0     -- idfAmtFreightHome  
                                  ,0     -- idfAmtMisc         
                                  ,0     -- idfAmtMiscApr      
                                  ,0     -- idfAmtMiscHome     
                                  ,0     -- idfAmtSubTotal     
                                  ,0     -- idfAmtSubTotalApr  
                                  ,0     -- idfAmtSubTotalHome 
                                  ,0     -- idfAmtTax          
                                  ,0     -- idfAmtTaxApr       
                                  ,0     -- idfAmtTaxHome      
                              ,null--<idfBudgetApplyDate, datetime,>
                              ,'CommentInternal'
                              ,0  --<idfCurrLineUpSeq, int,>
                              ,GETDATE() --<idfDatePromised, datetime,>
                              ,GETDATE() --<idfDateRequired, datetime,>
							  ,0 --idfFlagBlanketPO
                              ,0  --<idfFlagManualDist, int,>
                              ,0 -- idfFlagReversal
                              ,0  --<idfFlagVCOverride, int,>
                              ,'DEFER'   -- idfFulfillType
                              ,'' --idfGeneratedDocument
                              ,@nRQDetailCtr+1--<idfLine, int,>
                              ,1  --<idfQty, numeric(15,5),>
                              ,0  --idfQtyChangeOrderMin

                              ,2  --<idfQtyPrec, int,>
                              ,1  --                            ,[idfRateHome]
                                  ,''           -- idfShipToAddr1       
                                  ,''           -- idfShipToAddr2       
                                  ,''           -- idfShipToAddr3       
                                  ,''           -- idfShipToAltPhone1   
                                  ,''           -- idfShipToAltPhone2   
                                  ,''           -- idfShipToAltPhoneExt1
                                  ,''           -- idfShipToAltPhoneExt2
                                  ,''           -- idfShipToCity        
                                  ,''           -- idfShipToContact     
                                  ,''           -- idfShipToCountry     
                                  ,''           -- idfShipToFax         
                                  ,''           -- idfShipToName        
                                  ,''           -- idfShipToState       
                                  ,''           -- idfShipToZipCode
                                  ,''           -- idfURLReference        
                                  ,''           -- idfVCOverrideNote       
                               
,GETDATE() --idfDateCreated
,getDATE () --idfDateModified
,null--idfAPTaxTypeDtlKey
,null --idfBUDPeriodKey
,null --idfEXPTypeKey
,null --idfGLReferenceKey
,null --idfLogKey
,'1' --idfPTICompanyKey
,null --idfPTICurrencyRateDtlKeyApr
,null --idfPTICurrencyRateDtlKeyHome
,null --idfRCVDetailKey
,null --idfRQDetailKeyChangeSource
,@nidfRQHeaderKey --idfRQHeaderKey
,null --idfRQMemoKey
,null --idfRQPriorityKey
,100 -- idfRQSessionKey
,null --idfSessionLinkKey
,null -- idfVCHeaderKey
,'2' --idfWCDeptKey
,null --idfWCICCompanyKeySource
,null --idfWCICCompanyKeyTarget
,null --idfWCLineUpKey
,null --idfWCRRGroupLineUpKey
,null --idfWCSecurityDelegateKey
,null --idfWCTaxScheduleHdrKey
,1000 --edfAmtAprExtended
,1000 --edfAmtExtended
,1000 --edfAmtHomeExtended
,0010 -- edfPrice
,2 -- edfPricePrec
,'' --edfAnalysisGroup
,'PRIMARY' --edfBillTo
,'' --edfBuyer
,'Z-US$          ' --edfCurrency
,''--edfDocumentID
,'0' --edfDropShip
,'' --edfDropShipCustomer
,''--edfENCBreakDown
,''--edfENCGrantID
,''--edfENCProjectID
,''--edfENCUserDefined1
,''--edfENCUserDefined2
,''--edfENCUserDefined3
,''--edfENCUserDefined4
,''--edfENCUserDefined5
,''--edfENCUserDefined6
,''--edfENCUserDefined7
,''--edfFacilityID
,''--edfFacilityIDFrom
,'18'--edfGL
,'128 SDRAM                      '--edfItem
,'128 meg SDRAM                                                                                        '--edfItemDesc
,'01-N           '--edfLocation
,''--edfLocationFrom
,''--edfManuItem
,0--edfPABudgetAuthCost
,0--edfPABudgetAuthQty
,0--edfPALineItemSeq
,'' --edfPAProjectL1
,''--edfPAProjectL2
,''--edfPAProjectL3
,'Net 30'--edfPaymentTerm
,'0' --edfPOLine
,'' --edfPONumber
,'OVERNIGHT'--edfShipMethod
,'Primary' --edfShipTo
,'STD' --edfTranType
,'Each' --edfUOM
,'ACETRAVE0001   '--edfVendor
,'PRIMARY'--edfVendorAddrID
,'' --edfVendorDocNum
,'128 SDRAM' --edfVendorItem
,'0' --edfWSProductIndicator
                              ,null--<udfDateField01, datetime,>
                              ,null--<udfDateField02, datetime,>
                              ,null--<udfDateField03, datetime,>
                              ,null--<udfDateField04, datetime,>
                              ,null--<udfDateField05, datetime,>
                              ,''--<udfLargeTextField01, varchar(255),>
                              ,''--<udfLargeTextField02, varchar(255),>
                              ,''--<udfLargeTextField03, varchar(255),>
                              ,0--<udfNumericField01, numeric(15,5),>
                              ,0--<udfNumericField02, numeric(15,5),>
                              ,0--<udfNumericField03, numeric(15,5),>
                              ,0--<udfNumericField04, numeric(15,5),>
                              ,0--<udfNumericField05, numeric(15,5),>
                              ,0--<udfNumericField06, numeric(15,5),>
                              ,0--<udfNumericField07, numeric(15,5),>
                              ,0--<udfNumericField08, numeric(15,5),>
                              ,0--<udfNumericField09, numeric(15,5),>
                              ,0--<udfNumericField10, numeric(15,5),>
                              ,''--<udfTextField01, varchar(60),>
                              ,''--<udfTextField02, varchar(60),>
                              ,''--<udfTextField03, varchar(60),>
                              ,''--<udfTextField04, varchar(60),>
                              ,''--<udfTextField05, varchar(60),>
                              ,''--<udfTextField06, varchar(60),>
                              ,''--<udfTextField07, varchar(60),>
                              ,''--<udfTextField08, varchar(60),>
                              ,''--<udfTextField09, varchar(60),>
                               ,''   --<udfTextField10, varchar(60),>
							   )

              -- SELECT * FROM RQDetail
              SET @nRQDetailCtr = @nRQDetailCtr + 1
       END

       IF @nSubmitReq=1
              EXEC dbo.spRQHeaderSubmit '',0,'', @nidfRQHeaderKey, ''

       SET @nRQHeaderCtr = @nRQHeaderCtr + 1
END

--ALTER TABLE RQDetail ENABLE TRIGGER ALL
--ALTER TABLE RQHeader ENABLE TRIGGER ALL

------------------------------------------------------------------------------------
-- END: RQHeader
------------------------------------------------------------------------------------
