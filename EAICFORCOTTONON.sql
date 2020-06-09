SELECT	 MAX(WPEAICLog.idfWPEAICLogKey)	AS idfWPEAICLogKey
					,MIN(WPEAICLog.idfAction)		AS idfAction
					,CONVERT(VARCHAR(10),WPEAICLog.idfPKNewValue01) + '{COMPANYDB}'	AS idfEAICLink
					,MIN(GL00100.ACTIVE)			AS idfFlagActive
					,RTRIM(MIN(GL00105.ACTNUMST))		AS idfGLID
					,ISNULL(MIN(GL00100.ACTDESCR),WPEAICLog.idfPKNewValue01)	AS idfDescription
					FROM dbo.WPEAICLog WPEAICLog WITH (NOLOCK)
					LEFT OUTER JOIN dbo.GL00100 GL00100 WITH (NOLOCK) ON WPEAICLog.idfTableName = 'GL00100' AND WPEAICLog.idfPKNewValue01 = GL00100.ACTINDX
					LEFT OUTER JOIN dbo.GL00105 GL00105 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
					WHERE WPEAICLog.idfTableName = 'GL00100' AND {DYNAMIC_SQLWHERE}
					GROUP BY WPEAICLog.idfPKNewValue01

					--or

					SELECT 0                         AS idfWPEAICLogKey
                                  ,''                                      AS idfAction
                                  ,CONVERT(VARCHAR(10),GL00100.ACTINDX) + '{COMPANYDB}'  AS idfEAICLink
                                  ,GL00100.ACTIVE                   AS idfFlagActive
                                  ,RTRIM(GL00105.ACTNUMST)                 AS idfGLID
                                  ,GL00100.ACTDESCR                 AS idfDescription
                                  FROM dbo.GL00100 GL00100 WITH (NOLOCK)
                                  INNER JOIN dbo.GL00105 GL00105 WITH (NOLOCK) ON GL00100.ACTINDX = GL00105.ACTINDX
                                  WHERE GL00105.ACTNUMST <> ''
