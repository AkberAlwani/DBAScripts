SELECT * FROM SOP10100 WHERE SOPNUMBE IN ('ORDST2225','ORDST2230','ORDST2231')
SELECT * FROM SOP10101 WHERE SOPNUMBE IN ('ORDST2225','ORDST2230','ORDST2231')
SELECT * FROM SOP10200 WHERE SOPNUMBE IN ('ORDST2225','ORDST2230','ORDST2231')
--IF Cancelled Header
--**REMSUBTO, OREMSUBT =0
--IF Partial Cancel and Backorder
-- ** Do not Change these REMSUBTO, OREMSUBT =0

--Lines Level SOP10200
-- Invoice Qty Must be zero (QTYCANCE=QTYORD, QTYREMAI=0
-- REMPRICE,OREPRICE = 0 When NO Backorder
-- If Backorder QTYREMBO=QTYORD-QTYCANEL - QTYBAORD, QTYBORD, QTYTOINV=1
SELECT BACHNUMB,CUSTNMBR, * FROM SOP10100


