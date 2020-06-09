select count(*) from APVendor 
select count(*) from EPS.dbo.PM00200 
select * from APVendor where idfName like 'COX%'
select * from EPS.dbo.PM00200 where vendNAME  like 'COX%'

select * from EPS.dbo.PM00200 where VENDORID not in (select idfVEndorID from APVendor)
select * from EPS.dbo.PM00200 where VENDORID in (select idfVEndorID from APVendor)

select * from EPS.dbo.PM00100 where ltrim(rtrim(VNDCLSID)) not in (select ltrim(rtrim(idfVendorClassID)) from APVendorClass)
select * from APVendorClass where idfVendorClassID in ('CUSTOMER','EMPLOYEE','VENDOR')

select distinct VNDCLSID from EPS.dbo.PM00200 where VENDORID not in (select idfVEndorID from APVendor)
select * from EPS.dbo.PM00200 where VENDORID like '%SPRI2000%'

select VENDORID,VENDNAME,VNDCLSID from EPS.dbo.PM00200 where VNDCLSID no

