declare @oldVendor varchar(50),@newVendor varchar(50)
declare @UpdateSQL varchar(max)

declare @oldVendorID int,@newVendorID int
set @newVendor='23229E'
set @oldVendor='23229'
select @newVendorID=idfAPVendorKey from APVendor where idfVendorID=@newVendor
select @oldVendorID=idfAPVendorKey from APVendor where idfVendorID=@oldVendor

DECLARE curVendor cursor FOR
select 'UPDATE '+t.Name+' set '+c.Name+'='+cast(@newVendorID as varchar)+' WHERE '+c.Name+'='+cast(@oldVendorID as varchar)+''  DYNSQL
from sys.objects as t
join sys.columns as c on t.object_id=c.object_Id
join sys.types as p on c.system_type_id=p.system_type_id
where t.type_desc='USER_TABLE'
and t.name not in ('APVendor','APAddress')
and c.name like '%idfAPVendorKey'
union 
select 'UPDATE '+t.Name+' set '+c.Name+'='''+@newVendor+''' WHERE '+c.Name+'='''+@oldVendor+''''
from sys.objects as t
join sys.columns as c on t.object_id=c.object_Id
join sys.types as p on c.system_type_id=p.system_type_id
where t.type_desc='USER_TABLE'
and t.name not in ('APVendor','APAddress')
and c.name like '%edfVendor'
order by 1

OPEN curVendor
FETCH NEXT from curVendor INTO @UpdateSQL
WHILE @@FETCH_STATUS<>-1
BEGIN
   PRINT @UpdateSQL
   EXEC (@UpdateSQL)
   FETCH NEXT from curVendor INTO @UpdateSQL
END
close curVendor
deallocate curVendor
