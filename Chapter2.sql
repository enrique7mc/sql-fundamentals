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


-- TODO: complete string functions

--*** Using Single-Row Numeric Functions

-- ABS(n)
/*This function returns the absolute value of n.*/
SELECT ABS(-52) negative, ABS(52) positive
FROM dual;

-- ACOS(n)
/*This function returns the arc cosine of n expressed in radians*/
SELECT ACOS(-1) PI, ACOS(0) ACOSZERO,
	   ACOS(.045) ACOS045, ACOS(1) ZERO
FROM dual;

-- ASIN(n) 
/* This function returns the arc sine of n expressed in radians*/
SELECT ASIN(1) high, ASIN(0) middle, ASIN(-1) low
FROM dual;

-- ATAN(n)
/*This function returns the arc tangent of n expressed in radians*/
SELECT ATAN(9E99) high, ATAN(0) middle, ATAN(-9E99) low
FROM dual;

-- ATAN2(n1, n2)
/*This function returns the arc tangent of n1 and n2 expressed in radians*/
SELECT ATAN2(9E99,1) high, ATAN2(0,3.1415) middle, ATAN2(-9E99,1) low
FROM dual;

-- BITAND(n1, n2)
/*This function performs a bitwise AND operation 
on the two input values and returns the results, also an integer*/
SELECT BITAND(6,3) T1, BITAND(8,2) T2
FROM dual;

-- CEIL(n)
/* This function returns the smallest integer that is greater than or equal to n.*/
SELECT CEIL(9.8), CEIL(-32.85), CEIL(0), CEIL(5)
FROM dual;

-- COS(n)
/* This function returns the cosine of n*/
SELECT COS(-3.14159) FROM dual;

-- COSH(n)
/* This function returns the hyperbolic cosine of n */
SELECT COSH(1.4) FROM dual;

-- EXP(n)
/* This function returns e (the base of natural logarithms) raised to the n power*/
SELECT EXP(1) "e" FROM dual;

-- FLOOR(n)
/* This function returns the largest integer that is less than or equal to n*/
SELECT FLOOR(9.8), FLOOR(-32.85), FLOOR(137)
FROM dual;

-- LN(n)
/* This function returns the natural logarithm of n*/
SELECT LN(2.7) FROM dual;

-- LOG(n1, n2)
/* This function returns the logarithm base n1 of n2*/
SELECT LOG(8,64), LOG(3,27), LOG(2,1024), LOG(2,8)
FROM dual;

-- MOD(n1, n2)
/* This function returns n1 modulo n2, or the remainder of n1 divided by n2. If n1 is negative, the result
is negative. The sign of n2 has no effect on the result. If n2 is zero, the result is n1.*/
SELECT MOD(14,5), MOD(8,2.5), MOD(-64,7), MOD(12,0)
FROM dual;

-- POWER(n1, n2)
/* This function returns n1 to the n2 power*/
SELECT POWER(2,10), POWER(3,3), POWER(5,3), POWER(2,-3)
FROM dual;

-- REMAINDER(n1, n2)
/* This function returns the remainder of n1 divided by n2. If n1 is negative, the result is negative.
The sign of n2 has no effect on the result. If n2 is zero and the datatype of n1 is NUMBER,
an error is returned; if the datatype of n1 is BINARY_FLOAT or BINARY_DOUBLE,
NaNis returned. */
SELECT REMAINDER(13,5), REMAINDER(12,5), REMAINDER(12.5, 5)
FROM dual;

SELECT REMAINDER(TO_BINARY_FLOAT(‘13.0’), 0) RBF
from dual;

/* The difference between MOD and REMAINDER is that MOD uses the FLOOR function, whereas
REMAINDER uses the ROUND function in the formula. */
SELECT MOD(13,5), MOD(12,5), MOD(12.5, 5)
FROM dual;

-- ROUND(n1 [,n2])
/* This function returns n1 rounded to n2 digits of precision to the right of the decimal. If n2
is negative, n1 is rounded to the left of the decimal. If n2 is omitted, the default is zero. */
SELECT ROUND(123.489), ROUND(123.489, 2),
	   ROUND(123.489, -2), ROUND(1275, -2)
FROM dual;

-- SIGN(n)
/* This function returns –1 if n is negative, 1 if n is positive, and 0 if n is 0. */  
SELECT SIGN(-2.3), SIGN(0), SIGN(47)
FROM dual;

-- SIN(n)
/* This function returns the sine of n */
SELECT SIN(1.57079) FROM dual;

-- SINH(n)
/* This function returns the hyperbolic sine of n*/
SELECT SINH(1) FROM dual;

-- SQRT(n)
/* This function returns the square root of n*/
SELECT SQRT(64), SQRT(49), SQRT(5)
FROM dual;

-- TAN(n)
/* This function returns the tangent of n*/
SELECT TAN(1.57079633/2) "45_degrees"
FROM dual;

-- TANH(n)
/* This function returns the hyperbolic tangent of n */
SELECT TANH( ACOS(-1) ) hyp_tan_of_pi
FROM dual;

-- TRUNC(n1 [,n2])
/* This function returns n1 truncated to n2 digits of precision to the right of the decimal. If n2
is negative, n1 is truncated to the left of the decimal.*/
SELECT TRUNC(123.489), TRUNC(123.489, 2),
	   TRUNC(123.489, -2), TRUNC(1275, -2)
FROM dual;

-- WIDTH_BUCKET(n1, min_val, max_val, buckets)
/* This function builds histograms of equal
width. The first argument n1 can be an expression of a numeric or datetime datatype. The
second and third arguments, min_val and max_val, indicate the end points for the histogram’s
range. The fourth argument, buckets, indicates the number of buckets./

/* The following example divides the salary into a 10-bucket histogram within the range
2,500 to 11,000. If the salary falls below 2500, it will be in the underflow bucket (bucket 0),
and if the salary exceeds 11,000, it will be in the overflow bucket (buckets + 1). */
SELECT first_name, salary,
	WIDTH_BUCKET(salary, 2500, 11000, 10) hist
FROM employees
WHERE first_name like ‘J%’;

--*** Using Single-Row Date Functions

-- Date-Format Conversion
SELECT SYSDATE FROM dual;
ALTER SESSION SET NLS_DATE_FORMAT=’DD-Mon-YYYY HH24:MI:SS’;

-- SYSDATE
/* returns the current date and time to the second for the
operating-system host where the database resides. The value is returned in a DATE datatype. */
SELECT SYSDATE FROM dual;

-- SYSTIMESTAMP
/* returns a TIMESTAMP WITH TIME ZONE for
the current database date and time (the time of the host server where the database resides)*/
SELECT SYSDATE, SYSTIMESTAMP FROM dual;

-- LOCALTIMESTAMP([p])
/* returns the current date and time in the session’s time zone to p digits
of precision. p can be 0 to 9 and defaults to 6. */
SELECT SYSTIMESTAMP, LOCALTIMESTAMP FROM dual;

-- ADD_MONTHS(d, i)
/* This function returns the date d plus i months. */
SELECT SYSDATE, ADD_MONTHS(SYSDATE, -1) PREV_MONTH,
		ADD_MONTHS(SYSDATE, 12) NEXT_YEAR
FROM dual;

-- CURRENT_DATE
/* returns the current date in the Gregorian calendar for the session’s (client) time zone.*/
ALTER SESSION SET NLS_DATE_FORMAT='DD-Mon-YYYY HH24:MI:SS';
SELECT SYSDATE, CURRENT_DATE FROM dual;

ALTER SESSION SET TIME_ZONE = 'US/Eastern';
SELECT SYSDATE, CURRENT_DATE FROM dual;

-- CURRENT_TIMESTAMP([p])
/* returns the current date and time in the session’s time zone to p digits
of precision. p can be an integer 0 through 9 and defaults to 6 */
SELECT CURRENT_DATE, CURRENT_TIMESTAMP FROM dual;

-- DBTIMEZONE
/* returns the database’s time zone, as set by the latest CREATE DATABASE or ALTER
DATABASE SET TIME_ZONE statement */
SELECT DBTIMEZONE FROM dual;

-- EXTRACT(c FROM dt)
/* extracts and returns the specified component c of date/time or interval
expression dt. The valid components are YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, TIMEZONE_
HOUR, TIMEZONE_MINUTE, TIMEZONE_REGION, and TIMEZONE_ABBR. */
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE) year_d
FROM dual;

SELECT LOCALTIMESTAMP,
		EXTRACT(YEAR FROM LOCALTIMESTAMP) YEAR_TS,
		EXTRACT(DAY FROM LOCALTIMESTAMP) DAY_TS,
		EXTRACT(SECOND FROM LOCALTIMESTAMP) SECOND_TS
FROM dual;

-- FROM_TZ(ts, tz)
/* returns a TIMESTAMP WITH TIME ZONE for the timestamp ts using
time zone value tz. */
SELECT LOCALTIMESTAMP, FROM_TZ(LOCALTIMESTAMP, 'Japan') Japan,
FROM_TZ(LOCALTIMESTAMP, '-5:00') Central
FROM dual;

-- LAST_DAY(d)
/* This function returns the last day
of the month for the date d. The return datatype is DATE. */
SELECT SYSDATE,
		LAST_DAY(SYSDATE) END_OF_MONTH,
		LAST_DAY(SYSDATE)+1 NEXT_MONTH
FROM dual;

-- MONTHS_BETWEEN(d1, d2)
/* This function returns the number of months that d2 is later than d1.*/
SELECT MONTHS_BETWEEN('31-MAR-08', '30-SEP-08') E1,
	   MONTHS_BETWEEN('11-MAR-08', '30-SEP-08') E2,
	   MONTHS_BETWEEN('01-MAR-08', '30-SEP-08') E3,
	   MONTHS_BETWEEN('31-MAR-08', '30-SEP-07') E4
FROM dual;

-- NEW_TIME(d>, tz1, tz2)
/* This function returns the date in time zone tz2 for date d in
time zone tz1. */
SELECT SYSDATE Dallas, NEW_TIME(SYSDATE, 'CDT', 'HDT') Hawaii
FROM dual;

-- NEXT_DAY(d, dow) dow is a text string containing the full or abbreviated day of the week
/* This function returns the next dow following d.*/
SELECT SYSDATE, NEXT_DAY(SYSDATE,'Thu') NEXT_THU,
NEXT_DAY('31-OCT-2008', 'Tue') Election_Day
FROM dual;

-- ROUND(<d> [,fmt])
/* This function returns d rounded to the granularity specified
in fmt. If fmt is omitted, d is rounded to the nearest day. */
SELECT SYSDATE, ROUND(SYSDATE,'HH24') ROUND_HOUR,
	ROUND(SYSDATE) ROUND_DATE, ROUND(SYSDATE,'MM') NEW_MONTH,
	ROUND(SYSDATE,'YY') NEW_YEAR
FROM dual;

-- SESSIONTIMEZONE
/* returns the database’s time zone offset as per
the last ALTER SESSION statement. SESSIONTIMEZONE will default to DBTIMEZONE if it is not
changed with an ALTER SESSION statement. */
SELECT DBTIMEZONE, SESSIONTIMEZONE
FROM dual;

-- SYS_EXTRACT_UTC(ts)
/* This function returns the UTC (GMT) time for the timestamp ts. */
SELECT CURRENT_TIMESTAMP local,
SYS_EXTRACT_UTC(CURRENT_TIMESTAMP) GMT
FROM dual;

-- TRUNC(d [,fmt])
/* This function returns d truncated to the granularity specified
in fmt. */
SELECT SYSDATE, TRUNC(SYSDATE,'HH24') CURR_HOUR,
TRUNC(SYSDATE) CURR_DATE, TRUNC(SYSDATE,'MM') CURR_MONTH,
TRUNC(SYSDATE,'YY') CURR_YEAR
FROM dual;

-- TZ_OFFSET(tz)
/* This function returns the numeric time zone offset for a textual time zone name. */
SELECT TZ_OFFSET(SESSIONTIMEZONE) NEW_YORK,
TZ_OFFSET('US/Pacific') LOS_ANGELES,
TZ_OFFSET('Europe/London') LONDON,
TZ_OFFSET('Asia/Singapore') SINGAPORE
FROM dual;