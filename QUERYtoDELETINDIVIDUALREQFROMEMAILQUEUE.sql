DELETE WCEmailQueue
FROM WCEmailQueue E
INNER JOIN RQDetail D ON D.idfRQDetailKey = E.idfInfoKey AND E.idfWCEmailDocDtlKey = 5
WHERE idfRQHeaderKey =xxx
