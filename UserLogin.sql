select idfRQSessionKey,* from RQDetail
select * from WCTax
select * from WCTaxScheduleHdr

select idfSecurityId,idfDescription,idfDateModified,* from WCSecurity
select * from PTIMaster..PTINETSessionHdr ses


--In regards to who is currently login to system.

SELECT s.idfSecurityId,s.idfDescription,s.idfDateModified,ses.idfLastAccess
from PTIMaster..PTINETSessionHdr ses
inner join WCSecurity s on s.idfSecurityID=ses.idfUserName
WHERE ses.idfLastAccess is not NULL

--For users who are logged out from WP:
SELECT s.idfSecurityId,s.idfDescription,s.idfDateModified,ses.idfLastAccess,ses.idfDateModified
from PTIMaster..PTINETSessionHdr ses
inner join WCSecurity s on s.idfSecurityID=ses.idfUserName
WHERE NOT(s.idfDateModified> ses.idfDateModified)
AND ses.idfLastAccess is NULL

select idfAPVendorKey from RQHeader
delete RQHeader where idfAPVendorKey is null