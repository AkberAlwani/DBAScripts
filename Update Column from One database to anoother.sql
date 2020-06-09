Update CMC..APVendor set idfDatePromisedOffset=B.idfDatePromisedOffset 
from ZCMC..APVendor A
Inner join CMC..APVendor B on  A.idfVendorID=B.idfVendorID 
Where A.idfDatePromisedOffset<>0