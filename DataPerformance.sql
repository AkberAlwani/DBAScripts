SELECT a.avg_user_impact
  * a.avg_total_user_cost
  * a.user_seeks,
  db_name(c.database_id),
  OBJECT_NAME(c.object_id, c.database_id),
  c.equality_columns,
  c.inequality_columns,
  c.included_columns,
  c.statement,
  'USE [' + DB_NAME(c.database_id) + '];
CREATE INDEX mrdenny_' + replace(replace(replace(replace
  (ISNULL(equality_columns, '')
  + ISNULL(c.inequality_columns, ''), ', ', '_'),
  '[', ''), ']', ''), ' ', '') + '
  ON [' + schema_name(d.schema_id) + ']
  .[' + OBJECT_NAME(c.object_id, c.database_id) + ']
  (' + ISNULL(equality_columns, '') +
  CASE WHEN c.equality_columns IS NOT NULL
    AND c.inequality_columns IS NOT NULL THEN ', '
    ELSE '' END + ISNULL(c.inequality_columns, '') + ')
    ' + CASE WHEN included_columns IS NOT NULL THEN
    'INCLUDE (' + included_columns + ')' ELSE '' END + '
    WITH (FILLFACTOR=70, ONLINE=ON)'
FROM sys.dm_db_missing_index_group_stats a
JOIN sys.dm_db_missing_index_groups b
  ON a.group_handle = b.index_group_handle
JOIN sys.dm_db_missing_index_details c
  ON b.index_handle = c.index_handle
JOIN sys.objects d ON c.object_id = d.object_id
WHERE c.database_id = db_id()
ORDER BY DB_NAME(c.database_id),
  ISNULL(equality_columns, '')
  + ISNULL(c.inequality_columns, ''), a.avg_user_impact
  * a.avg_total_user_cost * a.user_seeks DESC

  SELECT *

FROM sys.dm_os_wait_stats

ORDER BY wait_time_ms desc 

DECLARE @BatchRequests BIGINT;
 
SELECT @BatchRequests = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec';
 
WAITFOR DELAY '00:00:10';
 
SELECT (cntr_value - @BatchRequests) / 10 AS 'Batch Requests/sec'
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec';

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

-- Get Index Fragmentation
SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName
    , ind.name AS IndexName, indexstats.index_type_desc AS IndexType
    , indexstats.avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind  
        ON ind.object_id = indexstats.object_id 
        AND ind.index_id = indexstats.index_id 
WHERE indexstats.avg_fragmentation_in_percent > 25 
ORDER BY indexstats.avg_fragmentation_in_percent DESC
GO

EXEC sp_configure N'show advanced options'
