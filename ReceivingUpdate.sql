SELECT
	d.*
   ,h.edfReceiptNumber
   ,h.idfTransactionType
   ,h.*
FROM RCVHeader H (NOLOCK)
INNER JOIN (SELECT
		idfRCVHeaderKey
	   ,SUM(edfAmtExtended) edfAmtExtended
	FROM RCVDetail(NOLOCK)
	GROUP BY idfRCVHeaderKey) D
	ON d.idfRCVHeaderKey = h.idfRCVHeaderKey
--WHERE d.edfAmtExtended <> h.idfAmountExtended

select RCVHeader.edfReceiptNumber,* from RCVHeader

UPDATE RCVHeader set idfAmountExtendedHome=0 -- this fires trigger tuRCVHeader but does not update all fiels.
UpDATE RCVDetail set idfAmtExtendedApr=idfAmtExtendedApr



UPDATE H
SET H.idfAmountSubTotalHome = h.idfAmountSubTotalHome + i.edfAmtHomeExtended
,H.idfAmountSubTotal = h.idfAmountSubTotal + i.edfAmtExtended
,H.idfAmountSubTotalApr = h.idfAmountSubTotalApr + i.idfAmtExtendedApr
,H.idfAmountExtended = (i.idfAmountSubTotal + i.idfAmountTax - i.idfAmountDiscount + i.idfAmountFreight + i.idfAmountMisc)
,H.idfAmountExtendedHome = (i.idfAmountSubTotalHome + i.idfAmountTaxHome - i.idfAmountDiscountHome + i.idfAmountFreightHome + i.idfAmountMiscHome)
,H.idfAmountExtendedApr = (i.idfAmountSubTotalApr + i.idfAmountTaxApr - i.idfAmountDiscountApr + i.idfAmountFreightApr + i.idfAmountMiscApr)
FROM 
--SELECT i.* from 
RCVHeader H
inner join 
    (SELECT
        SUM(idfAmountSubTotalHome) AS edfAmtHomeExtended
		,SUM(idfAmountSubTotal) AS edfAmtExtended
		,SUM(edfAmtHomeExtended) AS idfAmountExtendedHome
	    ,SUM(idfAmtExtendedApr) AS idfAmtExtendedApr
	    ,SUM(idfAmountTax) AS idfAmountTax
		,SUM(i.idfAmountSubTotal) AS idfAmountSubTotal
		,SUM(i.idfAmountSubTotalHome) AS idfAmountSubTotalHome
		,i.idfRCVHeaderKey
		FROM (SELECT I.idfRCVDetailKey,I.edfPrice,I.idfAmtExtendedApr,I.edfAmtExtended,I.edfAmtHomeExtended,I.idfAmtTaxIncluded idfAmountTax,

		CASE WHEN Hdr.idfTransactionType = 1 THEN I.edfPrice*(I.idfQtyShipped-idfQtyRejected) ELSE I.edfPrice*I.idfQtyInvoiced END idfAmountSubTotal
		,CASE WHEN Hdr.idfTransactionType = 1 THEN I.edfPrice*(I.idfQtyShipped-idfQtyRejected)*I.idfRateHome  ELSE I.edfPrice*I.idfQtyInvoiced*I.idfRateHome  END idfAmountSubTotalHome
		,I.idfRCVHeaderKey,I.idfRateHome 
     From RCVDetail I
      INNER JOIN RCVHEADER Hdr on i.idfRCVHeaderKey=hdr.idfRCVHeaderKey) i
    GROUP BY i.idfRCVHeaderKey) i
	ON H.idfRCVHeaderKey = i.idfRCVHeaderKey

select * from RCVDetail where idfRCVHeaderKey in (9,13)
update RCVDetail set idfAmtExtendedApr=idfAmtExtendedApr, edfAmtExtended=edfAmtExtended,edfAmtHomeExtended=edfAmtHomeExtended