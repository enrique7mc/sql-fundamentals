/***** USING GROUP FUNCTIONS******/
/* 	Group functions do not consider NULL values, 
except the COUNT(*) and GROUPING functions. */

/*	Most of the group functions can be applied either 
to ALL values or to only the DISTINCT values for the specified expression.*/

--*** COUNT({*|[DISTINCT|ALL ] expr});
/* The execution of COUNT on a column or an expression returns an integer value
that represents the number of rows in the group. */

-- counts the rows in the EMPLOYEES table
SELECT COUNT(*) 
FROM employees;

-- counts the rows with nonnull COMMISSION_PCT values
SELECT COUNT(commission_pct) 
FROM employees;

-- considers the nonnull rows and deterMINes the number of unique values
SELECT COUNT(DISTINCT commission_pct) 
FROM employees;

-- return the nonnull hire_date count, and manager id_count
SELECT COUNT(hire_date), COUNT(manager_id) 
FROM employees;

/* There are 107 employee records in the EMPLOYEES
table. These 107 employees are allocated to 12 departments, including null
departments, and work in 19 unique jobs.*/
SELECT COUNT(*),
	   COUNT(DISTINCT NVL(department_id, 0)),
	   COUNT(DISTINCT NVL(job_id, 0))
FROM employees;	 

--*** SUM([DISTINCT|ALL ] expr);
/* The aggregated total of a column or an expression is computed with the SUM
function. */

-- adds the number 2 across 107 rows
SELECT sum(2) 
FROM employees;

-- takes the SALARY column value for every row in the group
SELECT sum(salary) 
FROM employees;

-- only adds unique values in the column
SELECT sum(distinct salary) 
FROM employees;

-- sum of nonnull commission_pct
SELECT sum(commission_pct) 
FROM employees;

SELECT SUM(SYSDATE - hire_date) / 365.25 "Total years worked by all"
FROM employees;

-- error, sum expects NUMBER
SELECT SUM(hire_date)
FROM employees;

--*** AVG([DISTINCT|ALL ] expr);
/* The average value of a column or expression divides the sum by the number of
nonnull rows in the group. */

-- Numeric literals submitted to the AVG function are returned unchanged
SELECT AVG(5) 
FROM employees;

SELECT AVG(salary) 
FROM employees;

SELECT AVG(DISTINCT salary) 
FROM employees;

SELECT AVG(commission_pct) 
FROM employees;

SELECT last_name, job_id, (SYSDATE - hire_date) / 365.25 "Years worked"
FROM employees
WHERE job_id = 'IT_PROG';

SELECT AVG((SYSDATE - hire_date) / 365.25) "Avg years worked IT members"
FROM employees
WHERE job_id = 'IT_PROG';

--*** MAX([DISTINCT|ALL] expr); MIN([DISTINCT|ALL] expr)
/* The MAX and MIN functions operate on NUMBER, DATE, CHAR, and
VARCHAR2 data types. They return a value of the same data type as their input
arguments, which are either the largest or smallest items in the group. */

SELECT MIN(commission_pct), MAX(commission_pct)
FROM employees;

SELECT MIN(start_date),MAX(end_date)
FROM job_history;

SELECT MIN(job_id),MAX(job_id) 
FROM employees;

SELECT MIN(hire_date), MIN(salary), MAX(hire_date), MAX(salary)
FROM employees
WHERE job_id = 'SA_REP';

/* Excercise
You are required to calculate the average length of all the 
country names. Any fractional components must be rounded to 
the nearest whole number.*/
SELECT ROUND(AVG(LENGTH(country_name))) AVG_COUNTRY_NAME_LENGTH
FROM countries;

--*** Nested Group Functions
-- Group functions may only be nested two levels deep.

SELECT SUM(commission_pct), NVL(department_id, 0)
FROM employees
WHERE NVL(department_id, 0) IN (40, 80, 0)
GROUP BY department_id;

SELECT AVG(SUM(commission_pct))
FROM employees
WHERE NVL(department_id, 0) IN (40, 80, 0)
GROUP BY department_id;

--*** GROUP BY Clause

-- Average of salary per department
SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id;

-- Number of employees per manager
SELECT COUNT(*), manager_id
FROM employees
GROUP BY manager_id
ORDER BY 1 DESC, 2 NULLS LAST;

-- Max salary and count of employees per department
SELECT MAX(salary), COUNT(*)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Number of countries per region
SELECT COUNT(*), region_id
FROM countries
GROUP BY region_id;

-- Employees per year of quitting
-- Group by can have grouping expressions, not only columns
SELECT TO_CHAR(END_DATE, 'YYYY') "Year",
	COUNT(*) "Employees"
FROM job_history
GROUP BY TO_CHAR(END_DATE, 'YYYY')
ORDER BY COUNT(*) DESC;

-- Common errors

-- fails to add the group by clause
SELECT end_date, COUNT(*)
FROM job_history;

-- start_date must be in the group by clause
SELECT end_date, start_date, COUNT(*)
FROM job_history
GROUP BY end_date;

/* GROUP BY Golden Rule
Any item in the SELECT list that is not a group function or a constant
must be a grouping attribute of the GROUP BY clause. */

--*** Grouping by multiple columns
SELECT department_id, SUM(commission_pct)
FROM employees
WHERE commission_pct IS NOT NULL 
GROUP BY department_id;

SELECT department_id, job_id, SUM(commission_pct)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id, job_id;

/* Excercise
Create a report containing the number of employees who left their jobs, grouped by
the year in which they left. The jobs they performed are also required. The results
must be sorted in descending order based on the number of employees in each group.
The report must list the year, the JOB_ID, and the number of employees who left a
particular job in that year. */

SELECT TO_CHAR(end_date, 'YYYY'), job_id, COUNT(*)
FROM job_history
GROUP BY TO_CHAR(end_date, 'YYYY'), job_id
ORDER BY COUNT(*) DESC;

-- Select the length of the shortest and longest LAST_NAME
-- who are sales representatives
SELECT MAX(LENGTH(last_name)), MIN(LENGTH(last_name))
FROM employees
WHERE job_id = 'SA_REP';

--*** Using the HAVING clause

SELECT department_id
FROM job_history
WHERE department_id IN (50, 60, 80, 110);

SELECT department_id, COUNT(*)
FROM job_history
WHERE department_id IN (50, 60, 80, 110)
GROUP BY department_id;

-- HAVING can appear before of after GROUP BY
SELECT department_id, COUNT(*)
FROM job_history
WHERE department_id IN (50, 60, 80, 110)
GROUP BY department_id
HAVING COUNT(*) > 1;

-- Average and count per job
SELECT job_id, AVG(salary), COUNT(*)
FROM employees
GROUP BY job_id;

-- Average and count per job if average is greater than 10000
SELECT job_id, AVG(salary), COUNT(*)
FROM employees
GROUP BY job_id
HAVING AVG(salary) > 10000;

-- Average and count per job if average > 10000
-- and count > 1
SELECT job_id, AVG(salary), COUNT(*)
FROM employees
GROUP BY job_id
HAVING AVG(salary) > 10000
AND COUNT(*) > 1;

-- HAVING may only be specified when a GROUP BY clause is present

/* Excercise
Identify the days of the week on which 15 or more staff members 
were hired. Your report must list the days and the number of 
employees hired on each of them.*/

SELECT TO_CHAR(hire_date, 'DAY'), COUNT(*)
from employees
GROUP BY TO_CHAR(hire_date, 'DAY')
HAVING COUNT(*) > 15
ORDER BY COUNT(*);