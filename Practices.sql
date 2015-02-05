/* Práctica: Restricting and Sorting Data */

SELECT last_name, salary
FROM employees
WHERE salary > 12000;

SELECT last_name, department_id
FROM employees
WHERE employee_id = 176;

SELECT last_name, salary
FROM employees
WHERE salary NOT BETWEEN 5000 AND 12000;

SELECT last_name, job_id, hire_date
FROM employees
WHERE last_name IN ('Matos', 'Taylor')
ORDER BY hire_date;

SELECT last_name, department_id
FROM employees
WHERE department_id IN (20, 50)
ORDER BY last_name ASC;

SELECT last_name "Employee", salary "Monthly Salary"
FROM employees
WHERE salary BETWEEN 5000 AND 12000
  AND department_id IN (20, 50);
  
SELECT last_name, hire_date
FROM employees
WHERE hire_date LIKE '%94';

SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;


SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY 2 DESC, 3 DESC;

SELECT last_name, salary
FROM employees
WHERE salary > &sal;

SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE manager_id = &man
ORDER BY &order_col;

SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';

SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' OR last_name LIKE '%e%';

SELECT last_name, job_id, salary
FROM employees
WHERE job_id IN ('SA_REP', 'ST_CLERK')
  AND salary NOT IN (2500, 3500, 7000);
  
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct = .2;

/* Práctica: Using Single-Row functions to customize output*/

SELECT SYSDATE "Date"
FROM dual;

SELECT employee_id, last_name, salary,
        ROUND(salary * 1.155, 0) "New Salary"
FROM employees;       

SELECT employee_id, last_name, salary,
      ROUND(salary * 1.155, 0) "New Salary",
      ROUND(salary * 1.155, 0) - salary "Increment"
FROM employees;      

SELECT INITCAP(last_name) "Name",
       LENGTH(last_name) "Length"
FROM employees
WHERE last_name LIKE 'J%'
  OR last_name LIKE 'A%'
  OR last_name LIKE 'M%'
ORDER BY last_name;  

SELECT INITCAP(last_name) "Name",
       LENGTH(last_name) "Length"
FROM employees
WHERE last_name LIKE '&letra%'
ORDER BY last_name;

SELECT INITCAP(last_name) "Name",
       LENGTH(last_name) "Length"
FROM employees
WHERE last_name LIKE UPPER('&letra%')
ORDER BY last_name;

SELECT last_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) "Months Worked"
FROM employees
ORDER BY 2;

SELECT last_name, LPAD(salary, 15, '$') SALARY
FROM employees;


SELECT RPAD(last_name, 8) || ' ' ||
      RPAD(' ', salary / 1000 + 1, '*')
        EMPLOYEES_AND_THEIR_SALARIES
FROM employees
ORDER BY salary DESC;


SELECT last_name, TRUNC((SYSDATE - hire_date) / 7)
FROM employees
WHERE department_id = 90
ORDER BY 2;

/* Práctica: Funciones de Conversión y Condicionales*/

SELECT last_name || ' earns '
      || TO_CHAR(salary, 'fm$99,999.00')
      || ' monthly but wants '
      || TO_CHAR(salary * 3, 'fm$99,999.00')
      || '.' "Dream Salaries"
FROM employees;      

SELECT last_name, hire_date,
      TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 'LUNES'),
        'fmDay, "the" Ddspth "of" Month, YYYY') REVIEW
FROM employees;  

SELECT last_name, hire_date,
      TO_CHAR(hire_date, 'DAY') DAY
FROM employees
ORDER BY TO_CHAR(hire_date - 1, 'd');

SELECT last_name, NVL(TO_CHAR(commission_pct), 'No commission') COMM
FROM employees;

SELECT job_id, DECODE(job_id, 
                        'ST_CLERK', 'E',
                        'SA_REP', 'D',
                        'IT_PROG', 'C',
                        'ST_MAN', 'B',
                        'AD_PRES', 'A',
                        '0') GRADE
FROM employees;             

SELECT job_id, CASE job_id
              WHEN 'ST_CLERK' THEN 'E'
              WHEN 'SA_REP' THEN 'D'
              WHEN 'IT_PROG' THEN 'C'
              WHEN 'ST_MAN' THEN 'B'
              WHEN 'AD_PRES' THEN 'A'
              ELSE '0' END GRADE
From employees;              

/* Práctica: Reporting Aggregated Data Using group functions */

SELECT ROUND(MAX(salary), 0) "Maximum",
       ROUND(MIN(salary), 0) "Minimum",
       ROUND(SUM(salary), 0) "Sum",
       ROUND(AVG(salary), 0) "Average"
FROM employees;       

SELECT job_id, ROUND(MAX(salary), 0) "Maximum",
       ROUND(MIN(salary), 0) "Minimum",
       ROUND(SUM(salary), 0) "Sum",
       ROUND(AVG(salary), 0) "Average"
FROM employees
GROUP BY job_id;       

SELECT job_id, COUNT(*)
FROM employees
GROUP BY job_id
ORDER BY COUNT(*) DESC;

SELECT job_id, COUNT(*)
FROM employees
WHERE job_id = '&job_title'
GROUP BY job_id;

SELECT COUNT(DISTINCT manager_id) "Number of managers"
FROM employees;

SELECT MAX(salary) - MIN(salary) DIFFERENCE
FROM employees;


SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) > 6000
ORDER BY MIN(salary) DESC;

SELECT COUNT(*) total,
        SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2001, 1, 0)) "2001",
        SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2002, 1, 0)) "2002",
        SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2003, 1, 0)) "2003",
        SUM(DECODE(TO_CHAR(hire_date, 'YYYY'), 2004, 1, 0)) "2004"
FROM employees;    

SELECT job_id "Job",
       SUM(DECODE(department_id, 20, salary)) "Dep 20",
       SUM(DECODE(department_id, 50, salary)) "Dep 50",
       SUM(DECODE(department_id, 80, salary)) "Dep 80",
       SUM(DECODE(department_id, 90, salary)) "Dep 90",
       SUM(salary) "Total"
FROM employees
GROUP BY job_id;

/* Práctica: Displaying Data from Multiple Tables Using Joins */

SELECT location_id, street_address, city, state_province,
      country_name
FROM locations
NATURAL JOIN countries;

SELECT last_name, department_id, department_name
FROM employees
--JOIN departments USING(department_id);
NATURAL JOIN departments;

SELECT e.last_name, e.job_id, e.department_id,
      d.department_name
FROM employees e JOIN departments d      
ON (e.department_id = d.department_id)
JOIN locations l
ON (d.location_id = l.location_id)
WHERE LOWER(city) = 'toronto';


SELECT w.last_name "Employee", w.employee_id "EMP#",
      m.last_name "Manager", m.employee_id "MGR#"
FROM employees w JOIN employees m
ON (w.manager_id = m.employee_id);

SELECT w.last_name "Employee", w.employee_id "EMP#",
      m.last_name "Manager", m.employee_id "MGR#"
FROM employees w
LEFT JOIN employees m
ON (w.manager_id = m.employee_id)
ORDER BY 2;

SELECT e.department_id department, e.last_name employee,
    c.last_name colleague
FROM employees e JOIN employees c
ON (e.department_id = c.department_id)
WHERE e.employee_id <> c.employee_id
ORDER BY e.department_id, e.last_name, c.last_name;

SELECT e.last_name, e.hire_date
FROM employees e JOIN employees davies
ON (davies.last_name = 'Davies')
WHERE davies.hire_date < e.hire_date;

SELECT w.last_name, w.hire_date, m.last_name, m.hire_Date
FROM employees w JOIN employees m
ON (w.manager_id = m.employee_id)
WHERE w.hire_date < m.hire_date;

/* Práctica: Using subqueries to solve queries */

UNDEFINE name;

SELECT last_name, hire_date
FROM employees
WHERE department_id = (SELECT department_id
                        FROM employees
                        WHERE last_name = '&&name')
      AND last_name <> '&&name';   
      
      
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary)
                  FROM  employees)
ORDER BY salary;  


SELECT employee_id, last_name
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE last_name LIKE '%u%');
                        
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE location_id = 1700);
                        
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE location_id = &loc);       
                        
SELECT last_name, salary
FROM employees
WHERE manager_id = (SELECT employee_id
                    FROM employees
                    WHERE employee_id = 100);
                    
SELECT department_id, last_name, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE department_name = 'Executive');
                        
SELECT last_name 
FROM employees
WHERE salary > ANY (SELECT salary
                    FROM employees
                    WHERE department_id = 60);
                    
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE last_name LIKE '%u%')
AND salary > (SELECT AVG(salary)
              FROM employees);                        


/* Práctica: Using the Set Operators */

SELECT department_id
FROM departments
MINUS
SELECT department_id
FROM employees
WHERE job_id = 'ST_CLERK';

SELECT country_id, country_name
FROM countries
MINUS
SELECT l.country_id, c.country_name
FROM locations l JOIN countries c
ON (l.country_id = c.country_id)
JOIN departments d
ON d.location_id = l.location_id;

SELECT DISTINCT job_id, department_id
FROM employees
WHERE department_id = 10
UNION ALL
SELECT DISTINCT job_id, department_id
FROM employees
WHERE department_id = 50
UNION ALL
SELECT DISTINCT job_id, department_id
FROM employees
WHERE department_id = 20;


SELECT employee_id, job_id
FROM employees
INTERSECT
SELECT employee_id, job_id
FROM job_history;

/* Práctica: Managing Schema Objects */

CREATE TABLE dept2(
  id NUMBER(7),
  name VARCHAR2(25)
);

DESCRIBE dept2;

INSERT INTO dept2
SELECT department_id, department_name
FROM departments;

SELECT * FROM dept2;

CREATE TABLE emp2(
  id NUMBER(7),
  last_name VARCHAR2(25),
  first_name VARCHAR2(25),
  dept_id NUMBER(7)
);

DESC emp2;

ALTER TABLE emp2
MODIFY(last_name  VARCHAR2(50));

DESC emp2;

CREATE TABLE employees2 AS
SELECT employee_id id, first_name, last_name, salary,
      department_id dept_id
FROM employees;    

DROP TABLE emp2;

SELECT original_name, operation, droptime
FROM recyclebin;

FLASHBACK TABLE emp2 TO BEFORE DROP;

DESC emp2;

ALTER TABLE employees2
DROP COLUMN first_name;

DESC employees2;

ALTER TABLE employees2
SET UNUSED(dept_id);

DESC employees2;

ALTER TABLE employees2
DROP UNUSED COLUMNS;

DESC employees2;

ALTER TABLE emp2
ADD CONSTRAINT emp2_pk PRIMARY KEY(id);

ALTER TABLE dept2
ADD CONSTRAINT dep2_pk PRIMARY KEY(id);

ALTER TABLE emp2
ADD CONSTRAINT dept_emp_fk 
FOREIGN KEY(dept_id) REFERENCES
dept2(id);

ALTER TABLE emp2
ADD commission NUMBER(2,2)
CONSTRAINT emp_comm_chk CHECK(commission > 0);

DROP TABLE emp2 PURGE;
DROP TABLE dept2 PURGE;

SELECT original_name, operation, droptime
FROM recyclebin;

CREATE TABLE dept_named_index(
deptno NUMBER(4)
PRIMARY KEY USING INDEX(
CREATE INDEX dept_pk_idx ON
dept_named_index(deptno)),
dname VARCHAR2(30)

);

/* Práctica: Managing Objects with Data Dictionary Views*/

SELECT table_name
FROM user_tables;

SELECT table_name owner
FROM all_tables
WHERE UPPER(owner) <> 'HR';

SELECT column_name, data_type, data_length,
    data_precision PRECISION, data_scale SCALE, nullable
FROM user_tab_columns
WHERE table_name = UPPER('&tab_name');


SELECT ucc.column_name, uc.constraint_name,
  uc.constraint_type, uc.search_condition, uc.status
FROM user_constraints uc JOIN user_cons_columns ucc 
ON (uc.table_name = ucc.table_name
    AND uc.constraint_name = ucc.constraint_name
    AND uc.table_name = UPPER('&tab_name'));
    
COMMENT ON TABLE departments IS
  'Este es un comentario sobre departments';
  
SELECT comments
FROM user_tab_comments
WHERE table_name = 'DEPARTMENTS';

CREATE SYNONYM emp FOR employees;
SELECT * FROM user_synonyms;

SELECT view_name, text
FROM user_views;

SELECT sequence_name, max_value, increment_by, last_number
FROM user_sequences;

SELECT table_name
FROM user_tables
WHERE table_name IN ('DEPT2', 'EMP2');

CREATE TABLE sales_dept(
  team_id NUMBER(3)
  PRIMARY KEY USING INDEX(
    CREATE INDEX sales_pk_idx ON
    SALES_DEPT(team_id)
  ),
  location VARCHAR2(30)
);

SELECT index_name, table_name, uniqueness
FROM user_indexes
WHERE table_name = 'SALES_DEPT';


/* Práctica: Creating Other Schema Objects */

CREATE OR REPLACE VIEW employees_vu AS
  SELECT employee_id, last_name employee, department_id
  FROM employees;
  
SELECT * FROM employees_vu; 

SELECT employee, department_id
FROM employees_vu;

CREATE VIEW dept50 AS
  SELECT employee_id empno, last_name employee,
        department_id deptno
  FROM employees
  WHERE department_id = 50
  WITH CHECK OPTION CONSTRAINT emp_dept_50;
  
DESC dept50;

SELECT * FROM dept50;

UPDATE dept50
SET deptno = 80
WHERE employee = 'Weiss';


CREATE SEQUENCE dept_id_seq
START WITH 200
INCREMENT BY 10
MAXVALUE 1000;

CREATE TABLE prueba2(col1 NUMBER);

INSERT INTO prueba2 VALUES (dept_id_seq.nextval);

SELECT * FROM prueba;

CREATE INDEX prueba_idx ON prueba(col1);

CREATE SYNONYM pr2 FOR prueba2;

ROLLBACK;

/* Práctica: Oracle Join Syntax */

SELECT location_id, street_address, city, state_province,
      country_name
FROM locations, countries  
WHERE locations.country_id = countries.country_id;

SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

SELECT e.last_name, e.job_id, e.department_id,
    d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id AND
  d.location_id = l.location_id AND
  LOWER(l.city) = 'toronto';
  
SELECT w.last_name "Employee", w.employee_id "EMP#",
    m.last_name "Manager", m.employee_id "MGR#"
FROM employees w, employees m
WHERE w.manager_id = m.employee_id;

SELECT w.last_name "Employee", w.employee_id "EMP#",
    m.last_name "Manager", m.employee_id "MGR#"
FROM employees w, employees m
WHERE w.manager_id = m.employee_id(+);

SELECT e1.department_id department, e1.last_name employee,
    e2.last_name colleague
FROM employees e1, employees e2
WHERE e1.department_id = e2.department_id
  AND e1.employee_id <> e2.employee_id
ORDER BY e1.department_id, e1.last_name, e2.last_name; 


SELECT e.last_name, e.hire_date
FROM employees e, employees davies
WHERE davies.last_name = 'Davies'
  AND davies.hire_date < e.hire_date;
  
  
SELECT w.last_name, w.hire_Date, m.last_name, m.hire_date
FROM employees w, employees m
WHERE w.manager_id = m.employee_id
  AND w.hire_date < m.hire_date;

  /* Práctica: Managing Data in Different Time Zones */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

SELECT SYSDATE FROM dual;

SELECT TZ_OFFSET('US/Pacific-New') FROM dual;
SELECT TZ_OFFSET('Singapore') FROM dual;
SELECT TZ_OFFSET('Egypt') FROM dual;

ALTER SESSION SET TIME_ZONE = '-7:00';

SELECT CURRENT_DATE, CURRENT_TIMESTAMP,
  LOCALTIMESTAMP
  FROM dual;
  
ALTER SESSION SET TIME_ZONE = '+8:00';  

SELECT CURRENT_DATE, CURRENT_TIMESTAMP,
  LOCALTIMESTAMP
  FROM dual;
  
SELECT DBTIMEZONE, SESSIONTIMEZONE FROM dual;

SELECT last_name, EXTRACT(YEAR FROM hire_date)
FROM employees
WHERE department_id = 80;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

SELECT SYSDATE FROM dual;

SELECT e.last_name,
(CASE EXTRACT(YEAR FROM e.hire_date) WHEN 2004 THEN 'Needs Review'
ELSE 'Not this year' END) AS "Review"
FROM employees e
ORDER BY e.hire_date;


SELECT e.last_name, hire_date, SYSDATE,
        (CASE
          WHEN (SYSDATE - TO_YMINTERVAL('15-0')) >= hire_date
            THEN '15 year of service'
          WHEN (SYSDATE - TO_YMINTERVAL('10-0')) >= hire_date
            THEN '10 years of service'
          WHEN  (SYSDATE - TO_YMINTERVAL('5-0')) >= hire_date  
            THEN '5 years of service'
          ELSE 'Maybe next year' END) AS "Awards"
FROM employees e;          