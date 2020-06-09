--UNPOSTED LINE SUMMARY FOR WorkPlace DATA
--***ADD GRANT NAME BELOW TO SEE BREAKDOWN***
--SET @GRANTID = 'ENTER GRANT ID'
DECLARE @GRANTID VARCHAR(100)
SET @GRANTID = 'NHMRC 1029467'

-- RQ Entry
SELECT WCAAAllocation.edfAmt AS UnpostedAmountWP, RQDetail.idfRQHeaderKey AS [Requistion Number], RQDetail.idfLine AS [Requistion Line]
FROM dbo.WCAADimension
INNER JOIN dbo.WCAAAllocation		WITH (NOLOCK) ON WCAAAllocation.idfWCAAAllocationKey = WCAADimension.idfWCAAAllocationKey 
INNER JOIN dbo.WCDistribution 		WITH (NOLOCK) ON WCDistribution.idfWCDistributionKey = WCAAAllocation.idfWCDistributionKey
INNER JOIN dbo.WMIAAGMBudgetSummary WITH (NOLOCK) ON WMIAAGMBudgetSummary.aaTrxDimCode = WCAADimension.edfCodeAlphanumeric	
INNER JOIN dbo.GTM01100				WITH (NOLOCK) ON GTM01100.aaTrxDimCode = WMIAAGMBudgetSummary.aaTrxDimCode AND WCDistribution.idfDateApply BETWEEN GTM01100.STRTDATE AND GTM01100.ENDDATE
INNER JOIN dbo.RQDetail				WITH (NOLOCK) ON RQDetail.idfRQDetailKey = WCDistribution.idfTableLinkKey AND WCDistribution.idfTableLinkName = 'RQDetail' AND (idfRQSessionKey < 120 OR idfRQSessionKey = 130 OR idfRQSessionKey = 140  OR idfRQSessionKey = 145)
INNER JOIN dbo.GL00105				WITH (NOLOCK) ON GL00105.ACTINDX = WCDistribution.edfGL AND (GL00105.ACTNUMBR_2 >= '6000' AND GL00105.ACTNUMBR_2 <= '7000')
WHERE WMIAAGMBudgetSummary.GRANTID = @GRANTID

--RQ Approval
SELECT WCAAAllocation.edfAmt AS UnpostedAmountWP, RQAprDtl.idfRQAprHdrKey AS [Approval Session], RQAprDtl.idfLine AS [Approval Line], RQDetail.idfRQHeaderKey AS [Requistion Number], RQDetail.idfLine AS [Requistion Line]
FROM dbo.WCAADimension
INNER JOIN dbo.WCAAAllocation		WITH (NOLOCK) ON WCAAAllocation.idfWCAAAllocationKey = WCAADimension.idfWCAAAllocationKey 
INNER JOIN dbo.WCDistribution 		WITH (NOLOCK) ON WCDistribution.idfWCDistributionKey = WCAAAllocation.idfWCDistributionKey
INNER JOIN dbo.WMIAAGMBudgetSummary WITH (NOLOCK) ON WMIAAGMBudgetSummary.aaTrxDimCode = WCAADimension.edfCodeAlphanumeric	
INNER JOIN dbo.GTM01100				WITH (NOLOCK) ON GTM01100.aaTrxDimCode = WMIAAGMBudgetSummary.aaTrxDimCode AND WCDistribution.idfDateApply BETWEEN GTM01100.STRTDATE AND GTM01100.ENDDATE
INNER JOIN dbo.RQAprDtl				WITH (NOLOCK) ON RQAprDtl.idfRQAprDtlKey = WCDistribution.idfTableLinkKey AND WCDistribution.idfTableLinkName = 'RQAprDtl'
INNER JOIN dbo.RQDetail				WITH (NOLOCK) ON RQDetail.idfSessionLinkKey = RQAprDtl.idfRQAprDtlKey AND idfRQSessionKey = 120
INNER JOIN dbo.GL00105				WITH (NOLOCK) ON GL00105.ACTINDX = WCDistribution.edfGL AND (GL00105.ACTNUMBR_2 >= '6000' AND GL00105.ACTNUMBR_2 <= '7000')
WHERE WMIAAGMBudgetSummary.GRANTID = @GRANTID

--RQ Review
SELECT WCAAAllocation.edfAmt AS UnpostedAmountWP,RQRevDtl.idfRQRevHdrKey AS [Review Session],RQRevDtl.idfLine AS [Review Line], RQDetail.idfRQHeaderKey AS [Requistion Number], RQDetail.idfLine AS [Requistion Line]
FROM dbo.WCAADimension
INNER JOIN dbo.WCAAAllocation		WITH (NOLOCK) ON WCAAAllocation.idfWCAAAllocationKey = WCAADimension.idfWCAAAllocationKey 
INNER JOIN dbo.WCDistribution 		WITH (NOLOCK) ON WCDistribution.idfWCDistributionKey = WCAAAllocation.idfWCDistributionKey
INNER JOIN dbo.WMIAAGMBudgetSummary WITH (NOLOCK) ON WMIAAGMBudgetSummary.aaTrxDimCode = WCAADimension.edfCodeAlphanumeric	
INNER JOIN dbo.GTM01100				WITH (NOLOCK) ON GTM01100.aaTrxDimCode = WMIAAGMBudgetSummary.aaTrxDimCode AND WCDistribution.idfDateApply BETWEEN GTM01100.STRTDATE AND GTM01100.ENDDATE
INNER JOIN dbo.RQRevDtl				WITH (NOLOCK) ON RQRevDtl.idfRQRevDtlKey = WCDistribution.idfTableLinkKey AND WCDistribution.idfTableLinkName = 'RQRevDtl'
INNER JOIN dbo.RQDetail				WITH (NOLOCK) ON RQDetail.idfSessionLinkKey = RQRevDtl.idfRQRevDtlKey AND idfRQSessionKey > 149 AND idfRQSessionKey < 170
INNER JOIN dbo.GL00105				WITH (NOLOCK) ON GL00105.ACTINDX = WCDistribution.edfGL AND (GL00105.ACTNUMBR_2 >= '6000' AND GL00105.ACTNUMBR_2 <= '7000')
WHERE WMIAAGMBudgetSummary.GRANTID = @GRANTID