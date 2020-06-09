USE DYNAMICS
GO
DECLARE @user_name VARCHAR(50),@SQL VARCHAR(500)

DECLARE cur_users CURSOR FOR SELECT DISTINCT
	idfSecurityID
FROM PTIMaster..PTISecurity WHERE idfSecurityID<>'sa' AND idfSecurityID not like '%\%'
OPEN cur_users
FETCH NEXT FROM cur_users INTO @user_name
WHILE @@FETCH_STATUS = 0
BEGIN
SET @SQL = 'GRANT SELECT ON ACTIVITY TO [PTIWorkPlaceUser]'
EXEC (@SQL)
SET @SQL = 'GRANT SELECT ON ACTIVITY TO [PTIWorkPlaceAdmin] WITH GRANT OPTION'
EXEC (@SQL)
SET @SQL = 'GRANT SELECT ON ACTIVITY TO ' + @user_name  -- if Authentication is SQL

EXEC (@SQL)
FETCH NEXT FROM cur_users INTO @user_name
END
CLOSE cur_users
DEALLOCATE cur_users