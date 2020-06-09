select * from GLSegmentDtl
--where idfEAICLink <>''
where idfSegmentID like 'F%'
order by idfSegmentID

--update GLSegmentDtl set idfSegmentID=Upper(idfSegmentID),idfEAICLink=b.idfDescription+Upper(idfSegmentID)
select b.idfDescription,*
from GLSegmentDtl a
inner join GLSegmentHdr b on a.idfGLSegmentHdrKey=b.idfGLSegmentHdrKey
where 
--a.idfEAICLink =''
where  a.idfGLSegmentDtlKey not in (select idfTableLinkKey from PTIPagingPageDetail)
and b.idfGLSegmentHdrKey=3
order by a.idfSegmentID


select idfSegmentID
from GLSegmentDtl
group by idfSegmentID
having count (*)>1

select idfSEcurityID,* from WCSecurity where idfDescription like '%Kim%'

select * from GLSEGMENTHDR
 SET FMTONLY OFF; SET NO_BROWSETABLE ON;use WPELIVESUN
EXEC sp_executesql N'SELECT
											 GLSegmentDtl.*
											,GLSegmentHdr.idfDescription AS vdfSegmentHdrDesc
                                            ,'''' AS vdfCompanyCode 
				
											,0 AS vdfXMLReadOnly 
										  FROM dbo.GLSegmentDtl WITH (NOLOCK)
										  INNER JOIN dbo.GLSegmentHdr WITH (NOLOCK) ON GLSegmentHdr.idfGLSegmentHdrKey = GLSegmentDtl.idfGLSegmentHdrKey
                                          INNER JOIN dbo.PTIPagingPageDetail PPD    WITH (NOLOCK) ON PPD.idfPTIPagingPageHeaderKey = 60436 AND GLSegmentDtl.idfGLSegmentDtlKey = PPD.idfTableLinkKey
                                          WHERE GLSegmentDtl.idfGLSegmentHdrKey = 3' SET NO_BROWSETABLE OFF;

select * from PTIPagingPageDetail
where idfTableLinkID like 'CV%'




Declare @rowID int
select @rowID= max(idfPTIPagingPageDetailkey)+1 from PTIPagingPageDetail
insert into PTIPagingPageDetail (idfTableLinkID,idfTableLinkKey,idfPTIPagingPageHeaderKey)
select idfSegmentID,idfGLSegmentDtlKey,60518
from GLSegmentDtl
where idfGLSegmentDtlKey
not in (select idfTableLinkKey from PTIPagingPageDetail)
--and (idfEAICLink like 'F%')
and   idfSegmentID like 'CV%'


exec spPTIFixPrimaryKey