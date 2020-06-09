CREATE TABLE #Duplicates (idfTableLinkKey INT, ID VARCHAR(60), idfWCICCompanyKey INT, idfTableLinkName VARCHAR(60))

SET NOCOUNT ON

WHILE 1=1 BEGIN
	
	DELETE #Duplicates

	INSERT INTO #Duplicates 
	SELECT MAX(idfAPVendorClassKey),idfVendorClassID AS ID,idfWCICCompanyKey,'APVendorClass' FROM dbo.APVendorClass WITH (NOLOCK) GROUP BY idfVendorClassID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfAPVendorKey), idfVendorID AS ID,idfWCICCompanyKey,'APVendor' FROM dbo.APVendor WITH (NOLOCK) GROUP BY idfVendorID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfARCustomerKey), idfCustomerID AS ID,NULL AS idfWCICCompanyKey,'ARCustomer' FROM dbo.ARCustomer WITH (NOLOCK) GROUP BY idfCustomerID HAVING COUNT(*) > 1
	UNION SELECT MAX(idfGLAccountKey), idfGLID AS ID,idfWCICCompanyKey,'GLAccount' FROM dbo.GLAccount WITH (NOLOCK) GROUP BY idfGLID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfIVItemGroupKey), idfItemGroupID AS ID, NULL AS idfWCICCompanyKey, 'IVItemGroup' FROM dbo.IVItemGroup WITH (NOLOCK) GROUP BY idfItemGroupID HAVING COUNT(*) > 1
	UNION SELECT MAX(idfIVItemKey), idfItemID AS ID,idfWCICCompanyKey,'IVItem' FROM dbo.IVItem WITH (NOLOCK) GROUP BY idfItemID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfIVSiteKey), idfSiteID AS ID,idfWCICCompanyKey,'IVSite' FROM dbo.IVSite WITH (NOLOCK) GROUP BY idfSiteID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfIVUOMKey), idfUOMID AS ID,idfWCICCompanyKey,'IVUOM' FROM dbo.IVUOM WITH (NOLOCK) GROUP BY idfUOMID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfWCAddressKey), idfAddressID AS ID,idfWCICCompanyKey,'WCAddress' FROM dbo.WCAddress WITH (NOLOCK) GROUP BY idfAddressID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfWCPaymentTermKey), idfPaymentTermID AS ID,idfWCICCompanyKey,'WCPaymentTerm' FROM dbo.WCPaymentTerm WITH (NOLOCK) GROUP BY idfPaymentTermID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfWCShippingMethodKey), idfShippingMethodID AS ID,idfWCICCompanyKey,'WCShippingMethod' FROM dbo.WCShippingMethod WITH (NOLOCK) GROUP BY idfShippingMethodID,idfWCICCompanyKey HAVING COUNT(*) > 1
	UNION SELECT MAX(idfWCTaxScheduleHdrKey), idfTaxScheduleID AS ID,idfWCICCompanyKey,'WCTaxScheduleHdr' FROM dbo.WCTaxScheduleHdr WITH (NOLOCK) GROUP BY idfTaxScheduleID,idfWCICCompanyKey HAVING COUNT(*) > 1
        SELECT * INTO Duplicates_Rec from #Duplicates
	IF EXISTS (SELECT TOP 1 1 FROM #Duplicates) BEGIN

		--BEGIN DELETE
		DELETE IVItemVendor
		FROM dbo.IVItemVendor A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVItemKey = B.idfTableLinkKey AND B.idfTableLinkName = 'IVItem'

		DELETE IVItemVendor
		FROM dbo.IVItemVendor A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfAPVendorKey = B.idfTableLinkKey AND B.idfTableLinkName = 'APVendor'

		DELETE IVItemSite
		FROM dbo.IVItemSite A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVItemKey = B.idfTableLinkKey AND B.idfTableLinkName = 'IVItem'

		DELETE IVItemSite
		FROM dbo.IVItemSite A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVSiteKey = B.idfTableLinkKey AND B.idfTableLinkName = 'IVSite'

		DELETE IVItem
		FROM dbo.IVItem A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVSiteKey = B.idfTableLinkKey AND B.idfTableLinkName = 'IVSite'

		DELETE IVItem
		FROM dbo.IVItem A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVSiteKeyMaster = B.idfTableLinkKey AND B.idfTableLinkName = 'IVSite'

		DELETE IVItem
		FROM dbo.IVItem A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVUOMKeyPurchase = B.idfTableLinkKey AND B.idfTableLinkName = 'IVUOM'

		DELETE IVItem
		FROM dbo.IVItem A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVUOMKeyStock = B.idfTableLinkKey AND B.idfTableLinkName = 'IVUOM'

		DELETE IVSite
		FROM dbo.IVSite A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVSiteKey = B.idfTableLinkKey AND B.idfTableLinkName = 'IVSite'

		DELETE IVItem
		FROM dbo.IVItem A WITH (NOLOCK)
		INNER JOIN dbo.IVUOMConversionGroupHdr B WITH (NOLOCK) ON A.idfIVUOMConversionGroupHdrKey = B.idfIVUOMConversionGroupHdrKey
		INNER JOIN #Duplicates  C ON B.idfIVUOMKeyBase = C.idfTableLinkKey AND C.idfTableLinkName = 'IVUOM'

		DELETE IVUOMConversionGroupHdr
		FROM dbo.IVUOMConversionGroupHdr A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVUOMKeyBase = B.idfTableLinkKey AND B.idfTableLinkName = 'IVUOM'

		DELETE IVUOMConversionGroupHdr
		FROM dbo.IVUOMConversionGroupHdr A WITH (NOLOCK)
		INNER JOIN dbo.IVUOMConversionGroupDtl B WITH (NOLOCK) ON A.idfIVUOMConversionGroupHdrKey = B.idfIVUOMConversionGroupHdrKey
		INNER JOIN #Duplicates  C ON B.idfIVUOMKey = C.idfTableLinkKey AND C.idfTableLinkName = 'IVUOM'

		DELETE IVUOM
		FROM dbo.IVUOM A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVUOMKey = B.idfTableLinkKey AND B.idfTableLinkName = 'IVUOM'

		DELETE IVItem
		FROM dbo.IVItem A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVItemGroupKey = B.idfTableLinkKey AND idfTableLinkName = 'IVItemGroup'

		DELETE IVItem
		FROM dbo.IVItem A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVItemKey = B.idfTableLinkKey AND idfTableLinkName = 'IVItem'

		DELETE IVItemGroup
		FROM dbo.IVItemGroup A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfIVItemGroupKey = B.idfTableLinkKey AND idfTableLinkName = 'IVItemGroup'

		DELETE APVendor
		FROM dbo.APVendor A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfAPVendorClassKey = B.idfTableLinkKey AND idfTableLinkName = 'APVendorClass'

		DELETE APVendor
		FROM dbo.APVendor A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfAPVendorKey = B.idfTableLinkKey AND idfTableLinkName = 'APVendor'

		DELETE APVendor
		FROM dbo.APVendor A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfWCTaxScheduleHdrKey = B.idfTableLinkKey AND idfTableLinkName = 'WCTaxScheduleHdr'

		DELETE WCTaxScheduleHdr
		FROM dbo.WCTaxScheduleHdr A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfWCTaxScheduleHdrKey = B.idfTableLinkKey AND idfTableLinkName = 'WCTaxScheduleHdr'

		DELETE APVendor
		FROM dbo.APVendor A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfWCShippingMethodKey = B.idfTableLinkKey AND idfTableLinkName = 'WCShippingMethod'

		DELETE WCShippingMethod
		FROM dbo.WCShippingMethod A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfWCShippingMethodKey = B.idfTableLinkKey AND idfTableLinkName = 'WCShippingMethod'

		DELETE APVendor
		FROM dbo.APVendor A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfWCPaymentTermKey = B.idfTableLinkKey AND idfTableLinkName = 'WCPaymentTerm'

		DELETE WCPaymentTerm
		FROM dbo.WCPaymentTerm A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfWCPaymentTermKey = B.idfTableLinkKey AND idfTableLinkName = 'WCPaymentTerm'

		DELETE ARCustomer
		FROM dbo.ARCustomer A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfARCustomerKey = B.idfTableLinkKey AND idfTableLinkName = 'ARCustomer'

		DELETE WCAddress
		FROM dbo.WCAddress A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfWCAddressKey = B.idfTableLinkKey AND idfTableLinkName = 'WCAddress'

		DELETE GLAccount
		FROM dbo.GLAccount A WITH (NOLOCK)
		INNER JOIN #Duplicates  B ON A.idfGLAccountKey = B.idfTableLinkKey AND B.idfTableLinkName = 'GLAccount'
	
	END
	ELSE
		
		BREAK

END

DROP TABLE #Duplicates
SELECT * FROM  Duplicates_Rec