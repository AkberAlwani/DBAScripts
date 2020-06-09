SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET ANSI_NULL_DFLT_ON ON
GO
SET CURSOR_CLOSE_ON_COMMIT OFF
GO
SET IMPLICIT_TRANSACTIONS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.PODistributionCheck')) )	DROP table dbo.PODistributionCheck
GO
IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.PODistributionCheck')) )
BEGIN
	PRINT 'PTI_ERROR- Object dbo.PODistributionCheck failed to drop.' 
END
GO

CREATE TABLE PODistributionCheck(
    idfDateCreated                         datetime          DEFAULT GETDATE() NULL,
    idfDateModified                        datetime          DEFAULT GETDATE() NULL,
	idfPODetailKey						   INT,
	idfPOSessionKey						   INT,
	idfAmountNew						   NUMERIC(19,5),
	idfAmountOld						   NUMERIC(19,5),
	idfHist								   VARCHAR(10)
)
GO
IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.PODistributionCheck')) )
BEGIN
	PRINT 'PTI_INFO- Object dbo.PODistributionCheck was successfully created.' 
END
ELSE
BEGIN
	PRINT 'PTI_ERROR- Object dbo.PODistributionCheck was not created.' 
END
GO

GRANT SELECT,INSERT,DELETE,UPDATE ON [PODistributionCheck] TO [PTIWorkPlaceUser] WITH GRANT OPTION
GO
GRANT SELECT,INSERT,DELETE,UPDATE ON [PODistributionCheck] TO [PTIWorkPlaceAdmin] WITH GRANT OPTION
GO

IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.tuidPODetailDistributionCheck')) )	DROP trigger dbo.tuidPODetailDistributionCheck
GO
IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.tuidPODetailDistributionCheck')) )
BEGIN
	PRINT 'PTI_ERROR- Object dbo.tuidPODetailDistributionCheck failed to drop.' 
END
GO

CREATE TRIGGER tuidPODetailDistributionCheck ON PODetailDistribution
	FOR INSERT,UPDATE,DELETE
AS
INSERT INTO PODistributionCheck 
(
	 idfPODetailKey						 
	,idfPOSessionKey						 
	,idfAmountNew						 
	,idfAmountOld	
	,idfHist					 
)
SELECT 
	 i.idfPODetailKey						 
	,ISNULL(PODetail.idfPOSessionKey,0)
	,i.idfAmtExtended 						 
	,ISNULL(d.idfAmtExtended,0)
	,''
from inserted i
LEFT OUTER JOIN PODetail WITH (NOLOCK) ON PODetail.idfPODetailKey = i.idfPODetailKey 
LEFT OUTER JOIN deleted d on d.idfPODetailDistributionKey = i.idfPODetailDistributionKey
WHERE i.idfAmtExtended <= 0

GO
IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.tuidPODetailDistributionCheck')) )
BEGIN
	PRINT 'PTI_INFO- Object dbo.tuidPODetailDistributionCheck was successfully created.' 
END
ELSE
BEGIN
	PRINT 'PTI_ERROR- Object dbo.tuidPODetailDistributionCheck was not created.' 
END
GO

IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.tuidPODetailDistributionHistCheck')) )	DROP trigger dbo.tuidPODetailDistributionHistCheck
GO
IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.tuidPODetailDistributionHistCheck')) )
BEGIN
	PRINT 'PTI_ERROR- Object dbo.tuidPODetailDistributionHistCheck failed to drop.' 
END
GO

CREATE TRIGGER tuidPODetailDistributionHistCheck ON PODetailDistributionHist
	FOR INSERT,UPDATE,DELETE
AS
INSERT INTO PODistributionCheck 
(
	 idfPODetailKey						 
	,idfPOSessionKey						 
	,idfAmountNew						 
	,idfAmountOld
	,idfHist						 
)
SELECT 
	 i.idfPODetailHistKey						 
	,ISNULL(PODetailHist.idfPOSessionKey,0)
	,i.idfAmtExtended 						 
	,ISNULL(d.idfAmtExtended,0)
	,'Hist'
from inserted i
LEFT OUTER JOIN PODetailHist WITH (NOLOCK) ON PODetailHist.idfPODetailHistKey = i.idfPODetailHistKey 
LEFT OUTER JOIN deleted d on d.idfPODetailDistributionHistKey = i.idfPODetailDistributionHistKey
WHERE i.idfAmtExtended <= 0

GO
IF ( EXISTS (SELECT name FROM sysobjects WHERE id = object_id('dbo.tuidPODetailDistributionHistCheck')) )
BEGIN
	PRINT 'PTI_INFO- Object dbo.tuidPODetailDistributionHistCheck was successfully created.' 
END
ELSE
BEGIN
	PRINT 'PTI_ERROR- Object dbo.tuidPODetailDistributionHistCheck was not created.' 
END
GO


