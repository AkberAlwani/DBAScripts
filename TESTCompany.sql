if exists (select 1 from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SY00100') begin
  declare @Statement varchar(850)
  select @Statement = 'declare @cStatement varchar(255)
declare G_cursor CURSOR for
select case when UPPER(a.COLUMN_NAME) in (''COMPANYID'',''CMPANYID'')
  then ''update ''+a.TABLE_NAME+'' set ''+a.COLUMN_NAME+'' = ''+ cast(b.CMPANYID as char(3)) 
  else ''update ''+a.TABLE_NAME+'' set ''+a.COLUMN_NAME+'' = ''''''+ db_name()+'''''''' end
from INFORMATION_SCHEMA.COLUMNS a, '+rtrim(DBNAME)+'.dbo.SY01500 b
  where UPPER(a.COLUMN_NAME) in (''COMPANYID'',''CMPANYID'',''INTERID'',''DB_NAME'',''DBNAME'')
    and b.INTERID = db_name() and COLUMN_DEFAULT is not null
 and rtrim(a.TABLE_NAME)+''-''+rtrim(a.COLUMN_NAME) <> ''SY00100-DBNAME''
  order by a.TABLE_NAME
set nocount on
OPEN G_cursor
FETCH NEXT FROM G_cursor INTO @cStatement
WHILE (@@FETCH_STATUS <> -1)
begin
  exec (@cStatement)
  FETCH NEXT FROM G_cursor INTO @cStatement
end
close G_cursor
DEALLOCATE G_cursor
set nocount off'
  from SY00100
  exec (@Statement)
end
else begin
  declare @cStatement varchar(255)
  declare G_cursor CURSOR for
  select case when UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID')
    then 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '+ cast(b.CMPANYID as char(3)) 
    else 'update '+a.TABLE_NAME+' set '+a.COLUMN_NAME+' = '''+ db_name()+'''' end
  from INFORMATION_SCHEMA.COLUMNS a, DYNAMICS.dbo.SY01500 b
    where UPPER(a.COLUMN_NAME) in ('COMPANYID','CMPANYID','INTERID','DB_NAME','DBNAME')
      and b.INTERID = db_name() and COLUMN_DEFAULT is not null
    order by a.TABLE_NAME
  set nocount on
  OPEN G_cursor
  FETCH NEXT FROM G_cursor INTO @cStatement
  WHILE (@@FETCH_STATUS <> -1)
  begin
    exec (@cStatement)
    FETCH NEXT FROM G_cursor INTO @cStatement
  end
  close G_cursor
  DEALLOCATE G_cursor
  set nocount off
end

sp_changedbowner 'DYNSA'