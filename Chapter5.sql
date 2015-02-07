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