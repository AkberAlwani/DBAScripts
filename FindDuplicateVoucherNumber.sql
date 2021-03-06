SELECT 1 Flag,DOCNUMBR,DOCDATE,VENDORID,TRXDSCRN,VCHRNMBR
FROM PM10000 A -- PM Work Table
WHERE EXISTS (
SELECT * FROM (SELECT VENDORID,DOCNUMBR FROM PM10000 GROUP BY VENDORID,DOCNUMBR HAVING COUNT(*)>1) B
WHERE A.VENDORID=B.VENDORID AND A.DOCNUMBR =B.DOCNUMBR )
UNION ALL
SELECT 2,DOCNUMBR,DOCDATE,VENDORID,TRXDSCRN,VCHRNMBR
FROM PM20000 A -- PM Open Table
WHERE EXISTS (
SELECT * FROM (SELECT VENDORID,DOCNUMBR FROM PM20000 GROUP BY VENDORID,DOCNUMBR HAVING COUNT(*)>1) B
WHERE A.VENDORID=B.VENDORID AND A.DOCNUMBR =B.DOCNUMBR )
UNION ALL
SELECT 3,DOCNUMBR,DOCDATE,VENDORID,TRXDSCRN,VCHRNMBR
FROM PM30200 A --- PM History Table
WHERE EXISTS (SELECT * FROM 
(SELECT VENDORID,DOCNUMBR FROM PM30200 GROUP BY VENDORID,DOCNUMBR HAVING COUNT(*)>1) B
WHERE A.VENDORID=B.VENDORID AND A.DOCNUMBR =B.DOCNUMBR )
ORDER BY 3,1