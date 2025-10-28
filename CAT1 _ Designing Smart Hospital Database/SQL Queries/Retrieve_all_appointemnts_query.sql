-- retrieving all appointments showing doctor name, patient name and diagnosis
-- Inner join will be used to select only records from patient and doctor relations that match the criteria
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
