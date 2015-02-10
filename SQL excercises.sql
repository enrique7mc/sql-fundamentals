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

/* 13. Mostrar first_name, fecha de ingreso y el primer día del siguiente
  mes a la fecha de ingreso de los empleados*/

SELECT FIRST_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)+1 FROM EMPLOYEES;

/* 14. Mostrar first_name y años de experiencia de los empleados*/

SELECT FIRST_NAME, HIRE_DATE, FLOOR((SYSDATE-HIRE_DATE)/365)FROM EMPLOYEES;

/* 15. Mostrar first_name de los empleados que ingresaron durante
	el año 2001*/

SELECT first_name
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = '2001';

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


------------------- INSERT, UPDATE, DELETE

/* 36. Cambiar el salario del empleado 115 a 8000 si el salario
	existente es menor que 6000*/

UPDATE EMPLOYEES 
SET SALARY = 8000 
WHERE EMPLOYEE_ID = 115 AND SALARY < 6000;

/* 37. Insertar un nuevo empleado con todos los campos*/

INSERT INTO EMPLOYEES  (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE,JOB_ID, SALARY, DEPARTMENT_ID) 
VALUES (207, 'ANGELA', 'SNYDER','ANGELA@DOMAIN.COM','215 253 4737', SYSDATE, 'SA_MAN', 12000, 80);

/* 38. Borrar el departamento 20 */

DELETE FROM DEPARTMENTS 
WHERE DEPARTMENT_ID=20;

/* 39. Cambiar el job_id del empleado 110 a IT_PRGO si el empleado pertenece 
	al departamento 10 y el job_id existente no empieza con 'IT' */
UPDATE EMPLOYEES SET JOB_ID= 'IT_PROG' 
WHERE EMPLOYEE_ID=110 AND DEPARTMENT_ID=10 AND NOT JOB_ID LIKE 'IT%';

/* 40. Insertar una fila en la tabla de departamentos con manager id 120
	y location id en cualquier ciudad de Tokyo */

INSERT INTO DEPARTMENTS (150,'SPORTS',120,1200);

------------------- JOINS

/* 41. Mostrar el nombre del departamento y el número de empleados
	en cada uno*/

SELECT DEPARTMENT_NAME, COUNT(*) 
FROM EMPLOYEES NATURAL JOIN DEPARTMENTS GROUP BY DEPARTMENT_NAME;

/* 42. Mostrar job_title, employee_id y número de días de diferencia
	entre end_date y start_date para los jobs del departamento 30,
	de la tabla job_history */

SELECT EMPLOYEE_ID, JOB_TITLE, END_DATE-START_DATE DAYS 
FROM JOB_HISTORY NATURAL JOIN JOBS 
WHERE DEPARTMENT_ID = 30;

/* 43. Mostrar el nombre del departamento y el nombre del manager
	a cargo del departamento*/

SELECT DEPARTMENT_NAME, FIRST_NAME 
FROM DEPARTMENTS D JOIN EMPLOYEES E ON (D.MANAGER_ID=E.EMPLOYEE_ID);

/* 44. Mostrar el nombre del departamento, el del manager a cargo
	y la ciudad a la que pertenece*/

SELECT DEPARTMENT_NAME, FIRST_NAME, CITY 
FROM DEPARTMENTS D JOIN EMPLOYEES E 
ON (D.MANAGER_ID=E.EMPLOYEE_ID) JOIN LOCATIONS L USING (LOCATION_ID);

/* 45. Mostrar nombre de departamento, y su país*/

SELECT COUNTRY_NAME, DEPARTMENT_NAME 
FROM COUNTRIES JOIN LOCATIONS USING (COUNTRY_ID) 
JOIN DEPARTMENTS USING (LOCATION_ID)

/* 46. Mostrar job_title, department_name, last_name de empleado y la fecha
	de inicio de todos los puestos de 2000 a 2005*/

SELECT JOB_TITLE, DEPARTMENT_NAME, LAST_NAME, START_DATE 
FROM JOB_HISTORY 
JOIN JOBS USING (JOB_ID) 
JOIN DEPARTMENTS USING (DEPARTMENT_ID) 
JOIN  EMPLOYEES USING (EMPLOYEE_ID) 
WHERE TO_CHAR(START_DATE,'YYYY') BETWEEN 2000 AND 2005;

/* 47. Mostrar job_title y promedio de los salarios de los empleados */

SELECT JOB_TITLE, AVG(SALARY) 
FROM EMPLOYEES 
NATURAL JOIN JOBS GROUP BY JOB_TITLE;

/* 48. Mostrar job_title, first_name de empleado, y la diferencia entre al
	salary mayor y el menor para el puesto del empleado*/

SELECT JOB_TITLE, FIRST_NAME, MAX_SALARY-SALARY DIFFERENCE 
FROM EMPLOYEES NATURAL JOIN JOBS;

/* 49. Mostrar last_name, job_title de los empleados que tienen un 
	commission_pct y pertenecen al departamento 30 */

SELECT LAST_NAME, JOB_TITLE
FROM EMPLOYEES NATURAL JOIN JOBS 
WHERE COMMISSION_PCT IS NOT NULL AND DEPARTMENT_ID  = 80;

/* 50. Mostrar los detalles de los puestos ocupados por cualquier empleado
	que actualmente tenga más de 15000 de salario*/

SELECT JH.*
FROM  JOB_HISTORY JH 
JOIN EMPLOYEES E ON (JH.EMPLOYEE_ID = E.EMPLOYEE_ID)
WHERE SALARY > 15000;

/* 51. Mostrar department_name, nombre y salario de los managers con experiencia
	mayor a 5 años*/

SELECT DEPARTMENT_NAME, FIRST_NAME, SALARY 
FROM DEPARTMENTS D 
JOIN EMPLOYEES E ON (D.MANAGER_ID=E.MANAGER_ID) 
WHERE  (SYSDATE-HIRE_DATE) / 365 > 5;

/* 52. Mostrar nombre de los empleados que ingresaron antes que su manager*/ 

SELECT E1.FIRST_NAME 
FROM  EMPLOYEES E1 JOIN EMPLOYEES E2 ON (E1.MANAGER_ID=E2.EMPLOYEE_ID) 
WHERE E1.HIRE_DATE < E2.HIRE_DATE;

/* 53. Mostrar nombre, job_title para los puestos que un empleado tuvo 
	anteriormente y que duró menos de 6 meses */
SELECT FIRST_NAME, JOB_TITLE 
FROM EMPLOYEES E 
JOIN JOB_HISTORY JH ON (JH.EMPLOYEE_ID = E.EMPLOYEE_ID) 
JOIN JOBS J  ON( JH.JOB_ID = J.JOB_ID) 
WHERE  MONTHS_BETWEEN(END_DATE,START_DATE)  < 6 ;

/* 54. Mostrar nombre del empleado y el país en el que trabaja */

SELECT FIRST_NAME, COUNTRY_NAME 
FROM EMPLOYEES 
JOIN DEPARTMENTS USING(DEPARTMENT_ID) 
JOIN LOCATIONS USING( LOCATION_ID) 
JOIN COUNTRIES USING ( COUNTRY_ID);

/* 55. Mostrar department_name, promedio del salario y numero de
	empleados con commission_pct en el departamento*/

SELECT DEPARTMENT_NAME, AVG(SALARY), COUNT(COMMISSION_PCT) 
FROM DEPARTMENTS 
JOIN EMPLOYEES USING (DEPARTMENT_ID) 
GROUP BY DEPARTMENT_NAME;

/* 56. Mostrar el mes en qúe más de 5 empleados ingresaron
	a un departamento ubicado en Seattle*/

SELECT TO_CHAR(HIRE_DATE,'MON-YY')
FROM EMPLOYEES 
JOIN DEPARTMENTS USING (DEPARTMENT_ID) 
JOIN LOCATIONS USING (LOCATION_ID) 
WHERE  CITY = 'Seattle'
GROUP BY TO_CHAR(HIRE_DATE,'MON-YY')
HAVING COUNT(*) > 5;

-------- SUBQUERIES

/* 57. Mostrar los detalles de los departamentos en los cuales
	el salario máximo sea mayor a 10000*/

SELECT * 
FROM DEPARTMENTS 
WHERE DEPARTMENT_ID IN 
(SELECT DEPARTMENT_ID FROM EMPLOYEES 
  GROUP BY DEPARTMENT_ID 
  HAVING MAX(SALARY)>10000);

/* 58. Mostrar los detalles de los departamentos a cargo
	de 'Smith' */

SELECT * FROM DEPARTMENTS WHERE MANAGER_ID IN 
  (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE last_name='SMITH');

 /* 59. Mostrar los puestos de los empleados se unieron durante el 2008 */

SELECT * FROM JOBS 
WHERE JOB_ID IN 
       (SELECT JOB_ID FROM EMPLOYEES 
       	WHERE TO_CHAR(HIRE_DATE,'YYYY')= '2008');

/* 60. Mostrar los empleados que no tienen un puesto previo
	en la compañía */

SELECT * FROM EMPLOYEES 
WHERE EMPLOYEE_ID NOT IN 
       (SELECT EMPLOYEE_ID FROM JOB_HISTORY);


/* 61. Mostrar job_title y promedio de salario para empleados
	que tenían un puesto previo en la compañía */

SELECT JOB_TITLE, AVG(SALARY) 
FROM JOBS NATURAL JOIN EMPLOYEES 
GROUP BY JOB_TITLE 
WHERE EMPLOYEE_ID IN
    (SELECT EMPLOYEE_ID FROM JOB_HISTORY);

/* 62. Mostrar country_name, city y número de departamentos
	donde el departamento tenga más de 5 empleados */

SELECT COUNTRY_NAME, CITY, COUNT(DEPARTMENT_ID)
FROM COUNTRIES 
JOIN LOCATIONS USING (COUNTRY_ID) 
JOIN DEPARTMENTS USING (LOCATION_ID) 
WHERE DEPARTMENT_ID IN 
    (SELECT DEPARTMENT_ID FROM EMPLOYEES 
	 GROUP BY DEPARTMENT_ID 
	 HAVING COUNT(DEPARTMENT_ID)>5)
GROUP BY COUNTRY_NAME, CITY;

/* 63. Mostrar el nombre de los manager que tengan a su
	cargo más de 5 personas */

SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE EMPLOYEE_ID IN 
(SELECT MANAGER_ID FROM EMPLOYEES 
 GROUP BY MANAGER_ID 
 HAVING COUNT(*)>5);

/* 64. Mostrar para los empleados: nombre, job_title, start_date 
	y end_date de los trabajos previos, que no tengan 
	commission_pct*/

SELECT FIRST_NAME, JOB_TITLE, START_DATE, END_DATE
FROM JOB_HISTORY JH 
JOIN JOBS J USING (JOB_ID) 
JOIN EMPLOYEES E  ON ( JH.EMPLOYEE_ID = E.EMPLOYEE_ID)
WHERE COMMISSION_PCT IS NULL;

/* 65. Mostrar los departamentos en los cuales no ha ingresado
	un empleado durante los últimos dos años */

SELECT  * FROM DEPARTMENTS
WHERE DEPARTMENT_ID NOT IN 
( SELECT DEPARTMENT_ID 
	FROM EMPLOYEES 
   WHERE FLOOR((SYSDATE-HIRE_DATE)/365) < 2);

/* 66. Mostrar los detalles de los departamentos en los cuales
	el salario máximo es mayor que 10000 para los empleados
	que no tuvieron un puesto previamente */

SELECT * FROM DEPARTMENTS
WHERE DEPARTMENT_ID IN 
(SELECT DEPARTMENT_ID 
  FROM EMPLOYEES 
 WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM JOB_HISTORY) 
 GROUP BY DEPARTMENT_ID
 HAVING MAX(SALARY) > 10000);

/* 67. Mostrar detalles del job actual para los empleados
	que trabajaron previamente en IT_PROG */

SELECT * 
FROM JOBS 
WHERE JOB_ID IN 
 (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN 
        (SELECT EMPLOYEE_ID FROM JOB_HISTORY WHERE JOB_ID='IT_PROG'));

 /* 68. Mostrar los detalles de los empleados que tienen el
 	mayor salario de su departamento*/

 SELECT DEPARTMENT_ID,FIRST_NAME, SALARY 
 FROM EMPLOYEES OUTER WHERE SALARY = 
    (SELECT MAX(SALARY) 
    FROM EMPLOYEES 
    WHERE DEPARTMENT_ID = OUTER.DEPARTMENT_ID);

/* 69. Mostrar la ciudad del empleado 105 */

SELECT CITY FROM LOCATIONS 
WHERE LOCATION_ID = 
    (SELECT LOCATION_ID 
    	FROM DEPARTMENTS 
    	WHERE DEPARTMENT_ID =
             	(SELECT DEPARTMENT_ID 
             		FROM EMPLOYEES 
             		WHERE EMPLOYEE_ID=105))

 /* 70. Mostrar el tercer mayor salario de los empleados */

SELECT SALARY 
FROM EMPLOYEES main
WHERE  2 = (SELECT COUNT( DISTINCT SALARY ) 
            FROM EMPLOYEES
            WHERE  SALARY > main.SALARY);