use PTIMaster
GO
Drop PROCEDURE PTICompanyFix
GO
create procedure PTICompanyFix
@CompanyDb varchar(100)
AS

DECLARE @SQL nVarchar(4000),@DbID Varchar(20)

Select @DbID=idfPTICompanyKey from PTImaster..PTICompany where PTICompany.idfDBName=@CompanyDb
BEGIN
USE @CompanyDb
DECLARE coUpdate cursor for
 SELECT DISTINCT
	 'USE '+@CompanyDb+' ; UPDATE ' + T.name + ' set ' + c.name + '='+@DbID AS Table_Name
 FROM sys.objects AS T
 JOIN sys.columns AS C
	 ON T.object_id = C.object_id
 JOIN sys.types AS P ON C.system_type_id = P.system_type_id
 WHERE T.type_desc = 'USER_TABLE'  AND c.name LIKE '%PTICompanyKey%'
ORDER BY 1

OPEN coUpdate
 
FETCH NEXT FROM coUpdate INTO @SQL
WHILE @@FETCH_STATUS<>-1
	BEGIN
	  EXEC sp_executesql @SQL 
	  FETCH NEXT FROM coUpdate INTO @SQL
	END
	CLOSE coUpdate
	DEALLOCATE coUpdate
	
END 