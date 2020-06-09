DECLARE
@xochErrSP		CHAR(32)      	= '',
@xonErrNum		INT          	= 0,
@xostrErrInfo		VARCHAR(255),
@strHDR_edfCurrency VARCHAR(20),
@nConvertedValue NUMERIC(19,5)	te
SELECT @strHDR_edfCurrency=COL1 FROM TEST
EXEC spFNAConvertCur @xochErrSP OUTPUT, @xonErrNum OUTPUT,@xostrErrInfo OUTPUT, @strHDR_edfCurrency,1, 0, @nConvertedValue OUTPUT
SELECT @xochErrSP,@xonErrNum,@xostrErrInfo,@strHDR_edfCurrency,@nConvertedValue
--select * FROM DYNAMICS..MC00100 (NOLOCK) where EXGTBLID='Z-C$-SELL'

