SELECT 'SQL_Latin1_General_CP1_CI_AS' AS 'Collation',
	COLLATIONPROPERTY('SQL_Latin1_General_CP1_CI_AS', 'CodePage') AS 'CodePage', 
	COLLATIONPROPERTY('SQL_Latin1_General_CP1_CI_AS', 'LCID') AS 'LCID',
	COLLATIONPROPERTY('SQL_Latin1_General_CP1_CI_AS', 'ComparisonStyle') AS 'ComparisonStyle', 
	COLLATIONPROPERTY('SQL_Latin1_General_CP1_CI_AS', 'Version') AS 'Version'
UNION ALL
SELECT 'Latin1_General_CI_AS' AS 'Collation', 
	COLLATIONPROPERTY('Latin1_General_CI_AS', 'CodePage') AS 'CodePage', 
	COLLATIONPROPERTY('Latin1_General_CI_AS', 'LCID') AS 'LCID',
	COLLATIONPROPERTY('Latin1_General_CI_AS', 'ComparisonStyle') AS 'ComparisonStyle', 
	COLLATIONPROPERTY('Latin1_General_CI_AS', 'Version') AS 'Version'
GO

--Create a table using collation Latin1_General_CI_AS and add some data to it 
CREATE TABLE MyTable1
(
	ID INT IDENTITY(1, 1), 
	Comments VARCHAR(100) COLLATE Latin1_General_CI_AS
)
INSERT INTO MyTable1 (Comments) VALUES ('Chiapas')
INSERT INTO MyTable1 (Comments) VALUES ('Colima')

--Create a second table using collation SQL_Latin1_General_CP1_CI_AS and add some data to it 
CREATE TABLE MyTable2
(
	ID INT IDENTITY(1, 1), 
	Comments VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS
)
INSERT INTO MyTable2 (Comments) VALUES ('Chiapas')
INSERT INTO MyTable2 (Comments) VALUES ('Colima')
 
--Join both tables on a column with differing collations
select * from MyTable1 
select * from MyTable2

SELECT * FROM MyTable1 M1
INNER JOIN MyTable2 M2 ON M1.Comments = M2.Comments

GO