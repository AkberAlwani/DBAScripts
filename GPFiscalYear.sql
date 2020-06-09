
select * from SY40100 a
where exists (select ODESCTN,year1  from SY40100 b where a.ODESCTN=b.ODESCTN and a.year1=b.year1 group by ODESCTN,year1  having count(*)>1)
order by 3

select * from SY40100 a
where ODESCTN like 'General Entry %' 
order by year1,a.PERIOD


select * from SY40100 where ODESCTN like 'General%'
select * from SY01000 where TRXSOURC like 'Bank%' 
delete from SY01000 where TRXSOURC like 'Bank%' and DEX_ROW_ID=109
delete from SY01000 where TRXSOURC like 'Budget%' and DEX_ROW_ID=73
delete from SY01000 where TRXSOURC like 'Payable%' and DEX_ROW_ID=83
delete from SY01000 where TRXSOURC like 'Computer%' and DEX_ROW_ID=85
delete from SY01000 where TRXSOURC like 'Bank%' and DEX_ROW_ID=163
delete from SY01000 where TRXSOURC like 'General%' and DEX_ROW_ID=79
