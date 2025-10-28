--show user;
-- These queries create tables that contain all data that belong to Neurology department from amoss database user
-- Creating Department table fragment (Neurology only)
CREATE TABLE Department_Bugesera AS
SELECT * FROM c##amoss.Department WHERE DepatName = 'Neurology';

-- Create Doctor table fragment (doctors in Neurology)
CREATE TABLE Doctor_Bugesera AS
SELECT * FROM c##amoss.Doctor 
WHERE DeptID IN (SELECT DeptID FROM c##amoss.Department WHERE DepatName = 'Neurology');

-- Create Patient fragment that belongs to Neurology departments
CREATE TABLE Patient_Bugesera AS
SELECT * FROM c##amoss.Patient 
WHERE PatientID IN (
    SELECT a.PatientID FROM c##amoss.Appointment a
    JOIN c##amoss.Doctor d ON a.DoctorID = d.DoctorID
    WHERE d.DeptID IN (SELECT DeptID FROM c##amoss.Department WHERE DepatName = 'Neurology')
);

-- Creating Appointment fragement that belongs to Neurology department
CREATE TABLE Appointment_Bugesera AS
SELECT * FROM c##amoss.Appointment 
WHERE DoctorID IN (
    SELECT DoctorID FROM c##amoss.Doctor 
    WHERE DeptID IN (SELECT DeptID FROM c##amoss.Department WHERE DepatName = 'Neurology')
);

-- Creating Prescription fragement that belongs to Neurology department
CREATE TABLE Prescription_Bugesera AS
SELECT * FROM c##amoss.Prescription 
WHERE AppointmentID IN (SELECT AppointmentID FROM Appointment_Bugesera);

-- Creating Medication fragment that belongs to Neurology department
CREATE TABLE Medication_Bugesera AS
SELECT * FROM c##amoss.Medication 
WHERE PrescriptionID IN (SELECT PrescriptionID FROM Prescription_Bugesera);


