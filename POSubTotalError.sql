Declare @nFunctionalPrecision int
,@xnQtyInvoiced			NUMERIC(19,5)	= 0
,@xstrPONumber			CHAR(17)	= 'PO000000000000026'
,@xstrPOLine			INT		= 16384
SELECT @nFunctionalPrecision = edfPrecision FROM vwFNACurrency WITH (NOLOCK) WHERE edfFunctional = 1
Select REMSUBTO,OREMSUBT, REMSUBTO- ROUND((@xnQtyInvoiced * POP10110.UNITCOST), @nFunctionalPrecision) Update1,
			OREMSUBT - ROUND((@xnQtyInvoiced * POP10110.ORUNTCST), ISNULL(c.edfPrecision,0)) Update2,POP10100.CURNCYID,
			c.edfCurrencyID,c.edfFunctional,c.edfPrecision,c.edfCurrencyIndex,c.idfPTICurrencyKey
FROM dbo.POP10100 WITH (NOLOCK)
		INNER JOIN dbo.POP10110 WITH (NOLOCK) ON POP10110.PONUMBER = POP10100.PONUMBER AND POP10110.ORD = @xstrPOLine
		LEFT OUTER JOIN vwFNACurrency c WITH (NOLOCK) ON c.edfCurrencyID = POP10100.CURNCYID 
		WHERE POP10100.PONUMBER = @xstrPONumber
		
select CURNCYID ,* from pM00200 Where VENDORID='ACETRAVE0001'
update pop10100  set CURNCYID='' where PONUMBER like 'PO00000000000002%'
select CURNCYID,* from pop10100 where PONUMBER like 'PO00000000000002%'