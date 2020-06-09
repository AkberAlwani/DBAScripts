Update RQDetail D set idfRQSessionKey=145 where idfRQSessionKey=150 and is (Select * from RQRevDtl DT where D.idfRQDetailKey=DT.idfRQDetailKey)


UPDATE RQDetail
set idfRQSessionKey=145
FROM RQDetail
INNER JOIN RQRevDtl on RQRevDtl.idfRQDetailKey=RQDetail.idfRQDetailKey
WHERE RQDetail.idfRQsessionKey=150 and RQRevDTL.idfRQRevHdrKey=10823



Select idfRQDetailKey,idfRQRevHdrKey,* from RQRevDtl
Select idfRQSessionkey,* from RQDetail  where idfRQDetailKey in (14,15,16,17)


Select D.idfRQHeaderKey,RD.idfRQRevHdrKey,* from RQDetail D
Inner Join  RQRevDtl RD on RD.idfRQDetailKey = D.idfRQDetailKey
where D.idfRQSessionKey=150  and RD.idfRQRevHdrKey=10823