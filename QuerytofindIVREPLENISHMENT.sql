SELECT vdfQtyInEntry,vdfQtyInApproval,vdfQtyInReview,vdfQtyInPO,I.idfItemID,S.idfSiteID,*
FROM IVItemSite V
INNER JOIN dbo.IVItem I WITH (NOLOCK) ON V.idfIVItemKey=I.idfIVItemKey 
INNER JOIN dbo.IVSite S WITH (NOLOCK) ON V.idfIVSiteKey=S.idfIVSiteKey 
LEFT OUTER JOIN (SELECT edfItem,edfLocation,SUM(CASE WHEN idfRQSessionKey < 110 THEN ISNULL(R.idfQty,0)*QTYBSUOM ELSE 0 END) vdfQtyInEntry,
SUM(CASE WHEN (idfRQSessionKey > 110 OR idfRQSessionKey = 110) AND idfRQSessionKey < 130 THEN ISNULL(R.idfQty,0)*QTYBSUOM ELSE 0 END) vdfQtyInApproval,
SUM(CASE WHEN (idfRQSessionKey > 130 OR idfRQSessionKey = 130) AND idfRQSessionKey < 170 THEN ISNULL(R.idfQty,0)*QTYBSUOM ELSE 0 END) vdfQtyInReview 
FROM dbo.RQDetail R WITH (NOLOCK) LEFT OUTER JOIN IV00106 (NOLOCK) ON ITEMNMBR = R.edfItem AND R.edfUOM = UOFM WHERE edfItem > '' GROUP BY edfItem,edfLocation) M ON M.edfItem = I.idfItemID AND M.edfLocation = S.idfSiteID 
LEFT OUTER JOIN (SELECT ITEMNMBR,LOCNCODE,SUM(QTYORDER*UMQTYINB) - SUM(QTYCANCE*UMQTYINB) vdfQtyInPO 
FROM dbo.POP10110 WITH (NOLOCK) WHERE POLNESTA = 1 AND POTYPE IN (1,2) GROUP BY ITEMNMBR,LOCNCODE) P ON ITEMNMBR = I.idfItemID AND S.idfSiteID = LOCNCODE
WHERE V.idfQtyOrderUpTo > 0 AND V.idfReplenishmentLevel = 2 
AND I.idfItemID = 'xxxxx' AND S.idfSiteID = 'sssss'

