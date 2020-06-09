 Select  * into WCFilterDtl_old from WCFilterDtl
  Select  * into WCRRGroupLineUp_old from WCRRGroupLineUp

Update WCFilterDtl set idfFlagES=0 where idfFlagES=1
Update WCRRGroupLineUp set idfFlagES=0 where idfFlagES=1

--Delete from WCRRTemplate where idfWCRRTemplateKey=671 
--Select * from WCRRGroupLineUp where 