ALTER TABLE RQDetail DISABLE TRIGGER ALL
update RQDetail set idfDateModified=GETDATE()-1 where idfRQHeaderKey=7
ALTER TABLE RQDetail enABLE TRIGGER ALL