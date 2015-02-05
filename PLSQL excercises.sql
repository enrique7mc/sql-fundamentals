/* 1. Programa que intercambie los salarios de los empleados
   con id 120 y 122. */
   
DECLARE
  V_salary_120 employees.salary%type;
Begin
  SELECT salary INTO V_salary_120
  FROM employees WHERE employee_id = 120;
  
  UPDATE employees SET salary = ( SELECT salary FROM employees 
                              WHERE employee_id = 122)
  WHERE employee_id = 120;            
  
  UPDATE employees SET  salary = V_salary_120 WHERE employee_id = 122;
  
  COMMIT;
END;


/* 2. Incrementar el salario del empleado 115 basado en las siguientes
  condiciones: Si la experiencia es de más de 10 años aumentar 20%,
  si la experiencia es mayor que 5 años aumentar 10%, en otro caso 5%.*/
  
DECLARE
  v_exp NUMBER(2);
  v_aumento NUMBER(5,2);
BEGIN
  SELECT FLOOR((SYSDATE - hire_date) / 365) INTO v_exp
  FROM employees
  WHERE employee_id = 115;
  
  v_aumento := 1.05;
  
  CASE 
    WHEN v_exp > 10 THEN
          v_aumento := 1.20;
    WHEN v_exp > 5 THEN
          v_aumento := 1.10;
  END CASE;
  
  UPDATE employees SET salary = salary * v_aumento
  WHERE employee_id = 115;
END;



/* 3. Cambiar el porcentaje de comisión para el empleado con id 150. Si el
  salario es mayor que 10000 cambiarlo a 0.4%. Si el salario es menor a
  10000 pero la experiencia es mayor a 10 años, entonces 0.35%. Si el salario
  es menor a 3000 entonces a 0.25%, en otro caso 0.15%.*/


DECLARE
  v_salary employee.salary%type;
  v_exp    NUMBER(2);
  v_porcentaje NUMBER(5,2);
BEGIN
  SELECT salary, FLOOR((SYSDATE - hire_date) / 365) INTO v_salary, v_exp
  FROM employees
  WHERE employee_id = 150;
  
  IF v_salary > 10000 THEN
          v_porcentaje := 0.4;
  ELSIF v_exp > 10 THEN
          v_porcentaje := 0.35;
  ELSIF v_salary < 3000 THEN
          v_porcentaje := 0.25;
  ELSE
          v_porcentaje := 0.15;
  END IF;
  
  UPDATE employees SET commission_pct = v_porcentaje
  WHERE employee_id = 150;
END;


/* 4. Encontrar el nombre del empleado y del departamento para el manager
    que está a cargo del empleado id 103*/
    
DECLARE
  v_name      employees.first_name%type;
  v_deptname  departments.department_name%type;
BEGIN
  SELECT first_name, department_name INTO v_name, v_deptname
  FROM employees JOIN departments USING(department_id)
  WHERE employee_id = (SELECT manager_id FROM employees
                                    WHERE employee_id = 103);
                                    
  dbms_output.put_line(v_name);
  dbms_output.put_line(v_deptname);
END;

/* 5. Mostrar los ids de los empleados que faltan. */

DECLARE
  v_min NUMBER(3);
  v_max NUMBER(3);
  v_c   NUMBER(1);
BEGIN
  SELECT MIN(employee_id), MAX(employee_id) INTO v_min, v_max
  FROM employees;
  
  FOR i in v_min + 1 .. v_max - 1
  LOOP
      SELECT COUNT(*) INTO v_c
      FROM employees
      WHERE employee_id = i;
      
      IF v_c = 0 THEN
          dbms_output.put_line(i);
      END IF;
  END LOOP;
END;

/* 6. Mostrar el año en que se unió el máximo número de empleados
    y mostrar cuantos empleados por mes se unieron dicho año. */

DECLARE
  v_year  NUMBER(4);
  v_c     NUMBER(2);
BEGIN
  SELECT TO_CHAR(hire_date, 'YYYY') INTO v_year
  FROM employees
  GROUP BY TO_CHAR(hire_date, 'YYYY')
  HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                      FROM employees
                      GROUP BY TO_CHAR(hire_date, 'YYYY'));
                      
  dbms_output.put_line('Year: ' || v_year);
  
  FOR month IN 1 .. 12
  LOOP
    SELECT COUNT(*) INTO v_c
    FROM employees
    WHERE TO_CHAR(hire_date, 'MM') = month AND TO_CHAR(hire_date, 'YYYY') = v_year;
    
    dbms_output.put_line('Month: ' || TO_CHAR(month) || '# Emp: ' || TO_CHAR(v_c));
  END LOOP;
END;


/* 7. Cambiar el salario del empleado 130 por el salario del empleado de
  nombre 'Joe'. Si no se encuentra Joe, se debe tomar el promedio del 
  salario de todos los empleados. Si hay más de un empleado con el nombre Joe
  se deberá tomar el menor de todos los salarios de los empleados de nombre Joe*/
  
DECLARE
  v_salary employee.salary%type;
BEGIN
  SELECT salary INTO v_salary
  FROM employees
  WHERE first_name = 'Joe';
  
  UPDATE employees SET salary = v_salary
  WHERE employee_id = 130;
  
EXCEPTION
  WHEN no_data_found THEN
    UPDATE employees SET salary = (SELECT AVG(salary) FROM employees)
    WHERE employee_id = 130;
END;

/* 8. Mostrar el nombre del puesto y el nombre del empleado que
  ingresó primero a ese puesto. */
  
DECLARE
  CURSOR jobscur IS SELECT job_id, job_title FROM jobs;
  v_name employees.first_name%type;
BEGIN
  FOR jobrec IN jobscur
  LOOP
    SELECT first_name into v_name
    FROM employees
    WHERE hire_date = (SELECT MIN(hire_date)
                        FROM employees WHERE job_id = jobrec.job_id)
          AND job_id = jobrec.job_id;      
    
    dbms_output.put_line(jobrec.job_title || '-' || v_name);
  END LOOP;
END;

/* 9. Mostrar del 5° al 10° empleado de la tabla de employees */

DECLARE
  CURSOR empcur IS SELECT employee_id, first_name FROM employees;
BEGIN
  FOR emprec IN empcur
  LOOP
    IF empcur%rowcount > 4 THEN
      dbms_output.put_line(emprec.employee_id || ' ' || emprec.first_name);
      EXIT WHEN empcur%rowcount >= 10;
    END IF;
  END LOOP;
END;

/* 10. Acualizar el salario de un empleado basado en su departamento y 
  porcentaje de comisión. Si el departamento es 40 aumentar un 10%, si el
  departamento es 70 aumentar 15%. Si el porcentaje de comisión es mayor que
  0.3% aumentar 5%, en otro caso aumentar 10%*/
  
DECLARE
  CURSOR empcur IS SELECT employee_id, department_id, commission_pct
                   FROM employees;
  v_aumento NUMBER(2);                 
BEGIN
  FOR emprec IN empcur
  LOOP
    IF emprec.department_id = 40 THEN
      v_aumento := 10;
    ELSIF emprec.department_id = 70 THEN
      v_aumento := 15;
    ELSIF emprec.commission_pct > 0.3 THEN
      v_aumento := 5;
    ELSE
      v_aumento := 10;
    END IF;
    
    UPDATE employees SET salary = salary + (salary * v_aumento / 100)
    WHERE employee_id = emprec.employee_id;
  END LOOP;
END;

/* 12. Crear una función que reciba el id de empleado y regrese
  el número de puestos que ha tenido dicho empleado. */
  
CREATE OR REPLACE FUNCTION get_no_of_jobs(empid NUMBER)
RETURN NUMBER IS
  v_count NUMBER(2);
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM job_history
  WHERE employee_id = empid;
  
  RETURN v_count;
END;

/* 13. Crear un procedimiento que reciba el ID de departamento y cambie su
  manager por el empleado en dicho departamento con el salario más alto*/
  
CREATE OR REPLACE PROCEDURE change_dept_manager(deptid NUMBER)
IS
  v_empid employees.employee_id%type;
BEGIN
  SELECT employee_id INTO v_empid
  FROM employees
  WHERE salary = (SELECT MAX(salary)
                    FROM employees
                    WHERE department_id = deptid)
        AND department_id = deptid;
        
  UPDATE departments SET manager_id = v_empid
  WHERE department_id = deptid;
END;

/* 14. Crear una función que reciba el manager id y regrese el nombre
  de los empleados a cargo de dicho manager, los nombres deben ser
  retornados como una cadena separada por comas. */
  
CREATE OR REPLACE FUNCTION get_employees_for_manager(manager NUMBER)
RETURN VARCHAR2 IS
  v_employees VARCHAR2(1000) := '';
  CURSOR empcur IS
    SELECT first_name FROM employees
    WHERE manager_id = manager;
BEGIN
  FOR emprec IN empcur
  LOOP
    v_employees := v_employees || ',' || emprec.first_name;
  END LOOP;
  
  RETURN LTRIM(v_employees, ',');
END;

/* 15. Asegurar que no se puedan hacer cambios en la tabla de empleados
  antes de las 6am y después de las 10pm*/
  
CREATE OR REPLACE TRIGGER trg_employees_time_check
BEFORE UPDATE OR INSERT OR DELETE
ON employees
FOR EACH ROW
BEGIN
  IF TO_CHAR(SYSDATE, 'hh24') < 6 OR TO_CHAR(SYSDATE, 'hh24') > 22 THEN
    raise_application_error(-20111, 'No se permiten modificaciones');
  END IF;
END;

/* 16. Crear un trigger para asegurar que el salario de un empleado
  no disminuya */
  
CREATE OR REPLACE TRIGGER trg_employees_salary_check
BEFORE UPDATE
ON employees
FOR EACH ROW
BEGIN
  IF :old.salary > :new.salary THEN
    raise_application_error(-20111, 'No es posible cambiar el salario a
      una cantidad menor');
  END IF;
END;

/* 17. Cada que se cambie un puesto para un empleado, escribir los siguientes
  detalles en la tabla job_history. Id del empleado, antiguo job_id, fecha
    de contratación para la nueva fecha de inicio, y sysdate para la fecha
    de fin. Si la fila ya existe, entonces la fecha de inicio debe ser la
    fecha de fin de esa fila + 1.*/

CREATE OR REPLACE TRIGGER trg_log_job_change
AFTER UPDATE OF job_id
ON employees
FOR EACH ROW
  v_enddate DATE;
  v_startdate DATE;
BEGIN
  SELECT MAX(end_date) INTO v_enddate
  FROM job_history
  WHERE employee_id = :old.employee_id;
  
  IF v_enddate IS NULL THEN
    v_startdate := :old.hire_date
  ELSE
    v_startdate := v_enddate + 1;
  END IF;
  
  INSERT INTO job_history VALUES (:old.employee_id, v_startdate, sysdate,
    :old.job_id, :old.department_id);
END;  