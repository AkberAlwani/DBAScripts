select 'insert into EXPType (idfEXPTypeKey,idfDescription,idfFlagActive,idfFlagRequireMapDistance,idfPrice,idfTypeID,idfPTICompanyKey,idfWCTaxScheduleHdrKey,
idfAttachmentRequirement,idfMapDistanceUOM,idfDailyPerDiem,idfEAICLink,idfFlagCreateCM,idfFlagPriceFixed,idfGLOverlayMask,idfUNSPSC) 
Values ('+convert(varchar,idfEXPTypeKey)+','''+[idfDescription]+''','+convert(varchar,idfFlagActive)+','+convert(varchar,idfFlagRequireMapDistance)+','+
convert(varchar,idfPrice)+','''+rtrim(idfTypeID)+''','+convert(varchar,idfPTICompanyKey)+','+convert(varchar,isnull(idfWCTaxScheduleHdrKey,0))+','+
convert(varchar,idfAttachmentRequirement)+','+convert(varchar,idfMapDistanceUOM)+','+convert(varchar,idfDailyPerDiem)+','''+idfEAICLink+''','+
convert(varchar,idfFlagCreateCM)+','+convert(varchar,idfFlagPriceFixed)+','''','''')'
from EXPType

---select idfUNSPSC,* from expType