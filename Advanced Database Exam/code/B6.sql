-- ============================================================
-- B6_1: VERIFICATION OF EXISTING CONSTRAINTS - PRESCRIPTION TABLE
-- ============================================================

-- Check existing constraints on Prescription table
SELECT constraint_name, constraint_type, search_condition, status
FROM user_constraints 
WHERE table_name = 'PRESCRIPTION_A'
ORDER BY constraint_type, constraint_name;


-- ============================================================
-- B6_1: VERIFICATION OF EXISTING CONSTRAINTS - MEDICATION TABLE
-- ============================================================

-- Check existing constraints on Medication table
SELECT constraint_name, constraint_type, search_condition, status
FROM user_constraints 
WHERE table_name = 'MEDICATION_A'
ORDER BY constraint_type, constraint_name;


-- ============================================================
-- B6_2: TEST INSERT VALIDATION WITHOUT ALTERING TABLES
-- ============================================================

-- Test INSERTs for Prescription table using existing constraints
-- PASSING INSERT 1: Valid prescription that should work with current constraints
INSERT INTO Prescription_A (PrescriptionID, AppointmentID, Notes, DateIssued)
VALUES (1001, 1, 'Regular medication for blood pressure', SYSDATE);
select * from prescription_a;
commit;

-- PASSING INSERT 2: Valid prescription within existing rules
INSERT INTO Prescription_A (PrescriptionID, AppointmentID, Notes, DateIssued)
VALUES (1002, 2, 'Follow-up prescription', SYSDATE - 1);
select * from prescription_a;
commit;

-- FAILING INSERT 1: Test what happens with NULL in required field
BEGIN
    INSERT INTO Prescription_A (PrescriptionID, AppointmentID, Notes, DateIssued)
    VALUES (1003, NULL, 'Test prescription with NULL AppointmentID', SYSDATE);
    commit;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('PRESCRIPTION FAIL 1: ' || SQLERRM);
        ROLLBACK;
END;
/
SELECT * FROM prescription_a;  -- check updated content

-- FAILING INSERT 2: Test invalid data based on existing constraints - unique primary key
BEGIN
    -- This will fail if there are CHECK constraints or foreign key violations
    INSERT INTO Prescription_A (PrescriptionID, AppointmentID, Notes, DateIssued)
    VALUES (1004, 9999, 'Test with non-existent AppointmentID', SYSDATE);
    commit;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('PRESCRIPTION FAIL 2: ' || SQLERRM);
        ROLLBACK;
END;
/

-- Test INSERTs for Medication table using existing constraints
-- PASSING INSERT 1: Valid medication
INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
VALUES (5001, 1001, 'Paracetamol', '500mg', '7 days', '30 tablets');
commit;
select * from medication_a;

-- PASSING INSERT 2: Valid medication
INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
VALUES (5002, 1002, 'Amoxicillin', '250mg', '10 days', '20 capsules');
commit;
select * from medication_a;

-- FAILING INSERT 1: Test NULL in required field
BEGIN
    INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
    VALUES (5003, 1001, NULL, '500mg', '7 days', '30 tablets');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('MEDICATION FAIL 1: ' || SQLERRM);
        ROLLBACK;
END;
/

-- FAILING INSERT 2: Test invalid foreign key reference
BEGIN
    INSERT INTO Medication_A (MedID, PrescriptionID, DrugName, Dosage, DurationN, Quantity)
    VALUES (5004, 9999, 'Ibuprofen', '400mg', '5 days', '15 tablets');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('MEDICATION FAIL 2: ' || SQLERRM);
        ROLLBACK;
END;
/

COMMIT; -- Commit only the successful inserts



-- ============================================================
-- B6_4: FINAL VERIFICATION - COMMITTED ROWS COUNT
-- ============================================================

-- Verify we stay within ≤10 committed rows budget
SELECT 
    'Prescription' as Table_Name, 
    COUNT(*) as Committed_Rows 
FROM Prescription_A
WHERE PrescriptionID IN (1001, 1002)
UNION ALL
SELECT 
    'Medication', 
    COUNT(*) 
FROM Medication_A 
WHERE MedID IN (5001, 5002)
UNION ALL
SELECT 
    'TOTAL_COMMITTED', 
    (SELECT COUNT(*) FROM Prescription_A WHERE PrescriptionID IN (1001, 1002)) + 
    (SELECT COUNT(*) FROM Medication_A WHERE MedID IN (5001, 5002))
FROM dual;