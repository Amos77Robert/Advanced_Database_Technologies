show user;

-- Creating a database link between Kigali Branch and Bugesera Branch and test witl SELECT and distributed join
CREATE DATABASE LINK kigali_branch_link
CONNECT TO c##Kigali_Branch IDENTIFIED BY kigali2025
USING 'localhost:1521/orcl';

-- Demonstrating its creation by querying from Bugesera_Branch, query Kigali_Branch's Department table
SELECT * FROM Department_Kigali@KIGALI_BRANCH_LINK;

-- Testing distributed join on Kigali_Branch from Bugesera_Branch by 
-- Retrieving local patients from Bugesera and combine them with remote doctors and their departments in Kigali

SELECT p.FullName AS Patient_Name,
       d.FullName AS Doctor_Name,
       dept.DepatName AS Doctor_Department
FROM Patient_Bugesera p 
JOIN Doctor_Kigali@KIGALI_BRANCH_LINK d
  ON 1=1                                                -- Cartesian product for demo purpopses
JOIN Department_Kigali@KIGALI_BRANCH_LINK dept
  ON d.DeptID = dept.DeptID
WHERE dept.DepatName IN ('Cardiology', 'Radiology');


