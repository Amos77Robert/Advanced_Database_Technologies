show user;

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