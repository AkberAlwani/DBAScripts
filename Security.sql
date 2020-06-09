SELECT a.idfWCRoleKey,idfWCSecurityAccessTemplateKey,b.idfRoleID
from WCSecurityAccess a 
inner join WCRole b on a.idfWCRoleKey=b.idfWCRoleKey
where a.idfWCSecurityAccessTemplateKey =5

select * from WCSecurityAccess where idfWCSecurityAccessTemplateKey =5

Select a.idfWCSecurityKey,idfWCSecurityAccessTemplateKey,idfSecurityID
from WCSecurityAccess a 
inner join WCSecurity b on a.idfWCSecurityKey=b.idfWCSecurityKey
where a.idfWCSecurityAccessTemplateKey =5

select * from PODetailLogHist where 
select * from PODetailHist where idfPOHeaderHistKey =(select POHeaderHist where idfPO


select * from PODetail where idfPOHeaderKey= (select idfPOHeaderKey from POHeader where idfPONumber='PO000019')
select rh.idfRCVHeaderHistKey,rh.idfRCTNumber,
idfRCVDetailHistKey,idfAmtExtended,idfAmtExtendedHome,idfDateReceived,idfPriceApr,idfPriceHome,idfQtyInvMatch,idfQtyInvMatchReturned,idfQtyInvoiced
idfQtyShipped 
from RCVDetailHist rd inner join RCVHeaderHist rh on 
  rd.idfRCVHeaderHistKey=rh.idfRCVHeaderHistKey
where idfPONumber='PO000019'



Select a.idfWCSecurityKey,b.idfSecurityID,c.idfRoleID,c.idfDescription
from WCSecRole a 
inner join WCSecurity b on a.idfWCSecurityKey=b.idfWCSecurityKey
left join WCRole C on a.idfWCRoleKey=c.idfWCRoleKey

