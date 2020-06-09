-- IN THE BELOW QUERY, Replace @idfRQHeaderKey in the Wehere clause with the Requisition Number of a requisition that had AA information and was a stock release

DECLARE @idfRQHeaderKey INT = 999999
DECLARE @DOCNUMBR VARCHAR(60)

SELECT @DOCNUMBR = edfDocumentNumber
FROM dbo.RQRevDtlRelease I WITH (NOLOCK)
INNER JOIN dbo.RQRevDtl REV WITH (NOLOCK) ON REV.idfRQRevDtlKey = I.idfRQRevDtlKey
INNER JOIN dbo.RQDetail DET WITH (NOLOCK) ON DET.idfRQDetailKey = REV.idfRQDetailKey
WHERE idfRQHeaderKey = @idfRQHeaderKey
GROUP BY edfDocumentNumber 

SELECT *
FROM 
dbo.AAG20000 WITH (NOLOCK) 
LEFT OUTER JOIN dbo.AAG20001 WITH (NOLOCK) ON AAG20001.aaSubLedgerHdrID = AAG20000.aaSubLedgerHdrID
LEFT OUTER JOIN dbo.AAG20002 WITH (NOLOCK) ON AAG20002.aaSubLedgerHdrID = AAG20001.aaSubLedgerHdrID AND AAG20002.aaSubLedgerDistID = AAG20001.aaSubLedgerDistID
LEFT OUTER JOIN dbo.AAG20003 WITH (NOLOCK) ON AAG20003.aaSubLedgerHdrID = AAG20002.aaSubLedgerHdrID AND AAG20003.aaSubLedgerDistID = AAG20002.aaSubLedgerDistID AND AAG20003.aaSubLedgerAssignID = AAG20002.aaSubLedgerAssignID 
WHERE DOCNUMBR = @DOCNUMBR