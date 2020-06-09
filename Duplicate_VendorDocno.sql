--Case 194244

select * from PTImaster..pTICompany
select * from PTIMaster..PTISecurity where idfSecurityID like '%cook%'

select edfVendorDocNum,* 
from RQRevDtl 
where idfRQREvHdrKey=19796
and edfVendorDocNum in (select DOCNUMBR from PM10000)

--select rd.edfVendorDocNum,d.idfRQDetailKey,d.idfRQHeaderKey,rd.idfRQREvDtlKey
SELECT DISTINCT rd.edfVendorDocNum,d.idfRQHeaderKey,VCHRNMBR,DOCNUMBR
from RQRevDtl rd 
inner join RQDetail D on rd.idfRQDetailKey=d.idfRQDetailKey
inner join (SELECT VCHRNMBR,DOCNUMBR,VENDORID from PM10000 (NOLOCK)
            UNION 
			SELECT VCHRNMBR,DOCNUMBR,VENDORID from PM20000 (NOLOCK)
			UNION 
			SELECT VCHRNMBR,DOCNUMBR,VENDORID from PM30200 (NOLOCK)
			UNION
			SELECT POPRCTNM,VNDDOCNM,VENDORID from POP10300 (NOLOCK)
			) GP
ON GP.DOCNUMBR=rd.edfVendorDocNum and d.edfVendor=VENDORID
where idfRQREvHdrKey=19796


Declare @VendorDoc varchar(100)
set @VendorDoc='xxx'
SELECT * from
            (SELECT VCHRNMBR,DOCNUMBR,VENDORID from PM10000 (NOLOCK)
            UNION  ALL
			SELECT VCHRNMBR,DOCNUMBR,VENDORID from PM20000 (NOLOCK)
			UNION  ALL
			SELECT VCHRNMBR,DOCNUMBR,VENDORID from PM30200 (NOLOCK)
			UNION  ALL
			SELECT POPRCTNM,VNDDOCNM,VENDORID from POP10300 (NOLOCK)
			) GP
WHERE GP.DOCNUMBR=@VendorDoc

select 1 Flag,idfRCVHeaderKey,edfVendorDocNum,edfVendor 
from RCVHeader (NOLOCK) where edfVendorDocNum=@VendorDoc 
UNION ALL 
SELECT 2,idfRQHeaderKey,RQHeader.idfVendorDocNum,idfVendorID 
from RQHeader (NOLOCK) 
inner join APVendor on RQHeader.idfAPVendorKey=APVendor.idfAPVendorKey
where idfVendorDocNum=@VendorDoc

select * from RQHeader