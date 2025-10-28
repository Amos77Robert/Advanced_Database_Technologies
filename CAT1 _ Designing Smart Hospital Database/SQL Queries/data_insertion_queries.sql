
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

