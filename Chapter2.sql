/* Using Single-Row Functions */

--***Functions for NULL Handling

-- NVL(x1, x2)
/* The NVL function returns x2 if x1 is
NULL. If x1 is not NULL, then x1 is returned. */
SELECT first_name, salary, commission_pct,
salary + (salary * commission_pct) compensation
FROM employees
WHERE first_name LIKE 'T%';

SELECT first_name, salary, commission_pct,
salary + (salary * NVL(commission_pct,0)) compensation
FROM employees
WHERE first_name LIKE 'T%';

-- NVL2(x1, x2, x3)
/* NVL2 returns x3 if x1 is NULL, and x2 if x1 is not NULL.*/
SELECT first_name, salary, commission_pct, NVL2(commission_pct,
salary + salary * commission_pct, salary) compensation
FROM employees
WHERE first_name LIKE 'T%';

-- COALESCE(exp_list)
/*COALESCE(x1, x2, x3) would be evaluated as the following:
If x1 is NULL, check x2, or else return x1. Stop.
If x2 is NULL, check x3, or else return x2. Stop.
If x3 is NULL, return NULL, or else return x3. Stop.*/

SELECT last_name, salary, commission_pct AS comm,
COALESCE(salary+salary*commission_pct,
salary+100, 900) compensation
FROM employees
WHERE last_name like 'T%';

-- Alternative to the last example using CASE
SELECT last_name, salary, commission_pct AS comm,
(CASE WHEN salary IS NULL THEN 900
	  WHEN commission_pct IS NOT NULL THEN salary+salary*commission_pct
	  WHEN commission_pct IS NULL THEN salary+100
      ELSE 0 END) AS compensation
FROM employees
WHERE last_name like 'T%';

--*** Using Single-Row Character Functions

-- ASCII(c1) 
/* This function returns
the ASCII decimal equivalent of the first character in c1.*/
SELECT ASCII('A') Big_A, ASCII('z') Little_Z, ASCII('AMER')
FROM dual;

-- CHR(i)
/* Returns the character equivalent of the decimal (binary) 
representation of the character*/
SELECT CHR(65), CHR(122), CHR(223)
FROM dual;

-- CONCAT(c1,c2)
/*This function returns c2 appended to c1. If c1 is NULL, 
then c2 is returned. If c2 is NULL, then c1 is 
returned. If both c1 and c2 are NULL, then NULL is returned.*/
SELECT CONCAT(CONCAT(first_name, ' '), last_name) employee_name,
first_name || ' ' || last_name AS alternate_method
FROM employees
WHERE department_id = 30;

-- INITCAP(c1)
/*This function returns
c1 with the first character of each word in uppercase 
and all others in lowercase.*/
SELECT 'prueba de initcap', INITCAP('prueba de initcap') 
from dual;

SELECT 'otra*prueba*initcap', INITCAP('otra*prueba*initcap') 
from dual;

-- INSTR(c1,c2[,i[,j]])
/* This function returns the numeric character position in c1 where the j
occurrence of c2 is found. The search begins at the i character position in c1. INSTR returns
a 0 when the requested string is not found. If i is negative, the search is performed backward,
from right to left, but the position is still counted from left to right. Both i and j
default to 1, and j cannot be negative. */