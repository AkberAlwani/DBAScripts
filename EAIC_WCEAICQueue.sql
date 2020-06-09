-- this will insert of the Inventory Accruals that didn't get processed into the EAIC Queue so that they can be sent to GP

INSERT INTO [dbo].[WCEAICQueue]
	([idfDescription]
	,[idfLinkTableKey]
	,[idfLinkTableName]
	,[idfParam01]
	,[idfParam02]
	,[idfParam03]
	,[idfParamText01]
	,[idfProcessAttempts]
	,[idfProcessedLast]
	,[idfProcessErrorLast]
	,[idfType]
	,[idfDateCreated]
	,[idfDateModified])
SELECT '::EAICQUEUE-GLPROCBATCH::'					-- <idfDescription, varchar(128),>
	,G.idfGLJournalHdrKey						-- <idfLinkTableKey, int,>
	,'GLJournalHdr'								-- <idfLinkTableName, varchar(128),>
	,G.idfJournalNumber							-- <idfParam01, varchar(128),>
	,''											-- <idfParam02, varchar(128),>
	,''											-- <idfParam03, varchar(128),>
	,''											-- <idfParamText01, text,>
	,0											-- <idfProcessAttempts, int,>
	,NULL										-- <idfProcessedLast, datetime,>
	,''											-- <idfProcessErrorLast, text,>
	,'::EAICQUEUE-GL::'							-- <idfType, varchar(60),>
	,GETDATE()									-- <idfDateCreated, datetime,>
	,GETDATE()									-- <idfDateModified, datetime,>)
FROM GLJournalHdr G WITH (NOLOCK)
LEFT JOIN WCEAICQueue Q WITH (NOLOCK) ON Q.idfLinkTableKey = G.idfGLJournalHdrKey AND Q.idfLinkTableName = 'GLJournalHdr'
LEFT JOIN WCEAICQueueHist QH WITH (NOLOCK) ON QH.idfLinkTableKey = G.idfGLJournalHdrKey AND QH.idfLinkTableName = 'GLJournalHdr'
WHERE G.idfTableLinkName = 'IVStockAdjustmentHdr' AND G.idfDocument02 LIKE 'RCT%'
AND Q.idfWCEAICQueueKey IS NULL AND QH.idfWCEAICQueueHistKey IS NULL
AND G.idfDatePost BETWEEN '2018-02-15 00:00:00.000' AND '2018-02-28 00:00:00.000'


-- 2nd Option
SELECT * From WCEAICQueue
SELECT * INTO WCEAICQueue_tmp from WCEAICQueue

DELETE FROm WCEAICQueue

INSERT INTO [dbo].[WCEAICQueue]
           (
		    [idfBatchStart] ,[idfDescription],[idfLinkTableName],[idfParam01]
           ,[idfParam02],[idfParam03],[idfParamText01],[idfPriority],[idfProcessAttempts]
           ,[idfProcessedLast],[idfProcessErrorLast],[idfType]
           ,[idfDateCreated],[idfDateModified],[idfBatchKey],[idfLinkTableKey])

SELECT   [idfBatchStart],[idfDescription],[idfLinkTableName],[idfParam01],[idfParam02]
           ,[idfParam03],[idfParamText01],[idfPriority],[idfProcessAttempts],[idfProcessedLast],[idfProcessErrorLast]
           ,[idfType],[idfDateCreated],[idfDateModified],[idfBatchKey],[idfLinkTableKey]
FROM WCEAICQueue_tmp


iNSERT INTO [dbo].[WCEAICQueue]
           (
		    [idfBatchStart] ,[idfDescription],[idfLinkTableName],[idfParam01]
           ,[idfParam02],[idfParam03],[idfParamText01],[idfPriority],[idfProcessAttempts]
           ,[idfProcessedLast],[idfProcessErrorLast],[idfType]
           ,[idfDateCreated],[idfDateModified],[idfBatchKey],[idfLinkTableKey])
SELECT
[idfBatchStart] ,[idfDescription],[idfLinkTableName],[idfParam01]
           ,[idfParam02],[idfParam03],[idfParamText01],[idfPriority],[idfProcessAttempts]
           ,[idfProcessedLast],[idfProcessErrorLast],[idfType]
           ,[idfDateCreated],[idfDateModified],[idfBatchKey],[idfLinkTableKey]
FROM WCEAICQueueHist
where idfDocument02 in ('00000000000020932','00000000000020933')
