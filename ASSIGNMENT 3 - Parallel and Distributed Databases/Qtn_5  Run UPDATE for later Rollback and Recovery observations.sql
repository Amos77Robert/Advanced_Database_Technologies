-- Get current session
SELECT sid, serial# FROM v$session WHERE audsid = USERENV('SESSIONID'); 
SELECT * FROM doctor_bugesera;                     -- Let's check doctor table in bugesera_branch node
SELECT * FROM doctor_kigali@kigali_branch_link;    -- Let's check doctor table in kigali__branch node

SET TRANSACTION NAME 'distributed_txn';            -- create transaction name
UPDATE Doctor_Bugesera SET email = 'robertfisha88@gmail.com' WHERE DoctorID = 30;              -- updating bugesera doctor table
UPDATE Doctor_kigali@kigali_branch_link SET email = 'evelynbanda@gmail.com' WHERE DoctorID = 25;      -- updating kigali doctor table

COMMIT;
-- Check active sessions and transactions
SELECT s.sid, s.serial#, s.username, t.start_time, t.status
FROM v$session s JOIN v$transaction t ON s.saddr = t.ses_addr;
