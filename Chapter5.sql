CREATE TABLE myaccounts(
	acc_no NUMBER(5) NOT NULL,
	acc_dt DATE NOT NULL,
	dr_cr CHAR,
	amount NUMBER(15, 2)
);

INSERT INTO myaccounts (acc_no, acc_dt, amount)
VALUES (120003, TRUNC(SYSDATE), 400);

INSERT INTO myaccounts (acc_no, acc_dt, dr_cr, amount)
VALUES (120003, TRUNC(SYSDATE), DEFAULT, 400);

CREATE TABLE accounts(
	cust_name VARCHAR2(20),
	acc_open_date DATE,
	balance NUMBER(15, 2)
);

INSERT INTO accounts VALUES ('John', '13/05/68', 2300.45);

INSERT INTO hr.accounts (cust_name, acc_open_date)
VALUES (Shine, 'April-23-2001'); -- error 1st value

INSERT INTO hr.accounts (cust_name, acc_open_date)
VALUES ('Shine', 'April-23-2001'); -- error date

-- correct 
INSERT INTO hr.accounts (cust_name, acc_open_date)
VALUES ('Shine', TO_DATE('April-23-2001','Month-DD-YYYY'));

-- not enough values
INSERT INTO accounts VALUES ('Jishi', '4-AUG-72');

-- using functions
INSERT INTO accounts VALUES (USER, SYSDATE, 345);

---**** Inserting Rows from a Subquery

INSERT INTO accounts
SELECT first_name, hire_date, salary
FROM hr.employees
WHERE first_name like 'R%';

-- error too many values
INSERT INTO accounts (cust_name, balance)
SELECT first_name, hire_date, salary
FROM hr.employees
WHERE first_name like 'T%';

-- correct
INSERT INTO accounts (cust_name, acc_open_date)
2 SELECT UPPER(first_name), ADD_MONTHS(hire_date,2)
3 FROM hr.employees
4 WHERE first_name like 'T%';

-- Inserting Rows into Multiple Tables
/* INSERT [ALL | FIRST] {WHEN <condition> 
THEN INTO <insert_clause> … … …} [ELSE
<insert_clause>}*/

---*** Updating rows in a table

/* UPDATE <table_name>
SET <column> = <value>
[,<column> = <value> … … …]
[WHERE <condition>]*/

SELECT first_name, last_name, department_id
FROM employees
WHERE employee_id = 200;

UPDATE employees
SET department_id = 20
WHERE employee_id = 200;

SELECT first_name, last_name, department_id
FROM employees
WHERE employee_id = 200;

CREATE TABLE old_employees AS
SELECT * FROM employees;

UPDATE old_employees
SET manager_id = NULL,
commission_pct = 0;

-- Updating Rows Using a Subquery
SELECT first_name, last_name, job_id
FROM employees
WHERE department_id = 30;

/* the job_id values of all employees in department 30 are changed to match
the job_id of employee 114 */
UPDATE employees
SET job_id = (SELECT job_id
FROM employees
WHERE employee_id = 114)
WHERE department_id = 30;

SELECT first_name, last_name, job_id
FROM employees
WHERE department_id = 30;

-- Deleting Rows from a Table

/* DELETE [FROM] <table>
[WHERE <condition>] */

-- Delete some rows from old_employees

/* Removing all rows from a large table can take a long time and require significant rollback
segment space.*/

TRUNCATE TABLE old_employees;

/* A DDL statement cannot be rolled back; only DML statements can be 
rolled back.*/

------------------------------------------------
-------- Understanding Transaction Control -----
------------------------------------------------

/* A transaction can include one or more DML statements. A transaction ends when you
save the transaction (COMMIT) or undo the changes (ROLLBACK). When DDL statements are
executed, Oracle implicitly ends the previous transaction by saving the changes. It also
begins a new transaction for the DDL and ends the transaction after the DDL is completed.*/

