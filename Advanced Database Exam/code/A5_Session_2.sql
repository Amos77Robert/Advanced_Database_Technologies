-- Logged in c##Bugesera_branch
SELECT sid,     serial# FROM v$session WHERE username = USER AND status = 'ACTIVE'; -- Session ID
-- Found SID is 498 and SEIAL# is 23834

select * from prescription_B; -- checking existing prescription records  from Node_B prescription Table

-- updating doctor information in the Kigali_Branch database
UPDATE prescription_B SET NOTES = 'Old infection resurfaced' WHERE prescriptionid = 3;