--4) Module - Purchase Order:

SELECT 
	idfPONumber AS PO_Number
	,WCSecurity.idfSecurityID AS Created_By
	,POHeader.idfDateCreated AS [Created]
	,POHeader.idfRevision AS Revision
	,ISNULL(ICS.idfCompanyCode,'') AS Source_Company
	,ISNULL(APV.idfVendorID,'') AS Vendor
	,ISNULL(APV.idfName,'') AS Vendor_Name
	,Currency.edfCurrencyID AS Currency
	,POHeader.idfAmtExtended AS Total
	,isnull(ICT.idfCompanyCode,'') AS Target_Company
	,ISNULL(WCDept.idfDeptID,'') AS Department
	,LRD.idfDescription AS [Status] --Status of the PO Detail
	,ISNULL(PODetail.idfItemID,'') AS Item
	,ISNULL(PODetail.idfItemDesc,'') AS Item_Description
	,ISNULL(GLA.idfGLID,'') AS 'G/L'
	,ISNULL(GLA.idfDescription,'') AS 'G/L Description'
	,idfQty AS Qty
	,PODetail.idfIVUOMID AS 'U/M'
	,PODetail.idfPrice AS Price
	,PODetail.idfAmtExtended AS Amt_Extended
	,SH.idfPOSessionKey AS 'Status No.'
	,LRH.idfDescription AS Status_Description --Status of the PO Header
FROM POHeader WITH (NOLOCK) 
LEFT OUTER JOIN PODetail WITH (NOLOCK) ON POHeader.idfPOHeaderKey = PODetail.idfPOHeaderKey 
INNER JOIN WCSecurity WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = POHeader.idfWCSecurityKey 
LEFT OUTER JOIN POSession WITH (NOLOCK) ON PODetail.idfPOSessionKey = POSession.idfPOSessionKey 
LEFT OUTER JOIN POSession AS SH WITH (NOLOCK) ON POHeader.idfPOSessionKey = SH.idfPOSessionKey
LEFT OUTER JOIN WCDept WITH (NOLOCK) ON PODetail.idfWCDeptKey = WCDept.idfWCDeptKey 
LEFT OUTER JOIN APVendor AS APV WITH (NOLOCK) ON POHeader.idfAPVendorKey = APV.idfAPVendorKey 
LEFT OUTER JOIN GLAccount AS GLA WITH (NOLOCK) ON PODetail.idfGLAccountKey = GLA.idfGLAccountKey 
LEFT OUTER JOIN vwFNACurrency AS Currency WITH (NOLOCK) ON Currency.idfPTICurrencyKey = POHeader.idfPTICurrencyKey 
LEFT OUTER JOIN WCICCompany ICS WITH (NOLOCK) ON ICS.idfWCICCompanyKey = POHeader.idfWCICCompanyKeySource 
LEFT OUTER JOIN WCICCompany ICT WITH (NOLOCK) ON ICT.idfWCICCompanyKey = PODetail.idfWCICCompanyKeyTarget 
LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRD WITH (NOLOCK) ON LRD.idfWCLanguageKey = 1 AND '::' + LRD.idfResourceID + '::' = POSession.idfResourceID
LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRH WITH (NOLOCK) ON LRH.idfWCLanguageKey = 1 AND '::' + LRH.idfResourceID + '::' = SH.idfResourceID