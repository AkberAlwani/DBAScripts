select * from GLAccount where idfGLID='071-01-30-14-1100' --39499ZTEST
select * from ZTEST..GL00105 where ACTNUMST='071-01-30-14-1100'
update GLAccount set idfEAICLink='39586YMCA' where idfGLID='071-01-30-14-1100' and idfWCICCompanyKey=1


--9/28/2018 11:40
select * from GLAccount where idfGlID='082-02-00-00-9270'
select * from WINSC..GL00105 where ACTNUMST='082-02-00-00-9270'

UPDATE GLAccount set idfEAICLink=convert(varchar,a.ACTINDX)+'WINSC'
--SELECT b.*,a.ACTINDX
from WINSC..GL00105 a
inner join GLAccount B on a.ACTNUMST=b.idfGLID
AND b.idfEAICLink like '%WINSC%'
AND convert(varchar,ACTINDX)<>SUBSTRING(idfEAICLink,0,CHARINDEX('WINSC',idfEAICLink,0))


select SUBSTRING(idfEAICLink,0,CHARINDEX('WINSC',idfEAICLink,0)),*
from GLAccount
where idfEAICLink like '%WINSC%'
