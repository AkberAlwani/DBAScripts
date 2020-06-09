-- Case 
SELECT RCVHeaderHist.idfRCTNumber 'RECVD',RCVHeaderHist.idfAPVendorKey 'RECVVendor', RQHeader.idfRQHeaderKey as 'REQNUM', RQHeader.idfAPVendorKey 'REQVendor'
FROM dbo.RQHeader WITH (NOLOCK)
INNER JOIN dbo.RQDetail WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey
INNER JOIN dbo.APVendor  WITH (NOLOCK) ON RQHeader.idfAPVendorKey = APVendor.idfAPVendorKey
LEFT OUTER JOIN dbo.RCVDetailHist WITH (NOLOCK) ON RCVDetailHist.idfRCVDetailHistKey=RQDetail.idfRCVDetailKey
LEFT OUTER JOIN dbo.RCVHeaderHist WITH (NOLOCK) ON RCVHeaderHist.idfRCVHeaderHistKey = RCVDetailHist.idfRCVHeaderHistKey 
WHERE RQHeader.idfAPVendorKey<>RCVHeaderHist.idfAPVendorKey

select * from RCVHeaderHist where idfRCTNumber='RCT0040223'
select * from RQHeader where idfRQHeaderKey=36275
select * from RQDetail where idfRQHeaderKey=36275

SELECT idfAPVendorKey,idfVendorDocNum,*
FROM dbo.RCVDetailHist WITH (NOLOCK) 
INNER JOIN dbo.RCVHeaderHist WITH (NOLOCK) ON RCVHeaderHist.idfRCVHeaderHistKey = RCVDetailHist.idfRCVHeaderHistKey
where idfRCTNumber='RCT0040223'


