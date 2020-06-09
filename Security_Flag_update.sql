UPDATE WCSecurity
    set idfFlagNotifyFromApr=0,
	idfFlagNotifyFromAprFilter=0,
	idfFlagNotifyFromRcv=0,
	idfFlagNotifyFromRev=0,
    idfFlagNotifyRCVToApr=0,
	idfFlagNotifyRQNotApr=0,
	idfFlagNotifyToRev=0,
	idfFlagNotifyRQNotFullyRcv=0
WHERE idfFlagActive=1
and idfSecurityID='janet'   -- replace the user with any existing users, once you see the results are good, you can remove this line.

select * from WCSecurity where idfSecurityID='janet'