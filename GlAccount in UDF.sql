select * from WCListHdr
select * from WCListDtl
select * from GLAccount where idfGLAccountKey in (233,292,253)

declare @Accountcode varchar(100)
set @AccountCode='01-'
select b.idfCodeKey,a.idfWCListHdrKey,idfGLID
from WCListHdr a 
inner join WCListDtl b on a.idfWCListHdrKey=b.idfWCListHdrKey and a.idfWCListTypeKey=2
inner join GLAccount c on b.idfCodeKey=c.idfGlAccountKey
WHERE idfGLID like '%'+@Accountcode+'%'


sp_helptext spGLDistribution