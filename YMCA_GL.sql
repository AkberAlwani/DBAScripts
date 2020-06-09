print '----- start of query -----'

declare @debitdoc as varchar(30)
set @debitdoc = 'V0148326' 
-- replace with corresponding invoice / finance charge / miscellaneous charge voucher number
-- e.g. set @debitdoc = '00000000000000466' 

declare @creditdoc as varchar(30)
set @creditdoc = '13-0293984' 
-- replace with corresponding return / credit memo voucher number or check payment number
-- e.g. set @creditdoc = '00000000000000345' 


set nocount on

print '----------------'
print 'transaction info'
print '----------------'

print 'SY00500 Batch Headers'
select 'SY00500', DEX_ROW_ID, BACHNUMB, * from SY00500 
	where SERIES = 4 and BACHNUMB in 
	(select BACHNUMB from PM10000 
		where doctype in (1, 2, 3) and VCHNUMWK in (@debitdoc) 
	union
	select BACHNUMB from PM10000 
		where doctype in (4, 5) and VCHNUMWK in (@creditdoc)
	union
	select BACHNUMB from PM10300 
		where PMNTNMBR in (@creditdoc)
	union	
	select BACHNUMB from PM10400 
		where PMNTNMBR in (@creditdoc))

print 'PM10000 / WORK (debit):'
select 'PM10000', DEX_ROW_ID, VENDORID, DOCTYPE, VCHNUMWK, DOCNUMBR, DOCAMNT, CURTRXAM, DOCDATE, * from PM10000 
	where doctype in (1, 2, 3) and VCHNUMWK in (@debitdoc) 

print 'PM10000 / WORK (credit):'
select 'PM10000', DEX_ROW_ID, VENDORID, DOCTYPE, VCHNUMWK, DOCNUMBR, DOCAMNT, CURTRXAM, DOCDATE, * from PM10000 
	where doctype in (4, 5) and VCHNUMWK in (@creditdoc)

print 'PM10300 / WORK (computer check):'
select 'PM10300', DEX_ROW_ID, BACHNUMB, CHEKBKID, VENDORID, PMNTNMBR, DOCNUMBR, DOCDATE, APPLDAMT, CURTRXAM, CHEKTOTL, * from PM10300 
	where PMNTNMBR in (@creditdoc)

print 'PM10400 / WORK (manual payment):'
select 'PM10400', DEX_ROW_ID, BACHNUMB, CHEKBKID, VENDORID, PMNTNMBR, DOCNUMBR, DOCDATE, APPLDAMT, CURTRXAM, * from PM10400 
	where PMNTNMBR in (@creditdoc)

print 'PM20000 / OPEN:'
select 'PM20000', DEX_ROW_ID, VENDORID, DOCTYPE, VCHRNMBR, DOCNUMBR, DOCAMNT, CURTRXAM, DOCDATE, * from PM20000 
	where (VCHRNMBR in (@debitdoc) and DOCTYPE in (1, 2, 3))
	or (VCHRNMBR in ((@creditdoc)) and DOCTYPE in (4, 5, 6))

print 'PM30200  / HIST:' 
select 'PM30200', DEX_ROW_ID, VENDORID, DOCTYPE, VCHRNMBR, DOCNUMBR, DOCAMNT, CURTRXAM, DOCDATE, * from PM30200 
	where (VCHRNMBR in (@debitdoc) and DOCTYPE in (1, 2, 3))
	or (VCHRNMBR in ((@creditdoc)) and DOCTYPE in (4, 5, 6))

print 'PM00400 / PM Keys:' 
select 'PM00400', DEX_ROW_ID, CNTRLTYP, DCSTATUS, DOCTYPE, CNTRLNUM, DOCNUMBR, VENDORID, TRXSORCE from PM00400 
	where (CNTRLNUM in (@debitdoc) and DOCTYPE in (1, 2, 3))
	or (CNTRLNUM in ((@creditdoc)) and DOCTYPE in (4, 5, 6))

print '-------------------------------------'
print 'apply record info based on debit doc'
print '-------------------------------------'

print 'PM10200  / OPEN:' 
select 'PM10200', DEX_ROW_ID, VENDORID, DOCTYPE, VCHRNMBR, APFRDCNM, APTVCHNM, APTODCNM, APTODCTY, 
	APPLDAMT, ORAPPAMT, APFRMAPLYAMT, ActualApplyToAmount, * from PM10200 
		where APTODCTY in (1, 2, 3) and APTVCHNM in (@debitdoc)

print 'PM30300 / HIST:' 
select 'PM30300', DEX_ROW_ID, VENDORID, DOCTYPE, VCHRNMBR, APFRDCNM, APTVCHNM, APTODCNM, APTODCTY, 
	APPLDAMT, ORAPPAMT, APFRMAPLYAMT, ActualApplyToAmount, * from PM30300 
		where APTODCTY in (1, 2, 3) and APTVCHNM in (@debitdoc)

print '------------------------------------'
print 'apply record info based on credit doc'
print '------------------------------------'

print 'PM10200  / OPEN:' 
select 'PM10200', DEX_ROW_ID, VENDORID, DOCTYPE, VCHRNMBR, APFRDCNM, APTVCHNM, APTODCNM, APTODCTY, 
	APPLDAMT, ORAPPAMT, APFRMAPLYAMT, ActualApplyToAmount, * from PM10200 
	where DOCTYPE in (4, 5, 6) and VCHRNMBR in (@creditdoc)

print ' PM30300  / HIST:' 
select 'PM30300', DEX_ROW_ID, VENDORID, DOCTYPE, VCHRNMBR, APFRDCNM, APTVCHNM, APTODCNM, APTODCTY, 
	APPLDAMT, ORAPPAMT, APFRMAPLYAMT, ActualApplyToAmount, * from PM30300 
	where DOCTYPE in (4, 5, 6) and VCHRNMBR in (@creditdoc)

print '--------------------'
print 'distribution records'
print '--------------------'

print 'PM10100-DR / WORK-OPEN distribution, debit document:' 
select 'PM10100-DR', DEX_ROW_ID, VCHRNMBR, CNTRLTYP, '', DEBITAMT, CRDTAMNT, DSTINDX, PSTGSTUS, VENDORID, TRXSORCE, * from PM10100 
	where (VCHRNMBR in (select VCHNUMWK from PM10000 where doctype in (1, 2, 3) and VCHNUMWK in (@debitdoc)) and CNTRLTYP = 0)
	or(VCHRNMBR in (select VCHRNMBR from PM20000 where VCHRNMBR in (@debitdoc)) and CNTRLTYP = 0)
	
print 'PM10100-CR / WORK-OPEN distribution, credit document:' 
select 'PM10100-CR', DEX_ROW_ID, VCHRNMBR, CNTRLTYP, '', DEBITAMT, CRDTAMNT, DSTINDX, PSTGSTUS, VENDORID, TRXSORCE, * from PM10100 
	where (VCHRNMBR in (select VCHNUMWK from PM10000 where doctype in (4, 5) and VCHNUMWK in (@creditdoc)))
	or(VCHRNMBR in (select VCHRNMBR from PM20000 where VCHRNMBR in (@creditdoc)))

print 'PM30600-DR / HIST distribution, debit document:' 
select 'PM30600-DR', DEX_ROW_ID, VCHRNMBR, CNTRLTYP, DOCTYPE, DEBITAMT, CRDTAMNT, DSTINDX, PSTGSTUS, VENDORID, TRXSORCE, * from PM30600 
	where (VCHRNMBR in (select VCHNUMWK from PM10000 where doctype in (1, 2, 3) and VCHNUMWK in (@debitdoc)) and CNTRLTYP = 0)
	or(VCHRNMBR in (select VCHRNMBR from PM30200 where VCHRNMBR in (@debitdoc)) and CNTRLTYP = 0)

print 'PM30600-CR / HIST distribution, credit document:' 	
select 'PM30600-CR', DEX_ROW_ID, VCHRNMBR, CNTRLTYP, DOCTYPE, DEBITAMT, CRDTAMNT, DSTINDX, PSTGSTUS, VENDORID, TRXSORCE, * from PM30600 
	where (VCHRNMBR in (select VCHNUMWK from PM10000 where doctype in (4, 5) and VCHNUMWK in (@creditdoc)))
	or(VCHRNMBR in (select VCHRNMBR from PM20000 where VCHRNMBR in (@creditdoc)))

print '----------------------'
print 'General Ledger records'
print '----------------------'

print 'GL10000 - Transaction Work (header):'
select 'GL10000', DEX_ROW_ID, JRNENTRY, * from GL10000 
 	where JRNENTRY in 
		(select JRNENTRY from GL10001 where ORCTRNUM in (@debitdoc, @creditdoc))

print 'GL10001 - Transaction Amounts Work (detail):'
select 'GL10001', a.DEX_ROW_ID, a.JRNENTRY, a.ORCTRNUM, a.ORTRXTYP, a.ORDOCNUM, a.ORMSTRID, 
	a.ACTINDX, b.ACTNUMST, a.CURRNIDX, a.DEBITAMT, a.CRDTAMNT, a.ORDBTAMT, a.ORCRDAMT, a.* from GL10001 a
	inner join GL00105 b on a.ACTINDX = b.ACTINDX
 	where a.ORCTRNUM in (@debitdoc, @creditdoc)
	order by a.ORTRXTYP, a.ORCTRNUM

print 'GL20000 - Year-to-Date Transaction Open:'
select 'GL20000', a.DEX_ROW_ID, a.JRNENTRY, a.ORCTRNUM, a.ORTRXTYP, a.ORDOCNUM, a.ORMSTRID, 
	a.ACTINDX, b.ACTNUMST, a.CURRNIDX, a.DEBITAMT, a.CRDTAMNT, a.ORDBTAMT, a.ORCRDAMT, a.* from GL20000 a
	inner join GL00105 b on a.ACTINDX = b.ACTINDX
 	where a.ORCTRNUM in (@debitdoc, @creditdoc)
	order by a.ORTRXTYP, a.ORCTRNUM

print 'GL30000 - Account Transaction History:'
select 'GL30000', a.DEX_ROW_ID, a.JRNENTRY, a.ORCTRNUM, a.ORTRXTYP, a.ORDOCNUM, a.ORMSTRID, 
	a.ACTINDX, b.ACTNUMST, a.CURRNIDX, a.DEBITAMT, a.CRDTAMNT, a.ORDBTAMT, a.ORCRDAMT, a.* from GL30000 a
	inner join GL00105 b on a.ACTINDX = b.ACTINDX
 	where a.ORCTRNUM in (@debitdoc, @creditdoc)
	order by a.ORTRXTYP, a.ORCTRNUM
            
set nocount off

print '----- end of query -----'
