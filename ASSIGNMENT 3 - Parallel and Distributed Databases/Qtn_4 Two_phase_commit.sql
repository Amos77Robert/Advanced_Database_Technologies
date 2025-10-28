-- A PL/SQL Block to perform inserts on both Kigali_Branch and Bugesera_Branch
SET SERVEROUTPUT ON;

BEGIN
    -- Insert into local Bugesera table
    INSERT INTO Patient_Bugesera (PatientID, FullName, Gender, DOB, Contact, Address)
    VALUES (7,'James Bugesera', 'Female', DATE '2000-01-10',0783456789, 'Bugesera District');

    -- Insert into remote Kigali table via DB link
    INSERT INTO Patient_Kigali@KIGALI_BRANCH_LINK (PatientID,FullName, Gender, DOB,Contact, Address)
    VALUES (7,'Isaac Kigali', 'Male', DATE '1998-01-10',0798754321, 'Kigali District');

    -- Commit both inserts together
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Distributed transaction committed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        ROLLBACK;

END;
/





