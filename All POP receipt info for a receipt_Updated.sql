/*********************************************************************************
** All POP receipt info.  Includes POP receipt and apply tables 		**
**    as well as INV, PM and GL:						**
**	POP10500 - Purchasing Receipt Line Quantites				**
**	POP10600 - Purchasing Shipment Invoice Apply				**
**	POP10300 - Purchasing Receipt Work					**
**	POP10306 - Purchasing Receipt User-Defined				**
**	POP10310 - Purchasing Receipt Line					**
**	POP10330 - Purchasing Serial Lot Work					**
**	POP10360 - Purchasing Tax						**
**	POP10390 - Purchasing Distribution Work					**
**	POP10700 - Purchasing Landed Cost					**
**	POP30300 - Purchasing Receipt History					**
**	POP30310 - Purchasing Receipt Line History				**
**	POP30330 - Purchasing Serial Lot History				**
**	POP30360 - Purchasing Tax History					**
**	POP30390 - Purchasing Distribution History				**
**	POP30700 - Purchasing Landed Cost History				**
**	IV10200 - Inventory Purchase Receipts Work				**
**	IV30300 - Inventory Transaction Amounts History				**
**	IV30301 - Inventory Transaction Detail History				**
**	IV30302 - Inventory Transaction Bin Quantities History			**
**	shouldn't be any records in IV30400 - Item Serial and Lot Number Hist	**
**	shouldn't be any records in IV30500 - Inventory Distribution History	**
**	PM00400 - PM Keys							**
**	PM20000/PM30200 - PM Open / PM History					**
**	PM10100/PM30600 Dist open Dist hist (VCHRNMBR, CNTRLTYP)		**
**	GL10001/GL20000/GL30000 - GL work / GL open / GL history		**
**
**  PA
**  PA10701 - PA PO Receipt Work
**  PA10702 - PA PO Receipt Line Work
**  PA10721 - PA PO Receipt Line Quantities Work
**  PA31101 - PA PO Receipt History
**  PA31102 - PA PO Receipt Line History
**
**  HITB
**  SEE30303 - HITB Transaction History Detail
**										**
** Input POPRCTNM								**
**										**
*********************************************************************************/

declare @POPRCTNM char(17)
select @POPRCTNM = 'RCTXXXX'

set nocount on

print 'POP All apply info for receipt'
print '=================================================================================='
print ''

if exists (select * from POP10500 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10500 - Purchasing Receipt Line Quantites'
	select * from POP10500 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP10600 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10600 - Purchasing Shipment Invoice Apply'
	select * from POP10600 where POPRCTNM = @POPRCTNM
end

print 'POP All work receipt info for receipt'
print '=================================================================================='
print ''

if exists (select * from POP10300 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10300 - Purchasing Receipt Work'
	select * from POP10300 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP10306 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10306 - Purchasing Receipt User-Defined'
	select * from POP10306 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP10310 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10310 - Purchasing Receipt Line'
	select * from POP10310 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP10330 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10330 - Purchasing Serial Lot Work'
	select * from POP10330 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP10360 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10360 - Purchasing Tax'
	select * from POP10360 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP10390 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10390 - Purchasing Distribution Work'
	select * from POP10390 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP10700 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP10700 - Purchasing Landed Cost'
	select * from POP10700 where POPRCTNM = @POPRCTNM
End

print 'POP All history receipt info for PO'
print '=================================================================================='
print ''

if exists (select * from POP30300 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP30300 - Purchasing Receipt History'
	select * from POP30300 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP30310 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP30310 - Purchasing Receipt Line History'
	select * from POP30310 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP30330 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP30330 - Purchasing Serial Lot History'
	select * from POP30330 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP30360 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP30360 - Purchasing Tax History'
	select * from POP30360 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP30390 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP30390 - Purchasing Distribution History'
	select * from POP30390 where POPRCTNM = @POPRCTNM
End

if exists (select * from POP30700 where POPRCTNM = @POPRCTNM)
Begin
	print 'POP30700 - Purchasing Landed Cost History'
	select * from POP30700 where POPRCTNM = @POPRCTNM
End

print 'Inventory'
print '=================================================================================='
print ''

if exists (select * from IV10200 where RCPTNMBR = @POPRCTNM)
Begin
	print 'IV10200 - Inventory Purchase Receipts Work'
	select RCPTNMBR, * from IV10200 where RCPTNMBR = @POPRCTNM
End

if exists (select * from IV30300 where DOCNUMBR = @POPRCTNM and DOCTYPE = 4)
Begin
	print 'IV30300 - Inventory Transaction Amounts History'
	select * from IV30300 where DOCNUMBR = @POPRCTNM and DOCTYPE = 4
End

if exists (select * from IV30301 where DOCNUMBR = @POPRCTNM and DOCTYPE = 4)
Begin
	print 'IV30301 - Inventory Transaction Detail History'
	select * from IV30301 where DOCNUMBR = @POPRCTNM and DOCTYPE = 4
End

if exists (select * from IV30302 where DOCNUMBR = @POPRCTNM and DOCTYPE = 4)
Begin
	print 'IV30302 - Inventory Transaction Bin Quantities History'
	select * from IV30302 where DOCNUMBR = @POPRCTNM and DOCTYPE = 4
End

-- shouldn't be any records in IV30400 (Item Serial/Lot Hist)

-- shouldn't be any records in IV30500 (INV Dist History)

print 'Payables'
print '=================================================================================='
print ''

if exists (select b.POPRCTNM, a.* 
		from PM00400 a 
		join POP30300 b on a.CNTRLNUM = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM = @POPRCTNM)
Begin
	print 'PM00400 - PM Keys'
	select b.POPRCTNM, a.* 
		from PM00400 a 
		join POP30300 b on a.CNTRLNUM = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM = @POPRCTNM
End

if exists (select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 2 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM20000 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM = @POPRCTNM
	   union select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 3 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM30200 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM = @POPRCTNM)
Begin
	print 'PM20000/PM30200 - PM Open / PM History'
	select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 2 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM20000 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM = @POPRCTNM
	   union select b.POPRCTNM, a.DOCNUMBR, a.DOCTYPE, a.VCHRNMBR, 3 as Status, a.VENDORID, a.TRXSORCE, a.DOCDATE, a.DOCAMNT, a.CURTRXAM
		from PM30200 a 
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.DOCTYPE = 1 and b.POPRCTNM = @POPRCTNM
End

if exists (select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 2 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM10100 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM = @POPRCTNM
	   union select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 3 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM30600 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM = @POPRCTNM)
Begin
	print 'PM10100/PM30600 - PM Dist open / PM Dist History'
	select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 2 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM10100 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM = @POPRCTNM
	   union select b.POPRCTNM, a.VCHRNMBR, a.TRXSORCE, 3 as Status, a.DSTSQNUM, a.DEBITAMT, a.CRDTAMNT, a.DSTINDX 
		from PM30600 a
		join POP30300 b on a.VCHRNMBR = b.VCHRNMBR
		where a.CNTRLTYP = 0 and b.POPRCTNM = @POPRCTNM
End

print 'GL'
print '=================================================================================='
print ''

if exists (select ORDOCNUM, JRNENTRY, 1 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL10001 where ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM = @POPRCTNM) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 2 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL20000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM = @POPRCTNM) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 3 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL30000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM = @POPRCTNM) group by ORDOCNUM, JRNENTRY)
Begin
	print 'GL10001/GL20000/GL30000 - GL work / GL open / GL history'
	select ORDOCNUM, JRNENTRY, 1 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL10001 where ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM = @POPRCTNM) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 2 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL20000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM = @POPRCTNM) group by ORDOCNUM, JRNENTRY
		union select ORDOCNUM, JRNENTRY, 3 as Status, sum(DEBITAMT) as Sum_DEBITAMT, sum(CRDTAMNT) as Sum_CRDTAMNT from GL30000 where SERIES = 4 and ORDOCNUM in (select POPRCTNM from POP30310 where POPRCTNM = @POPRCTNM) group by ORDOCNUM, JRNENTRY
End

if exists (select * from sysobjects where name ='PA10702')
	begin
		print 'PA'
		print '=================================================================================='
		print ''
	
		if exists (select * from PA10701 where PAVIDN = @POPRCTNM )
			begin
				print 'PA10701 - PA PO Receipt Work'
				select * from PA10701 where PAVIDN = @POPRCTNM
			end
		if exists (select * from PA10701 where PAVIDN = @POPRCTNM )
			begin
				print 'PA10702 - PA PO Receipt Line Work'
				select * from PA10702 where PAVIDN = @POPRCTNM
			end
		if exists (select * from PA10721 where PAVIDN = @POPRCTNM )
			begin
				print 'PA10721 - PA PO Receipt Line Quantities Work'
				select * from PA10721 where PAVIDN = @POPRCTNM
			end
		if exists (select * from PA31101 where PAVIDN = @POPRCTNM )
			begin
				print 'PA31101 - PA PO Receipt History'
				select * from PA31101 where PAVIDN = @POPRCTNM
			end
		if exists (select * from PA31102 where PAVIDN = @POPRCTNM )
			begin
				print 'PA31102 - PA PO Receipt Line History'
				select * from PA31102 where PAVIDN = @POPRCTNM
			end
	end
	
if exists (select * from sysobjects where name ='SEE30303')
	begin
		print 'HITB'
		print '=================================================================================='
		print ''
		
		if exists (select * from SEE30303 where DOCNUMBR = @POPRCTNM )
			begin
				print 'SEE30303 - HITB Transaction History Detail'
				select * from SEE30303 where DOCNUMBR = @POPRCTNM
			end
	end

set nocount off

