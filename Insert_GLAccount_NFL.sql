select * from WCListDtl where idfWCListHdrkey=3

select top 50 idfGLID from GLAccount where idfGLID>='000-1460-00'

declare @lastKey int,@account varchar(20)
Select  @lastKey =max(idfWCListDtlKey)+1 from WCListDtl

declare curGL cursor for
 SELECT top 50 idfGLID from GLAccount where idfGLID>='000-1460-00'

OPEN curGL
FETCH curGL INTO @account
WHILE @@FETCH_STATUS<>-1
BEGIN
   Print @account 
  
   insert into WCListDtl (idfWCListDtlKey,idfCodeID,idfWCListHdrKey)
   values (@lastkey,@account,3)
   set @lastkey=@lastkey+1
   FETCH curGL INTO @account
END
CLOSE curGL
DEALLOCATE curGL

exec spPTIFixSQLGrant




select * from WCListDtl 
select * from WCListHdr