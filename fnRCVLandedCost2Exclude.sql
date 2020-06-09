IF OBJECT_ID (N'dbo.fnRCVLandedCost2Exclude', N'FN') IS NOT NULL
    DROP FUNCTION dbo.fnRCVLandedCost2Exclude
GO
CREATE FUNCTION dbo.fnRCVLandedCost2Exclude (@xnFreight NUMERIC(19,5),@xnMisc NUMERIC(19,5),@xnTax NUMERIC(19,5),@xnDiscount NUMERIC(19,5),@xstrCostType VARCHAR(20))
RETURNS NUMERIC(19,5)
AS
BEGIN
	DECLARE
	 @nRetVal			NUMERIC(19,5)

	SET @nRetVal = 0

	IF (@xstrCostType = 'NONINVITEM')
	BEGIN
		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='RCVLANDCOSTINCLDISC' AND idfValue = '0')
			SET @nRetVal = @nRetVal - @xnDiscount 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='RCVLANDCOSTINCLFRHT' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnFreight 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='RCVLANDCOSTINCLMISC' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnMisc 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='RCVLANDCOSTINCLTAX' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnTax 
	END

	IF (@xstrCostType = 'INVITEM')
	BEGIN
		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVLANDCOSTINCLDISC' AND idfValue = '0')
			SET @nRetVal = @nRetVal - @xnDiscount 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVLANDCOSTINCLFRHT' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnFreight 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVLANDCOSTINCLMISC' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnMisc 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='IVLANDCOSTINCLTAX' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnTax 
	END

	IF (@xstrCostType = 'EXPENSE')
	BEGIN
		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='EXPLANDCOSTINCLFRHT' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnFreight 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='EXPLANDCOSTINCLMISC' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnMisc 

		IF EXISTS(SELECT TOP 1 1 FROM dbo.WCSystemSetting WITH (NOLOCK) WHERE idfSettingID='EXPLANDCOSTINCLTAX' AND idfValue = '0')
			SET @nRetVal = @nRetVal + @xnTax 
	END


	RETURN @nRetVal
END
GO
IF OBJECT_ID (N'dbo.fnRCVLandedCost2Exclude', N'FN') IS NOT NULL
	PRINT 'PTI_INFO- Object dbo.fnRCVLandedCost2Exclude was successfully created.' 
ELSE	
	PRINT 'PTI_ERROR- Object dbo.fnRCVLandedCost2Exclude was not created.' 
GO
