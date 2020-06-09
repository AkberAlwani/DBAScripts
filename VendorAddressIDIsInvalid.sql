INSERT INTO #RQHeader 
(idfRQHeaderKey,idfTimeStamp,idfAmtControlTotal,idfAmtDiscount,idfAmtDiscountApr,idfAmtDiscountHome,idfAmtFreight,idfAmtFreightApr,idfAmtFreightHome,idfAmtMisc,idfAmtMiscApr,idfAmtMiscHome,idfAmtSubTotal,idfAmtSubTotalApr,idfAmtSubTotalHome,
idfAmtTax,idfAmtTaxApr,idfAmtTaxHome,idfAmtTaxIncluded,idfAmtTaxIncludedApr,idfAmtTaxIncludedHome,idfBlanketInvAmt,idfBlanketInvPer,idfComment,idfCustAddr1,idfCustAddr2,idfCustAddr3,idfCustAddr4,idfCustAddr5,idfCustAddr6,
idfCustAltPhone1,idfCustAltPhone2,idfCustAltPhoneExt1,idfCustAltPhoneExt2,idfCustAttention,idfCustCity,idfCustCountry,idfCustEmail,idfCustFax,idfCustState,idfCustZipCode,idfDatePost,idfDelegateNote,idfDescription,idfFlagBlanketInvAmtOverride,
idfFlagKeepTogether,idfFlagProcessed,idfFlagSubmitted,idfLastLine,idfRateHome,idfRQDate,idfRQNumber,idfVendorDocNum,idfDateCreated,idfDateModified,idfAPAddressKeyPurch,idfAPTaxTypeDtlKey,idfAPVendorKey,idfARCustomerAddressKey,idfARCustomerKey,
idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICompanyKey,idfPTICurrencyKey,idfRQTypeKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCOrganizationKey,idfWCPaymentTermKey,idfWCSecurityKey,idfWCSecurityKeyCreated,idfWCSecurityKeyDelegate,idfWCTaxScheduleHdrKey,
edfAmtAprExtended,edfAmtHomeExtended,edfDocumentID,edfFacilityID,edfFacilityIDFrom,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,
udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,udfTextField07,
udfTextField08,udfTextField09,udfTextField10,idfFlagTaxableDisc,idfFlagTaxableFreight,idfFlagTaxableMisc,idfBatchID,edfCurrency,vdfAddressIDVendor,vdfCancelReason,vdfCurrencyID,vdfDeptID,vdfPaymentTermID,vdfRequester,vdfSecurityID,
vdfSecurityIDCreated,vdfTaxScheduleID,vdfTaxTypeID,vdfVendorID,vdfWCSecurityDelegate,idfRowAction,idfRowKey) 

VALUES (11886, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0,'','','','','','','',
'','','','','','','','','','','', '20180102','','Monthly Snow Removal Contract for 1730 Clifton Pl.', 0, 
1, 0, 0, 0, 0, '20180102','','1802-1', NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, 21, 0, 3, 0, NULL, NULL, NULL, NULL, 268, 268, NULL, NULL, 
0, 0,'','','', NULL, NULL, NULL, NULL, NULL,'','','', 0, 0,
0, 0, 0, 0, 0, 0, 0, 0,'','','','','','','',
'','','', 1, 1, 1,'','Z-US$','PRIMARY','','Z-US$','131200-3167','','WERTC\sasinasamreth',''
,'Samreth Sasina','','','48891','','UN', 0)



select idfAPVendorKey,* from RQHeader
select edfVendor,* from RQDetail