SET NOCOUNT ON
GO
------------------------------------------------------------------------------------
-- START: RQHeader
-- SELECT  COUNT(*) FROM WCAttach WITH (NOLOCK)
------------------------------------------------------------------------------------
/*
spPTIPurgeTableData
*/
-------------------------------------
DECLARE 
 @nRQHeader2Add		INT
,@nRQHeaderCtr			INT
,@nRQDetail2Add		INT
,@nRQDetailCtr			INT
,@nidfRQHeaderKey		INT
,@stredfCurrency		VARCHAR(60)
,@nidfWCSecurityKey		INT
,@nidfPTICompanyKey	INT
,@nSubmitReq			INT 
,@nidfRQDetailKey		INT
,@nidfRQSessionKey		INT
,@stridfSecurityID		VARCHAR(60) = 'testuser'
,@nProcessReq			INT
,@nidfRQRevHdrKey		INT
,@nidfPTICurrencyKey	INT
,@nBypassApproval		INT
,@nLoadIntoApproval		INT
,@nidfRQAprHdrKey		INT

SELECT
 @nRQHeader2Add			= 1
,@nRQHeaderCtr			= 0
,@nRQDetail2Add			= 150
,@nRQDetailCtr			= 0
,@nSubmitReq			= 1
,@nidfRQSessionKey		= 100
,@nProcessReq			= 0
,@nBypassApproval		= 1
,@nLoadIntoApproval		= 0 -- in order to use this make sure the requisition is routed to the user defined above (@stridfSecurityID)
-------------------------------------
-------------------------------------
DECLARE
 @nedfGL				INT
,@stredfShipTo			VARCHAR(60)
,@stredfShipMethod		VARCHAR(60)
,@nidfAPVendorKey		INT
,@stredfVendor			VARCHAR(60)
,@stredfPaymentTerm		VARCHAR(60)
,@stredfVendorAddrID	VARCHAR(60)
,@stredfLocation		VARCHAR(60)

SELECT
 @nedfGL				= (SELECT TOP 1 ACTINDX FROM GL00100 WHERE ACTIVE = 1 ORDER BY ACTINDX)
,@stredfShipTo			= (SELECT TOP 1 idfAddressID FROM WCAddress ORDER BY idfWCAddressKey)
,@stredfLocation		= (SELECT TOP 1 idfSiteID FROM IVSite WHERE idfFlagActive = 1 ORDER BY idfIVSiteKey)
,@nidfAPVendorKey		= (SELECT TOP 1 APVendor.idfAPVendorKey 
							FROM PM00300 (NOLOCK) 
							INNER JOIN APVendor (NOLOCK) ON APVendor.idfVendorID = PM00300.VENDORID 
							INNER JOIN APAddress (NOLOCK) ON APAddress.idfAddressID = PM00300.ADRSCODE AND APAddress.idfAPVendorKey = APVendor.idfAPVendorKey 
							WHERE APVendor.idfAPAddressKey > 0
							ORDER BY idfVendorID)
SELECT
 @stredfVendor			= (SELECT TOP 1 idfVendorID FROM APVendor WHERE idfAPVendorKey = @nidfAPVendorKey)
,@stredfShipMethod		= (SELECT TOP 1 idfShippingMethodID FROM WCShippingMethod ORDER BY idfWCShippingMethodKey)
,@stredfPaymentTerm		= 'Net 30               '--(SELECT TOP 1 idfPaymentTermID FROM WCPaymentTerm ORDER BY idfWCPaymentTermKey)
,@stredfVendorAddrID	= (SELECT TOP 1 idfAddressID FROM APAddress WHERE idfAPVendorKey = @nidfAPVendorKey)
-------------------------------------
-------------------------------------

DECLARE 
 @p1 VARCHAR(32) =NULL
,@p2 INT =NULL
,@p3 VARCHAR(255) = NULL
-------------------------------------
SELECT @nidfPTICompanyKey	= idfPTICompanyKey FROM PTIMaster.dbo.PTICompany WHERE idfDBName=DB_NAME()
SELECT @stredfCurrency	= edfCurrencyID, @nidfPTICurrencyKey = idfPTICurrencyKey FROM vwFNACurrency WHERE edfFunctional=1
SELECT @nidfWCSecurityKey = idfWCSecurityKey FROM dbo.WCSecurity WITH (NOLOCK) WHERE idfWCSecurityKey > ISNULL(@nidfWCSecurityKey,0) AND idfSecurityID = @stridfSecurityID


WHILE @nRQHeaderCtr < @nRQHeader2Add BEGIN

	EXEC spWCGetNextPK 'RQHeader',@nidfRQHeaderKey OUTPUT

	INSERT INTO [dbo].[RQHeader]
           ([idfRQHeaderKey]
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
           ,[idfComment]
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
           ,[idfDescription]
           ,[idfDelegateNote]
           ,[idfFlagKeepTogether]
           ,[idfFlagProcessed]
           ,[idfFlagSubmitted]
           ,[idfLastLine]
           ,idfRateHome
			,idfRQDate            
			,idfRQNumber           
          ,[idfPTICompanyKey]
          ,idfPTICurrencyKey
           ,[idfRQTypeKey]
           ,[idfWCDeptKey]
           ,[idfWCSecurityKey]
           ,[idfWCSecurityKeyDelegate]
           ,[edfAmtAprExtended]
           ,[edfAmtHomeExtended]
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
			,idfFlagBlanketInvAmtOverride
			,idfBlanketInvAmt
			,idfBlanketInvPer
			,idfVendorDocNum
			,idfWCSecurityKeyCreated
			,edfDocumentID
			,edfFacilityID
			,edfFacilityIDFrom
			
           )
     VALUES
           (@nidfRQHeaderKey
			,0	-- idfAmtDiscount     
			,0	-- idfAmtDiscountApr  
			,0	-- idfAmtDiscountHome 
			,0	-- idfAmtFreight      
			,0	-- idfAmtFreightApr   
			,0	-- idfAmtFreightHome  
			,0	-- idfAmtMisc         
			,0	-- idfAmtMiscApr      
			,0	-- idfAmtMiscHome     
			,0	-- idfAmtSubTotal     
			,0	-- idfAmtSubTotalApr  
			,0	-- idfAmtSubTotalHome 
			,0	-- idfAmtTax          
			,0	-- idfAmtTaxApr       
			,0	-- idfAmtTaxHome      
			,'comment'
			,''		-- idfCustAddr1       
			,''		-- idfCustAddr2       
			,''		-- idfCustAddr3       
			,''		-- idfCustAddr4       
			,''		-- idfCustAddr5       
			,''		-- idfCustAddr6       
			,''		-- idfCustAltPhone1   
			,''		-- idfCustAltPhone2   
			,''		-- idfCustAltPhoneExt1
			,''		-- idfCustAltPhoneExt2
			,''		-- idfCustAttention   
			,''		-- idfCustCity        
			,''		-- idfCustCountry     
			,''		-- idfCustEmail       
			,''		-- idfCustFax         
			,''		-- idfCustState       
			,''		-- idfCustZipCode     
           ,'desc'
           ,'DelegateNote'
           ,0	--<idfFlagKeepTogether, int,>
           ,0	--<idfFlagProcessed, bit,>
           ,0	--<idfFlagSubmitted, bit,>
          ,@nRQDetail2Add	--<idfLastLine, int,>
          ,1	--idfRateHome
 			,GETDATE()	--idfRQDate            
			,CONVERT(VARCHAR(10),@nidfRQHeaderKey)	--idfRQNumber           
           ,@nidfPTICompanyKey	--<idfPTICompanyKey, int,>
           ,@nidfPTICurrencyKey
           ,1	--<idfRQTypeKey, int,>
           ,2	-- <idfWCDeptKey, int,>
           ,@nidfWCSecurityKey	-- <idfWCSecurityKey, int,>
           ,null	-- <idfWCSecurityKeyDelegate, int,>
           ,12.99*@nRQDetail2Add		-- <edfAmtAprExtended, numeric(15,5),>
           ,12.99*@nRQDetail2Add		--<edfAmtHomeExtended, numeric(15,5),>
			,null -- udfDateField01      
			,null -- udfDateField02      
			,null -- udfDateField03      
			,null -- udfDateField04      
			,null -- udfDateField05      
			,''	-- udfLargeTextField01 
			,''	-- udfLargeTextField02 
			,''	-- udfLargeTextField03 
			,0	-- udfNumericField01   
			,0	-- udfNumericField02   
			,0	-- udfNumericField03   
			,0	-- udfNumericField04   
			,0	-- udfNumericField05   
			,0	-- udfNumericField06   
			,0	-- udfNumericField07   
			,0	-- udfNumericField08   
			,0	-- udfNumericField09   
			,0	-- udfNumericField10   
			,''	-- udfTextField01      
			,''	-- udfTextField02      
			,''	-- udfTextField03      
			,''	-- udfTextField04      
			,''	-- udfTextField05      
			,''	-- udfTextField06      
			,''	-- udfTextField07      
			,''	-- udfTextField08      
			,''	-- udfTextField09      
			,''	--udfTextField10      
			,0  --idfFlagBlanketInvAmtOverride
			,0	--idfBlanketInvAmt
			,0	--idfBlanketInvPer
			,''	-- idfVendorDocNum
			,@nidfWCSecurityKey
			,'' --edfDocumentID
			,''	--edfFacilityID
			,'' --edfFacilityIDFrom
			
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
				   ,[idfBudgetApplyDate]
				   ,[idfCommentInternal]
				   ,[idfCurrLineUpSeq]
				   ,[idfDatePromised]
				   ,[idfDateRequired]
				   ,[idfFlagManualDist]
				   ,[idfFlagVCOverride]
				   ,idfFulfillType
				   ,idfGeneratedDocument
				   ,[idfLine]
				   ,[idfLogKey]
				   ,[idfQty]
				   ,[idfQtyPrec]
				   ,[idfRateHome]
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
					,idfVCOverrideNote		
					,edfVendorDocNum	   
				   ,[idfSessionLinkKey]
				   ,[idfURLReference]
				   ,[idfBUDPeriodKey]
				   ,[idfGLReferenceKey]
				   ,[idfPTICompanyKey]
				   ,edfCurrency
				   ,[idfRCVDetailKey]
				   ,[idfRQHeaderKey]
				   ,[idfRQMemoKey]
				   ,[idfRQPriorityKey]
				   ,[idfRQSessionKey]
				   ,[idfVCHeaderKey]
				   ,[idfWCDeptKey]
				   ,[idfWCLineUpKey]
				   ,[idfWCRRGroupLineUpKey]
				   ,[idfWCSecurityDelegateKey]
				   ,[idfWCTaxScheduleHdrKey]
				   ,[edfAmtAprExtended]
				   ,[edfAmtExtended]
				   ,[edfAmtHomeExtended]
				   ,[edfPrice]
				   ,[edfPricePrec]
				   ,[edfItem]
				   ,[edfItemDesc]
				   ,edfPOLine
				   ,edfPONumber
				   ,[edfUOM]
				   ,edfVendorItem
				   ,[udfDateField01]
				   ,[udfDateField02]
				   ,[udfDateField03]
				   ,[udfDateField04]
				   ,[udfDateField05]
				   ,[udfLargeTextField01]
				   ,[udfLargeTextField02]
				   ,[udfLargeTextField03]
				   ,[udfNumericField01]
				   ,[udfNumericField02]
				   ,[udfNumericField03]
				   ,[udfNumericField04]
				   ,[udfNumericField05]
				   ,[udfNumericField06]
				   ,[udfNumericField07]
				   ,[udfNumericField08]
				   ,[udfNumericField09]
				   ,[udfNumericField10]
				   ,[udfTextField01]
				   ,[udfTextField02]
				   ,[udfTextField03]
				   ,[udfTextField04]
				   ,[udfTextField05]
				   ,[udfTextField06]
				   ,[udfTextField07]
				   ,[udfTextField08]
				   ,[udfTextField09]
				   ,[udfTextField10]
				   ,idfFlagReversal
				   ,idfQtyChangeOrderMin
			   	   
				   ,edfGL
				   ,edfVendor
				   ,edfShipTo
				   ,edfBillTo
				   ,edfShipMethod	
				   ,idfFlagBlanketPO	
				   ,edfAnalysisGroup
				   ,edfBuyer
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
				   ,edfTranType
				   ,edfVendorAddrID
				   ,edfWSProductIndicator
				   )
			 VALUES
				   (@nidfRQDetailKey
					,0	-- idfAmtDiscount     
					,0	-- idfAmtDiscountApr  
					,0	-- idfAmtDiscountHome 
					,0	-- idfAmtFreight      
					,0	-- idfAmtFreightApr   
					,0	-- idfAmtFreightHome  
					,0	-- idfAmtMisc         
					,0	-- idfAmtMiscApr      
					,0	-- idfAmtMiscHome     
					,0	-- idfAmtSubTotal     
					,0	-- idfAmtSubTotalApr  
					,0	-- idfAmtSubTotalHome 
					,0	-- idfAmtTax          
					,0	-- idfAmtTaxApr       
					,0	-- idfAmtTaxHome      
				   ,null--<idfBudgetApplyDate, datetime,>
				   ,'CommentInternal'
				   ,0	--<idfCurrLineUpSeq, int,>
				   ,GETDATE()	--<idfDatePromised, datetime,>
				   ,GETDATE()	--<idfDateRequired, datetime,>
				   ,0	--<idfFlagManualDist, int,>
				   ,0	--<idfFlagVCOverride, int,>
				   ,'DEFER'	-- idfFulfillType
				   ,''	--idfGeneratedDocument
				   ,@nRQDetailCtr+1--<idfLine, int,>
				   ,NULl	--<idfLogKey, int,>
				   ,1	--<idfQty, numeric(15,5),>
				   ,2	--<idfQtyPrec, int,>
				   ,1	--				   ,[idfRateHome]
					,''		-- idfShipToAddr1       
					,''		-- idfShipToAddr2       
					,''		-- idfShipToAddr3       
					,''		-- idfShipToAltPhone1   
					,''		-- idfShipToAltPhone2   
					,''		-- idfShipToAltPhoneExt1
					,''		-- idfShipToAltPhoneExt2
					,''		-- idfShipToCity        
					,''		-- idfShipToContact     
					,''		-- idfShipToCountry     
					,''		-- idfShipToFax         
					,''		-- idfShipToName        
					,''		-- idfShipToState       
					,''		-- idfShipToZipCode    	
					,''		-- idfVCOverrideNote		
					,''		-- idfVendorDocNum	   
				   ,NULL	--<idfSessionLinkKey, int,>
				   ,'URLReference'
				   ,NULL	--<idfBUDPeriodKey, int,>
				   ,NULL	--<idfGLReferenceKey, int,>
				   ,@nidfPTICompanyKey	--<idfPTICompanyKey, int,>
				   ,@stredfCurrency --edfCurrency
				   ,NULL	--<idfRCVDetailKey, int,>
				   ,@nidfRQHeaderKey	-- <idfRQHeaderKey, int,>
				   ,NULL	--<idfRQMemoKey, int,>
				   ,1		--<idfRQPriorityKey, int,>
				   ,@nidfRQSessionKey		--<idfRQSessionKey, int,>
				   ,NULL	--<idfVCHeaderKey, int,>
				   ,2		-- <idfWCDeptKey, int,>
				   ,NULL --<idfWCLineUpKey, int,>
				   ,NULL	--<idfWCRRGroupLineUpKey, int,>
				   ,NULL	--<idfWCSecurityDelegateKey, int,>
				   ,NULL	--<idfWCTaxScheduleHdrKey, int,>
				   ,12.99--<edfAmtAprExtended, numeric(15,5),>
				   ,12.99--<edfAmtExtended, numeric(15,5),>
				   ,12.99--<edfAmtHomeExtended, numeric(15,5),>
				   ,12.99--<edfPrice, numeric(15,5),>
				   ,2--<edfPricePrec, int,>
				   ,''--<edfItem, char(31),>
				   ,'testitem'--<edfItemDesc, char(101),>
				   ,0--<edfPOLine, int,>
				   ,''--<edfPONumber, char(17),>
				   ,'Each'--<edfUOM, char(9),>
				   ,''		-- edfVendorItem
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
				   ,''
				   ,0
				   ,0 -- idfQtyChangeOrderMin
				   
				   ,@nedfGL		--edfGL
				   ,@stredfVendor		--edfVendor
				   ,@stredfShipTo		--edfShipTo
				   ,@stredfShipTo		--edfBillTo
				   ,@stredfShipMethod	--edfShipMethod		
				   ,0 --idfFlagBlanketPO
				   ,''--edfAnalysisGroup
				   ,''--edfBuyer
				   ,''--edfDocumentID
				   ,0 --edfDropShip
				   ,''--edfDropShipCustomer
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
				   ,@stredfLocation --edfLocation
				   ,'' --edfLocationFrom
				   ,''--edfManuItem
				   ,''--edfPABudgetAuthCost
				   ,''--edfPABudgetAuthQty
				   ,''--edfPALineItemSeq
				   ,''--edfPAProjectL1
				   ,''--edfPAProjectL2
				   ,''--edfPAProjectL3
				   ,@stredfPaymentTerm
				   ,'STD' --edfTranType
				   ,@stredfVendorAddrID --edfVendorAddrID
				   ,'' --edfWSProductIndicator
				   )--<udfTextField10, varchar(60),>

		-- SELECT * FROM RQDetail
		SET @nRQDetailCtr = @nRQDetailCtr + 1
	END

	IF @nSubmitReq = 1
		EXEC dbo.spRQHeaderSubmit '',0,'', @nidfRQHeaderKey, ''
	
	IF @nLoadIntoApproval = 1
		BEGIN
			EXEC dbo.spRQAprLoad @xnidfWCSecurityKey=@nidfWCSecurityKey
								,@xonidfRQAprHdrKey=@nidfRQAprHdrKey OUTPUT
								,@xnidfPTICompanyKey=@nidfPTICompanyKey
		
			UPDATE RQAprDtl SET idfCodeApr = 'APPROVED' WHERE idfRQAprHdrKey = @nidfRQAprHdrKey

			EXEC dbo.spRQAprPost @xochErrSP=''--@p1 OUTPUT
								,@xonErrNum=''--@p2 OUTPUT
								,@xostrErrInfo=''--@p3 OUTPUT
								,@xnidfRQAprHdrKey=@nidfRQAprHdrKey
		END

	IF @nBypassApproval = 1
		UPDATE RQDetail SET idfRQSessionKey = 130 FROM RQDetail WITH (NOLOCK) WHERE idfRQHeaderKey = @nidfRQHeaderKey

	IF @nProcessReq = 1
	BEGIN
		EXEC dbo.spRQRevLoad @xnidfWCSecurityKey=@nidfWCSecurityKey
							,@xonidfRQRevHdrKey=@nidfRQRevHdrKey OUTPUT
							,@xstrLD_vdfSortOrder='Requisition'
							,@xstrLD_vdfReqType='0'
							,@xstrLD_RequisitionName=''
							,@xstrLD_vdfLoadType='Standard'
							,@xnLoadSizeLimit='999999'
							,@xstrLD_idfSecurityID_From=@stridfSecurityID
							,@xstrLD_idfSecurityID_To=@stridfSecurityID

		UPDATE RQRevDtl SET idfCodeRev = 'ORDER' WHERE idfRQRevHdrKey = @nidfRQRevHdrKey

		EXEC dbo.spRQRevPost @xochErrSP=''--@p1 OUTPUT
						    ,@xonErrNum=''--@p2 OUTPUT
							,@xostrErrInfo=''--@p3 OUTPUT
							,@xnidfRQRevHdrKey=@nidfRQRevHdrKey
	END
	SET @nRQHeaderCtr = @nRQHeaderCtr + 1
END

--ALTER TABLE RQDetail ENABLE TRIGGER ALL
--ALTER TABLE RQHeader ENABLE TRIGGER ALL

------------------------------------------------------------------------------------
-- END: RQHeader
------------------------------------------------------------------------------------

