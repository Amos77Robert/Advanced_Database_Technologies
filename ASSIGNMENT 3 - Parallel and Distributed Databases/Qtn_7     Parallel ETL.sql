-- ****************************************************************************************************************
-- Enable parallel DML for your session
-- ****************************************************************************************************************
ALTER SESSION ENABLE PARALLEL DML;

-- Check current parallel settings
SELECT * FROM v$option WHERE parameter LIKE '%Parallel%';

-- Check current table parallel degrees
SELECT table_name, degree FROM user_tables 
WHERE table_name LIKE 'PATIENT_%' OR table_name LIKE 'APPOINTMENT_%';

-- *****************************************************************************************************************
-- Create Test Table for Parallel Operations
-- *****************************************************************************************************************
-- Create a large test table for demonstration
CREATE TABLE patient_analysis_parallel
PARALLEL 4
AS SELECT * FROM c##amoss.patient WHERE 1=0;

-- Create same table without parallel
CREATE TABLE patient_analysis_serial
AS SELECT * FROM c##amoss.patient WHERE 1=0;

-- ***************************************************************************************************************
-- Perform Parallel Data Loading
-- ***************************************************************************************************************
-- Parallel Insert
-- Time this operation
SET TIMING ON

-- Parallel insert from both branches
INSERT /*+ PARALLEL(p, 4) */ INTO patient_analysis_parallel p
SELECT /*+ PARALLEL(bp, 2) PARALLEL(kp, 2) */ 
       bp.patientid, bp.fullname, bp.gender, bp.dob, bp.contact, bp.address
FROM patient_bugesera bp
UNION ALL
SELECT kp.patientid, kp.fullname, kp.gender, kp.dob, kp.contact, kp.address
FROM patient_kigali@kigali_branch_link kp;

COMMIT;
SET TIMING OFF

-- ************************************************************************************************************
-- Serial Insert
SET TIMING ON

-- Serial insert
INSERT INTO patient_analysis_serial
SELECT bp.patientid, bp.fullname, bp.gender, bp.dob, bp.contact, bp.address
FROM patient_bugesera bp
UNION ALL
SELECT kp.patientid, kp.fullname, kp.gender, kp.dob, kp.contact, kp.address
FROM patient_kigali@kigali_branch_link kp;

COMMIT;
SET TIMING OFF

-- ****************************************************************************************************************
-- Parallel Data Aggregation
-- ****************************************************************************************************************
-- Paralle aggregation
SET TIMING ON

-- Create summary table with parallel operations
CREATE TABLE patient_summary_parallel
PARALLEL 4
AS
SELECT /*+ PARALLEL(p, 4) */ 
    gender,
    COUNT(*) as patient_count,
    AVG(MONTHS_BETWEEN(SYSDATE, dob)/12) as avg_age,
    MAX(dob) as youngest_dob,
    MIN(dob) as oldest_dob
FROM patient_analysis_parallel p
GROUP BY gender;

SET TIMING OFF

-- Serial Aggregation
SET TIMING ON

CREATE TABLE patient_summary_serial
AS
SELECT 
    gender,
    COUNT(*) as patient_count,
    AVG(MONTHS_BETWEEN(SYSDATE, dob)/12) as avg_age,
    MAX(dob) as youngest_dob,
    MIN(dob) as oldest_dob
FROM patient_analysis_serial
GROUP BY gender;

SET TIMING OFF

-- ****************************************************************************************************************
-- Check Execution Plans and Costs
-- ****************************************************************************************************************

-- Explain plan for parallel query
EXPLAIN PLAN FOR
SELECT /*+ PARALLEL(p, 4) */ 
    gender, COUNT(*)
FROM patient_analysis_parallel p
GROUP BY gender;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Explain plan for serial query
EXPLAIN PLAN FOR
SELECT gender, COUNT(*)
FROM patient_analysis_serial
GROUP BY gender;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


-- **************************************************************************************************************
-- Compare Performance Metrics
-- **************************************************************************************************************
-- Check actual execution statistics
SELECT sql_id, sql_text, elapsed_time, cpu_time, buffer_gets, disk_reads
FROM v$sql
WHERE sql_text LIKE '%patient_analysis_parallel%' 
   OR sql_text LIKE '%patient_analysis_serial%'
ORDER BY last_active_time DESC;

-- Compare table sizes and performance
SELECT 
    table_name,
    num_rows,
    blocks,
    degree as parallel_degree
FROM user_tables
WHERE table_name IN ('PATIENT_ANALYSIS_PARALLEL', 'PATIENT_ANALYSIS_SERIAL',
                    'PATIENT_SUMMARY_PARALLEL', 'PATIENT_SUMMARY_SERIAL');


-- ***************************************************************************************************************
-- Document results
-- **************************************************************************************************************
-- Document your findings
SELECT 
    'Parallel Load' as operation,
    (SELECT elapsed_time FROM v$sql WHERE sql_text LIKE '%patient_analysis_parallel%' AND ROWNUM = 1) as elapsed_time,
    (SELECT buffer_gets FROM v$sql WHERE sql_text LIKE '%patient_analysis_parallel%' AND ROWNUM = 1) as buffer_gets
FROM dual
UNION ALL
SELECT 
    'Serial Load',
    (SELECT elapsed_time FROM v$sql WHERE sql_text LIKE '%patient_analysis_serial%' AND ROWNUM = 1),
    (SELECT buffer_gets FROM v$sql WHERE sql_text LIKE '%patient_analysis_serial%' AND ROWNUM = 1)
FROM dual;