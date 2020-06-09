Declare @tableName varchar(255)
Declare @SQL varchar(255)
DECLARE curRSTables INSENSITIVE CURSOR 
FOR SELECT Name 
from sys.tables where name like 'RS%'

OPEN curRSTables
FETCH NEXT FROM curRSTables INTO @tableName
WHILE (@@fetch_status <> -1)
BEGIN
   set @SQL='GRANT SELECT ON '+@tableName+' TO [PTIWorkPlaceUser]'
   exec (@SQL)
   set @SQL='GRANT SELECT ON '+@tableName+' TO [PTIWorkPlaceAdmin] WITH GRANT OPTION'
   exec (@SQL)	
   FETCH NEXT FROM curRSTables INTO @tableName
END
close curRSTables
deallocate curRSTables

--select * from DYNAMICS..SY60100  where SY60100.USERID='aali'
--select * from DYNAMICS..SY01500