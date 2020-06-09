SELECT
	DB_NAME(dbid) AS 'Database Name'
   ,COUNT(dbid) AS 'Total Connections'
FROM master.dbo.sysprocesses WITH (NOLOCK)
WHERE dbid > 0
GROUP BY dbid
SELECT
	@@MAX_CONNECTIONS AS 'Max Allowed Connections'

	USE master
GO
