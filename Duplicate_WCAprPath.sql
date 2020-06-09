-- AC LINEN 196484 
begin tran
SELECT COUNT(idfWCAprPathKey) from WCAprPath
DELETE H
FROm (SELECT ROW_NUMBER() OVER(Partition By idfLinkTableName,idfLinkTableKey,idfWCRRGroupLineUpKey  ORDER BY idfLinkTableName,idfLinkTableKey,idfWCRRGroupLineUpKey ) RID,*
from WCAprPath a
where exists (select * from (select idfWCRRGroupLineUpKey,idfLinkTableKey 
from WCAprPath
where idfLinkTableName='RQDetail'
group by  idfWCRRGroupLineUpKey,idfLinkTableKey 
having count (*)>1) b where a.idfLinkTableKey=b.idfLinkTableKey and a.idfWCRRGroupLineUpKey=b.idfWCRRGroupLineUpKey and a.idfLinkTableName='RQDetail')) H
INNER JOIN WCAprPath d on h.idfWCAprPathKey=h.idfWCAprPathKey
WHERE RID=2
SELECT COUNT(idfWCAprPathKey) from WCAprPath
rollback tran

begin tran
declare @p6 varchar(8000)
set @p6=NULL
declare @p7 varchar(8000)
set @p7=NULL
exec WPLIVE.dbo.spRQAprLoad @xnidfWCSecurityKey=2,@xnidfPTICompanyKey=2,@xstrLD_vdfRQType=-1,@xnGetRecordCountsOnly=0,@xnGetRecordHeadersOnly=1,@xostrRecordsPendingApproval=@p6 output,@xostrRecordsPendingApprovalCR=@p7 output
select @p6, @p7
rollback tran

SELECT ROW_NUMBER() OVER(Partition By idfLinkTableName,idfLinkTableKey,idfWCRRGroupLineUpKey  ORDER BY idfLinkTableName,idfLinkTableKey,idfWCRRGroupLineUpKey ) RID,*
from WCAprPath a
where exists (select idfWCRRGroupLineUpKey,idfLinkTableKey from WCAprPath
             where idfLinkTableName='RQDetail'
            GROUP by  idfWCRRGroupLineUpKey,idfLinkTableKey 
having count (*)>1) b where a.idfLinkTableKey=b.idfLinkTableKey and a.idfWCRRGroupLineUpKey=b.idfWCRRGroupLineUpKey and a.idfLinkTableName='RQDetail')) t1
WHERE RID=2

order by idfLinkTableName,idfLinkTableKey,idfWCRRGroupLineUpKey


select * from WCAprPath