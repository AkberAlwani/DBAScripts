SELECT name, is_disabled
FROM sys.triggers
WHERE parent_id = OBJECT_ID('APVendor')