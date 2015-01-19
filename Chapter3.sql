/***** USING GROUP FUNCTIONS******/
/* 	Group functions do not consider NULL values, 
except the COUNT(*) and GROUPING functions. */

/*	Most of the group functions can be applied either 
to ALL values or to only the DISTINCT values for the specified expression.*/

--*** COUNT({*|[DISTINCT|ALL ] expr});
/* The execution of COUNT on a column or an expression returns an integer value
that represents the number of rows in the group. */

-- counts the rows in the EMPLOYEES table
SELECT count(*) 
FROM employees;

-- counts the rows with nonnull COMMISSION_PCT values
SELECT count(commission_pct) 
FROM employees;

-- considers the nonnull rows and deterMINes the number of unique values
SELECT count(DISTINCT commission_pct) 
FROM employees;

-- return the nonnull hire_date count, and manager id_count
SELECT count(hire_date), count(manager_id) 
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