SELECT  A.[ITEMNMBR] ,
        A.[TRXLOCTN] ,
        A.[RCTSEQNM] ,
        A.[QTYRECVD_200] ,
        A.[QTYSOLD_200] ,
        A.[RCPTSOLD_Index] ,
        B.[ITEMNMBR] ,
        B.[TRXLOCTN] ,
        B.[SRCRCTSEQNM] ,
        B.[QTYSOLD_201] ,
        A.[QTYSOLD_200] - B.[QTYSOLD_201] AS VARIANCE
FROM    ( SELECT    [ITEMNMBR] ,
                    [TRXLOCTN] ,
                    [RCTSEQNM] ,
                    SUM([QTYRECVD]) AS QTYRECVD_200 ,
                    SUM([QTYSOLD]) AS QTYSOLD_200 ,
                    RCPTSOLD_Index = CASE 
                                     WHEN SUM([QTYRECVD]) - SUM([QTYSOLD]) = 0
                                     THEN 1
                                     ELSE 0
                                     END
                    FROM      [IV10200]
                    GROUP BY  [ITEMNMBR] ,
                    [TRXLOCTN] ,
                    [RCTSEQNM]
                    ) AS A
                    FULL OUTER JOIN ( SELECT   
                                      [ITEMNMBR] ,
                                      [TRXLOCTN] ,
                                      [SRCRCTSEQNM] ,
                                      SUM([QTYSOLD]) AS QTYSOLD_201
                                      FROM  [IV10201]
                                      GROUP BY  [ITEMNMBR] ,
                                      [TRXLOCTN] ,
                                      [SRCRCTSEQNM]
                                      ) AS B ON A.[ITEMNMBR] = B.[ITEMNMBR]
                                      AND A.[TRXLOCTN] = B.[TRXLOCTN]
                                      AND A.[RCTSEQNM] = B.[SRCRCTSEQNM]
                                      WHERE   ISNULL(A.[QTYSOLD_200], 0) - 
                                              ISNULL(B.[QTYSOLD_201], 0) <> 0