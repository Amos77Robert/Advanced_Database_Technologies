-- A2.1 database linking from Node A
CREATE DATABASE LINK proj_link
CONNECT TO c##Node_B IDENTIFIED BY nodeb2025
USING 'localhost:1521/orcl';


-- A2.2 REMOTE SELECT
SELECT * FROM Doctor_B@proj_link;


-- A2.3 DIstributed join from Appointment_A with Patient_B
SELECT a.AppointmentID,
       p.FullName AS Patient_Name,
       p.Gender,
       a.VisitDate,
       a.Diagnosis,
       d.FullName AS Doctor_Name
FROM Appointment_A a
JOIN Patient_B@proj_link p ON a.PatientID = p.PatientID
JOIN Doctor_B@proj_link d ON a.DoctorID = d.DoctorID
WHERE a.VisitDate BETWEEN DATE '2023-01-01' AND DATE '2025-10-30'  -- Date range filter
  AND ROWNUM <= 10                                                  -- Strict row limit
ORDER BY a.VisitDate;
