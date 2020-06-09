/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [RAYTH]
GO

/****** Object:  Trigger [dbo].[IFC_tuidGLSegmentDtl]    Script Date: 30/05/2018 9:40:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Paramount Technologies, Inc. $Version: WorkPlace_08.02.00 $  - $Revision: 1 $ $Modtime: 12/01/05 12:02p $
CREATE TRIGGER [dbo].[IFC_tuidGLSegmentDtl] ON [dbo].[GL40200] FOR INSERT, UPDATE, DELETE
AS
----------------------------------------------------------------------------
--GLSegmentDtl
----------------------------------------------------------------------------
	DECLARE @GLSegmentDtl TABLE
	(
		 idfKey				INT IDENTITY (0,1)
		,idfDescription		nvarchar(128)
		,idfSegmentID		nvarchar(128)
		,idfGLSegmentHdrKey	INT
		,idfRowAction		VARCHAR(2)
	)
	INSERT INTO @GLSegmentDtl (idfDescription,idfSegmentID,idfGLSegmentHdrKey,idfRowAction)
	SELECT 
		 i.DSCRIPTN
		,i.SGMNTID
		,HDR.idfGLSegmentHdrKey
		,CASE WHEN DTL.idfSegmentID IS NULL     THEN 'IN'
			  WHEN DTL.idfSegmentID IS NOT NULL THEN 'UP'
		 END
	FROM inserted i
	LEFT OUTER JOIN dbo.GLSegmentHdr HDR WITH (NOLOCK) ON HDR.idfSegmentNumber = i.SGMTNUMB
	LEFT OUTER JOIN dbo.GLSegmentDtl DTL WITH (NOLOCK) ON DTL.idfGLSegmentHdrKey = HDR.idfGLSegmentHdrKey AND DTL.idfSegmentID = i.SGMNTID

	INSERT INTO @GLSegmentDtl (idfDescription,idfSegmentID,idfGLSegmentHdrKey,idfRowAction)
	SELECT 
		 i.DSCRIPTN
		,i.SGMNTID
		,HDR.idfGLSegmentHdrKey
		,'DL'
	FROM dbo.GLSegmentHdr HDR WITH (NOLOCK) 
	INNER JOIN dbo.GLSegmentDtl DTL WITH (NOLOCK) ON DTL.idfGLSegmentHdrKey = HDR.idfGLSegmentHdrKey 
	LEFT OUTER JOIN inserted i ON i.SGMTNUMB = HDR.idfSegmentNumber AND i.SGMNTID = DTL.idfSegmentID
	WHERE i.SGMTNUMB IS NULL

	INSERT INTO GLSegmentDtl
	(	
		 idfDescription		
		,idfEAICLink			
		,idfFlagActive		
		,idfSegmentID		
		,idfDateCreated		
		,idfDateModified		
		,idfUserCreated		
		,idfUserModified		
		,idfGLSegmentHdrKey	
		,idfGLSegmentHash
	)
	SELECT 	
		 idfDescription			--idfDescription		
		,' '					--idfEAICLink			
		,1						--idfFlagActive		
		,idfSegmentID			--idfSegmentID		
		,GETDATE()				--idfDateCreated		
		,GETDATE()				--idfDateModified		
		,dbo.fnWCSecurity('')	--idfUserCreated		
		,dbo.fnWCSecurity('')	--idfUserModified		
		,idfGLSegmentHdrKey		--idfGLSegmentHdrKey
		,''	
	FROM @GLSegmentDtl
	WHERE idfRowAction = 'IN'
	ORDER BY idfGLSegmentHdrKey,idfSegmentID

	UPDATE GLSegmentDtl SET 
		 idfDescription	    = TMP.idfDescription	
		,idfFlagActive		= 1	
		,idfDateModified	= GETDATE()
		,idfUserModified	= dbo.fnWCSecurity('')
		,idfGLSegmentHash   = REPLICATE('0',10-LEN(DTL.idfGLSegmentDtlKey))+CONVERT(VARCHAR(10),DTL.idfGLSegmentDtlKey)
	FROM dbo.GLSegmentDtl DTL WITH (NOLOCK)
	INNER JOIN @GLSegmentDtl TMP ON TMP.idfGLSegmentHdrKey = DTL.idfGLSegmentHdrKey AND TMP.idfSegmentID = DTL.idfSegmentID
	WHERE TMP.idfRowAction = 'UP'

	DELETE GLSegmentDtl
	FROM dbo.GLSegmentDtl DTL WITH (NOLOCK)
	INNER JOIN @GLSegmentDtl TMP ON TMP.idfGLSegmentHdrKey = DTL.idfGLSegmentHdrKey AND TMP.idfSegmentID = DTL.idfSegmentID
	WHERE TMP.idfRowAction = 'DL'
----------------------------------------------------------------------------
GO

ALTER TABLE [dbo].[GL40200] ENABLE TRIGGER [IFC_tuidGLSegmentDtl]
GO

