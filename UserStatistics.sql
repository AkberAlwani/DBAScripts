SELECT s.idfWCSecurityKey,s.idfDescription ,Requsition, CheckRequest,Invoice,Shipment,ShipmentInvoice,Approval,Reviews
from WCSecurity s WITH (NOLOCK)
LEFT OUTER JOIN (SELECT idfWCSecurityKey ,Count(idfRQHeaderKey) Requsition 
          from RQHeader  WITH (NOLOCK)
          where idfRQTypeKey=1
            Group by idfWCSecurityKey ) t1 on s.idfWCSecurityKey=t1.idfWCSecurityKey
LEFT OUTER JOIN (SELECT idfWCSecurityKey ,Count(idfRQHeaderKey) CheckRequest
                  from RQHeader WITH (NOLOCK)
                   where idfRQTypeKey=3
             Group by idfWCSecurityKey ) t2 on s.idfWCSecurityKey=t2.idfWCSecurityKey
LEFT OUTER JOIN (select idfWCSecurityKey,Count(idfRCVHeaderKey) Invoice 
				from RCVHeader WITH (NOLOCK)
			where idfTransactionType=2 
			group by idfWCSecurityKey ) t3 on s.idfWCSecurityKey=t3.idfWCSecurityKey
LEFT OUTER JOIN (select idfWCSecurityKey,Count(idfRCVHeaderKey) Shipment
                 from RCVHeader WITH (NOLOCK)
                 where idfTransactionType=1  
                 group by idfWCSecurityKey  ) t4 on s.idfWCSecurityKey=t4.idfWCSecurityKey
LEFT OUTER JOIN (select idfWCSecurityKey,Count(idfRCVHeaderKey) ShipmentInvoice
				from RCVHeader WITH (NOLOCK)
				where idfTransactionType=3 
				group by idfWCSecurityKey ) t5 on s.idfWCSecurityKey=t5.idfWCSecurityKey
LEFT OUTER JOIN (select idfWCSecurityKey,Count(idfRQAprHdrKey) Approval 
				from RQAprHdr WITH (NOLOCK)
				group by idfWCSecurityKey ) t6 on s.idfWCSecurityKey=t6.idfWCSecurityKey 
LEFT OUTER JOIN (select idfWCSecurityKey,Count(idfRQRevHdrKey) Reviews
				 from RQRevHdr WITH (NOLOCK)
				 group by idfWCSecurityKey ) t7 on s.idfWCSecurityKey=t7.idfWCSecurityKey
