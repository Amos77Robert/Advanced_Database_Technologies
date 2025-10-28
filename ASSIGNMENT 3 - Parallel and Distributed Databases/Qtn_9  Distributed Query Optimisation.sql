-- ******************************************************************************************************************
-- Creating a distributed join query
-- ******************************************************************************************************************

-- Distributed join: Find Neurology patients with their appointments and doctors
EXPLAIN PLAN FOR
SELECT 
    p.FullName AS Patient_Name,
    p.Gender,
    p.Contact,
    a.VisitDate,
    a.Diagnosis,
    d.FullName AS Doctor_Name,
    d.Specialty
FROM Patient_Bugesera p
JOIN Appointment_Bugesera a ON p.PatientID = a.PatientID
JOIN Doctor_Bugesera d ON a.DoctorID = d.DoctorID
WHERE a.VisitDate >= DATE '2024-01-01'
UNION ALL
SELECT 
    p.FullName AS Patient_Name,
    p.Gender,
    p.Contact,
    a.VisitDate,
    a.Diagnosis,
    d.FullName AS Doctor_Name,
    d.Specialty
FROM Patient_Kigali@KIGALI_BRANCH_LINK p
JOIN Appointment_Kigali@KIGALI_BRANCH_LINK a ON p.PatientID = a.PatientID
JOIN Doctor_Kigali@KIGALI_BRANCH_LINK d ON a.DoctorID = d.DoctorID
WHERE a.VisitDate >= DATE '2024-01-01';


-- ************************************************************************************************************
-- Analysing the execution plan
-- ************************************************************************************************************

-- Display the execution plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- More detailed plan with costs
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(format => 'ALLSTATS LAST +COST +BYTES'));


-- ************************************************************************************************************
--  Comparing with optimiser hints
-- ************************************************************************************************************

-- Force distributed query with DRIVING_SITE hint
EXPLAIN PLAN FOR
SELECT /*+ DRIVING_SITE(p) */ 
    p.FullName,
    a.Diagnosis,
    d.FullName AS Doctor_Name
FROM Patient_Bugesera p
JOIN Appointment_Bugesera a ON p.PatientID = a.PatientID
JOIN Doctor_Kigali@KIGALI_BRANCH_LINK d ON a.DoctorID = d.DoctorID;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


-- *************************************************************************************************************
-- Chekc distributed query statistics
-- *************************************************************************************************************
-- Check if distributed query optimization is enabled
SELECT name, value FROM v$parameter 
WHERE name LIKE '%distrib%' OR name LIKE '%remote%';

-- View distributed query performance
SELECT sql_id, sql_text, executions, elapsed_time, cpu_time, buffer_gets
FROM v$sql 
WHERE sql_text LIKE '%@KIGALI_BRANCH_LINK%' 
   AND sql_text NOT LIKE '%EXPLAIN%'
ORDER BY last_active_time DESC;



-- ******************************************************************************************************
-- Documenting findings
-- *******************************************************************************************************
-- Summary of optimizer observations
SELECT 
    'Distributed Join Strategy' as analysis_area,
    'Oracle uses REMOTE coordination for cross-database joins' as observation,
    'Data movement minimized via predicate pushing to remote sites' as optimization
FROM dual
UNION ALL
SELECT 
    'Cost Calculation',
    'Optimizer considers network transfer costs in total query cost',
    'Chooses execution plan with least data movement across database link'
FROM dual;