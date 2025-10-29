-- ============================================================
-- B10_1: CREATE BUSINESS LIMITS TABLE
-- ============================================================
-- Purpose: Store business rules and thresholds for medication alerts
-- ============================================================

CREATE TABLE BUSINESS_LIMITS (
    rule_key VARCHAR2(64),
    threshold NUMBER,
    active CHAR(1) CHECK(active IN('Y', 'N'))
);

-- ============================================================
-- B10_1: SEED SINGLE ACTIVE BUSINESS RULE
-- ============================================================
-- Purpose: Add rule to limit maximum medications per prescription
-- ============================================================

INSERT INTO BUSINESS_LIMITS VALUES (
    'MAX_MEDS_PER_PRESCRIPTION',  -- Rule: Maximum medications per prescription
    3,                            -- Threshold: Only 3 medications allowed per prescription
    'Y'                           -- Active: Rule is enabled
);
COMMIT;
select * from business_limits;

-- ============================================================
-- B10_2: CREATE ALERT FUNCTION
-- ============================================================
-- Purpose: Check if current operation violates business limits
-- ============================================================

CREATE OR REPLACE FUNCTION fn_should_alert(
    p_prescription_id IN NUMBER
) RETURN NUMBER 
IS
    v_medication_count NUMBER;
    v_threshold NUMBER;
BEGIN
    -- Get current medication count for the prescription
    SELECT COUNT(*) INTO v_medication_count
    FROM Medication_A
    WHERE PrescriptionID = p_prescription_id;
    
    -- Get the active threshold from BUSINESS_LIMITS
    SELECT threshold INTO v_threshold
    FROM BUSINESS_LIMITS
    WHERE rule_key = 'MAX_MEDS_PER_PRESCRIPTION'
    AND active = 'Y';
    
    -- Return 1 if threshold would be exceeded, 0 otherwise
    IF v_medication_count >= v_threshold THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- No active rule found, allow operation
    WHEN OTHERS THEN
        RETURN 0; -- On error, allow operation
END fn_should_alert;
/

-- ============================================================
-- B10_3: CREATE BUSINESS RULE TRIGGER
-- ============================================================
-- Purpose: Enforce medication limits before insert/update operations
-- ============================================================

CREATE OR REPLACE TRIGGER trg_medication_limit
BEFORE INSERT OR UPDATE ON Medication_A
FOR EACH ROW
DECLARE
    v_alert_flag NUMBER;
BEGIN
    -- Check if this operation would violate business rules
    v_alert_flag := fn_should_alert(:NEW.PrescriptionID);
    
    -- Raise application error if limit would be exceeded
    IF v_alert_flag = 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Business rule violation: Maximum 3 medications allowed per prescription. ' ||
            'Prescription ID: ' || :NEW.PrescriptionID);
    END IF;
END trg_medication_limit;
/


-- ============================================================
-- B10_4: DEMONSTRATION - PASSING DML OPERATIONS
-- ============================================================
-- Purpose: Show successful operations within business limits
-- ============================================================

-- PASSING INSERT 1: First medication for prescription (within limit)
INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
VALUES (7001, 1001, 'Aspirin', '100mg', '7 days', '21 tablets');
commit;
select * from Medication_A;

-- PASSING INSERT 2: Second medication for same prescription (within limit)
INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
VALUES (7002, 1001, 'Vitamin D', '1000IU', '30 days', '30 tablets');
commit;
select * from Medication_A;


-- ============================================================
-- B10_4: DEMONSTRATION - FAILING DML OPERATIONS
-- ============================================================
-- Purpose: Show operations that violate business limits (rolled back)
-- ============================================================

-- FAILING INSERT 1: Third medication would exceed limit
BEGIN
    INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
    VALUES (7003, 1001, 'Calcium', '500mg', '30 days', '30 tablets');
    DBMS_OUTPUT.PUT_LINE('This should not print - insert should fail');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FAILED INSERT 1: ' || SQLERRM);
        ROLLBACK;
END;
/

-- FAILING INSERT 2: Fourth medication attempt (definitely exceeds limit)
BEGIN
    INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
    VALUES (7004, 1001, 'Iron', '65mg', '30 days', '30 tablets');
    DBMS_OUTPUT.PUT_LINE('This should not print - insert should fail');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FAILED INSERT 2: ' || SQLERRM);
        ROLLBACK;
END;
/

COMMIT; -- Commit the successful operations


-- ============================================================
-- B10: VERIFICATION AND ROW BUDGET CHECK
-- ============================================================
-- Purpose: Verify business rule enforcement and row count compliance
-- ============================================================

-- 1. Show current medication counts per prescription
SELECT 
    PrescriptionID,
    COUNT(*) as Medication_Count
FROM Medication_A
GROUP BY PrescriptionID
ORDER BY PrescriptionID;

-- 2. Show committed medications (should only have 2 rows max from passing inserts)
SELECT 
    MedID,
    PrescriptionID,
    DrugName
FROM Medication_A
WHERE MedID IN (7001, 7002)
ORDER BY MedID;

-- 3. Verify total committed rows across all tables
SELECT 
    (SELECT COUNT(*) FROM BUSINESS_LIMITS) as Business_Rule_Rows,
    (SELECT COUNT(*) FROM Medication WHERE MedID IN (7001, 7002)) as Medication_Rows,
    (SELECT COUNT(*) FROM BUSINESS_LIMITS) + 
    (SELECT COUNT(*) FROM Medication WHERE MedID IN (7001, 7002)) as Total_Committed_Rows
FROM dual;
