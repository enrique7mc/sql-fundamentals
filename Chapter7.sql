-------------------------------------
---- Creating and Modifying View ----
-------------------------------------

CREATE VIEW admin_employees AS
SELECT first_name || last_name NAME,
email, job_id POSITION
FROM employees
WHERE department_id = 10;

DESCRIBE admin_employees

CREATE VIEW emp_sal_comm AS
SELECT employee_id, salary,
salary * NVL(commission_pct,0) commission
FROM employees;

DESCRIBE emp_sal_comm

---*** Using defined column names

CREATE VIEW emp_hire
(employee_id, employee_name, department_name,
hire_date, commission_amt)
AS SELECT employee_id, first_name || ' ' || last_name,
	department_name, TO_CHAR(hire_date,'DD-MM-YYYY'),
	salary * NVL(commission_pct, .5)
	FROM employees JOIN departments USING (department_id)
	ORDER BY first_name || ' ' || last_name;

DESC emp_hire

---*** Create views with errors

CREATE VIEW test_view AS
SELECT c1, c2 FROM test_table; -- error

CREATE FORCE VIEW test_view AS -- correct
SELECT c1, c2 FROM test_table;

CREATE TABLE test_table (
c1 NUMBER (10),
c2 VARCHAR2 (20));

SELECT * FROM test_view;

---*** Creating Read-Only views

CREATE VIEW all_locations
AS SELECT country_id, country_name, location_id, city
FROM locations NATURAL JOIN countries
WITH READ ONLY;

---*** Creating Constraints on Views

/* When creating constraints on views, you must always include the DISABLE
NOVALIDATE clause. You can define primary key, unique key, and foreign key constraints on
views.*/

CREATE VIEW emp_details
(employee_no CONSTRAINT fk_employee_no
REFERENCES employees DISABLE NOVALIDATE,
manager_no,
phone_number CONSTRAINT uq_email unique
DISABLE NOVALIDATE,
CONSTRAINT fk_manager_no FOREIGN KEY (manager_no)
REFERENCES employees DISABLE NOVALIDATE)
AS SELECT employee_id, manager_id, phone_number
FROM employees
WHERE department_id = 40;

---*** Modifying Views

/* To change the definition of the view, use the CREATE VIEW statement with the OR REPLACE
option. The ALTER VIEW statement can be used to compile an invalid view or to add and
drop constraints. */

CREATE OR REPLACE VIEW admin_employees AS
SELECT first_name ||' '|| last_name NAME,
email, job_id
FROM employees
WHERE department_id = 10;

---*** Recompiling a view

SELECT last_ddl_time, status FROM user_objects
WHERE object_name = 'TEST_VIEW';

ALTER TABLE test_table MODIFY c2 VARCHAR2 (8);

SELECT last_ddl_time, status FROM user_objects
WHERE object_name = 'TEST_VIEW';

ALTER VIEW test_view compile;

SELECT last_ddl_time, status FROM user_objects
WHERE object_name = 'TEST_VIEW';

-- adds a primary key constraint on the TEST_VIEW view

ALTER VIEW hr.test_view
ADD CONSTRAINT pk_test_view
PRIMARY KEY (C1) DISABLE NOVALIDATE;

-- drop the constraint you just added

ALTER VIEW test_view DROP CONSTRAINT pk_test_view;

---*** Droping a view

/* The view definition is dropped from the dictionary,
and the privileges and grants on the view are also dropped. Other views and stored
programs that refer to the dropped view become invalid.*/

DROP VIEW test_view;

---*** Using Views in Queries

SELECT * FROM emp_details;

SELECT department_name, SUM(commission_amt) comm_amt
FROM emp_hire
WHERE commission_amt > 100
GROUP BY department_name;

---*** Inserting, Updating, and Deleting Data through Views

/* DML cannot be done if the view containts at least one of
the following: DISTINCT , GROU BY, START WITH, CONNECT BY,
ROWNUM, set operators, a subquery in the SELECT clause */

CREATE OR REPLACE VIEW dept_above_250
AS SELECT department_id DID, department_name
FROM departments
WHERE department_id > 250;
SELECT * FROM dept_above_250;

INSERT INTO dept_above_250
VALUES (199, 'Temporary Dept');

SELECT * FROM departments
WHERE department_id = 199;

/* The WITH CHECK OPTION clause creates a check constraint on the view to
enforce the condition */

CREATE OR REPLACE VIEW dept_above_250
AS SELECT department_id DID, department_name
FROM departments
WHERE department_id > 250
WITH CHECK OPTION;

INSERT INTO dept_above_250
VALUES (199, 'Temporary Dept'); -- error

SELECT constraint_name, table_name
FROM user_constraints
WHERE constraint_type = 'V';

CREATE OR REPLACE VIEW dept_above_250
AS SELECT department_id DID, department_name
FROM departments
WHERE department_id > 250
WITH CHECK OPTION CONSTRAINT check_dept_250;

FROM user_constraints
WHERE constraint_type = 'V';
SELECT constraint_name, table_name

/* Using Join Views */

CREATE OR REPLACE VIEW country_region AS
SELECT a.country_id, a.country_name, a.region_id,
b.region_name
FROM countries a, regions b
WHERE a.region_id = b.region_id;

/* In the COUNTRY_REGION view, the COUNTRIES table is key-preserved because it is the primary
key in the COUNTRIES table and its uniqueness is kept in the view also. The REGIONS
table is not key-preserved because its primary key REGION_ID is duplicated several times for
each country.*/

UPDATE country_region
SET region_name = 'Testing Update'
WHERE region_id = 1;

UPDATE country_region
SET region_id = 1
WHERE country_id = 'EG';

CREATE OR REPLACE VIEW country_region AS
SELECT a.country_id, a.country_name, a.region_id,
b.region_name
FROM countries a, regions b
WHERE a.region_id = b.region_id
WITH CHECK OPTION;

-- WITH CHECK OPTION prevents DML even if is a key-preserved table
UPDATE country_region
SET region_id = 1
WHERE country_id = 'EG';

---*** Viewing Allowable DML operations

SELECT column_name, updatable, insertable, deletable
FROM user_updatable_columns
WHERE owner = 'HR'
AND table_name = ‘COUNTRY_REGION’;

---*** Using Inline Views

--report the employee names, their salaries, and the average salary
in their department
SELECT first_name, salary, avg_salary
FROM employees, (SELECT department_id,
AVG(salary) avg_salary FROM employees e2
GROUP BY department_id) dept
WHERE employees.department_id = dept.department_id
AND first_name like 'B%';


---*** Performing Top-n Analysis

-- top five highest-paid employees
SELECT * FROM
(SELECT last_name, salary
FROM employees
ORDER BY salary DESC)
WHERE ROWNUM <= 5;

SELECT first_name, salary, avg_salary
FROM employees
NATURAL JOIN (SELECT department_id,
AVG(salary) avg_salary FROM employees e2
GROUP BY department_id) dept
WHERE first_name like 'B%';

-- find the newest employee in each department
SELECT department_name, first_name, last_name,
hire_date
FROM employees JOIN departments
USING (department_id)
JOIN (SELECT department_id, max(hire_date) hire_date
FROM employees
GROUP BY department_id)
USING (department_id, hire_date);

-----------------------------------------
---- Creating and Managing Sequences ----
-----------------------------------------

CREATE SEQUENCE hr.employee_identity START WITH 2001;

DROP SEQUENCE sequence_name;

/* The syntax for accessing the next sequence number is as follows:
	sequence_name.nextval
Here is the syntax for accessing the last-used sequence number:
	sequence_name.currval*/

CREATE SEQUENCE emp_seq NOMAXVALUE NOCYCLE;