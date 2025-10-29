-- A4_1 ============================================================
-- PL/SQL BLOCK: Distributed Transaction with Two-Phase Commit
-- ============================================================
-- Description: Inserts one local row on Node_A and one remote row via database link
--              Demonstrates atomic distributed transaction with COMMIT
-- ============================================================

SET SERVEROUTPUT ON;

DECLARE
    v_local_appointment_id NUMBER;
    v_remote_prescription_id NUMBER;
BEGIN
    -- Generate unique IDs for the new records
    SELECT COALESCE(MAX(AppointmentID), 0) + 1 INTO v_local_appointment_id FROM Appointment_A;
    SELECT COALESCE(MAX(PrescriptionID), 0) + 1 INTO v_remote_prescription_id FROM Prescription_B@proj_link;
    
    -- Insert LOCAL row into Appointment_A on Node_A
    INSERT INTO Appointment_A (
        AppointmentID, PatientID, DoctorID, VisitDate, Diagnosis, Status
    ) VALUES (
        v_local_appointment_id,
        1,  -- Existing PatientID
        1,  -- Existing DoctorID  
        SYSDATE,
        'Routine checkup distributed transaction test',
        'pending'
    );
    
    DBMS_OUTPUT.PUT_LINE('Local appointment inserted: ' || v_local_appointment_id);
    
    -- Insert REMOTE row into Prescription@proj_link on Node_B
    INSERT INTO Prescription_B@proj_link (
        PrescriptionID, AppointmentID, Notes, DateIssued
    ) VALUES (
        v_remote_prescription_id,
        v_local_appointment_id,  -- Links to the local appointment
        'Prescription for distributed transaction test',
        SYSDATE
    );
    
    DBMS_OUTPUT.PUT_LINE('Remote prescription inserted: ' || v_remote_prescription_id);
    
    -- COMMIT both inserts atomically (Two-Phase Commit)
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Distributed transaction committed successfully!');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Transaction rolled back due to error');
END;
/




-- A2  ============================================================
-- PL/SQL BLOCK: Induce Distributed Transaction Failure by disabling the proj_link through droping it 
-- ============================================================

DROP DATABASE LINK proj_link;
