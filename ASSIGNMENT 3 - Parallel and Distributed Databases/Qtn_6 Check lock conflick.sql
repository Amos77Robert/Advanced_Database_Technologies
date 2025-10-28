-- Check all locks in the system
SELECT 
    l.session_id,
    s.username,
    s.program,
    l.lock_type,
    l.mode_held,
    l.mode_requested,
    l.lock_id1,
    l.lock_id2,
    l.blocking_others
FROM dba_locks l
JOIN v$session s ON l.session_id = s.sid
WHERE s.username IN ('C##BUGESERA_BRANCH', 'C##KIGALI_BRANCH');