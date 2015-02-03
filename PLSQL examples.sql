DECLARE
  -- Este ejemplo es Hola Mundo
  mensaje VARCHAR2(20) := 'Hola mundo';
BEGIN
  /*
  Estas son
  líneas ejecutables
  */
  dbms_output.put_line(mensaje);
END;

DECLARE 
  num1 INTEGER;
  num2 REAL;
  num3 DOUBLE PRECISION;
  nombre VARCHAR2(50);
  CP CHAR(5);
BEGIN
  NULL;
END;
  

  DECLARE
  num1 INTEGER;
  ventas NUMBER(10, 2);
  pi CONSTANT DOUBLE PRECISION := 3.14159;
  nombre VARCHAR(2);
  direccion VARCHAR2(100);
  var FLOAT DEFAULT 1.5;
BEGIN
  -- Este programa declara variables
  NULL;
  
  /*
    Y demuestra el uso de comentarios
  */
END;



DECLARE
  a INTEGER := 10;
  b INTEGER := 20;
  c INTEGER;
  f REAL;
BEGIN
  c := a + b;
  dbms_output.put_line('Valor de c: ' || c);
  f := 70.0 / 3.0;
  dbms_output.put_line('Valor de f: ' || f);
END;

DECLARE
  -- Variables globales
  num1 NUMBER := 95;
  num2 NUMBER := 85;
BEGIN
  dbms_output.put_line('Variable global num1: ' || num1);
  dbms_output.put_line('Variable global num2: ' || num2);
  
  DECLARE
    num1 NUMBER := 195;
    num2 NUMBER := 185;
  BEGIN
    dbms_output.put_line('Variable local num1: ' || num1);
    dbms_output.put_line('Variable local num2: ' || num2);
  END;
END;

DECLARE 
  nombre    employees.first_name%type; 
  apellido  employees.last_name%type;
  sueldo    employees.salary%type;
BEGIN
  SELECT first_name, last_name, salary
    INTO nombre, apellido, sueldo
  FROM employees
  WHERE employee_id = 110;
  dbms_output.put_line('Nombre: ' || nombre);
  dbms_output.put_line('Apellido: ' || apellido);
  dbms_output.put_line('Sueldo: ' || sueldo);
END;

BEGIN
  dbms_output.put_line('10 + 5: ' || (10 + 5));
  dbms_output.put_line('10 - 5: ' || (10 - 5));
  dbms_output.put_line('10 * 5: ' || (10 * 5));
  dbms_output.put_line('10 / 5: ' || (10 / 5));
  dbms_output.put_line('10 ** 5: ' || (10 ** 5));
END;

DECLARE
  a NUMBER(2) := 21;
  b NUMBER(2) := 10;
BEGIN
  IF(a = b) THEN
    dbms_output.put_line('A es igual a B');
  ELSE
    dbms_output.put_line('A no es igual a B');
  END IF;
  
  IF(a < b) THEN
    dbms_output.put_line('A es menor que B');
  ELSE
    dbms_output.put_line('A no es menor que B');
  END IF;  
  
  IF(a > b) THEN
    dbms_output.put_line('A es mayor que B');
  ELSE
    dbms_output.put_line('A no es mayor que B');
  END IF;  
  
  a := 5;
  b := 20;
  
  IF(a <= b) THEN
    dbms_output.put_line('A es menor o igual que B');
  ELSE
    dbms_output.put_line('A no es menor o igual que B');
  END IF;  
  
  IF(a >= b) THEN
    dbms_output.put_line('A es mayor o igual que B');
  ELSE
    dbms_output.put_line('A no es mayor o igual que B');
  END IF;
  
  IF(a <> b) THEN
    dbms_output.put_line('A es diferente de B');
  ELSE
    dbms_output.put_line('A no es diferente de B');
  END IF;
END;

DECLARE
  a BOOLEAN := TRUE;
  b BOOLEAN := FALSE;
BEGIN
  IF(a AND b) THEN
    dbms_output.put_line('1a condición: TRUE');
  END IF;
  
  IF(a OR b) THEN
    dbms_output.put_line('2a condición: TRUE');
  END IF;
  
  IF(NOT a) THEN
    dbms_output.put_line('3a condición: a no es TRUE');
  ELSE
    dbms_output.put_line('3a condición: a es TRUE');
  END IF;
  
  IF(NOT b) THEN
    dbms_output.put_line('4a condición: b no es TRUE');
  ELSE
    dbms_output.put_line('4a condición: b es TRUE');
  END IF;
END;

DECLARE 
  a NUMBER(2) := 10;
BEGIN
   a := 30;
   -- revisar condición
   IF( a < 20) THEN
      -- La condición fue verdadera
      dbms_output.put_line('A es mayor que 20');
   END IF;
   
   dbms_output.put_line('Valor de a: ' || a);
END;

DECLARE
  a NUMBER(3) := 20;
BEGIN
  IF(a < 50) THEN
    dbms_output.put_line('A es menor que 50');
  ELSE
    dbms_output.put_line('A no es menor que 50');
  END IF;  
  
  dbms_output.put_line('Valor de a: ' || a);
END;

DECLARE
  A number(3) := 30;
BEGIN
  IF(a = 10) THEN
    dbms_output.put_line('A es igual a 10');
  ELSIF(a = 20) THEN
    dbms_output.put_line('A es igual a 20');
  ELSIF(a = 30) THEN
    dbms_output.put_line('A es igual a 30');
  ELSE
    dbms_output.put_line('El valor de a no coincidio');
  END IF;
  
  dbms_output.put_line('Valor de A: ' || a);
END;

DECLARE
  calif CHAR(2) := '10';
BEGIN
  CASE 
    WHEN calif = '10' THEN dbms_output.put_line('Excelente');
    WHEN calif = '9' THEN dbms_output.put_line('Muy bien');
    WHEN calif = '8' THEN dbms_output.put_line('Bien hecho');
    WHEN calif = '7' THEN dbms_output.put_line('Pasaste');
    WHEN calif = '5' THEN dbms_output.put_line('Reprobado');
  END CASE;
END;

DECLARE
  x NUMBER := 10;
BEGIN
  LOOP
    dbms_output.put_line(x);
    x := x + 10;
    
    EXIT WHEN x > 50;
  END LOOP;
  
  dbms_output.put_line('Al terminar el ciclo x: ' || x);
END;

DECLARE 
  a NUMBER(2) := 10;
BEGIN
  WHILE a < 20 LOOP
    dbms_output.put_line('Valor de a: ' || a);
    a := a + 1;
  END LOOP;
END;

DECLARE 
  a NUMBER(2);
BEGIN
  FOR a IN REVERSE 10 .. 20 LOOP
    dbms_output.put_line('Valor de a: ' || a);
  END LOOP;
END;

CREATE OR REPLACE PROCEDURE saludos
AS
BEGIN
  dbms_output.put_line('Saludos desde procedimiento');
END;

--EXECUTE saludos;

BEGIN
  saludos;
END;

DROP PROCEDURE saludos;

DECLARE
  a NUMBER;
  b NUMBER;
  c NUMBER;
PROCEDURE findMin(x IN number, y IN number, z OUT number) IS
BEGIN
  IF x < y THEN
    z := x;
  ELSE
    z := y;
  END IF;
END;
BEGIN
  a := 23;
  b := 45;
  findMin(a, b, c);
  dbms_output.put_line('El mínimo de 45 y 23 es: ' || c);
END;

DECLARE
  a NUMBER;
PROCEDURE cuadrado(x IN OUT NUMBER) IS
BEGIN
  x := x ** 2;
END;
BEGIN
  a := 9;
  cuadrado(a);
  dbms_output.put_line('Cuadrado de 9: ' || a);
END;

CREATE OR REPLACE FUNCTION totalEmpleados
RETURN NUMBER IS
  total NUMBER(3) := 0;
BEGIN
  SELECT COUNT(*) INTO total
  FROM employees;
  
  RETURN total;
END;

DECLARE
  c NUMBER(3);
BEGIN
  c := totalEmpleados();
  dbms_output.put_line('Total: ' || c);
END;

-- DROP function nombre;

DECLARE
  a NUMBER;
  b NUMBER;
  c NUMBER;
FUNCTION findMax(x IN NUMBER, y IN NUMBER)
RETURN NUMBER
IS 
  z NUMBER;
BEGIN
  IF x > y THEN
    z := x;
  ELSE
    z := y;
  END IF;
  
  RETURN z;
END;
BEGIN
  a := 55;
  b := 31;
  
  c := findMax(a, b);
  dbms_output.put_line('El mayor de a y b es: ' || c);
END;

DECLARE 
  num NUMBER;
  factorial NUMBER;
FUNCTION fact(x NUMBER)
RETURN NUMBER
IS
  f NUMBER;
BEGIN
  IF x = 0 THEN
    f := 1;
  ELSE
    f := x * fact(x - 1);
  END IF;
  
  RETURN f;
END;  
BEGIN
  num := 6;
  factorial := fact(num);
  dbms_output.put_line('Factorial de 6: ' || factorial);
END;
