--3)Module – Requisition/Check Request:

DECLARE @RQName VARCHAR(50);

SELECT @RQName = 
	CASE 
		WHEN dbo.fnWCLicenseAccess('RQREQUISITION') = 'YES' AND dbo.fnWCLicenseAccess('RQCHECKREQ') = 'NO' THEN 'Requisition' 
		WHEN dbo.fnWCLicenseAccess('RQREQUISITION') = 'NO' AND dbo.fnWCLicenseAccess('RQCHECKREQ') = 'YES' THEN 'Check Request' 
		ELSE 'Requisition / Check Request' 
	END
SELECT 
	RQHeader.idfRQHeaderKey AS Transaction_Number
	,RQHeader.idfDescription AS Document_Title
	,idfNameLast + ',' + idfNameFirst AS Requisitioner
	,RQHeader.idfDateCreated AS Created
	,RQHeader.idfRQDate AS Document_Date
	,CASE 
        WHEN idfFlagSubmitted = 1 THEN 'Yes'
        ELSE 'No'
    END AS Submitted
	,RQHeader.edfAmtHomeExtended AS Total
	,RQDetail.idfLine AS Line
	,edfPONumber AS PO_Number
	,ISNULL(ICS.idfCompanyCode,'') AS Source_Company
	,ISNULL(ICT.idfCompanyCode,'') AS Target_Company
	,ISNULL(WCDept.idfDeptID,'') AS Department
	,ISNULL(EXPType.idfTypeID,'') AS Expense_Type
	,ISNULL(APV.idfVendorID,'') AS Vendor
	,ISNULL(APV.idfName,'') AS Vendor_Name
	,edfVendorItem AS Vendor_Item
	,RQDetail.idfVendorDocNum AS 'Vendor Doc. No'
	,ISNULL(GLA.idfGLID,'') AS 'G/L'
	,ISNULL(GLA.idfDescription,'') AS 'G/L Description'
	,idfQty AS Quantity
	,edfUOM AS 'U/M'
	,edfPrice AS Price
	,CUR.edfCurrencyID AS Currency
	,RQDetail.edfAmtExtended AS Amt_Ext
	,RQSession.idfRQSessionKey AS 'Status No.'
	,REPLACE(LRD.idfDescription, '::RQNAME::', @RQName) AS Status_Description
FROM RQHeader WITH (NOLOCK) 
LEFT OUTER JOIN RQDetail WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey and RQDetail.idfFlagReversal = 0 
INNER JOIN WCSecurity WITH (NOLOCK) ON WCSecurity.idfWCSecurityKey = RQHeader.idfWCSecurityKey 
LEFT OUTER JOIN RQSession WITH (NOLOCK) ON RQDetail.idfRQSessionKey = RQSession.idfRQSessionKey 
LEFT OUTER JOIN WCDept WITH (NOLOCK) ON RQDetail.idfWCDeptKey = WCDept.idfWCDeptKey 
LEFT OUTER JOIN APVendor AS APV WITH (NOLOCK) ON RQDetail.idfAPVendorKey = APV.idfAPVendorKey 
LEFT OUTER JOIN GLAccount AS GLA WITH (NOLOCK) ON RQDetail.idfGLAccountKey = GLA.idfGLAccountKey 
LEFT OUTER JOIN vwFNACurrency AS CUR WITH (NOLOCK) ON RQDetail.idfPTICurrencyKey = CUR.idfPTICurrencyKey 
LEFT OUTER JOIN dbo.EXPType WITH (NOLOCK) ON EXPType.idfEXPTypeKey = RQDetail.idfEXPTypeKey 
LEFT OUTER JOIN WCICCompany AS ICS WITH (NOLOCK) ON ICS.idfWCICCompanyKey = RQDetail.idfWCICCompanyKeySource 
LEFT OUTER JOIN WCICCompany AS ICT WITH (NOLOCK) ON ICT.idfWCICCompanyKey = RQDetail.idfWCICCompanyKeyTarget 
LEFT OUTER JOIN dbo.RQType AS RQType WITH (NOLOCK) ON RQHeader.idfRQTypeKey = RQType.idfRQTypeKey 
LEFT OUTER JOIN dbo.VCHeader AS VC WITH (NOLOCK) ON VC.idfVCHeaderKey = RQDetail.idfVCHeaderKey 
LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRD WITH(NOLOCK) ON LRD.idfWCLanguageKey = 1 AND '::' + LRD.idfResourceID + '::' LIKE '%' + RQSession.idfDescription + '%'