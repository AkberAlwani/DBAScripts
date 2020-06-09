UPDATE WCSecurity
SET idfAPVendorKey = APVendor.idfAPVendorKey
FROM WCSecurity
INNER JOIN APVendor ON WCSecurity.edfVendor = APVendor.idfVendorID
WHERE ISNULL(APVendor.idfVendorID,'') > '' AND WCSecurity.idfAPVendorKey IS NULL
