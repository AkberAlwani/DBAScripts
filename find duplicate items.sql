
select PODetail.idfLine, PODetail.idfPOHeaderKey
from PODetail
where POHeader.idfPOHeaderKey=PODetail.idfPOHeaderKey
group by PODetail.idfLine, PODetail.idfPOHeaderKey having COUNT (PODetail.idfLine) >1