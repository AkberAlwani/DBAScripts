use ZTWO
alter table WCChart add constraint def_idfSQLData6 default '' for idfSQLData6
alter table WCChart add constraint def_idfSQLData4 default '' for idfSQLData4
alter table WCChart add constraint def_idfSQLData5 default '' for idfSQLData5
EXEC dbo.spWCChartInit

--exec spWCSecurityAccessEffectivesync

USE YTWO
alter table WCChart add constraint def_idfSQLData6 default '' for idfSQLData6
alter table WCChart add constraint def_idfSQLData4 default '' for idfSQLData4
alter table WCChart add constraint def_idfSQLData5 default '' for idfSQLData5
EXEC dbo.spWCChartInit

delete from dbo.CATCatalog
delete from dbo.CATCategory
delete from dbo.CATItemCategory


SELECT
	* INTO Tmp
FROM OPENROWSET('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;',
'EXEC TWO..spWCSecurityDSI @xnidfWCSecurityKey=2,@xnDateFormatNumber=101')


select idfFlagActive,idfPTICompanyKey,* from TWO..WCSecurity  where idfSecurityID='User1'
select idfFlagActive,idfPTICompanyKey,* from YTWO..WCSecurity  where idfSecurityID='User1'
select idfFlagActive,idfPTICompanyKey,* from ZTWO..WCSecurity  where idfSecurityID='User1'

USE YTWO
 

alter table IVPhysicalHdr add idfIVSiteKey int
alter table IVPhysicalHdrHist add idfIVSiteKey int

CREATE INDEX fkIVSite ON dbo.IVPhysicalHdr(idfIVSiteKey)
CREATE INDEX fkIVSite ON dbo.IVPhysicalHdrHist(idfIVSiteKey)

SELECT * FROM DYNAMICS.dbo.WCMobileSyncDataChange 