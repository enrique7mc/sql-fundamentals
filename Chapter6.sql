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