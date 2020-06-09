SELECT '1' Flag,RQH.idfAPVendorKey,APV.idfAPVendorKey,APV.idfVendorID,RVH.idfRCTNumber
FROM dbo.RCVHeader RVH WITH (NOLOCK)
INNER JOIN dbo.RCVDetail RVD WITH (NOLOCK) ON RVD.idfRCVHeaderKey = RVH.idfRCVHeaderKey
INNER JOIN dbo.RQRevDtl WITH (NOLOCK) ON RQRevDtl.idfRCVDetailKey = RVD.idfRCVDetailKey
INNER JOIN dbo.RQDetail RQD WITH (NOLOCK) ON RQD.idfRQDetailKey = RQRevDtl.idfRQDetailKey
INNER JOIN dbo.RQHeader RQH WITH (NOLOCK) ON RQH.idfRQHeaderKey = RQD.idfRQHeaderKey
INNER JOIN dbo.APVendor APV WITH (NOLOCK) ON APV.idfAPVendorKey = RQD.idfAPVendorKey 
WHERE RQH.idfAPVendorKey<> APV.idfAPVendorKey
UNION 
SELECT '2' Flag,RQH.idfAPVendorKey,APV.idfAPVendorKey,APV.idfVendorID,RVH.idfRCTNumber
FROM dbo.RCVHeader RVH WITH (NOLOCK)
INNER JOIN dbo.RCVDetail RVD WITH (NOLOCK) ON RVD.idfRCVHeaderKey = RVH.idfRCVHeaderKey
INNER JOIN dbo.RQDetail RQD WITH (NOLOCK) ON RQD.idfRCVDetailKey = RVD.idfRCVDetailKey
INNER JOIN dbo.RQHeader RQH WITH (NOLOCK) ON RQH.idfRQHeaderKey = RQD.idfRQHeaderKey
INNER JOIN dbo.APVendor APV WITH (NOLOCK) ON APV.idfAPVendorKey = RQD.idfAPVendorKey 
WHERE RQH.idfAPVendorKey<> APV.idfAPVendorKey
UNION 
SELECT '3' Flag,RQH.idfAPVendorKey,APV.idfAPVendorKey,APV.idfVendorID,RVH.idfRCTNumber
FROM dbo.RCVHeaderHist RVH WITH (NOLOCK)
INNER JOIN dbo.RCVDetailHist RVD WITH (NOLOCK) ON RVD.idfRCVHeaderHistKey = RVH.idfRCVHeaderHistKey
INNER JOIN dbo.RQRevDtl WITH (NOLOCK) ON RQRevDtl.idfRCVDetailKey = RVD.idfRCVDetailHistKey
INNER JOIN dbo.RQDetail RQD WITH (NOLOCK) ON RQD.idfRQDetailKey = RQRevDtl.idfRQDetailKey
INNER JOIN dbo.RQHeader RQH WITH (NOLOCK) ON RQH.idfRQHeaderKey = RQD.idfRQHeaderKey
INNER JOIN dbo.APVendor APV WITH (NOLOCK) ON APV.idfAPVendorKey = RQD.idfAPVendorKey 
WHERE RQH.idfAPVendorKey<> APV.idfAPVendorKey
UNION 
SELECT '4' Flag,RQH.idfAPVendorKey,APV.idfAPVendorKey,APV.idfVendorID,RVH.idfRCTNumber
FROM dbo.RCVHeaderHist RVH WITH (NOLOCK)
INNER JOIN dbo.RCVDetailHist RVD WITH (NOLOCK) ON RVD.idfRCVHeaderHistKey = RVH.idfRCVHeaderHistKey
INNER JOIN dbo.RQDetail RQD WITH (NOLOCK) ON RQD.idfRCVDetailKey = RVD.idfRCVDetailHistKey
INNER JOIN dbo.RQHeader RQH WITH (NOLOCK) ON RQH.idfRQHeaderKey = RQD.idfRQHeaderKey
INNER JOIN dbo.APVendor APV WITH (NOLOCK) ON APV.idfAPVendorKey = RQD.idfAPVendorKey 
WHERE RQH.idfAPVendorKey<> APV.idfAPVendorKey
