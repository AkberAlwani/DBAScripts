---select edfPONumber,* from RQDetail where edfPONumber like 'WP-001%'

WITH BasePO AS
(SELECT edfPONumber,idfRQHeaderKey from RQDetail where idfRQSessionKey=170)

SELECT * 
FROM 
(SELECT row_number() over(partition by idfRQHeaderKey order by idfRQHeaderkey) SNO,
edfPONumber,idfRQHeaderKey,idfDateCreated,idfDateModified,idfRQDetailKey 
FROM RQDetail (NOLOCK) a
WHERE exists (SELECT * from BasePO b 
               WHERE a.edfPONumber=b.edfPONumber and a.idfRQHeaderKey<>b.idfRQHeaderKey)) tmp

WHERE SNO=1 ORDER BY 2