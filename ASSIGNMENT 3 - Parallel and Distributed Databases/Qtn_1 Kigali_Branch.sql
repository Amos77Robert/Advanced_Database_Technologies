-- show user
-- These queries create tables that contain all data for Kigali Branch except Neurology Department

-- Creating Department fragment except Neurology department
CREATE TABLE Department_Kigali AS
SELECT * FROM c##amoss.Department WHERE DepatName <> 'Neurology';


-- Creating Doctor fragment for doctors not in Neurology department
CREATE TABLE Doctor_Kigali AS
SELECT * FROM c##amoss.Doctor 
WHERE DeptID IN (SELECT DeptID FROM c##amoss.Department WHERE DepatName <> 'Neurology');

-- Create Patient fragment that belongx to non-Neurology departments
CREATE TABLE Patient_Kigali AS
SELECT * FROM c##amoss.Patient 
WHERE PatientID IN (
    SELECT a.PatientID FROM c##amoss.Appointment a
    JOIN c##amoss.Doctor d ON a.DoctorID = d.DoctorID
    WHERE d.DeptID IN (SELECT DeptID FROM c##amoss.Department WHERE DepatName <> 'Neurology')
);

-- Creating Appointment fragement that belongs to non-Neurology department
CREATE TABLE Appointment_Kigali AS
SELECT * FROM c##amoss.Appointment 
WHERE DoctorID IN (
    SELECT DoctorID FROM c##amoss.Doctor 
    WHERE DeptID IN (SELECT DeptID FROM c##amoss.Department WHERE DepatName <> 'Neurology')
);

-- Creating Prescription fragement that belongs to non-Neurology department 
CREATE TABLE Prescription_Kigali AS
SELECT * FROM c##amoss.Prescription 
WHERE AppointmentID IN (SELECT AppointmentID FROM Appointment_Kigali);

-- Creating Medication fragment that belongs to non-Neurology department
CREATE TABLE Medication_Kigali AS
SELECT * FROM c##amoss.Medication 
WHERE PrescriptionID IN (SELECT PrescriptionID FROM Prescription_Kigali);


