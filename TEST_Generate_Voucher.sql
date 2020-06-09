BEGIN TRAN

CREATE TABLE #APVoucher (
idfVendorID VARCHAR(30)
,idfCurrencyID VARCHAR(20)
,idfAddressIDPurch VARCHAR(60)
,idfAttentionPurch VARCHAR(60)
,idfAddressIDRemitTo VARCHAR(60)
,idfAttentionRemitTo VARCHAR(60)
,idfRCTNumber VARCHAR(60)
,idfFOBID VARCHAR(20)
,idfShippingMethodID VARCHAR(40)
,idfTaxScheduleID VARCHAR(60)
,idfVendorClassID VARCHAR(20)
,idfPaymentTermID VARCHAR(100)
,idfOrganizationID VARCHAR(20)
,idfAddressIDBranch VARCHAR(30)
,vdfCompanyCodeSource VARCHAR(60)
,vdfCompanyCodeTarget VARCHAR(60)
,vdfMatchedPO VARCHAR(255)
,vdfComment VARCHAR(60)
,idfEmployeeID VARCHAR(20)
,vdfEmployee VARCHAR(256)
,vdfReceiver VARCHAR(256)
,idfEXPRevHdrKey VARCHAR(3)
,idfAPVoucherKey INT
,idfAmountDiscount NUMERIC(19,5)
,idfAmountDiscountApr NUMERIC(19,5)
,idfAmountDiscountHome NUMERIC(19,5)
,idfAmountExtended NUMERIC(19,5)
,idfAmountExtendedApr NUMERIC(19,5)
,idfAmountExtendedHome NUMERIC(19,5)
,idfAmountFreight NUMERIC(19,5)
,idfAmountFreightApr NUMERIC(19,5)
,idfAmountFreightHome NUMERIC(19,5)
,idfAmountMisc NUMERIC(19,5)
,idfAmountMiscApr NUMERIC(19,5)
,idfAmountMiscHome NUMERIC(19,5)
,idfAmountSubTotal NUMERIC(19,5)
,idfAmountSubTotalApr NUMERIC(19,5)
,idfAmountSubTotalHome NUMERIC(19,5)
,idfAmountTax NUMERIC(19,5)
,idfAmountTaxApr NUMERIC(19,5)
,idfAmountTaxHome NUMERIC(19,5)
,idfAmountTaxIncluded NUMERIC(19,5)
,idfAmountTaxIncludedApr NUMERIC(19,5)
,idfAmountTaxIncludedHome NUMERIC(19,5)
,idfAppConnCreated INT
,idfAppConnCreatedDate DATETIME
,idfAppConnError TEXT
,idfAppConnWarning INT
,idfComment TEXT
,idfCurrencyRateHome NUMERIC(19,5)
,idfDateDiscount DATETIME
,idfDateDue DATETIME
,idfDateInvReceived DATETIME
,idfDatePosted DATETIME
,idfDateTransaction DATETIME
,idfDocument01 VARCHAR(60)
,idfDocument02 VARCHAR(60)
,idfFlagPosted INT
,idfInvoiceNumber VARCHAR(60)
,idfPurchAddr1 VARCHAR(65)
,idfPurchAddr2 VARCHAR(65)
,idfPurchAddr3 VARCHAR(65)
,idfPurchAltPhone1 VARCHAR(40)
,idfPurchAltPhone2 VARCHAR(40)
,idfPurchAltPhoneExt1 VARCHAR(20)
,idfPurchAltPhoneExt2 VARCHAR(20)
,idfPurchCity VARCHAR(40)
,idfPurchContact VARCHAR(255)
,idfPurchCountry VARCHAR(65)
,idfPurchFax VARCHAR(40)
,idfPurchName VARCHAR(255)
,idfPurchState VARCHAR(40)
,idfPurchZipCode VARCHAR(40)
,idfRemitToAddr1 VARCHAR(65)
,idfRemitToAddr2 VARCHAR(65)
,idfRemitToAddr3 VARCHAR(65)
,idfRemitToAltPhone1 VARCHAR(40)
,idfRemitToAltPhone2 VARCHAR(40)
,idfRemitToAltPhoneExt1 VARCHAR(20)
,idfRemitToAltPhoneExt2 VARCHAR(20)
,idfRemitToCity VARCHAR(40)
,idfRemitToContact VARCHAR(255)
,idfRemitToCountry VARCHAR(65)
,idfRemitToFax VARCHAR(40)
,idfRemitToName VARCHAR(255)
,idfRemitToState VARCHAR(40)
,idfRemitToZipCode VARCHAR(40)
,idfType INT
,idfVoucherNumber VARCHAR(60)
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfAPAddressKeyPurch INT
,idfAPAddressKeyRemitTo INT
,idfAPVendorKey INT
,idfPTICurrencyKey INT
,idfRCVHeaderKey INT
,idfWCAddressKeyBranch INT
,idfWCBatchKey INT
,idfWCFOBKey INT
,idfWCICCompanyKeySource INT
,idfWCICCompanyKeyTarget INT
,idfWCOrganizationKey INT
,idfWCPaymentTermKey INT
,idfWCShippingMethodKey INT
,idfWCTaxScheduleHdrKey INT
,udfNumericField01 NUMERIC(19,5)
,udfNumericField02 NUMERIC(19,5)
,udfNumericField03 NUMERIC(19,5)
,udfNumericField04 NUMERIC(19,5)
,udfNumericField05 NUMERIC(19,5)
,udfTextField01 VARCHAR(60)
,udfTextField02 VARCHAR(60)
,udfTextField03 VARCHAR(60)
,udfTextField04 VARCHAR(60)
,udfTextField05 VARCHAR(60)
,idfBatchID VARCHAR(65)
,vdfRateTypeId VARCHAR(20)
,idfCurrencyRateHome1 NUMERIC(19,5)
)

CREATE TABLE #APVoucherDtl (
idfFOBID VARCHAR(20)
,idfShippingMethodID VARCHAR(40)
,idfTaxScheduleID VARCHAR(60)
,idfGLID VARCHAR(256)
,idfAPVoucherDtlKey INT
,idfAmountAppliedCM NUMERIC(19,5)
,idfAmountDiscount NUMERIC(19,5)
,idfAmountDiscountApr NUMERIC(19,5)
,idfAmountDiscountHome NUMERIC(19,5)
,idfAmountExtended NUMERIC(19,5)
,idfAmountExtendedApr NUMERIC(19,5)
,idfAmountExtendedHome NUMERIC(19,5)
,idfAmountFreight NUMERIC(19,5)
,idfAmountFreightApr NUMERIC(19,5)
,idfAmountFreightHome NUMERIC(19,5)
,idfAmountMisc NUMERIC(19,5)
,idfAmountMiscApr NUMERIC(19,5)
,idfAmountMiscHome NUMERIC(19,5)
,idfAmountSubTotal NUMERIC(19,5)
,idfAmountSubTotalApr NUMERIC(19,5)
,idfAmountSubTotalHome NUMERIC(19,5)
,idfAmountTax NUMERIC(19,5)
,idfAmountTaxApr NUMERIC(19,5)
,idfAmountTaxHome NUMERIC(19,5)
,idfAmountTaxIncluded NUMERIC(19,5)
,idfAmountTaxIncludedApr NUMERIC(19,5)
,idfAmountTaxIncludedHome NUMERIC(19,5)
,idfComment TEXT
,idfDescription VARCHAR(255)
,idfDocument01 VARCHAR(60)
,idfDocument02 VARCHAR(60)
,idfFlagFullyAppliedCM INT
,idfPrice NUMERIC(19,5)
,idfPricePrec INT
,idfQty NUMERIC(19,5)
,idfQtyPrec INT
,idfTableLinkName VARCHAR(80)
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfAPTaxTypeDtlKey INT
,idfAPVoucherKey INT
,idfGLAccountKey INT
,idfGLReferenceKey INT
,idfPAPhaseActivityKey INT
,idfPAProjectKey INT
,idfPAProjectPhaseKey INT
,idfTableLinkKey INT
,idfWCFOBKey INT
,idfWCICCompanyKeySource INT
,idfWCICCompanyKeyTarget INT
,idfWCShippingMethodKey INT
,idfWCTaxScheduleHdrKey INT
,udfNumericField01 NUMERIC(19,5)
,udfNumericField02 NUMERIC(19,5)
,udfNumericField03 NUMERIC(19,5)
,udfNumericField04 NUMERIC(19,5)
,udfNumericField05 NUMERIC(19,5)
,udfTextField01 VARCHAR(60)
,udfTextField02 VARCHAR(60)
,udfTextField03 VARCHAR(60)
,udfTextField04 VARCHAR(60)
,udfTextField05 VARCHAR(60)
,idfPONumber VARCHAR(60)
,idfPOLine INT
,idfQtyOrdered NUMERIC(19,5)
,idfQtyReturned NUMERIC(19,5)
,idfIVUOMID VARCHAR(40)
,idfItemID VARCHAR(100)
,idfReferenceID VARCHAR(40)
,vdfCompanyCodeSource VARCHAR(60)
,vdfCompanyCodeTarget VARCHAR(60)
,vdfProjectID VARCHAR(32)
,vdfPhaseID VARCHAR(32)
,vdfActivityID VARCHAR(20)
,vdfAPTaxTypeID VARCHAR(64)
,APTaxType_udfNumericField01 NUMERIC(19,5)
,vdfAPTaxTypeDtlID VARCHAR(64)
,APTaxTypeDtl_udfNumericField01 NUMERIC(19,5)
,vdfFlagLandCostDisc INT
,vdfFlagLandCostFreight INT
,vdfFlagLandCostMisc INT
,vdfFlagLandCostTax INT
)

CREATE TABLE #APVoucherDtlDistribution (
idfAPVoucherDtlDistributionKey INT
,idfAmtExtended NUMERIC(19,5)
,idfAmtExtendedHome NUMERIC(19,5)
,idfDateApply DATETIME
,idfFlagPrimary INT
,idfPercent NUMERIC(19,5)
,idfType INT
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfUserCreated VARCHAR(256)
,idfUserModified VARCHAR(256)
,idfAPVoucherDtlKey INT
,idfGLAccountKey INT
,idfGLReferenceKey INT
,idfGLSegmentDtlKey01 INT
,idfGLSegmentDtlKey02 INT
,idfGLSegmentDtlKey03 INT
,idfGLSegmentDtlKey04 INT
,idfGLSegmentDtlKey05 INT
,idfGLSegmentDtlKey06 INT
,idfGLSegmentDtlKey07 INT
,idfGLSegmentDtlKey08 INT
,idfGLSegmentDtlKey09 INT
,idfGLSegmentDtlKey10 INT
,idfGLSegmentDtlKey11 INT
,idfGLSegmentDtlKey12 INT
,idfGLSegmentDtlKey13 INT
,idfGLSegmentDtlKey14 INT
,idfGLSegmentDtlKey15 INT
,idfGLID VARCHAR(256)
)

CREATE TABLE #APVoucherDtlTax (
idfAPVoucherDtlTaxKey INT
,idfAmountTax NUMERIC(19,5)
,idfAmountTaxable NUMERIC(19,5)
,idfAmountTaxableHome NUMERIC(19,5)
,idfAmountTaxHome NUMERIC(19,5)
,idfAmountType VARCHAR(25)
,idfFlagTaxIncluded INT
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfUserCreated VARCHAR(128)
,idfUserModified VARCHAR(128)
,idfAPVoucherDtlKey INT
,idfGLAccountKey INT
,idfWCTaxClassKeyChild INT
,idfWCTaxClassKeyParent INT
,idfWCTaxKey INT
,vdfTaxID VARCHAR(60)
,vdfGLID VARCHAR(256)
,vdfClassIDVendor VARCHAR(60)
,vdfClassIDItem VARCHAR(60)
,vdfRate NUMERIC(19,5)
,idfTableLinkKey INT
,idfTableLinkName VARCHAR(80)
)

CREATE TABLE #GLJournalDtl (
idfGLJournalDtlKey INT
,idfAmount NUMERIC(19,5)
,idfAmountHome NUMERIC(19,5)
,idfDescription VARCHAR(128)
,idfDocument01 VARCHAR(128)
,idfDocument02 VARCHAR(128)
,idfFlagEncumbrance INT
,idfFlagICOffset INT
,idfRateHome NUMERIC(19,5)
,idfTableLinkName VARCHAR(80)
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfUserCreated VARCHAR(128)
,idfUserModified VARCHAR(128)
,idfGLAccountKey INT
,idfGLAccountKeyOffset INT
,idfGLJournalHdrKey INT
,idfGLPostCodeTypeKey INT
,idfGLReferenceKey INT
,idfGLSegmentDtlKey01 INT
,idfGLSegmentDtlKey02 INT
,idfGLSegmentDtlKey03 INT
,idfGLSegmentDtlKey04 INT
,idfGLSegmentDtlKey05 INT
,idfGLSegmentDtlKey06 INT
,idfGLSegmentDtlKey07 INT
,idfGLSegmentDtlKey08 INT
,idfGLSegmentDtlKey09 INT
,idfGLSegmentDtlKey10 INT
,idfGLSegmentDtlKey11 INT
,idfGLSegmentDtlKey12 INT
,idfGLSegmentDtlKey13 INT
,idfGLSegmentDtlKey14 INT
,idfGLSegmentDtlKey15 INT
,idfIVSiteKey INT
,idfPAPhaseActivityKey INT
,idfPAProjectKey INT
,idfPAProjectPhaseKey INT
,idfPTICurrencyKey INT
,idfPTICurrencyRateDtlKey INT
,idfTableLinkKey INT
,idfWCDeptKey INT
,idfWCICCompanyKey INT
,idfWCOrganizationKey INT
,idfAPVoucherKey INT
,vdfCurrencyID VARCHAR(20)
,vdfCompanyCode VARCHAR(60)
,vdfGLID VARCHAR(256)
,vdfGLIDOffset VARCHAR(256)
,vdfReferenceID VARCHAR(40)
,vdfProjectID VARCHAR(32)
,vdfPhaseID VARCHAR(32)
,vdfActivityID VARCHAR(20)
,vdfOrganizationID VARCHAR(20)
,vdfVendorName VARCHAR(300)
,vdfVendorDocNum VARCHAR(21)
)

CREATE TABLE #RQHeader (
idfRQHeaderKey INT
,idfAmtControlTotal NUMERIC(19,5)
,idfAmtDiscount NUMERIC(19,5)
,idfAmtDiscountApr NUMERIC(19,5)
,idfAmtDiscountHome NUMERIC(19,5)
,idfAmtFreight NUMERIC(19,5)
,idfAmtFreightApr NUMERIC(19,5)
,idfAmtFreightHome NUMERIC(19,5)
,idfAmtMisc NUMERIC(19,5)
,idfAmtMiscApr NUMERIC(19,5)
,idfAmtMiscHome NUMERIC(19,5)
,idfAmtSubTotal NUMERIC(19,5)
,idfAmtSubTotalApr NUMERIC(19,5)
,idfAmtSubTotalHome NUMERIC(19,5)
,idfAmtTax NUMERIC(19,5)
,idfAmtTaxApr NUMERIC(19,5)
,idfAmtTaxHome NUMERIC(19,5)
,idfAmtTaxIncluded NUMERIC(19,5)
,idfAmtTaxIncludedApr NUMERIC(19,5)
,idfAmtTaxIncludedHome NUMERIC(19,5)
,idfBatchID VARCHAR(60)
,idfBlanketInvAmt NUMERIC(19,5)
,idfBlanketInvPer NUMERIC(19,5)
,idfComment TEXT
,idfCustAddr1 VARCHAR(40)
,idfCustAddr2 VARCHAR(40)
,idfCustAddr3 VARCHAR(40)
,idfCustAddr4 VARCHAR(80)
,idfCustAddr5 VARCHAR(80)
,idfCustAddr6 VARCHAR(80)
,idfCustAltPhone1 VARCHAR(40)
,idfCustAltPhone2 VARCHAR(40)
,idfCustAltPhoneExt1 VARCHAR(20)
,idfCustAltPhoneExt2 VARCHAR(20)
,idfCustAttention VARCHAR(60)
,idfCustCity VARCHAR(40)
,idfCustCountry VARCHAR(40)
,idfCustEmail VARCHAR(255)
,idfCustFax VARCHAR(40)
,idfCustState VARCHAR(40)
,idfCustZipCode VARCHAR(40)
,idfDatePost DATETIME
,idfDelegateNote VARCHAR(60)
,idfDescription VARCHAR(60)
,idfFlagBlanketInvAmtOverride INT
,idfFlagKeepTogether INT
,idfFlagProcessed VARCHAR(120)
,idfFlagSubmitted VARCHAR(120)
,idfFlagTaxableDisc INT
,idfFlagTaxableFreight INT
,idfFlagTaxableMisc INT
,idfLastLine INT
,idfRateHome NUMERIC(19,5)
,idfRQDate DATETIME
,idfRQNumber VARCHAR(60)
,idfVendorDocNum VARCHAR(21)
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfAPAddressKeyPurch INT
,idfAPTaxTypeDtlKey INT
,idfAPVendorKey INT
,idfARCustomerAddressKey INT
,idfARCustomerKey INT
,idfPAPhaseActivityKey INT
,idfPAProjectKey INT
,idfPAProjectPhaseKey INT
,idfPTICompanyKey INT
,idfPTICurrencyKey INT
,idfRQTypeKey INT
,idfWCDeptKey INT
,idfWCICCompanyKeySource INT
,idfWCICCompanyKeyTarget INT
,idfWCOrganizationKey INT
,idfWCPaymentTermKey INT
,idfWCSecurityKey INT
,idfWCSecurityKeyCreated INT
,idfWCSecurityKeyDelegate INT
,idfWCTaxScheduleHdrKey INT
,edfAmtAprExtended NUMERIC(19,5)
,edfAmtHomeExtended NUMERIC(19,5)
,udfDateField01 DATETIME
,udfDateField02 DATETIME
,udfDateField03 DATETIME
,udfDateField04 DATETIME
,udfDateField05 DATETIME
,udfLargeTextField01 VARCHAR(255)
,udfLargeTextField02 VARCHAR(255)
,udfLargeTextField03 VARCHAR(255)
,udfNumericField01 NUMERIC(19,5)
,udfNumericField02 NUMERIC(19,5)
,udfNumericField03 NUMERIC(19,5)
,udfNumericField04 NUMERIC(19,5)
,udfNumericField05 NUMERIC(19,5)
,udfNumericField06 NUMERIC(19,5)
,udfNumericField07 NUMERIC(19,5)
,udfNumericField08 NUMERIC(19,5)
,udfNumericField09 NUMERIC(19,5)
,udfNumericField10 NUMERIC(19,5)
,udfTextField01 VARCHAR(60)
,udfTextField02 VARCHAR(60)
,udfTextField03 VARCHAR(60)
,udfTextField04 VARCHAR(60)
,udfTextField05 VARCHAR(60)
,udfTextField06 VARCHAR(60)
,udfTextField07 VARCHAR(60)
,udfTextField08 VARCHAR(60)
,udfTextField09 VARCHAR(60)
,udfTextField10 VARCHAR(60)
,idfAPVoucherDtlKey INT
)

CREATE TABLE #EXPExpenseSheetHdr (
idfEXPExpenseSheetHdrHistKey INT
,idfComment TEXT
,idfDatePosted DATETIME
,idfDescription VARCHAR(60)
,idfFlagSubmitted INT
,idfLastLine INT
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfEXPEntryTypeKey INT
,idfPTICompanyKey INT
,idfTETimePeriodKey INT
,idfWCDeptKey INT
,idfWCICCompanyKeySource INT
,idfWCSecurityKey INT
,idfWCSecurityKeyCreated INT
,idfWCUDFListDtlKey02 INT
,edfAmtAprExtended NUMERIC(19,5)
,edfAmtHomeExtended NUMERIC(19,5)
,edfAmtReimExtended NUMERIC(19,5)
,edfDocument01 VARCHAR(255)
,edfDocument02 VARCHAR(255)
,udfDateField01 DATETIME
,udfDateField02 DATETIME
,udfDateField03 DATETIME
,udfDateField04 DATETIME
,udfDateField05 DATETIME
,udfLargeTextField01 VARCHAR(255)
,udfLargeTextField02 VARCHAR(255)
,udfLargeTextField03 VARCHAR(255)
,udfNumericField01 NUMERIC(19,5)
,udfNumericField02 NUMERIC(19,5)
,udfNumericField03 NUMERIC(19,5)
,udfNumericField04 NUMERIC(19,5)
,udfNumericField05 NUMERIC(19,5)
,udfNumericField06 NUMERIC(19,5)
,udfNumericField07 NUMERIC(19,5)
,udfNumericField08 NUMERIC(19,5)
,udfNumericField09 NUMERIC(19,5)
,udfNumericField10 NUMERIC(19,5)
,udfTextField01 VARCHAR(60)
,udfTextField02 VARCHAR(60)
,udfTextField03 VARCHAR(60)
,udfTextField04 VARCHAR(60)
,udfTextField05 VARCHAR(60)
,udfTextField06 VARCHAR(60)
,udfTextField07 VARCHAR(60)
,udfTextField08 VARCHAR(60)
,udfTextField09 VARCHAR(60)
,udfTextField10 VARCHAR(60)
,idfAPVoucherDtlKey INT
)

CREATE TABLE #EXPExpenseSheetDtlSplit (
idfEXPExpenseSheetDtlSplitHistKey INT
,idfAmtExtendedReceipt NUMERIC(19,5)
,idfAmtFreightApr NUMERIC(19,5)
,idfAmtFreightHome NUMERIC(19,5)
,idfAmtMiscApr NUMERIC(19,5)
,idfAmtMiscHome NUMERIC(19,5)
,idfAmtSubTotal NUMERIC(19,5)
,idfAmtSubTotalApr NUMERIC(19,5)
,idfAmtSubTotalHome NUMERIC(19,5)
,idfAmtTax NUMERIC(19,5)
,idfAmtTaxApr NUMERIC(19,5)
,idfAmtTaxHome NUMERIC(19,5)
,idfAmtTaxIncluded NUMERIC(19,5)
,idfAmtTaxIncludedApr NUMERIC(19,5)
,idfAmtTaxIncludedHome NUMERIC(19,5)
,idfComment TEXT
,idfCurrLineUpSeq INT
,idfDay DATETIME
,idfDescription VARCHAR(255)
,idfFlagImported INT
,idfFlagManualDist INT
,idfFlagOutsidePeriod INT
,idfImportedRefNo VARCHAR(255)
,idfLine INT
,idfQuantity NUMERIC(19,5)
,idfRateHome NUMERIC(19,5)
,idfRateReimCalc NUMERIC(19,5)
,idfRateReimSystem NUMERIC(19,5)
,idfDateCreated DATETIME
,idfDateModified DATETIME
,idfAPVendorKey INT
,idfAPVoucherDtlKeyCM INT
,idfEXPEventKey INT
,idfEXPExpenseSheetDtlHistKey INT
,idfEXPPaymentKey INT
,idfEXPSessionKey INT
,idfEXPTypeKey INT
,idfGLAccountKey INT
,idfPABillTypeKey INT
,idfPAPhaseActivityKey INT
,idfPAProjectKey INT
,idfPAProjectPhaseKey INT
,idfPTICurrencyKey INT
,idfPTICurrencyKeyReceipt INT
,idfSessionLinkKey INT
,idfWCCountryKey INT
,idfWCDeptKey INT
,idfWCICCompanyKeySource INT
,idfWCICCompanyKeyTarget INT
,idfWCImportMapKey INT
,idfWCLineUpKey INT
,idfWCRRGroupLineUpKey INT
,idfWCShippingMethodKey INT
,idfWCTaxScheduleHdrKey INT
,edf1099Amount NUMERIC(19,5)
,edfAmtAprExtended NUMERIC(19,5)
,edfAmtExtended NUMERIC(19,5)
,edfAmtHomeExtended NUMERIC(19,5)
,edfAmtReimExtended NUMERIC(19,5)
,edfDocument01 VARCHAR(255)
,edfDocument02 VARCHAR(255)
,edfFreight NUMERIC(19,5)
,edfMiscCharges NUMERIC(19,5)
,edfPrice NUMERIC(19,5)
,edfTax VARCHAR(10)
,udfDateField01 DATETIME
,udfDateField02 DATETIME
,udfDateField03 DATETIME
,udfDateField04 DATETIME
,udfDateField05 DATETIME
,udfLargeTextField01 VARCHAR(255)
,udfLargeTextField02 VARCHAR(255)
,udfLargeTextField03 VARCHAR(255)
,udfNumericField01 NUMERIC(19,5)
,udfNumericField02 NUMERIC(19,5)
,udfNumericField03 NUMERIC(19,5)
,udfNumericField04 NUMERIC(19,5)
,udfNumericField05 NUMERIC(19,5)
,udfNumericField06 NUMERIC(19,5)
,udfNumericField07 NUMERIC(19,5)
,udfNumericField08 NUMERIC(19,5)
,udfNumericField09 NUMERIC(19,5)
,udfNumericField10 NUMERIC(19,5)
,udfTextField01 VARCHAR(60)
,udfTextField02 VARCHAR(60)
,udfTextField03 VARCHAR(60)
,udfTextField04 VARCHAR(60)
,udfTextField05 VARCHAR(60)
,udfTextField06 VARCHAR(60)
,udfTextField07 VARCHAR(60)
,udfTextField08 VARCHAR(60)
,udfTextField09 VARCHAR(60)
,udfTextField10 VARCHAR(60)
,idfDescriptionHeader VARCHAR(60)
,idfAPVoucherDtlKey INT
)

INSERT INTO #APVoucher 
(idfVendorID,idfCurrencyID,idfAddressIDPurch,idfAttentionPurch,idfAddressIDRemitTo,idfAttentionRemitTo,idfRCTNumber,idfFOBID,idfShippingMethodID,idfTaxScheduleID,idfVendorClassID,idfPaymentTermID,idfOrganizationID,idfAddressIDBranch,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfMatchedPO,vdfComment,idfEmployeeID,vdfEmployee,vdfReceiver,idfEXPRevHdrKey,idfAPVoucherKey,idfAmountDiscount,idfAmountDiscountApr,idfAmountDiscountHome,idfAmountExtended,idfAmountExtendedApr,idfAmountExtendedHome,idfAmountFreight,idfAmountFreightApr,idfAmountFreightHome,idfAmountMisc,idfAmountMiscApr,idfAmountMiscHome,idfAmountSubTotal,idfAmountSubTotalApr,idfAmountSubTotalHome,idfAmountTax,idfAmountTaxApr,idfAmountTaxHome,idfAmountTaxIncluded,idfAmountTaxIncludedApr,idfAmountTaxIncludedHome,idfAppConnCreated,idfAppConnCreatedDate,idfAppConnError,idfAppConnWarning,idfComment,idfCurrencyRateHome,idfDateDiscount,idfDateDue,idfDateInvReceived,idfDatePosted,idfDateTransaction,idfDocument01,idfDocument02,idfFlagPosted,idfInvoiceNumber,idfPurchAddr1,idfPurchAddr2,idfPurchAddr3,idfPurchAltPhone1,idfPurchAltPhone2,idfPurchAltPhoneExt1,idfPurchAltPhoneExt2,idfPurchCity,idfPurchContact,idfPurchCountry,idfPurchFax,idfPurchName,idfPurchState,idfPurchZipCode,idfRemitToAddr1,idfRemitToAddr2,idfRemitToAddr3,idfRemitToAltPhone1,idfRemitToAltPhone2,idfRemitToAltPhoneExt1,idfRemitToAltPhoneExt2,idfRemitToCity,idfRemitToContact,idfRemitToCountry,idfRemitToFax,idfRemitToName,idfRemitToState,idfRemitToZipCode,idfType,idfVoucherNumber,idfDateCreated,idfDateModified,idfAPAddressKeyPurch,idfAPAddressKeyRemitTo,idfAPVendorKey,idfPTICurrencyKey,idfRCVHeaderKey,idfWCAddressKeyBranch,idfWCBatchKey,idfWCFOBKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCOrganizationKey,idfWCPaymentTermKey,idfWCShippingMethodKey,idfWCTaxScheduleHdrKey,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,idfBatchID,vdfRateTypeId,idfCurrencyRateHome1) VALUES('VISA-BILLING   '
,'Z-AUD          '
,'MAIN           '
,'                                                            '
,'MAIN           '
,'                                                            '
,''
,''
,''
,'A_TAXABLE      '
,'CCARD'
,'Prompt               '
,''
,''
,'BDOGH'
,''
,''
,'S Levine CNS & DWN travel'
,'11471'
,'bdoau\slevine'
,''
,'142'
,9061
,0.00000
,0.00000
,0.00000
,1067.60000
,1067.60000
,1067.60000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,1067.60000
,1067.60000
,1067.60000
,0.00000
,0.00000
,0.00000
,56.41000
,38.80000
,56.41000
,0
,'19000101'
,''
,0
,''
,1.00000
,'20190312'
,'20190312'
,'20190312'
,'20190312'
,'20190312'
,'EXPHDR:5123'
,'EXPREV:142'
,0
,'EX05123-19'
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,7
,'WPV06832'
,'20190312'
,'20190312'
,null
,null
,4505
,1
,null
,null
,null
,null
,2
,null
,null
,11
,null
,180
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,'BUY            '
,1.00000
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72449
,13.20000
,13.20000
,'125-5740 CT booking fee for SL travel for IFRS f2F training in CNS & DWN'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,2633
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14882
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,'00-500-00-000-9000'
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72450
,-13.20000
,-13.20000
,'125-5740 CT booking fee for SL travel for IFRS f2F training in CNS & DWN'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2633
,null
,9039
,20000
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14882
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-9000'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72451
,1.20000
,1.20000
,'125-5740 CT booking fee for SL travel for IFRS f2F training in CNS & DWN'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,1509
,null
,9039
,20500
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14882
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-000-00-000-8105'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72452
,-1.20000
,-1.20000
,'125-5740 CT booking fee for SL travel for IFRS f2F training in CNS & DWN'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,null
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14882
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72453
,128.99000
,128.99000
,'125-5740 SL Accom in DWN for IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,2633
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14883
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,'00-500-00-000-9000'
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72454
,-128.99000
,-128.99000
,'125-5740 SL Accom in DWN for IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2633
,null
,9039
,20000
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14883
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-9000'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72455
,193.79000
,193.79000
,'125-5740 SL flight CNS to DWN for IFRS F2F facilitation'''
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,2633
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14884
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,'00-500-00-000-9000'
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72456
,-193.79000
,-193.79000
,'125-5740 SL flight CNS to DWN for IFRS F2F facilitation'''
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2633
,null
,9039
,20000
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14884
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-9000'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72457
,17.61000
,17.61000
,'125-5740 SL flight CNS to DWN for IFRS F2F facilitation'''
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,1509
,null
,9039
,20500
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14884
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-000-00-000-8105'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72458
,-17.61000
,-17.61000
,'125-5740 SL flight CNS to DWN for IFRS F2F facilitation'''
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,null
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14884
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72459
,318.00000
,318.00000
,'125-5740 SL Accom in CNS for IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,2633
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14885
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,'00-500-00-000-9000'
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72460
,-318.00000
,-318.00000
,'125-5740 SL Accom in CNS for IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2633
,null
,9039
,20000
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14885
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-9000'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72461
,413.62000
,413.62000
,'125-5740 SL flights SYD - CNS, DWN - SYD IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,2633
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14886
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,'00-500-00-000-9000'
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72462
,-413.62000
,-413.62000
,'125-5740 SL flights SYD - CNS, DWN - SYD IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2633
,null
,9039
,20000
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14886
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-9000'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72463
,37.60000
,37.60000
,'125-5740 SL flights SYD - CNS, DWN - SYD IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,1509
,null
,9039
,20500
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14886
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-000-00-000-8105'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #GLJournalDtl (idfGLJournalDtlKey,idfAmount,idfAmountHome,idfDescription,idfDocument01,idfDocument02,idfFlagEncumbrance,idfFlagICOffset,idfRateHome,idfTableLinkName,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfGLAccountKey,idfGLAccountKeyOffset,idfGLJournalHdrKey,idfGLPostCodeTypeKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfIVSiteKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfPTICurrencyKey,idfPTICurrencyRateDtlKey,idfTableLinkKey,idfWCDeptKey,idfWCICCompanyKey,idfWCOrganizationKey,idfAPVoucherKey,vdfCurrencyID,vdfCompanyCode,vdfGLID,vdfGLIDOffset,vdfReferenceID,vdfProjectID,vdfPhaseID,vdfActivityID,vdfOrganizationID,vdfVendorName,vdfVendorDocNum) VALUES(72464
,-37.60000
,-37.60000
,'125-5740 SL flights SYD - CNS, DWN - SYD IFRS F2F facilitation'
,'5123'
,''
,0
,0
,1.00000
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,2141
,null
,9039
,20100
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,530356
,16270
,40803
,1
,null
,14886
,92
,2
,null
,9061
,'Z-AUD          '
,'BDOGH'
,'00-500-00-000-8120'
,''
,''
,'~N/A'
,'~N/A'
,'~N/A'
,''
,''
,'                     '
)
INSERT INTO #APVoucherDtl (idfFOBID,idfShippingMethodID,idfTaxScheduleID,idfGLID,idfAPVoucherDtlKey,idfAmountAppliedCM,idfAmountDiscount,idfAmountDiscountApr,idfAmountDiscountHome,idfAmountExtended,idfAmountExtendedApr,idfAmountExtendedHome,idfAmountFreight,idfAmountFreightApr,idfAmountFreightHome,idfAmountMisc,idfAmountMiscApr,idfAmountMiscHome,idfAmountSubTotal,idfAmountSubTotalApr,idfAmountSubTotalHome,idfAmountTax,idfAmountTaxApr,idfAmountTaxHome,idfAmountTaxIncluded,idfAmountTaxIncludedApr,idfAmountTaxIncludedHome,idfComment,idfDescription,idfDocument01,idfDocument02,idfFlagFullyAppliedCM,idfPrice,idfPricePrec,idfQty,idfQtyPrec,idfTableLinkName,idfDateCreated,idfDateModified,idfAPTaxTypeDtlKey,idfAPVoucherKey,idfGLAccountKey,idfGLReferenceKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfTableLinkKey,idfWCFOBKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCShippingMethodKey,idfWCTaxScheduleHdrKey,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,idfPONumber,idfPOLine,idfQtyOrdered,idfQtyReturned,idfIVUOMID,idfItemID,idfReferenceID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfProjectID,vdfPhaseID,vdfActivityID,vdfAPTaxTypeID,APTaxType_udfNumericField01,vdfAPTaxTypeDtlID,APTaxTypeDtl_udfNumericField01,vdfFlagLandCostDisc,vdfFlagLandCostFreight,vdfFlagLandCostMisc,vdfFlagLandCostTax) VALUES(''
,'ACQUISITION    '
,'A_TAXABLE      '
,'00-500-00-000-8120'
,21072
,0.00000
,0.00000
,0.00000
,0.00000
,13.20000
,13.20000
,13.20000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,13.20000
,13.20000
,13.20000
,0.00000
,0.00000
,0.00000
,1.20000
,1.20000
,1.20000
,'Purchase (Original Amount $13.20)
 Corp TravellerB4807054'
,'125-5740 CT booking fee for SL travel for IFRS f2F training in CNS & DWN'
,'EXPDTL:14882'
,''
,0
,13.20000
,5
,1.00000
,5
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,null
,9061
,2141
,null
,530356
,16270
,40803
,14882
,null
,null
,2
,3
,180
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,0
,0.00000
,0.00000
,''
,''
,''
,''
,'BDOGH'
,'~N/A'
,'~N/A'
,'~N/A'
,''
,0.00000
,''
,0.00000
,0
,0
,0
,0
)
INSERT INTO #APVoucherDtlDistribution (idfAPVoucherDtlDistributionKey,idfAmtExtended,idfAmtExtendedHome,idfDateApply,idfFlagPrimary,idfPercent,idfType,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfGLID) VALUES(21073
,12.00000
,12.00000
,'20190301'
,1
,100.00000
,0
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21072
,2141
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,'00-500-00-000-8120'
)
INSERT INTO #APVoucherDtlTax (idfAPVoucherDtlTaxKey,idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfFlagTaxIncluded,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfWCTaxClassKeyChild,idfWCTaxClassKeyParent,idfWCTaxKey,vdfTaxID,vdfGLID,vdfClassIDVendor,vdfClassIDItem,vdfRate,idfTableLinkKey,idfTableLinkName) VALUES(19615
,1.20000
,12.00000
,12.00000
,1.20000
,'::TAXDETAIL_TOTAL::'
,1
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21072
,1509
,null
,null
,15
,'A_TAXABLE      '
,'00-000-00-000-8105'
,''
,''
,0.00000
,14882
,'EXPExpenseSheetDtl'
)
INSERT INTO #APVoucherDtl (idfFOBID,idfShippingMethodID,idfTaxScheduleID,idfGLID,idfAPVoucherDtlKey,idfAmountAppliedCM,idfAmountDiscount,idfAmountDiscountApr,idfAmountDiscountHome,idfAmountExtended,idfAmountExtendedApr,idfAmountExtendedHome,idfAmountFreight,idfAmountFreightApr,idfAmountFreightHome,idfAmountMisc,idfAmountMiscApr,idfAmountMiscHome,idfAmountSubTotal,idfAmountSubTotalApr,idfAmountSubTotalHome,idfAmountTax,idfAmountTaxApr,idfAmountTaxHome,idfAmountTaxIncluded,idfAmountTaxIncludedApr,idfAmountTaxIncludedHome,idfComment,idfDescription,idfDocument01,idfDocument02,idfFlagFullyAppliedCM,idfPrice,idfPricePrec,idfQty,idfQtyPrec,idfTableLinkName,idfDateCreated,idfDateModified,idfAPTaxTypeDtlKey,idfAPVoucherKey,idfGLAccountKey,idfGLReferenceKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfTableLinkKey,idfWCFOBKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCShippingMethodKey,idfWCTaxScheduleHdrKey,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,idfPONumber,idfPOLine,idfQtyOrdered,idfQtyReturned,idfIVUOMID,idfItemID,idfReferenceID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfProjectID,vdfPhaseID,vdfActivityID,vdfAPTaxTypeID,APTaxType_udfNumericField01,vdfAPTaxTypeDtlID,APTaxTypeDtl_udfNumericField01,vdfFlagLandCostDisc,vdfFlagLandCostFreight,vdfFlagLandCostMisc,vdfFlagLandCostTax) VALUES(''
,'ACQUISITION    '
,'A_TAXABLE      '
,'00-500-00-000-8120'
,21073
,0.00000
,0.00000
,0.00000
,0.00000
,128.99000
,128.99000
,128.99000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,128.99000
,128.99000
,128.99000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,'Purchase (Original Amount $128.99)
 HOTEL*8135447702703'
,'125-5740 SL Accom in DWN for IFRS F2F facilitation'
,'EXPDTL:14883'
,''
,0
,128.99000
,5
,1.00000
,5
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,null
,9061
,2141
,null
,530356
,16270
,40803
,14883
,null
,null
,2
,3
,180
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,0
,0.00000
,0.00000
,''
,''
,''
,''
,'BDOGH'
,'~N/A'
,'~N/A'
,'~N/A'
,''
,0.00000
,''
,0.00000
,0
,0
,0
,0
)
INSERT INTO #APVoucherDtlDistribution (idfAPVoucherDtlDistributionKey,idfAmtExtended,idfAmtExtendedHome,idfDateApply,idfFlagPrimary,idfPercent,idfType,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfGLID) VALUES(21074
,128.99000
,128.99000
,'20190301'
,1
,100.00000
,0
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21073
,2141
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,'00-500-00-000-8120'
)
INSERT INTO #APVoucherDtlTax (idfAPVoucherDtlTaxKey,idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfFlagTaxIncluded,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfWCTaxClassKeyChild,idfWCTaxClassKeyParent,idfWCTaxKey,vdfTaxID,vdfGLID,vdfClassIDVendor,vdfClassIDItem,vdfRate,idfTableLinkKey,idfTableLinkName) VALUES(19616
,0.00000
,0.00000
,0.00000
,0.00000
,'::TAXDETAIL_TOTAL::'
,0
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21073
,1509
,null
,null
,15
,'A_TAXABLE      '
,'00-000-00-000-8105'
,''
,''
,0.00000
,14883
,'EXPExpenseSheetDtl'
)
INSERT INTO #APVoucherDtl (idfFOBID,idfShippingMethodID,idfTaxScheduleID,idfGLID,idfAPVoucherDtlKey,idfAmountAppliedCM,idfAmountDiscount,idfAmountDiscountApr,idfAmountDiscountHome,idfAmountExtended,idfAmountExtendedApr,idfAmountExtendedHome,idfAmountFreight,idfAmountFreightApr,idfAmountFreightHome,idfAmountMisc,idfAmountMiscApr,idfAmountMiscHome,idfAmountSubTotal,idfAmountSubTotalApr,idfAmountSubTotalHome,idfAmountTax,idfAmountTaxApr,idfAmountTaxHome,idfAmountTaxIncluded,idfAmountTaxIncludedApr,idfAmountTaxIncludedHome,idfComment,idfDescription,idfDocument01,idfDocument02,idfFlagFullyAppliedCM,idfPrice,idfPricePrec,idfQty,idfQtyPrec,idfTableLinkName,idfDateCreated,idfDateModified,idfAPTaxTypeDtlKey,idfAPVoucherKey,idfGLAccountKey,idfGLReferenceKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfTableLinkKey,idfWCFOBKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCShippingMethodKey,idfWCTaxScheduleHdrKey,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,idfPONumber,idfPOLine,idfQtyOrdered,idfQtyReturned,idfIVUOMID,idfItemID,idfReferenceID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfProjectID,vdfPhaseID,vdfActivityID,vdfAPTaxTypeID,APTaxType_udfNumericField01,vdfAPTaxTypeDtlID,APTaxTypeDtl_udfNumericField01,vdfFlagLandCostDisc,vdfFlagLandCostFreight,vdfFlagLandCostMisc,vdfFlagLandCostTax) VALUES(''
,'ACQUISITION    '
,'A_TAXABLE      '
,'00-500-00-000-8120'
,21074
,0.00000
,0.00000
,0.00000
,0.00000
,193.79000
,193.79000
,193.79000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,193.79000
,193.79000
,193.79000
,0.00000
,0.00000
,0.00000
,17.61000
,0.00000
,17.61000
,'Purchase (Original Amount $193.79)
 JETSTAR'
,'125-5740 SL flight CNS to DWN for IFRS F2F facilitation'''
,'EXPDTL:14884'
,''
,0
,193.79000
,5
,1.00000
,5
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,null
,9061
,2141
,null
,530356
,16270
,40803
,14884
,null
,null
,2
,3
,180
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,0
,0.00000
,0.00000
,''
,''
,''
,''
,'BDOGH'
,'~N/A'
,'~N/A'
,'~N/A'
,''
,0.00000
,''
,0.00000
,0
,0
,0
,0
)
INSERT INTO #APVoucherDtlDistribution (idfAPVoucherDtlDistributionKey,idfAmtExtended,idfAmtExtendedHome,idfDateApply,idfFlagPrimary,idfPercent,idfType,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfGLID) VALUES(21075
,176.18000
,176.18000
,'20190301'
,1
,100.00000
,0
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21074
,2141
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,'00-500-00-000-8120'
)
INSERT INTO #APVoucherDtlTax (idfAPVoucherDtlTaxKey,idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfFlagTaxIncluded,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfWCTaxClassKeyChild,idfWCTaxClassKeyParent,idfWCTaxKey,vdfTaxID,vdfGLID,vdfClassIDVendor,vdfClassIDItem,vdfRate,idfTableLinkKey,idfTableLinkName) VALUES(19617
,17.61000
,176.18000
,176.18000
,17.61000
,'::TAXDETAIL_TOTAL::'
,1
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21074
,1509
,null
,null
,15
,'A_TAXABLE      '
,'00-000-00-000-8105'
,''
,''
,0.00000
,14884
,'EXPExpenseSheetDtl'
)
INSERT INTO #APVoucherDtl (idfFOBID,idfShippingMethodID,idfTaxScheduleID,idfGLID,idfAPVoucherDtlKey,idfAmountAppliedCM,idfAmountDiscount,idfAmountDiscountApr,idfAmountDiscountHome,idfAmountExtended,idfAmountExtendedApr,idfAmountExtendedHome,idfAmountFreight,idfAmountFreightApr,idfAmountFreightHome,idfAmountMisc,idfAmountMiscApr,idfAmountMiscHome,idfAmountSubTotal,idfAmountSubTotalApr,idfAmountSubTotalHome,idfAmountTax,idfAmountTaxApr,idfAmountTaxHome,idfAmountTaxIncluded,idfAmountTaxIncludedApr,idfAmountTaxIncludedHome,idfComment,idfDescription,idfDocument01,idfDocument02,idfFlagFullyAppliedCM,idfPrice,idfPricePrec,idfQty,idfQtyPrec,idfTableLinkName,idfDateCreated,idfDateModified,idfAPTaxTypeDtlKey,idfAPVoucherKey,idfGLAccountKey,idfGLReferenceKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfTableLinkKey,idfWCFOBKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCShippingMethodKey,idfWCTaxScheduleHdrKey,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,idfPONumber,idfPOLine,idfQtyOrdered,idfQtyReturned,idfIVUOMID,idfItemID,idfReferenceID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfProjectID,vdfPhaseID,vdfActivityID,vdfAPTaxTypeID,APTaxType_udfNumericField01,vdfAPTaxTypeDtlID,APTaxTypeDtl_udfNumericField01,vdfFlagLandCostDisc,vdfFlagLandCostFreight,vdfFlagLandCostMisc,vdfFlagLandCostTax) VALUES(''
,'ACQUISITION    '
,'A_TAXABLE      '
,'00-500-00-000-8120'
,21075
,0.00000
,0.00000
,0.00000
,0.00000
,318.00000
,318.00000
,318.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,318.00000
,318.00000
,318.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,'Purchase (Original Amount $318.00)
 HOTEL*8139770509001'
,'125-5740 SL Accom in CNS for IFRS F2F facilitation'
,'EXPDTL:14885'
,''
,0
,318.00000
,5
,1.00000
,5
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,null
,9061
,2141
,null
,530356
,16270
,40803
,14885
,null
,null
,2
,3
,180
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,0
,0.00000
,0.00000
,''
,''
,''
,''
,'BDOGH'
,'~N/A'
,'~N/A'
,'~N/A'
,''
,0.00000
,''
,0.00000
,0
,0
,0
,0
)
INSERT INTO #APVoucherDtlDistribution (idfAPVoucherDtlDistributionKey,idfAmtExtended,idfAmtExtendedHome,idfDateApply,idfFlagPrimary,idfPercent,idfType,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfGLID) VALUES(21076
,318.00000
,318.00000
,'20190301'
,1
,100.00000
,0
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21075
,2141
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,'00-500-00-000-8120'
)
INSERT INTO #APVoucherDtlTax (idfAPVoucherDtlTaxKey,idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfFlagTaxIncluded,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfWCTaxClassKeyChild,idfWCTaxClassKeyParent,idfWCTaxKey,vdfTaxID,vdfGLID,vdfClassIDVendor,vdfClassIDItem,vdfRate,idfTableLinkKey,idfTableLinkName) VALUES(19618
,0.00000
,0.00000
,0.00000
,0.00000
,'::TAXDETAIL_TOTAL::'
,0
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21075
,1509
,null
,null
,15
,'A_TAXABLE      '
,'00-000-00-000-8105'
,''
,''
,0.00000
,14885
,'EXPExpenseSheetDtl'
)
INSERT INTO #APVoucherDtl (idfFOBID,idfShippingMethodID,idfTaxScheduleID,idfGLID,idfAPVoucherDtlKey,idfAmountAppliedCM,idfAmountDiscount,idfAmountDiscountApr,idfAmountDiscountHome,idfAmountExtended,idfAmountExtendedApr,idfAmountExtendedHome,idfAmountFreight,idfAmountFreightApr,idfAmountFreightHome,idfAmountMisc,idfAmountMiscApr,idfAmountMiscHome,idfAmountSubTotal,idfAmountSubTotalApr,idfAmountSubTotalHome,idfAmountTax,idfAmountTaxApr,idfAmountTaxHome,idfAmountTaxIncluded,idfAmountTaxIncludedApr,idfAmountTaxIncludedHome,idfComment,idfDescription,idfDocument01,idfDocument02,idfFlagFullyAppliedCM,idfPrice,idfPricePrec,idfQty,idfQtyPrec,idfTableLinkName,idfDateCreated,idfDateModified,idfAPTaxTypeDtlKey,idfAPVoucherKey,idfGLAccountKey,idfGLReferenceKey,idfPAPhaseActivityKey,idfPAProjectKey,idfPAProjectPhaseKey,idfTableLinkKey,idfWCFOBKey,idfWCICCompanyKeySource,idfWCICCompanyKeyTarget,idfWCShippingMethodKey,idfWCTaxScheduleHdrKey,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,idfPONumber,idfPOLine,idfQtyOrdered,idfQtyReturned,idfIVUOMID,idfItemID,idfReferenceID,vdfCompanyCodeSource,vdfCompanyCodeTarget,vdfProjectID,vdfPhaseID,vdfActivityID,vdfAPTaxTypeID,APTaxType_udfNumericField01,vdfAPTaxTypeDtlID,APTaxTypeDtl_udfNumericField01,vdfFlagLandCostDisc,vdfFlagLandCostFreight,vdfFlagLandCostMisc,vdfFlagLandCostTax) VALUES(''
,'ACQUISITION    '
,'A_TAXABLE      '
,'00-500-00-000-8120'
,21076
,0.00000
,0.00000
,0.00000
,0.00000
,413.62000
,413.62000
,413.62000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,413.62000
,413.62000
,413.62000
,0.00000
,0.00000
,0.00000
,37.60000
,37.60000
,37.60000
,'Purchase (Original Amount $413.62)
 VIRGIN AUST'
,'125-5740 SL flights SYD - CNS, DWN - SYD IFRS F2F facilitation'
,'EXPDTL:14886'
,''
,0
,413.62000
,5
,1.00000
,5
,'EXPExpenseSheetDtl'
,'20190312'
,'20190312'
,null
,9061
,2141
,null
,530356
,16270
,40803
,14886
,null
,null
,2
,3
,180
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,0
,0.00000
,0.00000
,''
,''
,''
,''
,'BDOGH'
,'~N/A'
,'~N/A'
,'~N/A'
,''
,0.00000
,''
,0.00000
,0
,0
,0
,0
)
INSERT INTO #APVoucherDtlDistribution (idfAPVoucherDtlDistributionKey,idfAmtExtended,idfAmtExtendedHome,idfDateApply,idfFlagPrimary,idfPercent,idfType,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfGLReferenceKey,idfGLSegmentDtlKey01,idfGLSegmentDtlKey02,idfGLSegmentDtlKey03,idfGLSegmentDtlKey04,idfGLSegmentDtlKey05,idfGLSegmentDtlKey06,idfGLSegmentDtlKey07,idfGLSegmentDtlKey08,idfGLSegmentDtlKey09,idfGLSegmentDtlKey10,idfGLSegmentDtlKey11,idfGLSegmentDtlKey12,idfGLSegmentDtlKey13,idfGLSegmentDtlKey14,idfGLSegmentDtlKey15,idfGLID) VALUES(21077
,376.02000
,376.02000
,'20190304'
,1
,100.00000
,0
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21076
,2141
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,null
,'00-500-00-000-8120'
)
INSERT INTO #APVoucherDtlTax (idfAPVoucherDtlTaxKey,idfAmountTax,idfAmountTaxable,idfAmountTaxableHome,idfAmountTaxHome,idfAmountType,idfFlagTaxIncluded,idfDateCreated,idfDateModified,idfUserCreated,idfUserModified,idfAPVoucherDtlKey,idfGLAccountKey,idfWCTaxClassKeyChild,idfWCTaxClassKeyParent,idfWCTaxKey,vdfTaxID,vdfGLID,vdfClassIDVendor,vdfClassIDItem,vdfRate,idfTableLinkKey,idfTableLinkName) VALUES(19619
,37.60000
,376.02000
,376.02000
,37.60000
,'::TAXDETAIL_TOTAL::'
,1
,'20190312'
,'20190312'
,'WorkPlaceUser'
,'WorkPlaceUser'
,21076
,1509
,null
,null
,15
,'A_TAXABLE      '
,'00-000-00-000-8105'
,''
,''
,0.00000
,14886
,'EXPExpenseSheetDtl'
)
INSERT INTO #EXPExpenseSheetHdr (idfEXPExpenseSheetHdrHistKey,idfComment,idfDatePosted,idfDescription,idfFlagSubmitted,idfLastLine,idfDateCreated,idfDateModified,idfEXPEntryTypeKey,idfPTICompanyKey,idfTETimePeriodKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCSecurityKey,idfWCSecurityKeyCreated,idfWCUDFListDtlKey02,edfAmtAprExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfAPVoucherDtlKey) VALUES(5123
,''
,'20190312'
,'S Levine CNS & DWN travel'
,1
,5
,'20190311'
,'20190312'
,1
,1
,-1
,92
,null
,373
,372
,null
,1067.60000
,1067.60000
,0.00000
,'EX05123-19'
,''
,null
,null
,null
,null
,null
,''
,''
,''
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,21072
)
INSERT INTO #EXPExpenseSheetHdr (idfEXPExpenseSheetHdrHistKey,idfComment,idfDatePosted,idfDescription,idfFlagSubmitted,idfLastLine,idfDateCreated,idfDateModified,idfEXPEntryTypeKey,idfPTICompanyKey,idfTETimePeriodKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCSecurityKey,idfWCSecurityKeyCreated,idfWCUDFListDtlKey02,edfAmtAprExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfAPVoucherDtlKey) VALUES(5123
,''
,'20190312'
,'S Levine CNS & DWN travel'
,1
,5
,'20190311'
,'20190312'
,1
,1
,-1
,92
,null
,373
,372
,null
,1067.60000
,1067.60000
,0.00000
,'EX05123-19'
,''
,null
,null
,null
,null
,null
,''
,''
,''
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,21073
)
INSERT INTO #EXPExpenseSheetHdr (idfEXPExpenseSheetHdrHistKey,idfComment,idfDatePosted,idfDescription,idfFlagSubmitted,idfLastLine,idfDateCreated,idfDateModified,idfEXPEntryTypeKey,idfPTICompanyKey,idfTETimePeriodKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCSecurityKey,idfWCSecurityKeyCreated,idfWCUDFListDtlKey02,edfAmtAprExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfAPVoucherDtlKey) VALUES(5123
,''
,'20190312'
,'S Levine CNS & DWN travel'
,1
,5
,'20190311'
,'20190312'
,1
,1
,-1
,92
,null
,373
,372
,null
,1067.60000
,1067.60000
,0.00000
,'EX05123-19'
,''
,null
,null
,null
,null
,null
,''
,''
,''
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,21074
)
INSERT INTO #EXPExpenseSheetHdr (idfEXPExpenseSheetHdrHistKey,idfComment,idfDatePosted,idfDescription,idfFlagSubmitted,idfLastLine,idfDateCreated,idfDateModified,idfEXPEntryTypeKey,idfPTICompanyKey,idfTETimePeriodKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCSecurityKey,idfWCSecurityKeyCreated,idfWCUDFListDtlKey02,edfAmtAprExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfAPVoucherDtlKey) VALUES(5123
,''
,'20190312'
,'S Levine CNS & DWN travel'
,1
,5
,'20190311'
,'20190312'
,1
,1
,-1
,92
,null
,373
,372
,null
,1067.60000
,1067.60000
,0.00000
,'EX05123-19'
,''
,null
,null
,null
,null
,null
,''
,''
,''
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,21075
)
INSERT INTO #EXPExpenseSheetHdr (idfEXPExpenseSheetHdrHistKey,idfComment,idfDatePosted,idfDescription,idfFlagSubmitted,idfLastLine,idfDateCreated,idfDateModified,idfEXPEntryTypeKey,idfPTICompanyKey,idfTETimePeriodKey,idfWCDeptKey,idfWCICCompanyKeySource,idfWCSecurityKey,idfWCSecurityKeyCreated,idfWCUDFListDtlKey02,edfAmtAprExtended,edfAmtHomeExtended,edfAmtReimExtended,edfDocument01,edfDocument02,udfDateField01,udfDateField02,udfDateField03,udfDateField04,udfDateField05,udfLargeTextField01,udfLargeTextField02,udfLargeTextField03,udfNumericField01,udfNumericField02,udfNumericField03,udfNumericField04,udfNumericField05,udfNumericField06,udfNumericField07,udfNumericField08,udfNumericField09,udfNumericField10,udfTextField01,udfTextField02,udfTextField03,udfTextField04,udfTextField05,udfTextField06,udfTextField07,udfTextField08,udfTextField09,udfTextField10,idfAPVoucherDtlKey) VALUES(5123
,''
,'20190312'
,'S Levine CNS & DWN travel'
,1
,5
,'20190311'
,'20190312'
,1
,1
,-1
,92
,null
,373
,372
,null
,1067.60000
,1067.60000
,0.00000
,'EX05123-19'
,''
,null
,null
,null
,null
,null
,''
,''
,''
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,0.00000
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,21076
)

declare @p1 varchar(32)
set @p1=NULL
declare @p2 int
set @p2=NULL
declare @p3 varchar(255)
set @p3=NULL
exec dbo.spWPEAICAPGenerateVoucher @xochErrSP=@p1 output,@xonErrNum=@p2 output,@xostrErrInfo=@p3 output,@xnComplexGLDist=1,@xnCalculateTax=0,@xnTranDate_UseCurrentDate=0,@xnVOUCHER_USE_COMMENT_FOR_DISTREF=0,@xnAP_EXP_HANDLE_CREDIT=1,@xnEXP_VOUCHERBYLINE=0,@xnAP_INV_HDR_DESC_USE_NAME=0
select @p1, @p2, @p3

ROLLBACK TRAN

--sp_helptext spWPEAICAPGenerateVoucher