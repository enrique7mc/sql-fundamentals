-- HR schema excercises

------- SELECT STATEMENT AND SINGLE-ROW FUNCTIONS

/* 1. Mostrar las columnas de jobs donde el salario mínimo es
	mayor que 10000 */

SELECT * FROM JOBS WHERE MIN_SALARY > 10000;

/* 2. Mostrar first_name y hire_date de los empleados
	que ingresaron entre 2002 y 2005*/

SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE, 'YYYY') BETWEEN 2002 AND 2005 ORDER BY HIRE_DATE;

/* 3. Mostrar first_name y hire_Date de los empleados que son
	IT Programmer o Sales Man*/

SELECT FIRST_NAME, HIRE_DATE
FROM EMPLOYEES WHERE JOB_ID IN ('IT_PROG', 'SA_MAN');

/* 4. Mostrar empleados que ingresaron después del 1° de enero de 2008*/

SELECT * FROM EMPLOYEES  where hire_date > '01-jan-2008';

/* 5. Mostrar los detalles de los empleados con id 150 o 160*/

SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID in (150,160);

/* 6. Mostrar first_name, salary, commission_pct y hire_date de los
	empleados con salario menor a 10000*/

SELECT FIRST_NAME, SALARY, COMMISSION_PCT, HIRE_DATE 
FROM EMPLOYEES WHERE SALARY < 10000;

/* 7. Mostrar job_title, la diferencia etre el salario mínimo y máximo
	para los jobs con max_salary en el rango de 10000 a 20000*/

SELECT JOB_TITLE, MAX_SALARY-MIN_SALARY DIFFERENCE 
FROM JOBS WHERE MAX_SALARY BETWEEN 10000 AND 20000;

/* 8. Mostrar first_name, salary y redondear el salario a millares
	de todos los empleados*/

SELECT FIRST_NAME, SALARY, ROUND(SALARY, -3) FROM EMPLOYEES;

/* 9. Mostrar los detalles de los jobs en orden descendente por title*/

SELECT * FROM JOBS ORDER BY JOB_TITLE;

/* 10. Mostrar el nombre completo de los empleados cuyo first_name
	o last_name comiece con S*/

SELECT FIRST_NAME, LAST_NAME 
FROM EMPLOYEES 
WHERE  FIRST_NAME  LIKE 'S%' OR LAST_NAME LIKE 'S%';

/* 11. Mostrar los datos de los empleados que ingresaron durante
	el mes de mayo*/

SELECT * FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'MON') = 'MAY';

/* 12. Mostrar los datos de los empleados cuyo commission_pct es nulo,
tienen un salario en el rango de 5000 y 10000 y su departamento es 30*/

SELECT * FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NULL 
AND SALARY BETWEEN 5000 AND 10000 AND DEPARTMENT_ID=30;

/* 13. Mostrar first_name, fecha de ingreso y día de la fecha de ingreso
	de los empleados*/

SELECT FIRST_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)+1 FROM EMPLOYEES;

/* 14. Mostrar first_name y años de experiencia de los empleados*/

SELECT FIRST_NAME, HIRE_DATE, FLOOR((SYSDATE-HIRE_DATE)/365)FROM EMPLOYEES;

/* 15. Mostrar first_name de los empleados que ingresaron durante
	el año 2001*/

/* 16. Mostrar first_name, last_name después de convertir la primera letra
	de cada uno a mayúscula y el resto a minúscula*/

SELECT INITCAP(FIRST_NAME), INITCAP(LAST_NAME) FROM EMPLOYEES;

/* 17. Mostrar la primera palabra de cada job_title*/

SELECT JOB_TITLE,  SUBSTR(JOB_TITLE,1, INSTR(JOB_TITLE, ' ')-1) FROM JOBS;

/* 18. Mostrar la longitud de first_name de los empelados si
	el last_name contiene el carácter 'b' después de la 3a posición*/

SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES WHERE INSTR(LAST_NAME,'b') > 3;

/* 19. Mostrar first_name en mayúsculas, last_name en minúsuclas 
	para los empleados cuya primera letra de first_name sea distinta
	de la primera letra de last_name*/

SELECT UPPER(FIRST_NAME), LOWER(LAST_NAME) 
FROM EMPLOYEES WHERE SUBSTR(FIRST_NAME, 1, 1) <> SUBSTR(LAST_NAME, 1, 1);

/* 20. Mostrar datos de los empleados que han ingresado este año */

SELECT * FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE,'YYYY') = TO_CHAR(SYSDATE, 'YYYY');

/* 21. Mostrar el número de días entre la fecha actual y el
	1° de enero de 2011 */

SELECT SYSDATE - to_date('01-jan-2011') FROM DUAL


------ AGGREGATE FUNCTIONS AND GROUP BY CLAUSE
/* 22. Mostrar cuantos empleados por cada mes del año actual
	han ingresado a la compañia*/

SELECT TO_CHAR(HIRE_DATE,'MM'), COUNT (*) FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY') 
GROUP BY TO_CHAR(HIRE_DATE,'MM');

/* 23. Mostrar el manager_id y cuantos empleados tiene a su cargo*/

SELECT MANAGER_ID, COUNT(*) FROM EMPLOYEES GROUP BY MANAGER_ID;

/* 24. Mostrar el employee_id y la fecha en que terminó su
	puesto anterior (end_date)*/

SELECT EMPLOYEE_ID, MAX(END_DATE) FROM JOB_HISTORY GROUP BY EMPLOYEE_ID;

/* 25. Mostrar la cantidad de empleados que ingresaron en un día
	de mes mayor a 15*/

SELECT COUNT(*) FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE,'DD') > 15;

/* 26. Mostrar el country_id y el número de ciudades que hay
	en ese país*/

SELECT COUNTRY_ID,  COUNT(*)  FROM LOCATIONS GROUP BY COUNTRY_ID;

/* 27. Mostrar el promedio de salario de los empleados por departamento
	que tengan asignado un porcentaje de comisión */

SELECT DEPARTMENT_ID, AVG(SALARY) FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL GROUP BY DEPARTMENT_ID;

/* 28. Mostrar el job_id, número de empleados, suma de salarios
	y diferencia del mayor y el menor salario por puesto (job_id)*/

SELECT JOB_ID, COUNT(*), SUM(SALARY), MAX(SALARY)-MIN(SALARY) SALARY 
FROM EMPLOYEES GROUP BY JOB_ID;

/* 29. Mostrar el job_id y el promedio de salarios para los puestos 
	con promedio de salario	mayor a 10000*/

SELECT JOB_ID, AVG(SALARY) FROM EMPLOYEES 
GROUP BY JOB_ID 
HAVING AVG(SALARY) > 10000;

/* 30. Mostrar los años en que ingresaron más de 10 empleados*/

SELECT TO_CHAR(HIRE_DATE,'YYYY') FROM EMPLOYEES 
GROUP BY TO_CHAR(HIRE_DATE,'YYYY') 
HAVING COUNT(EMPLOYEE_ID) > 10;

/* 31. Mostrar los departamentos en los cuáles más de 5 empleados
	tengan porcentaje de comisión */

SELECT DEPARTMENT_ID FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID 
HAVING COUNT(COMMISSION_PCT) > 5;

/* 32. Mostrar el employee_id de los empleados que tuvieron 
	más de un puesto en la compañía*/
SELECT EMPLOYEE_ID 
FROM JOB_HISTORY GROUP BY EMPLOYEE_ID HAVING COUNT(*) > 1;

/* 33. Mostrar el job_id de los puestos que fueron ocupados
	por más de tres empleados que hayan trabajado más de 100 días*/

SELECT JOB_ID FROM JOB_HISTORY 
WHERE END_DATE-START_DATE > 100 
GROUP BY JOB_ID 
HAVING COUNT(*) > 3;

/* 34. Mostrar por departamento y año la cantidad de empleados 
	que ingresaron*/

SELECT DEPARTMENT_ID, TO_CHAR(HIRE_DATE,'YYYY'), COUNT(EMPLOYEE_ID) 
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID, TO_CHAR(HIRE_DATE, 'YYYY');
ORDER BY DEPARTMENT_ID;

/* 35. Mostrar los departament_id de los departamentos que tienen
	managers que tienen a cargo más de 5 empleados */

SELECT DISTINCT DEPARTMENT_ID
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, MANAGER_ID 
HAVING COUNT(EMPLOYEE_ID) > 5;