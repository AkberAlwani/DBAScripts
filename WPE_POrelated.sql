/**********CHANGE ORDER FLAG ISSUE************/
--find PO's in active table that have had change orders but the change order flag is incorrect
SELECT idfPONumber,idfFlagChangeOrderHist,idfRevision,* 
FROM POHeaderHist 
WHERE idfFlagChangeOrderHist = 0 
AND idfPONumber IN (SELECT idfPONumber FROM POHeader)
--update PO to fix change order flag based on PO number
begin tran
update POHeaderHist set idfFlagChangeOrderHist = 1 where idfPONumber = 'PO040-118181' and idfFlagChangeOrderHist = 0 and idfRevision = 1
rollback tran

/**********ITEM MISMATCH ISSUE************/
--find mismatched items
SELECT H.idfPONumber, D.idfLine,DH.idfLine, D.idfItemID, DH.idfItemID,D.idfItemVendorID,DH.idfItemVendorID,* 
FROM PODetail D
INNER JOIN POHeader H ON D.idfPOHeaderKey = H.idfPOHeaderKey
INNER JOIN POHeaderHist HH ON HH.idfPONumber = H.idfPONumber
LEFT OUTER JOIN PODetailHist DH ON HH.idfPOHeaderHistKey = DH.idfPOHeaderHistKey AND DH.idfLine = D.idfLine
WHERE --H.idfPONUmber = 'PO102-140343' AND 
(D.idfItemID <> DH.idfItemID OR D.idfItemVendorID <> DH.idfItemVendorID)

--update item or vendor item to get hist to match live
begin tran
UPDATE PODetailHist 
SET idfItemVendorID = D.idfItemVendorID, idfItemID = D.idfItemID
FROM PODetail D
INNER JOIN POHeader H ON D.idfPOHeaderKey = H.idfPOHeaderKey
INNER JOIN POHeaderHist HH ON HH.idfPONumber = H.idfPONumber
LEFT OUTER JOIN PODetailHist DH ON HH.idfPOHeaderHistKey = DH.idfPOHeaderHistKey AND DH.idfLine = D.idfLine
WHERE --H.idfPONUmber = 'PO102-140343' AND 
(D.idfItemID <> DH.idfItemID OR D.idfItemVendorID <> DH.idfItemVendorID)
rollback tran