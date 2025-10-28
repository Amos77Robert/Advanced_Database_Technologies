
-- CONTENT CHECKING FROM TABLES
SET AUTOTRACE ON;
select /*+ gather_plan_statistics */ * from department;    -- USED /*+ gather_plan_statistics */ to get statistics of detailed running time
SET AUTOTRACE OFF;

select * from doctor;
select * from Patient;
select * from appointment;
select * from prescription;
select * from prescription_log;
select * from medication;

--**************************************************************************************************************************************************
-- TABLE MODIFICATIONS  e.g. updates

DELETE FROM prescription WHERE appointmentid = '2'; 

DELETE FROM Appointment WHERE AppointmentID = 3;

UPDATE prescription set Notes = 'The patient is responding well' where prescriptionid = 3;

--***************************************************************************************************************************************************
-- VIEW SUMMARIES 

-- Query the database to summarise number of visist per doctor per month
SELECT * FROM Doctor_Monthly_Visits ORDER BY VisitMonth;

-- view by total visists, specialty etc
SELECT v.FullName, v.VisitMonth, v.TotalVisits, d.specialty
FROM Doctor_Monthly_Visits v
JOIN Doctor d ON v.DoctorID = d.DoctorID
WHERE lower(d.specialty) = 'cardiologist';   -- match case sensitive

--***************************************************************************************************************************************************
--RETRIEVE ALL MEDICATIONS PER DEPARTMENT
SELECT                                                          
    appointment.AppointmentID,                                  -- select the unique id of the appointment
    patient.FullName,                                           -- select the patient full name
    doctor.FullName,                                            -- select the doctor's full name
    appointment.Diagnosis                                       -- select the diagnosis for the appointment
FROM 
    Appointment                                                 -- from the appointment table
JOIN 
    Patient ON appointment.PatientID = patient.PatientID        -- select by joining only records that match patient id from patient table
JOIN 
    Doctor ON appointment.DoctorID = doctor.DoctorID;           -- and also only records that match doctor id from doctor's table 

--**************************************************************************************************************************************************
-- INSERT NEW DATA INTO TABLES HERE

-- Register a patient in the hospital (max of 10)
INSERT INTO Patient (
    FullName, Gender, DOB, Contact, Address
)
VALUES(
    'Mark Sandifolo','Male',TO_DATE('1998-01-15', 'YYYY-MM-DD'),0795989540,'Kigali'
);

-- Register a medical doctor (max of 5) in a hospital to be allocated appointments
INSERT INTO Doctor (
    Fullname,Specialty,DeptID,Phone,Email
)
VALUES(
    'Dr. Robert Fisher','Surgeon','3','0798576584','robertfisha@gmail.com'
);

-- Create new departments (max of 3) in the system
INSERT INTO Department (
    DepatName, LocationName
)
VALUES (
    'Neurology','Ground Floor, Second Wing'
);

-- Create new appointments linking the doctor and patient 
-- (have created one appointment for each patient in this case)
INSERT INTO Appointment (
    PatientID, DoctorID, VisitDate, Diagnosis, Status
)
VALUES(
    18,30,TO_DATE('2025-10-14', 'YYYY-MM-DD'),'Acute appendicitis','pending'
);

-- Create new prescription for the corresponding appointment (have created 10 new prescriptions )
INSERT INTO Prescription (
    AppointmentID, Notes, DateIssued
)
VALUES(
    12,'Patient scheduled for appendectomy. Pre-op antibiotics given, monitor vitals.',TO_DATE('2025-02-05', 'YYYY-MM-DD')
);

-- Prescribe medications to the corresponding prescriptionID 
-- (have prescribed a total of 19 medications in 1:N prescription and medication relationship )
INSERT INTO Medication (
    PrescriptionID, DrugName, Dosage, Durationn,quantity
)
VALUES(
    11,'Paracetamol 500 mg','1 tablet every 6 hours','As needed for pain control','10'
);