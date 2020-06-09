Found a script to rebuild pm00400 table.

--**/ REBUILD PM00400 PM KEY MASTER

truncate table PM00400

if exists (select * from dbo.sysobjects t1, dbo.sysindexes t2

where t2.name = 'AK2PM00400'

and t2.id = t1.id

and t1.id = Object_id('PM00400') and t1.type = 'U')

begin drop index PM00400.AK2PM00400 end

go

if exists (select * from dbo.sysobjects t1, dbo.sysindexes t2

where t2.name = 'AK3PM00400'

and t2.id = t1.id

and t1.id = Object_id('PM00400') and t1.type = 'U')

begin drop index PM00400.AK3PM00400 end

go

if exists (select * from dbo.sysobjects t1, dbo.sysindexes t2

where t2.name = 'AK4PM00400'

and t2.id = t1.id

and t1.id = Object_id('PM00400') and t1.type = 'U')

begin drop index PM00400.AK4PM00400 end

go

if exists (select * from dbo.sysobjects t1, dbo.sysindexes t2

where t2.name = 'AK5PM00400'

and t2.id = t1.id

and t1.id = Object_id('PM00400') and t1.type = 'U')

begin drop index PM00400.AK5PM00400 end

go

if exists (select * from dbo.sysobjects t1, dbo.sysindexes t2

where t2.name = 'AK7PM00400'

and t2.id = t1.id

and t1.id = Object_id('PM00400') and t1.type = 'U')

begin drop index PM00400.AK7PM00400 end

go

if exists (select * from dbo.sysobjects t1, dbo.sysindexes t2

where t2.name = 'AK6PM00400'

and t2.id = t1.id

and t1.id = Object_id('PM00400') and t1.type = 'U')

begin drop index PM00400.AK6PM00400 end

go

/*End_Indexes PM00400 */

insert into

PM00400

(DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

DUEDATE,

DISCDATE,

BCHSOURC,

CHEKBKID,

TRXSORCE,

CNTRLTYP,

CNTRLNUM)

select

DOCNUMBR,

3,

DOCTYPE,

VENDORID,

DOCDATE,

DUEDATE,

DISCDATE,

BCHSOURC,

CHEKBKID,

TRXSORCE,

CNTRLTYP,

VCHRNMBR

from

PM30200

go

insert into

PM00400(

DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

CNTRLNUM )

select

DOCNUMBR,

1,

DOCTYPE,

VENDORID,

DOCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

PMNTNMBR

from

PM10400

where

PM10400.BCHSOURC = 'PM_Payment'

and

NOT EXISTS

(select

CNTRLNUM

from

PM00400

where

PM10400.PMNTNMBR = PM00400.CNTRLNUM

and PM10400.CNTRLTYP = PM00400.CNTRLTYP )

go

insert into

PM00400(

DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

CNTRLNUM )

select

DOCNUMBR,

1,

DOCTYPE,

VENDORID,

DOCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

PMNTNMBR

from

PM10300

where

NOT EXISTS

(select

CNTRLNUM

from

PM00400

where

PM10300.PMNTNMBR = PM00400.CNTRLNUM

and

PM10300.CNTRLTYP = PM00400.CNTRLTYP )

go

insert into

PM00400(

DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

DUEDATE,

DISCDATE,

BCHSOURC,

CHEKBKID,

TRXSORCE,

CNTRLTYP,

CNTRLNUM )

select

DOCNUMBR,

2,

DOCTYPE,

VENDORID,

DOCDATE,

DUEDATE,

DISCDATE,

BCHSOURC,

CHEKBKID,

TRXSORCE,

CNTRLTYP,

VCHRNMBR

from

PM20000

where

NOT EXISTS

(select

CNTRLNUM

from

PM00400

where

PM20000.VCHRNMBR = PM00400.CNTRLNUM

and

PM20000.CNTRLTYP = PM00400.CNTRLTYP )

go

insert into

PM00400(

DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

DUEDATE,

DISCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

CNTRLNUM )

select

DOCNUMBR,

1,

DOCTYPE,

VENDORID,

DOCDATE,

DUEDATE,

DISCDATE,

BCHSOURC,

CHEKBKID,

0,

VCHNUMWK

from

PM10000

where

PM10000.BCHSOURC = 'PM_Trxent'

and

NOT EXISTS

(select

CNTRLNUM

from

PM00400

where

PM10000.VCHNUMWK = PM00400.CNTRLNUM

and PM10000.DOCTYPE = PM00400.DOCTYPE )

go

insert into

PM00400(

DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

CNTRLNUM )

select

CDOCNMBR,

1,

6,

VENDORID,

CAMTDATE,

BCHSOURC,

CAMCBKID,

1,

CAMPMTNM

from

PM10000

where

PM10000.BCHSOURC = 'PM_Trxent'

and PM10000.CASHAMNT > 0.00

and

NOT EXISTS

(select

CNTRLNUM

from

PM00400

where

PM10000.CAMPMTNM = PM00400.CNTRLNUM

and PM00400.CNTRLTYP = 1 )

go

insert into

PM00400(

DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

CNTRLNUM )

select

CHEKNMBR,

1,

6,

VENDORID,

CHEKDATE,

BCHSOURC,

CHAMCBID,

1,

CAMPYNBR

from

PM10000

where

PM10000.BCHSOURC = 'PM_Trxent'

and PM10000.CHEKAMNT > 0.00

and

NOT EXISTS

(select

CNTRLNUM

from

PM00400

where

PM10000.CAMPYNBR = PM00400.CNTRLNUM

and PM00400.CNTRLTYP = 1 )

go

insert into

PM00400(

DOCNUMBR,

DCSTATUS,

DOCTYPE,

VENDORID,

DOCDATE,

BCHSOURC,

CHEKBKID,

CNTRLTYP,

CNTRLNUM )

select

CCRCTNUM,

1,

6,

VENDORID,

CRCARDDT,

BCHSOURC,

'',

CNTRLTYP,

CCAMPYNM

from

PM10000

where

PM10000.BCHSOURC = 'PM_Trxent'

and PM10000.CRCRDAMT > 0

and

NOT EXISTS

(select

CNTRLNUM

from

SY03100,

PM00400

where

DCSTATUS = 1

and SY03100.PYBLGRBX = PM00400.CNTRLTYP

and PM00400.CNTRLNUM = PM10000.VCHNUMWK

and PM10000.CARDNAME = SY03100.CARDNAME)

go

CREATE unique nonclustered index AK2PM00400

on dbo.PM00400(DOCTYPE, VENDORID, DOCNUMBR, DEX_ROW_ID)

go

CREATE unique nonclustered index AK3PM00400

on dbo.PM00400(DOCNUMBR, CHEKBKID, DEX_ROW_ID)

go

CREATE unique nonclustered index AK4PM00400

on dbo.PM00400(VENDORID, DCSTATUS, DOCNUMBR, DEX_ROW_ID)

go

CREATE unique nonclustered index AK5PM00400

on dbo.PM00400(VENDORID, DCSTATUS, DOCDATE, DEX_ROW_ID)

go

CREATE unique nonclustered index AK6PM00400

on dbo.PM00400(TRXSORCE, CNTRLNUM, DEX_ROW_ID)

go

CREATE unique nonclustered index AK7PM00400

on dbo.PM00400(VENDORID, DCSTATUS, DOCTYPE, DEX_ROW_ID)

go