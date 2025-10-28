-- counting the number of medications issued from each department
-- using join and order from large to small quantity of medications issued

    SELECT 
        COUNT(medication.medid),                                                    -- count medications
        department.deptid,                                                          -- select department id
        department.depatname                                                        -- select department name table
    
    FROM medication                                                                 -- from medication table
    
    JOIN prescription ON medication.prescriptionid = prescription.prescriptionid    -- select (by join) prescription id that matches from prescription table
    
    JOIN appointment ON prescription.appointmentid = appointment.appointmentid      -- select appointment id that matches from appointment table
    
    JOIN doctor ON appointment.doctorid = doctor.doctorid                           -- select doctor id that matches from doctor table
    
    JOIN department ON doctor.deptid = department.deptid                            -- select department id that matches from the department table
    
    GROUP BY 
        department.deptid, department.depatname                                     -- group department id and department name rows of the same values
    
    ORDER BY
        COUNT(medication.medid) DESC;                                               -- show results from largest to smaller counts

        