IF EXISTS (SELECT TOP 1 1 FROM sys.procedures WHERE name = 'spPTIFixPrimaryKeySequence')
EXEC spPTIFixPrimaryKeySequence 1
ELSE
EXEC spPTIFixPrimaryKey
GO
