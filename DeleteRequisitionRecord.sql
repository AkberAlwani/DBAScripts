Declare @Start_Req int, @End_Req  int
SELECT @Start_Req=26,@End_Req=26

delete RQRevHdr
from RQRevDtl rd
inner join RQRevHdr h on rd.idfRQRevHdrKey=h.idfRQRevHdrKey
inner join RQDetail rqd on rd.idfRQDetailKey=rqd.idfRQDetailKey
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req

delete RQRevDtl
from RQRevDtl rd 
inner join RQDetail rqd on rd.idfRQDetailKey=rqd.idfRQDetailKey
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req

delete from RCVAprHdr
from RCVAprDtl d 
inner join RCVAprHdr h on d.idfRCVAprHdrKey=h.idfRCVAprHdrKey
inner join RCVDetail rd on d.idfRCVDetailKey=rd.idfRCVDetailKey
inner join RQDetail  rqd  on rqd.edfPOLine = rd.edfPOLine and rqd.edfPONumber=rd.edfPONumber
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req

delete from RCVAprDtl 
from RCVAprDtl d 
inner join RCVDetail rd on d.idfRCVDetailKey=rd.idfRCVDetailKey
inner join RQDetail  rqd  on rqd.edfPOLine = rd.edfPOLine and rqd.edfPONumber=rd.edfPONumber
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req


delete RCVAprHdrHist
from RCVAprDtlHist rd
inner join RCVAprHdrHist h on rd.idfRCVAprHdrHistKey=h.idfRCVAprHdrHistKey
inner join RQDetail rqd on rd.idfRCVDetailKey=rqd.idfRCVDetailKey
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req


delete RCVAprDtlHist
from RCVAprDtlHist d 
inner join RCVDetail rd on d.idfRCVDetailKey=rd.idfRCVDetailKey
inner join RQDetail  rqd  on rqd.edfPOLine = rd.edfPOLine and rqd.edfPONumber=rd.edfPONumber
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req


DELETE RCVHeader 
FROM RCVDetail rd
inner join RCVHeader rh on rd.idfRCVHeaderKey=rh.idfRCVHeaderKey
inner join RQDetail  rqd  on rqd.edfPOLine = rd.edfPOLine and rqd.edfPONumber=rd.edfPONumber
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req

DELETE RCVDetail
FROm RCVDetail rd
inner join RQDetail  rqd  on rqd.edfPOLine = rd.edfPOLine and rqd.edfPONumber=rd.edfPONumber
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req

delete RQDetailLog 
FROm RQDetailLog  rd
inner join RQDetail  rqd  on rqd.idfRQDetailKey=rd.idfRQDetailKey
WHERE rqd.idfRQHeaderKey BETWEEN @Start_Req and @End_Req

DELETE RQHeader
WHERE idfRQHeaderKey BETWEEN @Start_Req and @End_Req

DELETE RQDetail
WHERE idfRQHeaderKey BETWEEN @Start_Req and @End_Req

