SELECT MAX(idfAPVendorClassKey),idfVendorClassID AS ID,idfWCICCompanyKey,'APVendorClass' FROM APVendorClass GROUP BY idfVendorClassID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfAPVendorKey), idfVendorID AS ID,idfWCICCompanyKey,'APVendor' FROM APVendor GROUP BY idfVendorID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfARCustomerKey), idfCustomerID AS ID,NULL AS idfWCICCompanyKey,'ARCustomer' FROM ARCustomer GROUP BY idfCustomerID HAVING COUNT(*) > 1
UNION SELECT MAX(idfGLAccountKey), idfGLID AS ID,idfWCICCompanyKey,'GLAccount' FROM GLAccount GROUP BY idfGLID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfIVItemGroupKey), idfItemGroupID AS ID, NULL AS idfWCICCompanyKey, 'IVItemGroup' FROM IVItemGroup GROUP BY idfItemGroupID HAVING COUNT(*) > 1
UNION SELECT MAX(idfIVItemKey), idfItemID AS ID,idfWCICCompanyKey,'IVItem' FROM IVItem GROUP BY idfItemID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfIVSiteKey), idfSiteID AS ID,idfWCICCompanyKey,'IVSite' FROM IVSite GROUP BY idfSiteID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfIVUOMKey), idfUOMID AS ID,idfWCICCompanyKey,'IVUOM' FROM IVUOM GROUP BY idfUOMID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfWCAddressKey), idfAddressID AS ID,idfWCICCompanyKey,'WCAddress' FROM WCAddress GROUP BY idfAddressID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfWCPaymentTermKey), idfPaymentTermID AS ID,idfWCICCompanyKey,'WCPaymentTerm' FROM WCPaymentTerm GROUP BY idfPaymentTermID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfWCShippingMethodKey), idfShippingMethodID AS ID,idfWCICCompanyKey,'WCShippingMethod' FROM WCShippingMethod GROUP BY idfShippingMethodID,idfWCICCompanyKey HAVING COUNT(*) > 1
UNION SELECT MAX(idfWCTaxScheduleHdrKey), idfTaxScheduleID AS ID,idfWCICCompanyKey,'WCTaxScheduleHdr' FROM WCTaxScheduleHdr GROUP BY idfTaxScheduleID,idfWCICCompanyKey HAVING COUNT(*) > 1