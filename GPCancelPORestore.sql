select * from POP10500 where PONUMBER='PO1429'
select top 3 * from POP30300 order by 1 desc -- REPLACEGOODS
select top 3 * from POP30310 order by 1 desc
select * from POP10110 where PONUMBER='PO1429'
select * from POP30390 order by 1 desc
select * from POP30360 order by 1 desc
UPDATE POP30300 set REPLACEGOODS=1 where POPRCTNM='RCT1314'
UPDATE POP10110 set QTYUNCMTBASE=12500 where PONUMBER='PO1429'

select * from POP10110 where PONUMBER='PO1429'
UPDATE POP10110 set POLNESTA=4 where PONUMBER='PO1429'