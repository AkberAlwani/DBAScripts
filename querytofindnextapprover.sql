Select * from WCAprPath

Select D.idfRQHeaderKey as Requisition, Sec.idfSEcurityID as  approver from WCAprPath	P
Inner Join RQDetail D on D.idfRQDetailKey=P.idfLinkTableKey
Inner Join WCRRGroupLineUp RR on RR.idfWCRRGroupLineUpKey=P.idfWCRRGroupLineUpKey
Inner Join WCLineUpSec lnup on lnup.idfWCLineUpKey = RR.idfWCLineUpKey
Inner Join WCSecurity Sec on Sec.idfWCSecurityKey=lnup.idfWCSecurityKey
Where D.idfRQSessionKey>100 and d.idfRQSessionKey<130 




Select * from WCLineUpSec

Select * from RQAPrDtl

