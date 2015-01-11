-- Unlock HR user account
ALTER USER hr IDENTIFIED BY hrpassword ACCOUNT UNLOCK;

-- Using the SELECT Statement
SELECT * FROM jobs;

SELECT job_title, min_salary FROM jobs;

SELECT job_title AS Title,
min_salary AS "Minimum Salary" FROM jobs;

SELECT DISTINCT department_id FROM
employees;

SELECT DISTINCT department_id, job_id
FROM employees;

-- The DUAL table
SELECT * FROM dual;
SELECT SYSDATE, USER FROM dual;
SELECT 'I''m ' || user || 'Today is ' || SYSDATE;

-- ***Limiting rows***
--Employees who work for dept 90
SELECT first_name || ' ' || last_name "Name",
department_id FROM employees
WHERE department_id = 90;

-- Comparison operators
-- !=, <>, ^= (Inequality)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct != .35;

-- < (Less than)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct < .15;

-- > (Greater than)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct != .35;

-- <= (Less than or equal to)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct <= .15;

-- >= (Greater than or equal to)
SELECT first_name || ' ' || last_name "Name",
commission_pct FROM employees
WHERE commission_pct >= .35;

-- ANY or SOME
SELECT first_name || ' ' || last_name "Name",
department_id FROM employees
WHERE department_id <= ANY (10, 15, 20, 25);

-- ALL
SELECT first_name || ' ' || last_name "Name",
department_id FROM employees
WHERE department_id >= ALL (80, 90, 100);

-- *For all the comparison operators discussed, if one side of the operator is NULL, the result is NULL.

-- NOT
SELECT first_name, department_id
FROM employees
WHERE not (department_id >= 30);

-- AND
SELECT first_name, salary
FROM employees
WHERE last_name = 'Smith'
AND salary > 7500;

-- OR
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Kelly'
OR last_name = 'Smith';

-- *When a logical operator is applied to NULL, the result is UNKNOWN. UNKNOWN acts similarly to FALSE; the only difference is that NOT FALSE is TRUE, whereas NOT UNKNOWN is also UNKNOWN.

-- Other operators

-- IN and NOT IN
-- IN is equivalent to =ANY
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN (10, 20, 90);

--NOT IN is equivalent to !=ALL
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id NOT IN
(10, 30, 40, 50, 60, 80, 90, 110, 100);

-- *When using the NOT IN operator, if any value in the list or the result returned from the subquery is NULL, the NOT IN condition is evaluated to FALSE.

-- BETWEEN (is inclusive)
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 5000 AND 6000;

-- EXISTS
-- The EXISTS operator is always followed by a subquery in parentheses. EXISTS evaluates to
-- TRUE if the subquery returns at least one row. The following example lists the employees
-- who work for the administration department.
SELECT last_name, first_name, department_id
FROM employees e
WHERE EXISTS (select 1 FROM departments d
				WHERE d.department_id = e.department_id
				AND d.department_name = 'Administration');

-- IS NULL and IS NOT NULL
-- The = or != operator will not work with NULL values.

-- employees who do not have a department assigned
SELECT last_name, department_id
FROM employees
WHERE department_id IS NULL;

-- This doesn't work correctly
SELECT last_name, department_id
FROM employees
WHERE department_id = NULL;

-- LIKE
SELECT first_name, last_name
FROM employees
WHERE first_name LIKE 'Su%'
AND last_name NOT LIKE 'S%';

-- Escaping the _ character
SELECT job_id, job_title
FROM jobs
WHERE job_id like 'AC\_%' ESCAPE '\'';

-- ***Sorting rows

-- ASC is the default sorting
SELECT first_name || ' ' || last_name "Employee Name"
FROM employees
WHERE department_id = 90
ORDER BY last_name;

-- Multiple column sorting
SELECT first_name, hire_date, salary, manager_id mid
FROM employees
WHERE department_id IN (110,100)
ORDER BY mid ASC, salary DESC, hire_date;

-- *You can use column alias names in the ORDER BY clause.

-- If the DISTINCT keyword is used in the SELECT clause, you can use only those columns
-- listed in the SELECT clause in the ORDER BY clause. If you have used any operators on columns in
-- the SELECT clause, the ORDER BY clause also should use them.

-- Incorrect
SELECT DISTINCT 'Region ' || region_id
FROM countries
ORDER BY region_id;

-- Correct
SELECT DISTINCT 'Region ' || region_id
FROM countries
ORDER BY 'Region ' || region_id;

-- Sorting by column number
SELECT first_name, hire_date, salary, manager_id mid
FROM employees
WHERE department_id IN (110,100)
ORDER BY 4, 2, 3;

-- *The ORDER BY clause cannot have more than 255 columns or expressions.

-- ***Sorting NULLs
--By default, in an ascending-order sort, the NULL values appear at the bottom of the result set;
--that is, NULLs are sorted higher.

-- Nulls are sorted higher
SELECT last_name, commission_pct
FROM employees
WHERE last_name LIKE 'R%'
ORDER BY commission_pct ASC, last_name DESC;

-- Null first
SELECT last_name, commission_pct
FROM employees
WHERE last_name LIKE 'R%'
ORDER BY commission_pct ASC NULLS FIRST, last_name DESC;

-- *** The CASE expression

SELECT country_name, region_id,
		CASE region_id WHEN 1 THEN 'Europe'
									 WHEN 2 THEN 'America'
									 WHEN 3 THEN 'Asia'
									 ELSE 'Other' END Continent
FROM countries
WHERE country_name LIKE 'I%';

SELECT first_name, department_id, salary,
		CASE WHEN salary < 6000 THEN 'Low'
				 WHEN salary < 10000 THEN 'Medium'
				 WHEN salary >= 10000 THEN 'High' END Category
FROM employees
WHERE department_id <= 30
ORDER BY first_name;

-- *** Accepting values at runtime
SELECT department_name
FROM departments
WHERE department_id = &dept;

-- Execute in sql plus
DEFINE DEPT = 20
DEFINE DEPT
LIST
/

--A . (dot) is used to append characters immediately after the substitution variable.
SELECT job_id, job_title FROM jobs
WHERE job_id = '&JOB._REP';
/

--You can turn off the old/new display by using the command SET VERIFY OFF.
SELECT &COL1, &COL2
FROM &TABLE
WHERE &COL1 = '&VAL'
ORDER BY &COL2;

SAVE ex01
@ex01
-- FIRST_NAME, LAST_NAME, EMPLOYEES, FIRST_NAME, John, LAST_NAME

--To clear a defined variable, you can use the UNDEFINE command.

--Edit buffer
SELECT &&COL1, &&COL2
FROM &TABLE
WHERE &COL1 = ‘&VAL’
ORDER BY &COL2;

--** Using positional Notation for Variables
SELECT department_name, department_id
FROM departments
WHERE &1 = &2;
--department_id, 20

SAVE ex02
SET VERIFY OFF
@ex02 department_id 20
