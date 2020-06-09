SELECT 'BEFORE REMOVE',idfImportedRefNo,* FROM EXPCreditCard 

DECLARE @CCRef TABLE (idfEXPCreditCardKey INT,idfImportedRefNo nvarchar(255))
DECLARE @nidfEXPCreditCardKey INT, @stridfImportedRefNo nvarchar(255)

DECLARE zcurCC CURSOR
FOR SELECT idfEXPCreditCardKey,idfImportedRefNo	FROM EXPCreditCard WITH (NOLOCK)

OPEN zcurCC

FETCH zcurCC INTO @nidfEXPCreditCardKey , @stridfImportedRefNo

DECLARE @nNewLineNumber INT

WHILE @@fetch_status <> -1
BEGIN
	IF @@fetch_status <> -2
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM @CCRef WHERE idfImportedRefNo = @stridfImportedRefNo)
			DELETE FROM EXPCreditCard WHERE idfEXPCreditCardKey = @nidfEXPCreditCardKey 
		ELSE
			INSERT INTO @CCRef (idfEXPCreditCardKey,idfImportedRefNo) VALUES (@nidfEXPCreditCardKey,@stridfImportedRefNo)
	END --@@fetch_status <> -2

	FETCH zcurCC INTO @nidfEXPCreditCardKey , @stridfImportedRefNo	
END --@@fetch_status <> -1
CLOSE zcurCC
DEALLOCATE zcurCC

SELECT 'AFTER REMOVE',idfImportedRefNo,* FROM EXPCreditCard 
