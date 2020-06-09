--1)
Select * from WCSecurity where idfSecurityID='xx' -- whatever they changed the login name to


--2)
Select * from RQHeader where idfWCSecurityKeyDelegate='the wcsecuritykey from #1'

--3)
Update RQHeader set idfWCSecurityKeyDelegate=NULL where idfRQHeaderKey in (999,999)-- replace 999 with the header keys from above

--4)
Delete WCSecurity where idfWCSecurityKey='the wcsecuritykey from #1'

