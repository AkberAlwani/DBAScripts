--2)Module – Receive/Match Invoice:

SELECT
	RCVHeader.idfRCTNumber AS 'Recieve/Match Number'
	,CASE 
        WHEN RCVHeader.idfTransactionType = 1 THEN 'Receipt'
        WHEN RCVHeader.idfTransactionType = 2 THEN 'Invoice'
        WHEN RCVHeader.idfTransactionType = 3 THEN 'Receipt/Invoice'
        WHEN RCVHeader.idfTransactionType = 4 THEN 'Returned - Receipt'
        WHEN RCVHeader.idfTransactionType = 5 THEN 'Returned - Invoice'
        WHEN RCVHeader.idfTransactionType = 6 THEN 'Returned - Receipt/Invoice'
    END AS [Type]
	,idfNameLast + ',' + idfNameFirst AS Created_By
	,RCVHeader.idfDateCreated AS Created
	,CONVERT(VARCHAR(10),RCVHeader.idfDateReceipt,105) AS Receipt_Date
	,APVendor.idfVendorID AS Vendor
	,RCVHeader.idfVendorDocNum AS 'Vendor Doc. No.'
	,RCVDetail.idfPONumber AS PO_Number
	,WCDept.idfDeptID AS Department
	,RCVDetail.idfItemID AS Item
	,RCVDetail.idfItemDesc AS Item_Description
	,GLAccount.idfGLID AS 'G/L Account'
	,RCVDetail.idfQtyShipped AS Qty
	,RCVDetail.edfPrice AS Price
	,RCVDetail.idfAmtExtended AS Amt_Ext
	,RCVSession.idfRCVSessionKey AS 'Status No.'
	,LRD.idfDescription AS Status_Description
FROM dbo.RCVHeader WITH (NOLOCK) 
INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON RCVHeader.idfWCSecurityKey = WCSecurity.idfWCSecurityKey 
LEFT OUTER JOIN dbo.RCVDetail WITH (NOLOCK) ON RCVHeader.idfRCVHeaderKey = RCVDetail.idfRCVHeaderKey 
LEFT OUTER JOIN dbo.RQDetail WITH (NOLOCK) ON RCVDetail.idfPONumber > '' AND RQDetail.edfPONumber = RCVDetail.idfPONumber AND RQDetail.edfPOLine = RCVDetail.idfPOLine 
LEFT OUTER JOIN dbo.APVendor WITH (NOLOCK) ON RCVHeader.idfAPVendorKey = APVendor.idfAPVendorKey 
LEFT OUTER JOIN dbo.GLAccount WITH (NOLOCK) ON GLAccount.idfGLAccountKey = RCVDetail.idfGLAccountKeyPurch 
LEFT OUTER JOIN dbo.WCDept WITH (NOLOCK) ON WCDept.idfWCDeptKey = RQDetail.idfWCDeptKey 
LEFT OUTER JOIN dbo.RCVSession WITH (NOLOCK) ON RCVSession.idfRCVSessionKey = RCVDetail.idfRCVSessionKey
LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRD WITH (NOLOCK) ON LRD.idfWCLanguageKey = 1 AND '::' + LRD.idfResourceID + '::' LIKE '%' + RCVSession.idfDescription + '%'

UNION ALL

SELECT
	RCVHeaderHist.idfRCTNumber AS 'Recieve/Match Number'
	,CASE 
        WHEN RCVHeaderHist.idfTransactionType = 1 THEN 'Receipt'
        WHEN RCVHeaderHist.idfTransactionType = 2 THEN 'Invoice'
        WHEN RCVHeaderHist.idfTransactionType = 3 THEN 'Receipt/Invoice'
        WHEN RCVHeaderHist.idfTransactionType = 4 THEN 'Returned - Receipt'
        WHEN RCVHeaderHist.idfTransactionType = 5 THEN 'Returned - Invoice'
        WHEN RCVHeaderHist.idfTransactionType = 6 THEN 'Returned - Receipt/Invoice'
    END AS [Type]
	,idfNameLast + ',' + idfNameFirst AS Created_By
	,RCVHeaderHist.idfDateCreated AS Created
	,CONVERT(VARCHAR(10),RCVHeaderHist.idfDateReceipt,105) AS Receipt_Date
	,APVendor.idfVendorID AS Vendor
	,RCVHeaderHist.idfVendorDocNum AS 'Vendor Doc. No.'
	,RCVDetailHist.idfPONumber AS PO_Number
	,WCDept.idfDeptID AS Department
	,RCVDetailHist.idfItemID AS Item
	,RCVDetailHist.idfItemDesc AS Item_Description
	,GLAccount.idfGLID AS 'G/L Account'
	,RCVDetailHist.idfQtyShipped AS Qty
	,RCVDetailHist.edfPrice AS Price
	,RCVDetailHist.idfAmtExtended AS Amt_Ext
	,RCVSession.idfRCVSessionKey AS 'Status No.'
	,LRD.idfDescription AS Status_Description
FROM dbo.RCVHeaderHist WITH (NOLOCK) 
INNER JOIN dbo.WCSecurity WITH (NOLOCK) ON RCVHeaderHist.idfWCSecurityKey = WCSecurity.idfWCSecurityKey 
LEFT OUTER JOIN dbo.RCVDetailHist WITH (NOLOCK) ON RCVHeaderHist.idfRCVHeaderHistKey = RCVDetailHist.idfRCVHeaderHistKey 
LEFT OUTER JOIN dbo.RQDetail WITH (NOLOCK) ON RCVDetailHist.idfPONumber > '' AND RQDetail.edfPONumber = RCVDetailHist.idfPONumber AND RQDetail.edfPOLine = RCVDetailHist.idfPOLine 
LEFT OUTER JOIN dbo.APVendor WITH (NOLOCK) ON RCVHeaderHist.idfAPVendorKey = APVendor.idfAPVendorKey 
LEFT OUTER JOIN dbo.GLAccount WITH (NOLOCK) ON GLAccount.idfGLAccountKey = RCVDetailHist.idfGLAccountKeyPurch 
LEFT OUTER JOIN dbo.WCDept WITH (NOLOCK) ON WCDept.idfWCDeptKey = RQDetail.idfWCDeptKey 
LEFT OUTER JOIN dbo.RCVSession WITH (NOLOCK) ON RCVSession.idfRCVSessionKey = RCVDetailHist.idfRCVSessionKey
LEFT OUTER JOIN dbo.WCLanguageResourceD AS LRD WITH (NOLOCK) ON LRD.idfWCLanguageKey = 1 AND '::' + LRD.idfResourceID + '::' LIKE '%' + RCVSession.idfDescription + '%'