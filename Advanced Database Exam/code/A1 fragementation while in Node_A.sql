show user;


-- Creating a new database user by the name Kigali_Branch in container database
CREATE USER c##Node_A IDENTIFIED BY nodea2025;
GRANT UNLIMITED TABLESPACE TO c##Node_A;
GRANT RESOURCE, DBA, CONNECT TO c##Node_A;

-- Creating another database by the name Bugesera_Branch in container database
CREATE USER c##Node_B IDENTIFIED BY nodeB2025;
GRANT UNLIMITED TABLESPACE TO c##Node_B;
GRANT RESOURCE, DBA, CONNECT TO c##Node_B;
-- *******************************************************************************************************
-- A1.1 Create horizontally fragmented tables Appointment_A on Node_A and Appointment_B 
-- on Node_B using a deterministic rule (HASH or RANGE on a natural key).
-- ******************************************************************************************************
-- ============================================================
-- HORIZONTAL FRAGMENTATION USING HASH PARTITIONING
-- ============================================================
-- Description: Fragment all tables using HASH partitioning on natural keys
--              for balanced distribution across Node_A and Node_B
-- Hash Rule: MOD(ORA_HASH(primary_key), 2) = 0 for Node_A, = 1 for Node_B
-- ============================================================

-- Node_A tables (even hash values)
-- Department table fragmentation using HASH on DeptID
CREATE TABLE Department_A AS
SELECT * FROM c##amoss.Department 
WHERE MOD(ORA_HASH(DeptID), 2) = 0;  -- Even hash values to Node_A

-- Doctor table fragmentation using HASH on DoctorID  
CREATE TABLE Doctor_A AS
SELECT * FROM c##amoss.Doctor 
WHERE MOD(ORA_HASH(DoctorID), 2) = 0;  -- Even hash values to Node_A

-- Patient table fragmentation using HASH on PatientID
CREATE TABLE Patient_A AS
SELECT * FROM c##amoss.Patient 
WHERE MOD(ORA_HASH(PatientID), 2) = 0;  -- Even hash values to Node_A

-- Appointment table fragmentation using HASH on AppointmentID
CREATE TABLE Appointment_A AS
SELECT * FROM c##amoss.Appointment 
WHERE MOD(ORA_HASH(AppointmentID), 2) = 0;  -- Even hash values to Node_A

-- Prescription table fragmentation using HASH on PrescriptionID
CREATE TABLE Prescription_A AS
SELECT * FROM c##amoss.Prescription 
WHERE MOD(ORA_HASH(PrescriptionID), 2) = 0;  -- Even hash values to Node_A

-- Medication table fragmentation using HASH on MedID
CREATE TABLE Medication_A AS
SELECT * FROM c##amoss.Medication 
WHERE MOD(ORA_HASH(MedID), 2) = 0;  -- Even hash values to Node_A

COMMIT;

-- ============================================================
-- ADD CONSTRAINTS TO MAINTAIN DATA INTEGRITY
-- ============================================================

-- Primary Key constraints for Node_A
ALTER TABLE Department_A ADD CONSTRAINT pk_dept_a PRIMARY KEY (DeptID);
ALTER TABLE Doctor_A ADD CONSTRAINT pk_doctor_a PRIMARY KEY (DoctorID);
ALTER TABLE Patient_A ADD CONSTRAINT pk_patient_a PRIMARY KEY (PatientID);
ALTER TABLE Appointment_A ADD CONSTRAINT pk_appointment_a PRIMARY KEY (AppointmentID);
ALTER TABLE Prescription_A ADD CONSTRAINT pk_prescription_a PRIMARY KEY (PrescriptionID);
ALTER TABLE Medication_A ADD CONSTRAINT pk_medication_a PRIMARY KEY (MedID);

-- *****************************************************************************************
-- ============================================================
-- NODE_B TABLES (odd hash values)
-- ============================================================

-- Department table fragmentation for Node_B
CREATE TABLE Department_B AS
SELECT * FROM c##amoss.Department 
WHERE MOD(ORA_HASH(DeptID), 2) = 1;  -- Odd hash values to Node_B

-- Doctor table fragmentation for Node_B
CREATE TABLE Doctor_B AS
SELECT * FROM c##amoss.Doctor 
WHERE MOD(ORA_HASH(DoctorID), 2) = 1;  -- Odd hash values to Node_B

-- Patient table fragmentation for Node_B
CREATE TABLE Patient_B AS
SELECT * FROM c##amoss.Patient 
WHERE MOD(ORA_HASH(PatientID), 2) = 1;  -- Odd hash values to Node_B

-- Appointment table fragmentation for Node_B
CREATE TABLE Appointment_B AS
SELECT * FROM c##amoss.Appointment 
WHERE MOD(ORA_HASH(AppointmentID), 2) = 1;  -- Odd hash values to Node_B

-- Prescription table fragmentation for Node_B
CREATE TABLE Prescription_B AS
SELECT * FROM c##amoss.Prescription 
WHERE MOD(ORA_HASH(PrescriptionID), 2) = 1;  -- Odd hash values to Node_B

-- Medication table fragmentation for Node_B
CREATE TABLE Medication_B AS
SELECT * FROM c##amoss.Medication 
WHERE MOD(ORA_HASH(MedID), 2) = 1;  -- Odd hash values to Node_B

COMMIT;

-- Primary Key constraints for Node_B for integritu
ALTER TABLE Department_B ADD CONSTRAINT pk_dept_b PRIMARY KEY (DeptID);
ALTER TABLE Doctor_B ADD CONSTRAINT pk_doctor_b PRIMARY KEY (DoctorID);
ALTER TABLE Patient_B ADD CONSTRAINT pk_patient_b PRIMARY KEY (PatientID);
ALTER TABLE Appointment_B ADD CONSTRAINT pk_appointment_b PRIMARY KEY (AppointmentID);
ALTER TABLE Prescription_B ADD CONSTRAINT pk_prescription_b PRIMARY KEY (PrescriptionID);
ALTER TABLE Medication_B ADD CONSTRAINT pk_medication_b PRIMARY KEY (MedID);

COMMIT;

-- **********************************************************************************************
-- Database Link
-- Creating a database link between Node_A and Node_B and test witl SELECT and distributed join
CREATE DATABASE LINK proj_link
CONNECT TO c##Node_B IDENTIFIED BY nodeb2025
USING 'localhost:1521/orcl';

-- ********************************************************************************************
-- Creating Appointment_ALL View

SELECT * FROM Appointment_B@proj_link;

-- A.3.
-- Testing a VIEW on UNION ALL
SELECT * FROM Appointment_A 
UNION ALL 
SELECT * FROM Appointment_B@proj_link;


-- A.4.
Select count(*) from Appointment_A;
select count(*) from Appointment_B@proj_link;

