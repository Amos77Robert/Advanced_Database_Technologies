# Smart Hospital Patient Flow & Prescription System

## Project Overview
The **Smart Hospital System** is designed to streamline hospital workflows - from patient registration and appointment booking to diagnosis and medication issuance. The system ensures smooth coordination between departments, doctors, patients, appointments, prescriptions, and medications while maintaining data consistency.  

This project implements a **relational database in Oracle 21c Enterprise Edition** with triggers, views, and constraints to manage hospital operations efficiently.

---

## Case Study Description
Every doctor belongs to a department, and each appointment links a patient, a doctor, and a diagnosis report. Prescriptions are issued per appointment, referencing drugs stocked in the pharmacy. The system ensures:

- Accurate medical records  
- Patient follow-ups  
- Proper tracking of stock dispensing  

---

## Database Tables
The system includes six main tables:

| Table | Columns |
|-------|---------|
| **Department** | DeptID (PK), DeptName, Location |
| **Doctor** | DoctorID (PK), FullName, Specialty, DeptID (FK), Phone, Email |
| **Patient** | PatientID (PK), FullName, Gender, DOB, Contact, Address |
| **Appointment** | AppointmentID (PK), PatientID (FK), DoctorID (FK), VisitDate, Diagnosis, Status |
| **Prescription** | PrescriptionID (PK), AppointmentID (FK), Notes, DateIssued |
| **Medication** | MedID (PK), PrescriptionID (FK), DrugName, Dosage, Duration, Quantity |

---

## Relationships
- Department → Doctor (1:N)  
- Doctor → Appointment (1:N)  
- Patient → Appointment (1:N)  
- Appointment → Prescription (1:1)  
- Prescription → Medication (1:N)  

> **Cascade Delete** is defined between Appointment → Prescription and Prescription → Medication to ensure referential integrity.

---

## Key Features & Tasks Implemented
1. **Table creation** with proper primary keys, foreign keys, NOT NULL, and CHECK constraints.  
2. **Sample data insertion** for:  
   - 3 departments  
   - 5 doctors  
   - 10 patients  
3. **Queries** to:  
   - Retrieve all appointments showing doctor name, patient name, and diagnosis  
   - Identify the number of medications issued per department  
4. **Triggers**:  
   - Update prescription notes after an appointment is marked “Completed”  
   - Record a log whenever a new prescription is created  
5. **Views**:  
   - Summarize total visits per doctor per month  
6. **Consistency checks** for prescriptions, medications, and appointments.  

---

## Sample Queries
- **Retrieve appointments with doctor and patient names, and patient diagnosis**
```sql
SELECT appointment.AppointmentID, patient.FullName AS PatientName, doctor.FullName AS DoctorName, appointment.Diagnosis
FROM Appointment
JOIN Patient ON appointment.PatientID = patient.PatientID
JOIN Doctor ON appointment.DoctorID = doctor.DoctorID;

```  
## Usage  
- **How to clone the project**  
```sql  
git clone https://github.com/Amos77Robert/Advanced_Database_Technologies.git

```
## Disclaimer  
```sql
All the data used in the this database design and implementation is Dummy Data used to faciliate validation of the implementation hence it is not real nor was collected from any hospital  
These data include names, numbers, locations and emails
