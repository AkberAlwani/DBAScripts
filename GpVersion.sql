-- List of Company IDs 
select CMPANYID, INTERID, CMPNYNAM from DYNAMICS..SY01500
 
-- List of Product Versions for Company specified by Database 
select U.*, C.INTERID, C.CMPNYNAM from DYNAMICS..DU000020 U 
join Dynamics..SY01500 C on C.CMPANYID = U.companyID 
where C.INTERID = 'TWO' -- Enter desired Company DB name
order by U.PRODID
 
-- List of Product Versions for System Database 
select * from DYNAMICS..DU000020 
where companyID = -32767 
order by PRODID
