

-- A3.1
-- all available appointments
select * from appointment_b@proj_link;

-- SERIAL aggregation on Appointment_ALL 
SELECT 
    Status,
    COUNT(*) as Total_Appointments,
    AVG(MONTHS_BETWEEN(SYSDATE, VisitDate)) as Avg_Months_Since_Visit,
    MIN(VisitDate) as Earliest_Visit,
    MAX(VisitDate) as Latest_Visit
FROM Appointment_B@proj_link
GROUP BY Status
ORDER BY Total_Appointments DESC;


-- A3.2 Paralle aggregations
ALTER SESSION ENABLE PARALLEL QUERY;
-- PARALLEL aggregation on Appointment_ALL - totals by status with 3-10 groups
-- PARALLEL aggregation on remote Appointment_B table
SELECT /*+ PARALLEL(appointment_b@proj_link, 8) */
    Status,
    COUNT(*) as Total_Appointments,
    AVG(MONTHS_BETWEEN(SYSDATE, VisitDate)) as Avg_Months_Since_Visit,
    MIN(VisitDate) as Earliest_Visit,
    MAX(VisitDate) as Latest_Visit
FROM appointment_b@proj_link
GROUP BY Status
ORDER BY Total_Appointments DESC;

-- A3_3 EXECUTION PLAN
-- Capture execution plan for the parallel query
EXPLAIN PLAN FOR
SELECT /*+ PARALLEL(appointment_b@proj_link, 8) */
    Status,
    COUNT(*) as Total_Appointments,
    AVG(MONTHS_BETWEEN(SYSDATE, VisitDate)) as Avg_Months_Since_Visit,
    MIN(VisitDate) as Earliest_Visit,
    MAX(VisitDate) as Latest_Visit
FROM appointment_b@proj_link
GROUP BY Status
ORDER BY Total_Appointments DESC;

-- Display the execution plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


e