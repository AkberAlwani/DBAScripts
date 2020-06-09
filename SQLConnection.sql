SELECT
	esd.idfEXPSessionKey,*
FROM dbo.EXPExpenseSheetDtl esd

SELECT esds.idfEXPSessionKey, * FROM dbo.EXPExpenseSheetDtlSplit esds

SELECT
	DB_NAME(dbid) AS DBName
   ,COUNT(dbid) AS NumberOfConnections
   ,loginame AS LoginName
FROM sys.sysprocesses
WHERE dbid > 0
GROUP BY dbid,loginame

SELECT 
   COUNT(dbid) as TotalConnections
FROM sys.sysprocesses
WHERE dbid > 0

SELECT
	DB_NAME(dbid) AS DBName
   ,COUNT(dbid) AS NumberOfConnections
   ,loginame AS LoginName
   ,hostname
   ,hostprocess
FROM sys.sysprocesses WITH (NOLOCK)
WHERE dbid > 0
GROUP BY dbid
		,loginame
		,hostname
		,hostprocess