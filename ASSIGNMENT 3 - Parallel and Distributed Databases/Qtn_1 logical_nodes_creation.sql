
-- Creating a new database user by the name Kigali_Branch in container database
CREATE USER c##Kigali_Branch IDENTIFIED BY kigali2025;
GRANT UNLIMITED TABLESPACE TO c##Kigali_Branch;
GRANT RESOURCE, DBA, CONNECT TO c##Kigali_Branch;

-- Creating another database by the name Bugesera_Branch in container database
CREATE USER c##Bugesera_Branch IDENTIFIED BY bugesera2025;
GRANT UNLIMITED TABLESPACE TO c##Bugesera_Branch;
GRANT RESOURCE, DBA, CONNECT TO c##Bugesera_Branch;

