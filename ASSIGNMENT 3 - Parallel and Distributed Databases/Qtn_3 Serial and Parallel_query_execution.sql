-- Enable paralle query execution
ALTER SESSION ENABLE PARALLEL QUERY;

-- Serial execution
SET AUTOTRACE ON;
select /*+ gather_plan_statistics */ * from medication_bugesera;    -- USED /*+ gather_plan_statistics */ to get statistics of detailed running time
SET AUTOTRACE OFF;

-- Parallel execution
SET AUTOTRACE ON;
SELECT /*+ PARALLEL(Medication_Bugesera, 8) */ * FROM Medication_Bugesera ;
SET AUTOTRACE OFF;

-- Getting detailed plan for serial execution
EXPLAIN PLAN FOR
SELECT /*+ gather_plan_statistics */ * FROM medication_bugesera;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Get detailed plan for parallel execution  
EXPLAIN PLAN FOR
SELECT /*+ PARALLEL(Medication_Bugesera, 8) */ * FROM Medication_Bugesera;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

