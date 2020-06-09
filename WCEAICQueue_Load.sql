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
where idfParam02 like '%15976%'