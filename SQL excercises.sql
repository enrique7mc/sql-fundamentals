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