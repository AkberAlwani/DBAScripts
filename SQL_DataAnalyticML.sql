USE [AdventureWorks2014]
 -- Your database goes here
--DBCC DROPCLEANBUFFERS
--SET STATISTICS TIME ON
DECLARE @schema SYSNAME, @table SYSNAME
SET @schema = 'HumanResources' -- Your schema goes here
SET @table = 'Employee'
 -- Your table goes here
CREATE TABLE #Info ([Column] SYSNAME, [SystemType] TINYINT, [UserType] INT, [Min] VARCHAR(MAX), [Max] VARCHAR(MAX), [Std] VARCHAR(MAX), [Var] VARCHAR(MAX), [Mean] VARCHAR(MAX), [Mode] VARCHAR(MAX), [DistinctRows] BIGINT, [MissingRows] BIGINT)
CREATE TABLE #Info2 ([Column] SYSNAME, [Std] VARCHAR(MAX), [Var] VARCHAR(MAX), [Avg] VARCHAR(MAX))
CREATE TABLE #Info3 ([Column] SYSNAME, [Mode] VARCHAR(MAX), [NA] BIGINT)
CREATE TABLE #Info4 ([Column] SYSNAME, [Dis] BIGINT)
DECLARE @count BIGINT, @cmd VARCHAR(MAX)
-- Number of rows
SELECT
	@count = SUM([row_count])
FROM [sys].[dm_db_partition_stats]
WHERE [object_id] = OBJECT_ID(@schema + '.' + @table)
-- Min, Max
SET @cmd = ''
SELECT
	@cmd = @cmd + 'MIN(' + [name] + ') [Min' + [name] + '],MAX(' + [name] + ') [Max' + [name] + '],'
FROM [sys].[columns]
WHERE [object_id] = OBJECT_ID(@schema + '.' + @table)
AND [user_type_id] NOT IN (104, 189, 258) --BIT, TIMESTAMP, FLAG
SET @cmd = LEFT(@cmd, LEN(@cmd) - 1)
SELECT
	@cmd = 'SELECT ' + @cmd + ' INTO [tmp] FROM [' + @schema + '].[' + @table + ']'
EXEC (@cmd)
SET @cmd = ''
SELECT
	@cmd = @cmd + 'SELECT ''' + [name] + ''',' + CAST([system_type_id] AS VARCHAR(MAX)) + ',' + CAST([user_type_id] AS VARCHAR(MAX)) + ',CAST([Min' + [name] + '] AS VARCHAR(MAX)),CAST([Max' + [name] + '] AS VARCHAR(MAX)) FROM [tmp]
UNION ALL
'
FROM [sys].[columns]
WHERE [object_id] = OBJECT_ID(@schema + '.' + @table)
AND [user_type_id] NOT IN (104, 189, 258) --BIT, TIMESTAMP, FLAG
SET @cmd = 'INSERT #Info([Column],[SystemType],[UserType],[Min],[Max]) ' + LEFT(@cmd, LEN(@cmd) - 10)
EXEC (@cmd)
-- Delete null columns
DELETE FROM #Info
WHERE [Min] IS NULL
	AND [Max] IS NULL
-- STDEV, VAR, AVG
SET @cmd = ''
SELECT
	@cmd = @cmd + 'STDEV(' + [Column] + ') [Std' + [Column] + '],VAR(' + [Column] + ') [Var' + [Column] + '],AVG(' + [Column] + ') [Avg' + [Column] + '],'
FROM #Info
WHERE [UserType] IN (48, 52, 56, 59, 60, 62, 106, 122, 127)
SET @cmd = LEFT(@cmd, LEN(@cmd) - 1)
SELECT
	@cmd = 'SELECT ' + @cmd + ' INTO [tmp2] FROM [' + @schema + '].[' + @table + ']'
EXEC (@cmd)
SET @cmd = ''
SELECT
	@cmd = @cmd + 'SELECT ''' + [Column] + ''',CAST([Std' + [Column] + '] AS VARCHAR(MAX)),CAST([Var' + [Column] + '] AS VARCHAR(MAX)),CAST([Avg' + [Column] + '] AS VARCHAR(MAX)) FROM [tmp2]
UNION ALL
'
FROM #Info
WHERE [UserType] IN (48, 52, 56, 59, 60, 62, 106, 122, 127)
SET @cmd = 'INSERT #Info2 ' + LEFT(@cmd, LEN(@cmd) - 10)
EXEC (@cmd)
UPDATE [i]
SET [i].[Mean] = [i2].[Avg]
   ,[i].[Std] = [i2].[Std]
   ,[i].[Var] = [i2].[Var]
FROM #Info [i]
INNER JOIN #Info2 [i2]
	ON [i2].[Column] = [i].[Column]
-- Mode, missing rows
SET @cmd = ''
SELECT
	@cmd = @cmd + '(SELECT TOP 1 CAST([' + [Column] + '] AS VARCHAR(MAX))+'' (''+CAST([cn] AS VARCHAR(MAX))+'')'' FROM (
SELECT [' + [Column] + '], COUNT(1) [cn]
FROM [' + @schema + '].[' + @table + ']
WHERE [' + [Column] + '] IS NOT NULL
GROUP BY [' + [Column] + ']) [a]
ORDER BY [cn] DESC) [Mode' + [Column] + '],
(SELECT COUNT(1)
FROM [' + @schema + '].[' + @table + ']
WHERE [' + [Column] + '] IS NULL) [NA' + [Column] + '],'
FROM #Info
SET @cmd = LEFT(@cmd, LEN(@cmd) - 1)
SELECT
	@cmd = 'SELECT ' + @cmd + ' INTO [tmp3]'
EXEC (@cmd)
SET @cmd = ''
SELECT
	@cmd = @cmd + 'SELECT ''' + [Column] + ''',CAST([Mode' + [Column] + '] AS VARCHAR(MAX)),[NA' + [Column] + '] FROM [tmp3]
UNION ALL
'
FROM #Info
SET @cmd = 'INSERT #Info3 ' + LEFT(@cmd, LEN(@cmd) - 10)
EXEC (@cmd)
UPDATE [i]
SET [i].[Mode] = [i2].[Mode]
   ,[i].[MissingRows] = [i2].[NA]
FROM #Info [i]
INNER JOIN #Info3 [i2]
	ON [i2].[Column] = [i].[Column]
-- Count distinct
SET @cmd = ''
SELECT
	@cmd = @cmd + 'COUNT(DISTINCT [' + [Column] + ']) [Dis' + [Column] + '],'
FROM #Info
SET @cmd = LEFT(@cmd, LEN(@cmd) - 1)
SELECT
	@cmd = 'SELECT ' + @cmd + ' INTO [tmp4] FROM [' + @schema + '].[' + @table + ']'
EXEC (@cmd)
SET @cmd = ''
SELECT
	@cmd = @cmd + 'SELECT ''' + [Column] + ''',[Dis' + [Column] + '] FROM [tmp4]
UNION ALL
'
FROM #Info
SET @cmd = 'INSERT #Info4 ' + LEFT(@cmd, LEN(@cmd) - 10)
EXEC (@cmd)
UPDATE [i]
SET [i].[DistinctRows] = [i2].[Dis]
FROM #Info [i]
INNER JOIN #Info4 [i2]
	ON [i2].[Column] = [i].[Column]
-- Return results
SELECT
	[i].[Column]
   ,[t].[name] [Type]
   ,[i].[Min]
   ,[i].[Max]
   ,[i].[Std]
   ,[i].[Var]
   ,[i].[Mean]
   ,[i].[Mode]
   ,@count [Rows]
   ,[i].[MissingRows]
   ,[i].[DistinctRows]
FROM #Info [i]
INNER JOIN [sys].[types] [t]
	ON [t].[system_type_id] = [i].[SystemType]
		AND [t].[user_type_id] = [i].[UserType]
DROP TABLE #Info
DROP TABLE #Info2
DROP TABLE #Info3
DROP TABLE #Info4
DROP TABLE [tmp]
DROP TABLE [tmp2]
DROP TABLE [tmp3]
DROP TABLE [tmp4]