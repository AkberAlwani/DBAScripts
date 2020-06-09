begin tran

declare @PONumber varchar(50)
set @PONumber='PO000009'

-- Delete GLJournal if ANY
DELETE GLD
	FROM GLJournalSummary GLD
	INNER JOIN GLJournalHdr GLH ON GLD.idfGLJournalHdrKeySource = GLH.idfGLJournalHdrKey OR GLD.idfGLJournalHdrKeySummary=GLH.idfGLJournalHdrKey 
	INNER JOIN RCVHeader RH ON GLH.idfDocument01 = RH.idfRCTNumber
	INNER JOIN RCVDetail RD ON RH.idfRCVHeaderKey=RD.idfRCVHeaderKey
	WHERE RD.idfPONumber=@PONumber

DELETE GLD
	FROM GLJournalSummary GLD
	INNER JOIN GLJournalHdr GLH ON GLD.idfGLJournalHdrKeySource = GLH.idfGLJournalHdrKey OR GLD.idfGLJournalHdrKeySummary=GLH.idfGLJournalHdrKey 
	INNER JOIN RCVHeaderHist RH ON GLH.idfDocument01 = RH.idfRCTNumber
    INNER JOIN RCVDetailHist RD ON RH.idfRCVHeaderHistKey=RD.idfRCVHeaderHistKey
    WHERE RD.idfPONumber=@PONumber


DELETE PODist
FROM dbo.PODetailDistributionHist PODist
INNER JOIN dbo.PODetailHist PD
	ON PODist.idfPODetailHistKey = PD.idfPODetailHistKey
INNER JOIN dbo.POHeaderHist PH
	ON PD.idfPOHeaderHistKey = PH.idfPOHeaderHistKey
WHERE PH.idfPONumber = @PONumber

DELETE PD
FROM dbo.PODetailHist PD
INNER JOIN dbo.POHeaderHist PH
	ON PD.idfPOHeaderHistKey = PH.idfPOHeaderHistKey
WHERE PH.idfPONumber = @PONumber

DELETE PH
FROM POHeaderHist PH
WHERE PH.idfPONumber = @PONumber

--OPEN PURCHASES
DELETE POAprDtl
FROM POAprDtlPOHeader POAprDtl
INNER JOIN dbo.POHeader PH ON POAprDtl.idfPOHeaderKey=PH.idfPOHeaderKey
WHERE PH.idfPONumber=@PONumber

DELETE POHeader
FROM POHeader PH
WHERE PH.idfPONumber = @PONumber

--IVJournal (Mostly Non Inventory Items)


rollback tran