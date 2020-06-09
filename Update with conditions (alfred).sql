Select RQRevDtl.idfRQDetailKey,RD.idfRQSessionKey,* from RQDetail RD
Inner Join RQRevDtl on RD.idfRQDetailKey = RQRevDtl.idfRQDetailKey
Left Outer Join RQRevDtlRelease on RQRevDtlRelease.idfRQRevDtlKey=RQRevDtl.idfRQRevDtlKey
Where RQRevDtl.idfCodeRev='RELEASE' and RQRevDtlRelease.idfRQRevDtlReleaseKey is null and 
RQRevDtl.idfRQRevHdrKey IN ('190709','190710','190722','190721','190723')

Begin Tran
Update RQDetail set idfRQSessionKey=145 from RQdetail
Inner Join RQRevDtl on RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey
Left Outer Join RQRevDtlRelease on RQRevDtlRelease.idfRQRevDtlKey=RQRevDtl.idfRQRevDtlKey
Where RQRevDtl.idfCodeRev='RELEASE' and RQRevDtlRelease.idfRQRevDtlReleaseKey is null and 
RQRevDtl.idfRQRevHdrKey IN ('190709','190710','190722','190721','190723')
Rollback tran