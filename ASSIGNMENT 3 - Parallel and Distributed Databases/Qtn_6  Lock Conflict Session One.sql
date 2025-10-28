-- Logged in c##Bugesera_branch
SELECT sid,     serial# FROM v$session WHERE username = USER AND status = 'ACTIVE'; -- Session ID

-- Founds Session INFO is (SID = 861, SERIAL# =  26063)

select * from doctor_kigali@Kigali_Branch_Link; -- checking existing patient records

-- updating doctor information in the Kigali_Branch database
UPDATE doctor_kigali@Kigali_Branch_Link SET email = 'eviebanda@gmail.com' WHERE doctorid = 25;
