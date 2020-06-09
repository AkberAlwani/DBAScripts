
DECLARE @VendorDocNum TABLE (idfRQHeaderKey INT,idfVendorDocNum VARCHAR(60),vdfVendorID VARCHAR(60),idfAPVendorKey INT)

INSERT INTO @VendorDocNum
SELECT MAX(idfRQHeaderKey),idfVendorDocNum,idfVendorID,R.idfAPVendorKey
FROM dbo.RQRevDtlRQHeader R WITH (NOLOCK)
INNER JOIN dbo.APVendor A WITH (NOLOCK) ON A.idfAPVendorKey = R.idfAPVendorKey
WHERE idfRQRevHdrKey = 694 --replace with Review session #
GROUP BY idfVendorDocNum,idfVendorID,R.idfAPVendorKey

SELECT idfRQHeaderKey AS 'Req #',idfVendorDocNum,vdfVendorID
FROM @VendorDocNum V
INNER JOIN dbo.PM10000 WITH (NOLOCK) ON VENDORID = vdfVendorID AND DOCNUMBR = idfVendorDocNum
UNION ALL
SELECT idfRQHeaderKey AS 'Req #',idfVendorDocNum,vdfVendorID
FROM @VendorDocNum V
INNER JOIN dbo.PM20000 WITH (NOLOCK) ON VENDORID = vdfVendorID AND DOCNUMBR = idfVendorDocNum
UNION ALL
SELECT idfRQHeaderKey AS 'Req #',idfVendorDocNum,vdfVendorID
FROM @VendorDocNum V
INNER JOIN dbo.PM30200 WITH (NOLOCK) ON VENDORID = vdfVendorID AND DOCNUMBR = idfVendorDocNum
UNION ALL
SELECT idfRQHeaderKey AS 'Req #',idfVendorDocNum,vdfVendorID
FROM @VendorDocNum V
INNER JOIN dbo.POP10300 WITH (NOLOCK) ON VENDORID = vdfVendorID AND VNDDOCNM = idfVendorDocNum
UNION ALL
SELECT V.idfRQHeaderKey AS 'Req #',V.idfVendorDocNum,vdfVendorID
FROM @VendorDocNum V
INNER JOIN dbo.RQHeader WITH (NOLOCK) ON RQHeader.idfAPVendorKey = V.idfAPVendorKey AND RQHeader.idfVendorDocNum = V.idfVendorDocNum AND RQHeader.idfRQHeaderKey <> V.idfRQHeaderKey
