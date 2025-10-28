-- A query to create a view (virtial table) that summarises visits per doctor per month
CREATE OR REPLACE VIEW Doctor_Monthly_Visits AS         -- Create a new view or replace it if it already exists
SELECT                                                  -- selects doctor's unique identifier
    Appointment.DoctorID,
    Doctor.FullName,
    TO_CHAR(Appointment.VisitDate, 'YYYY-MM') AS VisitMonth,        -- Convert the visit date into a 'YYYY-MM' format to group by month and year
    COUNT(*) AS TotalVisits                             -- Count total number of visits for that doctor in that month
FROM Appointment                                        -- Use data from the Appointment table
JOIN Doctor ON Appointment.DoctorID = Doctor.DoctorID
GROUP BY 
    Appointment.DoctorID, 
    Doctor.FullName,
    TO_CHAR(Appointment.VisitDate, 'YYYY-MM');       -- Group results by doctor




