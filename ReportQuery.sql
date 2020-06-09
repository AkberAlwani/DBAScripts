select * from RCVDetail where idfRCVHeaderKey=40

select h.idfRQHeaderKey [PR Number],h.idfDescription [PR Description],Max(a.idfDateModified) [PR Approve Date],
d.idfDateRequired [PR Required by Date],d.idfDatePromised [PO Promised Date],Max(r.idfDateReceived) [PO Delivery Date]
from RQHeader h 
inner join RQDetail d       on h.idfRQHeaderKey=d.idfRQHeaderKey
left outer join RQAprDtl a  on d.idfRQDetailKey=a.idfRQDetailKey
left outer join RCVDetail r on d.edfPOLine = r.edfPOLine and d.edfPONumber=r.edfPONumber
group by h.idfRQHeaderKey ,h.idfDescription,d.idfDateRequired ,d.idfDatePromised 

select idfRCVDetailKey,edfPOLine,edfPONumber,* from RQDetail
where idfRQHeaderKey=26

