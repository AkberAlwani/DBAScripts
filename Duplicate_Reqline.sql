SELECT ROW_NUMBER() OVER (Partition By idfRQHeaderKey  ORDER BY idfRQDetailKey) AS NewLine, idfLine,idfRQHeaderKey,*
FROM RQDetail

update RQDetail set idfLine=1 where idfLine=2

UPDATE RQDetail set idfLine=NewLine
from (SELECT ROW_NUMBER() OVER (Partition By idfRQHeaderKey ORDER BY idfRQDetailKey) AS NewLine, idfRQDetailKey,idfRQHeaderKey
       from RQDetail 
	   WHERE idfRQHeaderKey=117) a
INNER JOIN RQDetail b ON a.idfRQDetailKey=b.idfRQDetailKey
WHERE idfLine<>NewLine and a.idfRQHeaderKey=117



UPDATE RQHeader set idfLastLine=MaxLine
from (SELECT Max(idfLine) AS MaxLine, idfRQHeaderKey
       from RQDetail 
	   GROUP by idfRQHeaderKey) a
INNER JOIN RQHeader b ON a.idfRQHeaderKey=b.idfRQHeaderKey
WHERE idfLastLine<>MaxLine and a.idfRQHeaderKey=117
