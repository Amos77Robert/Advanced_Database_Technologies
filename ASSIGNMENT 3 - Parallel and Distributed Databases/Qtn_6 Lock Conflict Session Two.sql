-- Logged in c##Kigali_branch node
SELECT sid,     serial# FROM v$session WHERE username = USER AND status = 'ACTIVE'; -- sessionID

-- Found session INFO is (SID = 1221, SERIAL# = 6703)

select * from doctor_kigali; -- checking existing patient records

-- Updating doctor ID (25) record inside Kigali_branch database

UPDATE doctor_kigali SET email = 'evelynbanda@gmail.com' WHERE doctorid = 25;


