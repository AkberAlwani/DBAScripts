select r.edfVendor RcvVendor,v.idfVendorID ChkVendor,r.edfVendorDocNum,rd.edfVendorItem,r.edfReceiptNumber
       ,r.idfRCVHeaderKey,cr_d.idfRCVDetailKey,cr_d.idfRQHeaderKey ,cr_h.idfAPVendorKey 
from RCVDetail rd 
inner join RCVHeader r on rd.idfRCVHeaderKey = r.idfRCVHeaderKey
inner join RQDetail cr_d on cr_d.idfRCVDetailKey = rd.idfRCVDetailKey
inner join RQHeader cr_h on cr_d.idfRQHeaderKey = cr_h.idfRQHeaderKey
inner join APVendor v    on cr_h.idfAPVendorKey = v.idfAPVendorKey
where r.edfVendor <> v.idfVendorID

SELECT RCVHeader.edfReceiptNumber AS 'RCTNUM', RQHeader.idfRQHeaderKey as 'REQNUM'
FROM dbo.RQHeader WITH (NOLOCK)
INNER JOIN dbo.RQDetail WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey
INNER JOIN dbo.APVendor  WITH (NOLOCK) ON RQHeader.idfAPVendorKey = APVendor.idfAPVendorKey
LEFT OUTER JOIN dbo.RCVDetail WITH (NOLOCK) ON RQDetail.idfRCVDetailKey = RCVDetail.idfRCVDetailKey
LEFT OUTER JOIN dbo.RCVHeader WITH (NOLOCK) ON RCVDetail.idfRCVHeaderKey = RCVHeader.idfRCVHeaderKey
WHERE RQHeader.idfRQTypeKey = 3 AND RCVHeader.edfVendor != APVendor.idfVendorID

--FOR WPE
--SELECT RCVHeaderHist.idfRCTNumber,RCVHeaderHist.idfAPVendorKey, RQHeader.idfRQHeaderKey as 'REQNUM', RQHeader.idfAPVendorKey
--FROM dbo.RQHeader WITH (NOLOCK)
--INNER JOIN dbo.RQDetail WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey
--INNER JOIN dbo.APVendor  WITH (NOLOCK) ON RQHeader.idfAPVendorKey = APVendor.idfAPVendorKey
--LEFT OUTER JOIN dbo.RCVDetailHist WITH (NOLOCK) ON RQDetail.idfRCVDetailKey = RCVDetailHist.idfRCVDetailHistKey
--LEFT OUTER JOIN dbo.RCVHeaderHist WITH (NOLOCK) ON RCVDetailHist.idfRCVHeaderHistKey = RCVHeaderHist.idfRCVHeaderHistKey
--WHERE RQHeader.idfRQHeaderKey=36275
-- WHERE RQHeader.idfAPVendorKey<>RCVHeaderHist.idfAPVendorKey



select idfVendorDocNum,h.idfAPVendorKey,* 
from RQHeader  h
inner join APVendor v on v.idfAPVendorKey=h.idfAPVendorKey
where idfRQHeaderKey=5
select edfVendor,idfRCVDetailKey,* from RQDetail where idfRQHeaderKey=5
select edfVendor,* from RQRevDtl where idfRQDetailKey=7
select * from APVendor


SELECT T.name AS Table_Name ,
       C.name AS Column_Name ,
       P.name AS Data_Type ,
       P.max_length AS Size ,
       CAST(P.precision AS VARCHAR) + '/' + CAST(P.scale AS VARCHAR) AS Precision_Scale
FROM   sys.objects AS T
       JOIN sys.columns AS C ON T.object_id = C.object_id
       JOIN sys.types AS P ON C.system_type_id = P.system_type_id
WHERE  T.type_desc = 'USER_TABLE' and t.name like 'ENC%'
and c.name like '%PONumber%'
order by 1


