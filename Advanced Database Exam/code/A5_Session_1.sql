-- Logged in c##Bugesera_branch
SELECT sid,     serial# FROM v$session WHERE username = USER AND status = 'ACTIVE'; -- Session ID

--Found SID is 857 and SERIAL# is 25804

-- A5_1 checking existing prescription records  from Node_B prescription Table
select * from prescription_B@proj_link; 
-- updating doctor information in the Kigali_Branch database

-- A5_2 running update to the same table from both node_A and node_B
UPDATE prescription_B@proj_link SET NOTES = 'New infection detected' WHERE prescriptionid = 3;

-- A5_4   Releasing the lock by commiting update
COMMIT;
-- ============================================================
-- A5_3    QUERY LOCK VIEWS TO SHOW BLOCKING SESSIONS
-- ============================================================

-- Detailed lock information from V$LOCK
SELECT 
    l.sid as SESSION_ID,
    s.username as USERNAME,
    s.program as PROGRAM,
    l.type as LOCK_TYPE,
    l.lmode as LOCK_MODE_HELD,
    l.request as LOCK_MODE_REQUESTED,
    l.id1 as LOCK_ID1,
    l.id2 as LOCK_ID2,
    l.block as IS_BLOCKING
FROM v$lock l
JOIN v$session s ON l.sid = s.sid
WHERE l.sid IN (SELECT sid FROM v$session WHERE username = USER)
ORDER BY l.block DESC, l.sid


