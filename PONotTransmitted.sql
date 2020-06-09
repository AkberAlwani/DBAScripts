---Output this in TEST1.CSV
WITH TEMP AS (
SELECT   L1.idfWCTransactionLogKey,L1.idfComment1,L1.idfDocument4,L1.idfDateCreated,L1.idfDateModified
        ,RQRevHdr.idfRQRevHdrKey RevHdrKey,RQRevHdr.idfDateModified RevDateModified
		,PM00200.VENDNAME			AS VENDNUM
		,RQHeader.idfRQHeaderKey	AS REQNUM
		,RQRevDtl.edfPONumber		AS PONUM
		,DATEDIFF(minute , RQRevHdr.idfDateModified, GETDATE()) AS TIMEELAP
		,RQDetail.idfRQDetailKey    
	FROM dbo.RQRevHdr			WITH (NOLOCK)
	INNER JOIN dbo.RQRevDtl		WITH (NOLOCK) ON RQRevDtl.idfRQRevHdrKey = RQRevHdr.idfRQRevHdrKey
	INNER JOIN dbo.RQDetail		WITH (NOLOCK) ON RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey
	INNER JOIN dbo.RQHeader		WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey
	INNER JOIN dbo.PM00200		WITH (NOLOCK) ON PM00200.VENDORID		 = RQRevDtl.edfVendor
	LEFT OUTER JOIN dbo.WCTransactionLog L1 WITH (NOLOCK) ON L1.idfType = '::12722::' AND L1.idfDocument2 = ('::12459::: ' + RQRevDtl.edfPONumber)
	LEFT OUTER JOIN dbo.WCTransactionLog L2 WITH (NOLOCK) ON L2.idfType = '::12719::' AND L2.idfDocument2 = ('::12459::: ' + RQRevDtl.edfPONumber) AND CONVERT(VARCHAR(255),L2.idfComment2) = '::12104::'
	INNER JOIN dbo.WCSystem		WITH (NOLOCK) ON idfFlagMail = 1
	WHERE RQRevHdr.idfFlagProcessed = 1	
	AND CONVERT(DATE, RQRevHdr.idfDateModified) >= '2019/01/01') 

SELECT T.idfWCTransactionLogKey,T.idfComment1,T.idfDocument4,T.idfDateCreated,T.idfDateModified,
RevHdrKey,RevDateModified,VENDNUM,REQNUM,PONUM,TIMEELAP,idfRQAprHdrKey RQAprHdrKey
FROM TEMP  T
LEFT OUTER JOIN RQAprDtl D (NOLOCK) ON T.idfRQDetailKey=D.idfRQDetailKey AND
D.idfRQAprHdrKey in (Select Max(idfRQAprHdrKey) 
FROM TEMP  TT
INNER JOIN RQAprDtl DD (NOLOCK) ON TT.idfRQDetailKey=DD.idfRQDetailKey)
Order by 7 desc
	

-- Output this to TEST2.csv
SELECT   L1.idfWCTransactionLogKey,L1.idfComment1,L1.idfDocument4,L1.idfDateCreated,L1.idfDateModified
        ,RQRevHdr.idfRQRevHdrKey RevHdrKey,RQRevHdr.idfDateModified RevDateModified
		,PM00200.VENDNAME			AS VENDNUM
		,RQHeader.idfRQHeaderKey	AS REQNUM
		,RQRevDtl.edfPONumber		AS PONUM
		,DATEDIFF(minute , RQRevHdr.idfDateModified, GETDATE()) AS TIMEELAP
	FROM dbo.RQRevHdr			WITH (NOLOCK)
	INNER JOIN dbo.RQRevDtl		WITH (NOLOCK) ON RQRevDtl.idfRQRevHdrKey = RQRevHdr.idfRQRevHdrKey
	INNER JOIN dbo.RQDetail		WITH (NOLOCK) ON RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey
	INNER JOIN dbo.RQHeader		WITH (NOLOCK) ON RQHeader.idfRQHeaderKey = RQDetail.idfRQHeaderKey
	--LEFT JOIN dbo.RQAprDtl     WITH (NOLOCK) ON RQDetail.idfRQDetailKey = RQAprDtl.idfRQDetailKey
	INNER JOIN dbo.PM00200		WITH (NOLOCK) ON PM00200.VENDORID		 = RQRevDtl.edfVendor
	LEFT OUTER JOIN dbo.WCTransactionLog L1 WITH (NOLOCK) ON L1.idfType = '::12722::' AND L1.idfDocument2 = ('::12459::: ' + RQRevDtl.edfPONumber)
	LEFT OUTER JOIN dbo.WCTransactionLog L2 WITH (NOLOCK) ON L2.idfType = '::12719::' AND L2.idfDocument2 = ('::12459::: ' + RQRevDtl.edfPONumber) AND CONVERT(VARCHAR(255),L2.idfComment2) = '::12104::'
	INNER JOIN dbo.WCSystem		WITH (NOLOCK) ON idfFlagMail = 1
	WHERE RQRevHdr.idfFlagProcessed = 1	
	AND CONVERT(DATE, RQRevHdr.idfDateModified) >= '2019/01/01'
	Order by 7 desc

	

