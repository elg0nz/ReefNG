CREATE USER koala_test WITH PASSWORD 'test' CREATEDB;
CREATE DATABASE api_test
    WITH 
    OWNER = koala_test
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;


CREATE USER koala_dev WITH PASSWORD 'dev' CREATEDB;
CREATE DATABASE api_dev
    WITH 
    OWNER = koala_dev
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;