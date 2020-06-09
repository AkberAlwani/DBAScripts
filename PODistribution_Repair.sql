UPDATE PODetailDistributionHist SET idfAmtExtended = PODetailHist.idfAmtExtended, idfAmtExtendedHome = PODetailHist.idfAmtExtendedHome
from PODetailDistributionHist with (nolock)
INNER JOIN PODetailHist with (nolock) ON PODetailHist.idfPODetailHistKey = PODetailDistributionHist.idfPODetailHistKey
where (PODetailDistributionHist.idfAmtExtended <= 0 or PODetailDistributionHist.idfAmtExtendedHome <= 0) AND PODetailDistributionHist.idfPercent = 100.00000
