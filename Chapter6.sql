---**** Creating tables

CREATE TABLE products( 
	prod_id NUMBER (4),
	prod_name VARCHAR2 (20),
	stock_qty NUMBER (15,3)
);

/*Table and column names are identifiers and can be up to 
30 characters long. 
Special characters allowed #, $, _
For case sensitivity use "" double quotes */

CREATE TABLE MyTable (
Column_1 NUMBER,
Column_2 CHAR);

DESC mytable

SELECT table_name FROM user_tables
WHERE table_name = 'MyTable';

CREATE TABLE "MyTable" (
"Column1" number,
"Column2" char);

DESC "MyTable"

SELECT table_name FROM user_tables
WHERE UPPER(table_name) = 'MYTABLE';

--*** Specifying default values for columns

-- The default values can include SYSDATE, USER, USERENV, and UID.

CREATE TABLE orders (
order_number NUMBER (8),
status VARCHAR2 (10) DEFAULT 'PENDING');

INSERT INTO orders (order_number) VALUES (4004);

SELECT * FROM orders;

CREATE TABLE emp_punch (
emp_id NUMBER (6) NOT NULL,
time_in DATE,
time_out DATE,
updated_by VARCHAR2 (30) DEFAULT USER,
update_time TIMESTAMP WITH LOCAL TIME ZONE
DEFAULT SYSTIMESTAMP
);

DESCRIBE emp_punch

INSERT INTO emp_punch (emp_id, time_in)
VALUES (1090, TO_DATE('062801-2121','MMDDYY-HH24MI'));

SELECT * FROM emp_punch;

/* If you explicitly insert a NULL value for a column with DEFAULT defined, 
the value in the DEFAULT clause will not be used.*/
INSERT INTO emp_punch
VALUES (104, TO_DATE('062801-2121','MMDDYY-HH24MI'),
DEFAULT, DEFAULT, NULL);

SELECT * FROM emp_punch;

---*** Comments

COMMENT ON TABLE mytable IS
'Oracle 11g Study Guide Example Table';

COMMENT ON COLUMN mytable.column_1 is
'First column in MYTABLE';

---*** Creating a table from another table

-- CREATE TABLE <table characteristics> AS SELECT <query>

CREATE TABLE emp 
AS SELECT * FROM employees;

CREATE TABLE depts
AS SELECT * FROM departments WHERE 1 = 2;

CREATE TABLE regions_2
AS SELECT region_id REG_ID, region_name REG_NAME
FROM regions;

SELECT COUNT(*) FROM regions_2;

DESC regions_2;

/* The CREATE TABLE … AS SELECT … statement will not work if the query
refers to columns of the LONG datatype. */


/* When you create a table using the subquery, only the NOT NULL constraints
associated with the columns are copied to the new table. Other constraints and
column default definitions are not copied. */  

------------------------------
---- Modifying tables --------
------------------------------

---*** Adding columns

-- ALTER TABLE [<schema>.]<table_name> ADD <column_definitions>;

DESCRIBE orders

SELECT * FROM orders;

ALTER TABLE orders ADD order_date DATE;

DESC orders

SELECT * FROM orders;

ALTER TABLE orders ADD
(quantity NUMBER (13,3),
update_dt DATE DEFAULT SYSDATE);

SELECT * FROM orders;

/* When adding a new column, you cannot specify the NOT NULL constraint if the table
already has rows. */

-- error table already contains rows
ALTER TABLE orders
ADD updated_by VARCHAR2 (30) NOT NULL;

ALTER TABLE orders ADD updated_by VARCHAR2 (30)
DEFAULT 'JOHN' NOT NULL;


---*** Modifying columns

-- ALTER TABLE [<schema>.]<table_name> MODIFY <column_name> <new_attributes>;

ALTER TABLE orders MODIFY (quantity NUMBER (10,3),
status VARCHAR2 (15));

/* Removes the default SYSDATE value from the UPDATE_DT column of the ORDERS table */
ALTER TABLE orders
MODIFY update_dt DEFAULT NULL;

---*** Renaming columns

-- ALTER TABLE [<schema>.]<table_name> RENAME COLUMN <column_name> TO <new_name>;

CREATE TABLE sample_data(
	data_value VARCHAR2(20),
	data_type VARCHAR2(10)
);

ALTER TABLE sample_data
RENAME COLUMN data_value to sample_value;

DESCRIBE sample_data

---*** Dropping columns

--DROP
/* ALTER TABLE [<schema>.]<table_name>
DROP {COLUMN <column_name> | (<column_names>)}
[CASCADE CONSTRAINTS] */

---SET UNUSED
/* ALTER TABLE [<schema>.]<table_name>
SET UNUSED {COLUMN <column_name> | (<column_names>)}
[CASCADE CONSTRAINTS] */

ALTER TABLE orders SET UNUSED COLUMN update_dt;

DESCRIBE orders

-- Drop a column already marked as unused
/* ALTER TABLE [<schema>.]<table_name>
DROP {UNUSED COLUMNS | COLUMNS CONTINUE} */

ALTER TABLE orders DROP UNUSED COLUMNS;

/* The data dictionary views DBA_UNUSED_COL_TABS, ALL_UNUSED_COL_TABS,
and USER_UNUSED_COL_TABS provide the names of tables in which you have
columns marked as unused. */

---*** Dropping tables

-- DROP TABLE [schema.]table_name [CASCADE CONSTRAINTS]

DROP TABLE sample_data;

---*** Renaming tables
 
/* Oracle invalidates all objects that depend on the renamed table, 
such as views, synonyms, stored procedures, and functions. */

-- RENAME old_name TO new_name;

RENAME orders TO purchase_orders;
DESCRIBE purchase_orders

-- Other technique

ALTER TABLE scott.purchase_orders
RENAME TO orders;

---*** Making tables read-only

ALTER TABLE products READ ONLY;

/* The following operations on
the read-only table are not allowed:
* INSERT, UPDATE, DELETE, or MERGE statements
* The TRUNCATE operation
* Adding, modifying, renaming, or dropping a column
* Flashing back a table
* SELECT FOR UPDATE*/

/* The following operations are allowed on the read-only table:
* SELECT
* Creating or modifying indexes
* Creating or modifying constraints
* Changing the storage characteristics of the table
* Renaming the table
* Dropping the table*/

-- Not allowed
TRUNCATE TABLE products;
DELETE FROM products;
INSERT INTO products (prod_id) VALUES (200);

-- Back to normal
ALTER TABLE products READ WRITE;

---------------------------------
------ Managing Constraints -----
---------------------------------

/* Types of constraints: NOT NULL, CHECK, UNIQUE, 
	PRIMARY KEY, FOREIGN KEY */

/* NOT NULL Constraint
 A NOT NULL constraint is defined at the column level 
 [CONSTRAINT <constraint name>] [NOT] NULL*/

-- DROP TABLE orders; -- just in case
CREATE TABLE orders (
order_num NUMBER (4) CONSTRAINT nn_order_num NOT NULL,
order_date DATE NOT NULL,
product_id NUMBER (6))

-- Add or remove NOT NULL
ALTER TABLE orders MODIFY order_date NULL;
ALTER TABLE orders MODIFY product_id NOT NULL;

/* Check Constraint
 You can define a check constraint at the column level or table level 
 [CONSTRAINT <constraint name>] CHECK ( <condition> )*/

CREATE TABLE bonus (
emp_id VARCHAR2 (40) NOT NULL,
salary NUMBER (9,2),
bonus NUMBER (9,2),
CONSTRAINT ck_bonus check (bonus > 0));

ALTER TABLE bonus
ADD CONSTRAINT ck_bonus2 CHECK (bonus < salary);

/* You cannot use the ALTER TABLE MODIFY clause to add or modify check constraints (only
NOT NULL constraints can be modified this way).*/

ALTER TABLE orders ADD cust_id number (5)
CONSTRAINT ck_cust_id CHECK (cust_id > 0);

-- simulate NOT NULL on multiple columns
ALTER TABLE bonus ADD CONSTRAINT ck_sal_bonus
CHECK ((bonus IS NULL AND salary IS NULL) OR
(bonus IS NOT NULL AND salary IS NOT NULL));

/* Unique Constraints
Unique constraints can be defined at the column level for 
single-column unique keys
[CONSTRAINT <constraint name>] UNIQUE
-- Multiple column up to 32
[CONSTRAINT <constraint name>]
UNIQUE (<column>, <column>, …)*/

CREATE TABLE employee(
	emp_id NUMBER(4),
	dept VARCHAR2(10)
);

ALTER TABLE employee
ADD CONSTRAINT uq_emp_id UNIQUE (dept, emp_id);

ALTER TABLE employee ADD
ssn VARCHAR2 (11) CONSTRAINT uq_ssn unique;

/* Primary Key
-- column level
[CONSTRAINT <constraint name>] PRIMARY KEY
-- table level
[CONSTRAINT <constraint name>]
PRIMARY KEY (<column>, <column>, …)*/

DROP TABLE employee;

CREATE TABLE employee (
dept_no VARCHAR2 (2),
emp_id NUMBER (4),
name VARCHAR2 (20) NOT NULL,
ssn VARCHAR2 (11),
salary NUMBER (9,2) CHECK (salary > 0),
CONSTRAINT pk_employee primary key (dept_no, emp_id),
CONSTRAINT uq_ssn unique (ssn));

-- add PK to existing table
ALTER TABLE employee
ADD CONSTRAINT pk_employee PRIMARY KEY (dept_no, emp_id);

/* Foreign Key
[CONSTRAINT <constraint name>]
REFERENCES [<schema>.]<table> [(<column>, <column>, …]
[ON DELETE {CASCADE | SET NULL}] */

/* You can query the constraint information from the Oracle dictionary using
the following views: USER_CONSTRAINTS, ALL_CONSTRAINTS, USER_CONS_
COLUMNS, and ALL_CONS_COLUMNS. */

-- Create a disabled constraint

ALTER TABLE bonus
ADD CONSTRAINT ck_bonus CHECK (bonus > 0) DISABLE;

---*** Drop constraints 

ALTER TABLE bonus DROP CONSTRAINT ck_bonus;

ALTER TABLE employee MODIFY name NULL;

-- Drop unique or primary key constraint with referenced FK

ALTER TABLE employee DROP UNIQUE (emp_id) CASCADE;

ALTER TABLE bonus DROP PRIMARY KEY CASCADE;