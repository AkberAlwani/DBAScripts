SET NOCOUNT ON
use master
GO
DECLARE @DbName Varchar(100),@SQL nvarchar(4000),@CompKey INT

DECLARE curCompany cursor FOR
SELECT idfPTICompanyKey,rtrim(ltrim(idfDbName))
 FROM  PTImaster..PTICompany WITH (NOLOCK)


OPEN curCompany 
FETCH NEXT FROM curCompany  INTO @CompKey,@DbName
WHILE @@FETCH_STATUS<>-1
BEGIN
	SET @SQL='USE '+@DBName+'; 	SELECT '''+@DbName+'''  Company ,lu.idfLineUpID ListID,lu.idfDescription Description,''USER:''+s.idfDescription Approval,s.idfSecurityID Id,wa.Alternate Alternate
				from WCLineUpSec ws WITH (NOLOCK)
				inner join WCSecurity s WITH (NOLOCK) on ws.idfWCSecurityKey=s.idfWCSecurityKey
				inner join WCLineUp lu WITH (NOLOCK) on ws.idfWCLineUpKey=lu.idfWCLineUpKey
				left outer join (select ss.idfDescription Alternate,ss.idfWCSecurityKey,idfWCLineUpSecKey
				from WCLineUpSecAltr wa WITH (NOLOCK)
				inner join WCSEcurity ss WITH (NOLOCK) on wa.idfWCSEcurityKey=ss.idfWCSEcurityKey)    wa
				on ws.idfWCLineUpSecKey=wa.idfWCLineUpSecKey
				UNION 
				select '''+@DbName+''' Company ,lu.idfLineUpID ListID,lu.idfDescription Description,''ROLE:''+rr.idfDescription,rr.idfRoleID,wa.Alternate
				from WCLineUp lu WITH (NOLOCK)
				inner join WCLineUpSec ws WITH (NOLOCK) on lu.idfWCLineUpKey=ws.idfWCLineUpKey
				inner join WCRole rr WITH (NOLOCK) on rr.idfWCRoleKey=ws.idfWCRoleKey
				inner join WCSecRole wsr WITH (NOLOCK) on rr.idfWCRoleKey=wsr.idfWCRoleKey
				inner join WCSecurity s WITH (NOLOCK) on wsr.idfWCSecurityKey=s.idfWCSecurityKey
				left outer join (select ''USER:''+ss.idfDescription Alternate,ss.idfWCSecurityKey,idfWCLineUpSecKey
								 from WCLineUpSecAltr wa WITH (NOLOCK)
								 inner join WCSEcurity ss WITH (NOLOCK) on wa.idfWCSecurityKey=ss.idfWCSecurityKey
								 UNION ALL
								 SELECT ''ROLE:''+rr.idfDescription Alternate,rr.idfWCRoleKey,idfWCLineUpSecKey
								 from WCLineUpSecAltr wa WITH (NOLOCK)
								  inner join WCRole rr WITH (NOLOCK)  on wa.idfWCRoleKey=rr.idfWCRoleKey)    wa
				 on ws.idfWCLineUpSecKey=wa.idfWCLineUpSecKey'
	
	EXEC sp_executesql @SQL
	FETCH NEXT FROM curCompany  INTO @CompKey,@DbName
END
CLOSE curCompany 
DEALLOCATE curCompany 
