-- ============================================================
-- B8_1: CREATE HIERARCHY TABLE
-- ============================================================
-- Purpose: Store department-doctor hierarchy for hospital organizational structure
-- ============================================================

CREATE TABLE HIER(
    parent_id VARCHAR2(50),  -- Department names or doctor seniority levels
    child_id VARCHAR2(50)    -- Doctor names or subordinate departments
);


-- ============================================================
-- B8_2: INSERT HIERARCHY DATA (6 ROWS)
-- ============================================================
-- Purpose: Create 3-level hospital department-doctor hierarchy
-- ============================================================

-- Level 1: Hospital Departments
INSERT INTO HIER VALUES (NULL, 'Neurology');           -- Root department
INSERT INTO HIER VALUES (NULL, 'Cardiology');          -- Root department

-- Level 2: Senior Doctors within departments  
INSERT INTO HIER VALUES ('Neurology', 'Dr_Smith');     -- Senior neurologist
INSERT INTO HIER VALUES ('Cardiology', 'Dr_Jones');    -- Senior cardiologist

-- Level 3: Junior doctors under senior doctors
INSERT INTO HIER VALUES ('Dr_Smith', 'Dr_Brown');      -- Junior neurologist
INSERT INTO HIER VALUES ('Dr_Jones', 'Dr_Green');      -- Junior cardiologist

COMMIT;


-- ============================================================
-- B8_3: RECURSIVE HIERARCHY QUERY
-- ============================================================
-- Purpose: Find root department for each doctor and calculate depth
-- ============================================================

WITH HIERARCHY_ROLLUP (child_id, root_id, depth) AS (
    -- Anchor: Start with root departments (depth 1)
    SELECT 
        child_id, 
        child_id as root_id, 
        1 as depth
    FROM HIER 
    WHERE parent_id IS NULL
    
    UNION ALL
    
    -- Recursive: Traverse down the hierarchy
    SELECT 
        h.child_id, 
        r.root_id, 
        r.depth + 1
    FROM HIER h
    JOIN HIERARCHY_ROLLUP r ON h.parent_id = r.child_id
)
SELECT 
    hr.child_id as DOCTOR_OR_DEPT,
    hr.root_id as ROOT_DEPARTMENT,
    hr.depth as HIERARCHY_LEVEL,
    COUNT(a.AppointmentID) as APPOINTMENT_COUNT
FROM HIERARCHY_ROLLUP hr
LEFT JOIN Doctor_A d ON UPPER(d.FullName) LIKE '%' || REPLACE(hr.child_id, 'Dr_', '') || '%'
LEFT JOIN Appointment_A a ON d.DoctorID = a.DoctorID
WHERE hr.child_id LIKE 'Dr_%'  -- Focus on doctors only
GROUP BY hr.child_id, hr.root_id, hr.depth
ORDER BY hr.root_id, hr.depth;


-- ============================================================
-- B8: CONTROL AGGREGATION VALIDATION
-- ============================================================
-- Purpose: Verify rollup correctness by comparing hierarchy levels
-- ============================================================

-- Validation 1: Show complete hierarchy with path
WITH HIERARCHY_PATH AS (
    SELECT 
        child_id, 
        parent_id,
        SYS_CONNECT_BY_PATH(child_id, ' -> ') as full_path,
        LEVEL as depth
    FROM HIER
    START WITH parent_id IS NULL
    CONNECT BY PRIOR child_id = parent_id
)
SELECT 
    child_id,
    parent_id, 
    full_path,
    depth
FROM HIERARCHY_PATH
ORDER BY depth, child_id;

-- Validation 2: Count appointments by root department (rollup verification)
WITH HIERARCHY_ROLLUP AS (
    SELECT 
        child_id, 
        root_id,
        depth
    FROM (
        SELECT 
            child_id, 
            CONNECT_BY_ROOT child_id as root_id,
            LEVEL as depth
        FROM HIER
        CONNECT BY PRIOR child_id = parent_id
    )
    WHERE child_id LIKE 'Dr_%'
)
SELECT 
    hr.root_id as DEPARTMENT,
    COUNT(DISTINCT hr.child_id) as DOCTOR_COUNT,
    COUNT(a.AppointmentID) as TOTAL_APPOINTMENTS
FROM HIERARCHY_ROLLUP hr
LEFT JOIN Doctor_A d ON UPPER(d.FullName) LIKE '%' || REPLACE(hr.child_id, 'Dr_', '') || '%'
LEFT JOIN Appointment_A a ON d.DoctorID = a.DoctorID
GROUP BY hr.root_id
ORDER BY hr.root_id;

