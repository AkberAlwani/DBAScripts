SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-0'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(BegBal)									AS idfAmtBudgeted
          ,0												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2017' = '' OR YEAR(FiscYr) >= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-1'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal00)									AS idfAmtBudgeted
          ,1												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-2'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal01)									AS idfAmtBudgeted
          ,2												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-3'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal02)									AS idfAmtBudgeted
          ,3												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-4'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal03)									AS idfAmtBudgeted
          ,4												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-5'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal04)									AS idfAmtBudgeted
          ,5											AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-6'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal05)									AS idfAmtBudgeted
          ,6												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-7'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal06)									AS idfAmtBudgeted
          ,7												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-8'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal07)									AS idfAmtBudgeted
          ,8												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-9'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal08)									AS idfAmtBudgeted
          ,9												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-10'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal09)									AS idfAmtBudgeted
          ,10												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-11'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal10)									AS idfAmtBudgeted
          ,11												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-12'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal11)									AS idfAmtBudgeted
          ,12												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr
          UNION ALL
          SELECT
          MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
          ,MIN(WPEAICLog.idfAction)				      AS idfAction
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)+'-'+RTRIM(CpnyID)+'-13'	AS idfEAICLink
          ,FiscYr											AS FiscYr
          ,'ACTUAL-'+FiscYr+'-'+RTRIM(AcctHist.CpnyId)			AS LedgerID
          ,'Fiscal Yr: '+FiscYr							AS BudDesc
          ,RTRIM(AcctHist.Acct)+'-'+RTRIM(AcctHist.Sub)	AS idfGLID
          ,MIN(YTDBal12)									AS idfAmtBudgeted
          ,13												AS Period
          ,AcctHist.CpnyID								AS CompanyID
          FROM dbo.AcctHist AcctHist WITH (NOLOCK)
          INNER JOIN dbo.WPEAICLog WPEAICLog WITH (NOLOCK) ON WPEAICLog.idfTableName	= 'AcctHist'
          AND AcctHist.CpnyID	= WPEAICLog.idfPKNewValue01 AND AcctHist.Acct		= WPEAICLog.idfPKNewValue02
          AND AcctHist.Sub	= WPEAICLog.idfPKNewValue03 AND WPEAICLog.idfPKNewValue04 = 'ACTUAL'
          AND AcctHist.FiscYr	= WPEAICLog.idfPKNewValue05
          WHERE 1=1 AND ('2020' = '' OR YEAR(FiscYr)>= YEAR('2020'))
          GROUP BY AcctHist.CpnyID,AcctHist.Acct,AcctHist.Sub,AcctHist.FiscYr