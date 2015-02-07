/*** Using Joins and Subqueries ***/

-- Canada's region
-- Natural join
SELECT region_name
FROM regions NATURAL JOIN countries
WHERE country_name = 'Canada';

-- Countries belonging to Americas
SELECT country_name
FROM countries NATURAL JOIN regions
WHERE region_name = 'Americas';

-- Using join syntax
SELECT region_name
FROM regions JOIN countries
USING (region_id)
WHERE country_name = 'Canada';

-- Join on syntax
SELECT country_name
FROM countries JOIN regions
ON (countries.region_id = regions.region_id)
WHERE region_name = 'Americas';

--*** Cross join
SELECT COUNT(*)
FROM countries;

SELECT COUNT(*)
FROM regions;

SELECT COUNT(*)
FROM regions
CROSS JOIN countries;

SELECT *
FROM regions
CROSS JOIN countries
WHERE country_id = 'CA';

--*** Oracle syntax

-- Countries with their region (natural join)
SELECT region_name, country_name
FROM regions, countries
WHERE regions.region_id = countries.region_id;

-- Employees and departments without employees
-- Oracle syntax for nonequijoins
SELECT last_name, department_name
FROM employees, departments
WHERE  employees.department_id(+) = departments.department_id;

-- Cartesian product
SELECT * 
FROM regions, countries;

--*** Resolving ambiguous column names

-- The column in USING and NATURAL JOIN can't be qualified
SELECT emp.employee_id, department_id, emp.manager_id,
	departments.manager_id
FROM employees emp JOIN departments
USING(department_id)
WHERE department_id > 80;

--*** NATURAL JOIN
/* SELECT table1.column, table2.column
FROM table1
NATURAL JOIN table2; */
SELECT *
FROM locations NATURAL JOIN countries;

-- Equivalent join
SELECT * 
FROM locations l, countries c
WHERE l.country_id = c.country_id;

-- No matching columns, cartesian join performed
SELECT *
FROM jobs NATURAL JOIN countries;

-- Equivalent join
SELECT *
FROM jobs, countries;

/* Warining: if the matching columns are not related or
have different data types an error will be raised */

/* Excercise 
The JOB_HISTORY table shares three identically named columns with the
EMPLOYEES table: EMPLOYEE_ID, JOB_ID, and DEPARTMENT_ID. You
are required to describe the tables and fetch the EMPLOYEE_ID, JOB_ID,
DEPARTMENT_ID, LAST_NAME, HIRE_DATE, and END_DATE values for all
rows retrieved using a pure natural join. Alias the EMPLOYEES table as EMP and
the JOB_HISTORY table as JH and use dot notation where possible.*/

SELECT employee_id, job_id, department_id,
e.last_name, e.hire_date, jh.end_date
FROM job_history jh NATURAL JOIN employees e;

--*** Natural JOIN USING Clause
/* SELECT table1.column, table2.column
FROM table1
JOIN table2 USING (join_column1, join_column2…); */

-- It is illegal to put NATURAL and USING in the same query

SELECT *
FROM locations JOIN countries
USING(country_id);

SELECT emp.last_name, emp.department_id, 
	jh.end_date, job_id, employee_id
FROM job_history jh JOIN employees emp
USING (job_id, employee_id);

--***Natural JOIN ON Clause
/* SELECT table1.column, table2.column
FROM table1
JOIN table2 ON (table1.column_name = table2.column_name);*/

-- The ON and NATURAL keywords cannot appear together in a join clause.
SELECT * 
FROM departments d JOIN employees e 
ON (e.employee_id = d.department_id);

-- Equivalent join
SELECT *
FROM employees e, departments d
WHERE e.employee_id = d.department_id;

-- employees who worked for the organization and changed jobs.
SELECT e.employee_id, e.last_name, j.start_date,
	e.hire_date, j.end_date, j.job_id previous,
	e.job_id current
FROM job_history j JOIN employees e
ON j.start_date = e.hire_date;

/* Excercise 
Each record in the DEPARTMENTS table has a MANAGER_ID column matching
an EMPLOYEE_ID value in the EMPLOYEES table. You are required to produce a
report with one column aliased as Managers. Each row must contain a sentence of the
format FIRST_NAME LAST_NAME is manager of the DEPARTMENT_NAME
department. */

SELECT first_name || ' ' || last_name || ' is manager of the ' ||
	department_name || ' department'
FROM employees e JOIN departments d
ON (e.employee_id = d.manager_id);

--*** Multiple table JOINS

-- List departments, their location, including country and region
SELECT r.region_name, c.country_name, l.city, d.department_name
FROM departments d 
NATURAL JOIN locations l
NATURAL JOIN countries c 
NATURAL JOIN regions r;

-- Equivalent join
SELECT r.region_name, c.country_name, l.city, d.department_name
FROM departments d 
JOIN locations l on (d.location_id = l.location_id)
JOIN countries c on (l.country_id = c.country_id)
JOIN regions r on (c.region_id = r.region_id);

-- Yet another equivalent join
SELECT r.region_name, c.country_name, l.city, d.department_name
FROM departments d
JOIN locations l USING(location_id)
JOIN countries c USING(country_id)
JOIN regions r USING(region_id);

-- Restrict rows with where or join on
SELECT d.department_name, l.city 
FROM departments d
JOIN locations l ON (l.location_id = d.location_id)
WHERE d.department_name LIKE 'P%';

-- Equivalent join
SELECT d.department_name, l.city 
FROM departments d
JOIN locations l ON l.location_id = d.location_id
					AND d.department_name LIKE 'P%';

/* list describing the top earning employees and 
geographical information about their departments.*/
SELECT r.region_name, c.country_name, l.city, d.department_name,
	e.last_name, e.salary
FROM employees e
JOIN departments d ON (e.department_id = d.department_id AND salary > 12000)
JOIN locations l ON (d.location_id = l.location_id)
JOIN countries c ON (l.country_id = c.country_id)
JOIN regions r ON (c.region_id = r.region_id);

/* Remember the USING, ON, and NATURAL keywords are
mutually exclusive in the context of the same join clause.*/

--*** Nonequijoins
/* A nonequijoin is specified using the JOIN…ON syntax, but the join condition
contains an inequality operator instead of an equal sign. */

/* SELECT table1.column, table2.column
FROM table1
[JOIN table2 ON (table1.column_name < table2.column_name)]|
[JOIN table2 ON (table1.column_name > table2.column_name)]|
[JOIN table2 ON (table1.column_name <= table2.column_name)]|
[JOIN table2 ON (table1.column_name >= table2.column_name)]|
[JOIN table2 ON (table1.column BETWEEN table2.col1 AND table2.col2)]|*/

SELECT e.job_id current_job, last_name || ' can earn twice their salary by changing jobs to: ' ||
	j.job_id options, e.salary current_salary, j.max_salary potential_max_salary
FROM employees e
JOIN jobs j ON (2 * e.salary < j.max_salary)
WHERE e.salary > 5000
ORDER BY last_name;

--*** Self join
SELECT e.last_name employee, e.employee_id, e.manager_id, m.last_name manager,
	e.department_id
FROM employees e
JOIN employees m ON (e.manager_id = m.employee_id)
WHERE e.department_id IN (10, 20, 30)
ORDER BY e.department_id;

--*** Left outer join
/* A left outer join between the source and target tables returns the results of an
inner join as well as rows from the source table excluded by that inner join. */

/* SELECT table1.column, table2.column
FROM table1
LEFT OUTER JOIN table2
ON (table1.column = table2.column); */

SELECT e.employee_id, e.department_id EMP_DEPT_ID,
	d.department_id DEPT_DEPT_ID, d.department_name
FROM departments d 
LEFT OUTER JOIN employees e ON (d.DEPARTMENT_ID=e.DEPARTMENT_ID)
WHERE d.department_name LIKE 'P%';

SELECT e.employee_id, e.department_id EMP_DEPT_ID,
	d.department_id DEPT_DEPT_ID, d.department_name
FROM departments d 
JOIN employees e ON (d.DEPARTMENT_ID=e.DEPARTMENT_ID)
WHERE d.department_name LIKE 'P%';

--*** Right outer join
/* A right outer join between the source and target tables returns the results of an inner join
as well as rows from the target table excluded by that inner join.*/

/* SELECT table1.column, table2.column
FROM table1
RIGHT OUTER JOIN table2
ON (table1.column = table2.column);*/

SELECT e.last_name, d.department_name 
FROM departments d
RIGHT OUTER JOIN employees e
ON (e.department_id=d.department_id)
WHERE e.last_name LIKE 'G%';

SELECT DISTINCT jh.job_id "Jobs in job history", e.job_id "jobs in employees"
FROM job_history jh
RIGHT OUTER JOIN employees e ON (jh.job_id = e.job_id)
ORDER BY jh.job_id;

--*** Full outer join
/* SELECT table1.column, table2.column
FROM table1
FULL OUTER JOIN table2
ON (table1.column = table2.column); */

SELECT e.last_name, d.department_name
FROM departments d 
FULL OUTER JOIN employees e
ON (e.department_id = d.department_id)
WHERE e.department_id IS NULL;

--*** Cartesian product
/* A Cartesian product freely associates the rows from table1 with every row
in table2. If table1 and table2 contain x and y number of rows, respectively,
the Cartesian product will contain x times y number of rows. */

/* SELECT table1.column, table2.column
FROM table1
CROSS JOIN table2;*/

SELECT * 
FROM jobs 
CROSS JOIN job_history;

SELECT * 
FROM jobs j 
CROSS JOIN job_history jh
WHERE j.job_id='AD_PRES';

SELECT r.region_name, c.country_name 
FROM regions r CROSS JOIN countries c
WHERE r.region_id IN (3, 4) 
ORDER BY region_name, country_name;

SELECT COUNT(*) 
FROM employees;

SELECT COUNT(*)
FROM departments;

SELECT COUNT(*)
FROM employees CROSS JOIN departments;



--------------------------------------
------Set Operators-------------------
--------------------------------------

-- Consider these two queries.

SELECT last_name, hire_date
FROM employees
WHERE department_id = 90;

SELECT last_name, hire_date
FROM employees
WHERE last_name LIKE 'K%';

/* The UNION operator is used to return rows from either query, 
	without any duplicate rows.*/

SELECT last_name, hire_date
FROM employees
WHERE department_id = 90
UNION
SELECT last_name, hire_date
FROM employees
WHERE last_name LIKE 'K%';

/* The UNION ALL operator does not sort or filter the result set; 
	it returns all rows from both queries. */

SELECT last_name, hire_date
FROM employees
WHERE department_id = 90
UNION ALL
SELECT last_name, hire_date
FROM employees
WHERE last_name LIKE 'K%';

/* The INTERSECT operator is used to return the rows returned 
	by both queries.*/

SELECT last_name, hire_date
FROM employees
WHERE department_id = 90
INTERSECT
SELECT last_name, hire_date
FROM employees
WHERE last_name LIKE 'K%';

/* The MINUS operatori returns rows from the first query but not 
in the second query.*/

-- There can be only one ORDER BY clause in the query at the very end

SELECT last_name, hire_date
FROM employees
WHERE department_id = 90
ORDER BY last_name -- error
UNION ALL
SELECT first_name, hire_date
FROM employees
WHERE first_name LIKE 'K%'
ORDER BY first_name;

/* You can use the column name or alias name used in the first query 
	or positional notation in the ORDER BY clause.*/

SELECT last_name, hire_date "Join Date"
FROM employees
WHERE department_id = 90
UNION ALL
SELECT first_name, hire_date
FROM employees
WHERE first_name LIKE 'K%'
ORDER BY last_name, "Join Date";

SELECT last_name, hire_date "Join Date"
FROM employees
WHERE department_id = 90
UNION ALL
SELECT first_name, hire_date
FROM employees
WHERE first_name LIKE 'K%'
ORDER BY 1, 2;

/* When using set operators, the number of columns in the SELECT clause
of the queries appearing on either side of the set operator should be the
same. The column datatypes should be compatible. If the datatypes are
different, Oracle tries to do an implicit conversion of data.*/

--------------------------
--------Subqueries--------
--------------------------

----*** Single-row subqueries

-- find the name of the employee with the highest salary

SELECT last_name, first_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- find the names and salaries of employees who work in the accounting department
SELECT last_name, first_name, salary
FROM employees
WHERE department_id = (SELECT department_id
						FROM departments
						WHERE department_name = 'Accounting');

SELECT last_name, first_name, department_id
FROM employees
WHERE department_id < (SELECT MAX(department_id)
						FROM departments
						WHERE location_id = 1500)
AND hire_date >= (SELECT MIN(hire_date)
					FROM employees
					WHERE department_id = 30);

/* lists the latest hire dates by departments that have hired an employee after the first
employee was hired in department 80 */

SELECT department_id, MAX(hire_date)
FROM employees
GROUP BY department_id
HAVING MAX(hire_date) > (SELECT MIN(hire_date)
							FROM employees
							WHERE department_id = 80);

-- Thes queries will fail if the result have more than 1 row

----*** Multi Row subqueries

SELECT last_name, first_name, department_id
FROM employees
WHERE department_id = (SELECT department_id -- error
						FROM employees
						WHERE first_name = 'John');

SELECT last_name, first_name, department_id
FROM employees
WHERE department_id IN (SELECT department_id -- correct
						FROM employees
						WHERE first_name = 'John');

SELECT last_name, salary, department_id
FROM employees
WHERE salary >= ANY (SELECT salary FROM employees
						WHERE department_id = 110)
						AND department_id != 80;

SELECT last_name, salary, department_id
FROM employees
WHERE salary > ALL (SELECT salary FROM employees
					WHERE department_id = 110)
					AND department_id != 80;

--**** Subquery returns no rows

SELECT last_name, first_name, salary
FROM employees
WHERE department_id = (SELECT department_id
						FROM departments
						WHERE department_name = 'No existe');

SELECT first_name, last_name, salary
FROM employees
WHERE salary NOT IN (
			SELECT salary
			FROM employees
			WHERE department_id = 30);

/* The SQL does not return any rows because one of the rows returned 
	by the inner query is NULL.*/

SELECT first_name, last_name, salary
FROM employees
WHERE salary NOT IN (
			SELECT salary
			FROM employees
			WHERE department_id = 30 -- solution
			AND salary is NOT NULL);

--**** Correlated subqueries

/* Oracle performs a correlated subquery when the subquery references a column from a
table referred to in the parent statement. A correlated subquery is evaluated once for each
row processed by the parent statement.*/

 -- List the highest-paid employee of each department is selected.

SELECT department_id, last_name, salary
FROM employees e1
WHERE salary = (SELECT MAX(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id)
ORDER BY 1, 2, 3;

SELECT last_name, first_name, department_id
FROM employees e1
WHERE EXISTS (SELECT *
				FROM employees e2
				WHERE first_name = 'John'
				AND e1.department_id = e2.department_id);

/* The column names in the parent queries are available for reference in
subqueries. The column names from the tables in the subquery cannot be
used in the parent queries. The scope is only the current query level and its
subqueries.*/

---**** Scalar subqueries
/* A scalar subquery returns exactly one column value from one row. You can use scalar
subqueries in most places where you would use a column name or expression*/

-- Case expression
SELECT city, country_id, (CASE
	WHEN country_id IN (SELECT country_id
						FROM countries
						WHERE country_name = 'India')
	THEN 'Indian'
	ELSE 'Non-Indian'
	END) "INDIA?"
FROM locations
WHERE city LIKE 'B%';

-- Select statement
-- Report the employee name, the department, and the highest salary in that department
SELECT last_name, department_id,
	(SELECT MAX(salary)
	FROM employees sq
	WHERE sq.department_id = e.department_id) HSAL
FROM employees e;


/* find the department names and their manager
names for all departments that are in the United States or Canada */
SELECT department_name, manager_id, (SELECT last_name
	FROM employees e
	WHERE e.employee_id = d.manager_id) MGR_NAME
FROM departments d
WHERE ((SELECT country_id FROM locations l
	WHERE d.location_id = l.location_id)
	IN (SELECT country_id FROM countries c
	WHERE c.country_name = 'United States of America'
	OR c.country_name = 'Canada'))
AND d.manager_id IS NOT NULL;
WHERE last_name like 'R%';

-- Order by clause
SELECT country_id, city, state_province
FROM locations l
ORDER BY (SELECT country_name
			FROM countries c
			WHERE l.country_id = c.country_id);

----**** Multiple column subqueries

SELECT * FROM state;
SELECT * FROM city;

-- List the cities in Texas
SELECT cty_name
FROM city
WHERE (cnt_code, st_code) IN
	(SELECT cnt_code, st_code
	FROM state
	WHERE st_name = 'TEXAS');


----**** Subqueries in Other DML Statements

/* You can use subqueries in DML statements such as INSERT, UPDATE, DELETE, and MERGE. */

-- update the salary of all employees to the maximum salary
UPDATE employees e1
SET salary = (SELECT MAX(salary)
FROM employees e2
WHERE e1.department_id = e2.department_id);

/* delete the records of employees whose salary is less than the average salary in the
department */
DELETE FROM employees e
WHERE salary < (SELECT AVG(salary) FROM employees
WHERE department_id = e.department_id);

-- insert records to a table u NN sing a subquery
INSERT INTO employee_archive
SELECT * FROM employees;

-- specify a subquery in the VALUES clause of the INSERT statement
INSERT INTO departments
(department_id, department_name)
VALUES ((SELECT MAX(department_id)
+10 FROM departments), ‘EDP’);



---*** Finding Total Space and Free Space Using Dictionary Views

-- query to get the tablespace names and type of tablespace
SELECT tablespace_name, contents
FROM dba_tablespaces;

-- find the total space allocated to each tablespace
SELECT tablespace_name, SUM(bytes)/1048576 MBytes
FROM dba_data_files
GROUP BY tablespace_name;

SELECT tablespace_name, SUM(bytes)/1048576 MBytes
FROM dba_temp_files
GROUP BY tablespace_name;

-- find the total free space in each tablespace
SELECT tablespace_name, SUM(bytes)/1048576 MBytesFree
FROM dba_free_space
GROUP BY tablespace_name;


--display the total size of the tablespaces and their free space

SELECT tablespace_name, SUM(bytes)/1048576 MBytes, 0 MBytesFree
FROM dba_data_files
GROUP BY tablespace_name
UNION ALL
SELECT tablespace_name, SUM(bytes)/1048576 MBytes, 0
FROM dba_temp_files
GROUP BY tablespace_name
UNION ALL
SELECT tablespace_name, 0, SUM(bytes)/1048576
FROM dba_free_space
GROUP BY tablespace_name;

-- better output
SELECT tablespace_name, MBytes, MBytesFree
FROM
(SELECT tablespace_name, SUM(bytes)/1048576 MBytes
FROM dba_data_files
GROUP BY tablespace_name
UNION ALL
SELECT tablespace_name, SUM(bytes)/1048576 MBytes
FROM dba_temp_files
GROUP BY tablespace_name) totalspace
JOIN
(SELECT tablespace_name, 0, SUM(bytes)/1048576 MBytesFree
FROM dba_free_space
GROUP BY tablespace_name) freespace
USING (tablespace_name);

-- includes temp tablespace

SELECT tablespace_name, MBytes, MBytesFree
FROM
	(SELECT tablespace_name, SUM(bytes)/1048576 MBytes
	FROM dba_data_files
	GROUP BY tablespace_name
	UNION ALL
	SELECT tablespace_name, SUM(bytes)/1048576 MBytes
	FROM dba_temp_files
	GROUP BY tablespace_name) totalspace
LEFT OUTER JOIN
	(SELECT tablespace_name, 0, SUM(bytes)/1048576 MBytesFree
	FROM dba_free_space
	GROUP BY tablespace_name) freespace
	USING (tablespace_name)
ORDER BY 1;

-- another method

SELECT tsname, sum(MBytes) MBytes, sum(MBytesFree) MBytesFree
FROM (
	SELECT tablespace_name tsname, SUM(bytes)/1048576 MBytes, 0 MBytesFree
	FROM dba_data_files
	GROUP BY tablespace_name
	UNION ALL
	SELECT tablespace_name, SUM(bytes)/1048576 MBytes, 0
	FROM dba_temp_files
	GROUP BY tablespace_name
	UNION ALL
	SELECT tablespace_name, 0, SUM(bytes)/1048576
	FROM dba_free_space
	GROUP BY tablespace_name)
GROUP BY tsname
ORDER BY 1;