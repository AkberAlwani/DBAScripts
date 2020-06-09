SELECT
	e.VENDNAME AS VendorName
   ,h.USCATVLS_1 AS Brand
   ,h.USCATVLS_2 AS ClassCode
   ,a.ITEMNMBR AS ItemNumber
   ,b.VNDITDSC AS Description
   ,h.ITMGEDSC AS Generic
   ,a.LSTORDDT AS LastOrderDate
   ,a.LSORDQTY AS LastOrderQTY
   ,a.LSRCPTDT AS LastOrderDate
   ,a.LRCPTQTY AS LastReceiptQTY
   ,a.QTYONORD AS QtyOnOrder
   ,a.ATYALLOC AS QtyAllocated
   ,a.QTYONHND AS QtyOnHand
   ,a.QTYSOLD AS QtySold
   ,b.LRCPTCST AS RcptCost
   ,h.CURRCOST AS UnitCost
   ,f.UOMPRICE AS SellingPrice
   ,a.MXMMORDRQTY AS MaxQty
   ,a.REORDERVARIANCE AS ReorderQty
   ,a.QTYONHND - a.ATYALLOC AS AvailableQty
   ,a.MXMMORDRQTY - a.QTYONHND + a.ATYALLOC AS SuggestedOrder

FROM dbo.IV00102 a
	,dbo.IV00103 b
	,dbo.IV00108 f
	,dbo.IV00101 h
	,dbo.PM00200 e

WHERE	/* Selected Item*/
a.ITEMNMBR = '401' /*and*/
/* Selected Brand*/
/*h.USCATVLS_1 = 'Apple' and*/
/* Selected Category*/
/*h.USCATVLS_2 = 'IT' and*/
a.LOCNCODE = ''
AND a.ITEMNMBR = h.ITEMNMBR
AND a.ITEMNMBR = b.ITEMNMBR
AND a.ITEMNMBR = f.ITEMNMBR
AND a.LSORDVND = e.VENDORID

--AND a.MXMMORDRQTY <> '0'
--AND a.QTYONHND <= a.REORDERVARIANCE