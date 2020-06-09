Update WCSecurity Set idfSecurityID
= REPLACE(idfSecurityID,'olddomain\','newdomain\')From WCSecurity 
-- replace olddomain\ with the old domain and newdomain\ to the new domain name,
--  This changes the old domain name to the new domain name in the users security

