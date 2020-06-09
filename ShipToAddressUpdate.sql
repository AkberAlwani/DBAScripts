UPDATE RQAprDtl
SET  idfShipToAddr1               = idfAddr1              
       ,idfShipToAddr2            = idfAddr2        
       ,idfShipToAddr3            = idfAddr3        
       ,idfShipToAltPhone1        = idfAltPhone1  
       ,idfShipToAltPhone2        = idfAltPhone2  
       ,idfShipToCity             = idfCity      
       ,idfShipToContact          = idfAttention       
       ,idfShipToCountry          = idfCountry     
       ,idfShipToFax              = idfFax       
       ,idfShipToName             = idfDescription         
       ,idfShipToState            = idfState     
       ,idfShipToZipCode          = idfZipCode  
FROM RQAprDtl WITH (NOLOCK)
INNER JOIN WCAddress WITH (NOLOCK) ON WCAddress.idfAddressID = RQAprDtl.edfShipTo
WHERE idfShipToAddr1 = '' AND idfAddr1 > ''
AND idfRQDetailKey in (SELECT idfRQDetailKey from RQDetail WHERE idfShipToAddr1 = '' AND idfAddr1 > '' AND idfRQHeaderKey In (510113,506310,495932) )

GO
UPDATE RQRevDtl
SET  idfShipToAddr1               = idfAddr1              
       ,idfShipToAddr2            = idfAddr2        
       ,idfShipToAddr3            = idfAddr3        
       ,idfShipToAltPhone1        = idfAltPhone1  
       ,idfShipToAltPhone2        = idfAltPhone2  
       ,idfShipToCity             = idfCity      
       ,idfShipToContact          = idfAttention       
       ,idfShipToCountry          = idfCountry     
       ,idfShipToFax              = idfFax       
       ,idfShipToName             = idfDescription         
       ,idfShipToState            = idfState     
       ,idfShipToZipCode          = idfZipCode  
FROM RQRevDtl WITH (NOLOCK)
INNER JOIN WCAddress WITH (NOLOCK) ON WCAddress.idfAddressID = RQRevDtl.edfShipTo
WHERE idfShipToAddr1 = '' AND idfAddr1 > ''
AND idfRQDetailKey in (SELECT idfRQDetailKey from RQDetail WHERE idfShipToAddr1 = '' AND idfAddr1 > '' AND idfRQHeaderKey In (510113,506310,495932) )


UPDATE RQDetail
SET  idfShipToAddr1               = idfAddr1              
       ,idfShipToAddr2            = idfAddr2        
       ,idfShipToAddr3            = idfAddr3        
       ,idfShipToAltPhone1        = idfAltPhone1  
       ,idfShipToAltPhone2        = idfAltPhone2  
       ,idfShipToCity             = idfCity      
       ,idfShipToContact          = idfAttention       
       ,idfShipToCountry          = idfCountry     
       ,idfShipToFax              = idfFax       
       ,idfShipToName             = idfDescription         
       ,idfShipToState            = idfState     
       ,idfShipToZipCode          = idfZipCode  
FROM RQDetail WITH (NOLOCK)
INNER JOIN WCAddress WITH (NOLOCK) ON WCAddress.idfAddressID = RQDetail.edfShipTo
WHERE idfShipToAddr1 = '' AND idfAddr1 > ''
AND idfRQHeaderKey In (510113,506310,495932)
