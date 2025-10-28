SELECT sid, serial# FROM v$session WHERE audsid = USERENV('SESSIONID'); 
-- *****************************************************************************************************************
-- SIMULATING NETWORK FAILURE BY KILLING A SESSION
-- *****************************************************************************************************************
SELECT * FROM Doctor_Kigali@kigali_branch_link;  -- checking updated record in distributed Kigali_branch node
-- Session ID and Serial to be killed from window 1. This is window 2
--     SID     SERIAL#
-- 1   5	   34685
ALTER SYSTEM KILL SESSION '5,34685' IMMEDIATE;

-- check pending transactions
SELECT * FROM dba_2pc_pending;