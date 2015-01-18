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
FROM dual;

SELECT 'otra*prueba*initcap', INITCAP('otra*prueba*initcap') 
FROM dual;

-- INSTR(c1,c2[,i[,j]])
/* This function returns the numeric character position in c1 where the j
occurrence of c2 is found. The search begins at the i character position in c1. INSTR returns
a 0 when the requested string is not found. If i is negative, the search is performed backward,
from right to left, but the position is still counted from left to right. Both i and j
default to 1, and j cannot be negative. */

SELECT INSTR(3 + 0.14, '.') 
FROM dual;

SELECT INSTR(sysdate, 'DEC') 
FROM dual;

SELECT INSTR('1#3#5#7#9#', '#') 
FROM dual;

SELECT INSTR('1#3#5#7#9#', '#', 5) 
FROM dual;

SELECT INSTR('1#3#5#7#9#', '#', 3, 4) 
FROM dual;

SELECT * FROM departments
WHERE INSTR(department_name, 'on') = 2;

-- LENGTH(c)
/* This function returns the numeric length in characters of c. 
If c is NULL, a NULL is returned.*/

SELECT LENGTH(1 + 2.14 || ' approximates pi') 
FROM dual;

SELECT LENGTH(SYSDATE) 
FROM dual;

SELECT * FROM countries
WHERE LENGTH(country_name) > 10;

-- LOWER(c)
/* This function returns the character string c with all 
characters in lowercase. */
SELECT LOWER('Hola mundo') 
FROM dual;

SELECT LOWER(100 + 100) 
FROM dual;

SELECT LOWER('The SUM ' || '100+100' || ' = 200') 
FROM dual;

SELECT LOWER(SYSDATE) 
FROM dual;

SELECT LOWER(SYSDATE + 2) 
FROM dual;

SELECT first_name, last_name, LOWER(last_name)
FROM employees
WHERE LOWER(last_name) LIKE '%ur%';

-- LPAD(c1, i [,c2])
/* This function returns the character string c1 expanded in length to i characters,
using c2 to fill in space as needed on the left side of c1. If c1 is more than i characters, it is
truncated to i characters. c2 defaults to a single space */

SELECT LPAD(1000 + 200.55, 14, '*') 
FROM dual;

SELECT LPAD(SYSDATE, 14, '$#') 
FROM dual;

SELECT LPAD(last_name, 10) lpad_lname,
	   LPAD(salary, 8, '*') lpad_salary
FROM employees
WHERE last_name like 'J%';

-- RPAD(c1, i [, c2])
/* This function returns the character string c1 expanded in length to i characters,
using c2 to fill in space as needed on the right side of c1. If c1 is more than i characters, it
is truncated to i characters. c2 defaults to a single space.*/

SELECT RPAD(1000 + 200.55, 14, '*')
FROM dual;

SELECT RPAD(SYSDATE, 4, '$#')
FROM dual;

SELECT RPAD(first_name, 15, '.') rpad_fname, LPAD(job_id, 12, '.') lpad_jid
FROM employees
WHERE first_name LIKE 'B%';

-- REPLACE(c1, c2 [,c3])
/* This function returns c1 with all occurrences of c2 replaced with c3. c3 defaults to NULL. If
c3 is NULL, all occurrences of c2 are removed. If c2 is NULL, then c1 is returned unchanged.
If c1 is NULL, then NULL is returned. */

SELECT REPLACE('uptown', 'up', 'down') 
FROM dual;

SELECT REPLACE(10000-3, '9', '85') 
FROM dual;

SELECT REPLACE(SYSDATE, '01', '08') 
FROM dual

SELECT last_name, salary, REPLACE(salary, '0', '000') "Dream salary"
FROM employees
WHERE job_id = 'SA_MAN';

-- SUBSTR(c1, x [, y])
/* This function returns the portion of c1 that is y characters long, beginning
at position x. If x is negative, the position is counted backward (that is, right to left). This
function returns NULL if y is 0 or negative. y defaults to the remainder of string c1. */

SELECT SUBSTR(10000-3, 3, 2)
FROM dual;

SELECT SUBSTR(SYSDATE, 4, 3)
FROM dual;

SELECT SUBSTR('1#3#5#7#9#', 5)
FROM dual;

SELECT SUBSTR('1#3#5#7#9#', 5, 6)
FROM dual;

SELECT SUBSTR('1#3#5#7#9#', -3, 2)
FROM dual;

SELECT 'Advertising Team Member' || SUBSTR(first_name, 1, 1)
|| '. ' || last_name "Name"
FROM employees
WHERE SUBSTR(job_id, 1, 2) = 'AD';

-- Execute as sys
-- extract only the filename from dba_data_files without the path name
SELECT file_name, 
	   SUBSTR(file_name, INSTR(file_name,'\', -1,1)+1) name --'
FROM dba_data_files;

-- TRIM([[c1] c2 FROM ] c3)
/* If present, c1 can be one of the following literals: LEADING, TRAILING, or BOTH. This function
returns c3 with all c1 (leading, trailing, or both) occurrences of characters in c2 removed.
A NULL is returned if any of c1, c2, or c3 is NULL. c1 defaults to BOTH. c2 defaults to a space
character. c3 is the only mandatory argument. If c2or c3 is NULL, the function returns a NULL.*/

SELECT TRIM('   fully padded   ') test1,
	   TRIM('   left padded') test2,
	   TRIM('right padded   ') test3
FROM dual;

SELECT TRIM(TRAILING 'e' from 1+2.14||' is pie') 
FROM dual;

SELECT TRIM(BOTH '*' from '*******Hidden*******') 
FROM dual;

-- UPPER(c)
/* This function returns
the character string c with all characters in uppercase.*/

SELECT UPPER(1+2.14) 
FROM dual;

SELECT UPPER(SYSDATE) 
FROM dual;

SELECT * FROM countries
WHERE UPPER(country_name) LIKE '%U%S%A%';


--*** Using Single-Row Numeric Functions
-- Most important are ROUND, TRUNC and MOD

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

---- MOD(n1, n2)
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
FROM dual;

/* The difference between MOD and REMAINDER is that MOD uses the FLOOR function, whereas
REMAINDER uses the ROUND function in the formula. */
SELECT MOD(13,5), MOD(12,5), MOD(12.5, 5)
FROM dual;

----- ROUND(n1 [,n2])
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

----- TRUNC(n1 [,n2])
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
WHERE first_name like 'J%';

--*** Using Single-Row Date Functions
--Most important are ADD_MONTHS, MONTHS_BETWEEN, LAST_DAY, NEXT_DAY, 
--ROUND, and TRUNC

-- Date-Format Conversion
SELECT SYSDATE FROM dual;
ALTER SESSION SET NLS_DATE_FORMAT='DD-Mon-YYYY HH24:MI:SS';

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

----- ADD_MONTHS(d, i)
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

----- LAST_DAY(d)
/* This function returns the last day
of the month for the date d. The return datatype is DATE. */
SELECT SYSDATE,
		LAST_DAY(SYSDATE) END_OF_MONTH,
		LAST_DAY(SYSDATE) + 1 NEXT_MONTH
FROM dual;

----- MONTHS_BETWEEN(d1, d2)
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

----- NEXT_DAY(d, dow) dow is a text string containing the full or abbreviated day of the week
/* This function returns the next dow following d.*/
SELECT SYSDATE, NEXT_DAY(SYSDATE,'Thu') NEXT_THU,
NEXT_DAY('31-OCT-2008', 'Tue') Election_Day
FROM dual;

----- ROUND(<d> [,fmt])
/* This function returns d rounded to the granularity specified
in fmt. If fmt is omitted, d is rounded to the nearest day. */
SELECT SYSDATE, ROUND(SYSDATE, 'HH24') ROUND_HOUR,
	ROUND(SYSDATE) ROUND_DATE, ROUND(SYSDATE, 'MM') NEW_MONTH,
	ROUND(SYSDATE, 'YY') NEW_YEAR
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

----- TRUNC(d [,fmt])
/* This function returns d truncated to the granularity specified
in fmt. */
SELECT SYSDATE, TRUNC(SYSDATE, 'HH24') CURR_HOUR,
TRUNC(SYSDATE) CURR_DATE, TRUNC(SYSDATE, 'MM') CURR_MONTH,
TRUNC(SYSDATE, 'YY') CURR_YEAR
FROM dual;

-- TZ_OFFSET(tz)
/* This function returns the numeric time zone offset for a textual time zone name. */
SELECT TZ_OFFSET(SESSIONTIMEZONE) NEW_YORK,
TZ_OFFSET('US/Pacific') LOS_ANGELES,
TZ_OFFSET('Europe/London') LONDON,
TZ_OFFSET('Asia/Singapore') SINGAPORE
FROM dual;

--*** Using Single-Row Conversion Functions

-- ASCIISTR(c1)
/* This function returns
the ASCII equivalent of all the characters in c1. This function leaves ASCII characters
unchanged, but non-ASCII characters are returned in the format \xxxx where xxxx represents
a UTF-16 code unit. */
SELECT ASCIISTR('cañon') E1, ASCIISTR('faß') E2
FROM dual;

-- BIN_TO_NUM(b), b is a comma-delimited list of bits
/* This function returns the numeric representation of all the bit-field set b. It essentially converts a
base 2 number into a base 10 number */
SELECT BIN_TO_NUM(1,1,0,1) bitfield1,
	   BIN_TO_NUM(0,0,0,1) bitfield2,
	   BIN_TO_NUM(1,1) bitfield3
FROM dual;

-- CAST(exp AS t)
/* This function converts the expression exp into the datatype t */
SELECT CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE) DT_2_TS
FROM dual;

-- CHARTOROWID(c)
/* This function returns c as a ROWID datatype. */
/*Each row in the database is uniquely identified by a ROWID. ROWID shows
the physical location of the row stored in the database.*/
SELECT rowid, first_name
FROM employees
WHERE first_name = 'Sarath';

SELECT first_name, last_name
FROM employees
WHERE rowid = CHARTOROWID('AAARAgAAFAAAABYAA9');

-- CONVERT(c, dset [,sset]) dset and sset are character-set names
/* This function returns the character string c converted
from the source character set sset to the destination character set dset */
SELECT CONVERT('vis-à-vis', 'AL16UTF16', 'AL32UTF8')
FROM dual;

-- NUMTODSINTERVAL(x , c)
/* This function converts the number x into an INTERVAL
DAY TO SECOND datatype. */
SELECT SYSDATE,
		SYSDATE + NUMTODSINTERVAL(2, 'HOUR') "2 hours later",
		SYSDATE + NUMTODSINTERVAL(30, 'MINUTE') "30 minutes later"
FROM dual;

-- NUMTOYMINTERVAL(x , c)
/* This function converts the number x into an INTERVAL
YEAR TO MONTH datatype. */
SELECT SYSDATE,
		SYSDATE+NUMTOYMINTERVAL(2,’YEAR’) "2 years later",
		SYSDATE+NUMTOYMINTERVAL(5,’MONTH’) "5 months later"
FROM dual;

-- ROWIDTOCHAR(c)
/* This function returns the ROWID string c converted to a VARCHAR2 datatype.
No translation is performed; only the datatype is changed */
SELECT ROWIDTOCHAR(ROWID) Char_RowID, first_name
FROM employees
WHERE first_name = 'Sarath';

-- SCN_TO_TIMESTAMP (n)
/* This function returns the timestamp associated with the SCN. 
An SCN is a number that gets incremented when a commit occurs in the database. The
SCN identifies the state of the database uniquely */
SELECT SCN_TO_TIMESTAMP(ORA_ROWSCN) mod_time, last_name
FROM employees
WHERE first_name = 'Lex';

-- TIMESTAMP_TO_SCN (<ts>)
/* identify the SCN associated with a particular timestamp. */
SELECT TIMESTAMP_TO_SCN('14-JAN-14 09.52.20') DB_SCN
FROM dual;

-- TO_BINARY_DOUBLE(<expr> [,<fmt> [,<nlsparm>] ])
/* where expr is
a character or numeric string, fmt is a format string specifying the format that c appears in,
and nlsparm specifies language- or location-formatting conventions */
/* This function returns a binary double-precision floating-point number 
of datatype BINARY_DOUBLE represented by expr. */
SELECT TO_BINARY_DOUBLE('1234.5678','999999.9999') CHR_FMT_DOUBLE,
TO_BINARY_DOUBLE('1234.5678') CHR_DOUBLE,
TO_BINARY_DOUBLE(1234.5678) NUM_DOUBLE,
TO_BINARY_DOUBLE('INF') INF_DOUBLE
FROM dual;

-- TO_BINARY_FLOAT(<expr> [,<fmt> [,<nlsparm>] ])
/* This function returns a binary single-precision floating-point 
number of datatype BINARY_FLOAT represented by expr. */
SELECT TO_BINARY_FLOAT('1234.5678','999999.9999') CHR_FMT_FLOAT,
		TO_BINARY_FLOAT('1234.5678') CHR_FLOAT,
		TO_BINARY_FLOAT(1234.5678) NUM_FLOAT,
		TO_BINARY_FLOAT('INF') INF_FLOAT
FROM dual;

/* NOTE: Converting from a character or NUMBER to BINARY_FLOAT and BINARY_
DOUBLE may not be exact since BINARY_FLOAT and BINARY_DOUBLE
use binary precision, whereas NUMBER uses decimal precision*/

-- TO_CHAR(<expr> [,<fmt >[,<nlsparm>] ])
/* This function returns expr converted into a character string (the VARCHAR2 datatype) */
SELECT TO_CHAR(SYSDATE,'Day Ddspth,Month YYYY'
 	,'NLS_DATE_LANGUAGE=German') Today_Heute
FROM dual;

SELECT TO_CHAR(SYSDATE ,'"On the "Ddspth" day of "Month, YYYY') Today
FROM dual;

/* For any of the numeric codes, the ordinal and/or spelled-out representation can be displayed
with the modifier codes th (for ordinal) and sp (for spelled out). Here is an example: */
SELECT SYSDATE,
TO_CHAR(SYSDATE,'Mmspth') Month,
TO_CHAR(SYSDATE,'DDth') Day,
TO_CHAR(SYSDATE,'Yyyysp') Year
FROM dual;

-- TO_DATE(<c> [,<fmt> [,<nlsparm>] ])
/* This function returns c converted into the DATE datatype. */
alter session set nls_date_format = 'DD-MON-RR HH24:MI:SS';

SELECT TO_DATE('30-SEP-2007', 'DD/MON/YY') DateExample
FROM dual;

SELECT TO_DATE('SEP-2007 13', 'MON/YYYY HH24') DateExample
FROM dual;

--** Converting Numbers to Words
SELECT TO_CHAR(TO_DATE(&NUM, 'J'), 'jsp') num_to_spell
FROM dual;

-- TO_DSINTERVAL(<c> [,<nlsparm>])
/* This function returns c converted into an INTERVAL DAY TO SECOND */
SELECT SYSDATE,
		SYSDATE+TO_DSINTERVAL('007 12:00:00') "+7 1/2 days",
		SYSDATE+TO_DSINTERVAL('030 00:00:00') "+30 days"
FROM dual;

-- TO_NUMBER(<expr> [,<fmt> [,<nlsparm>] ])
/* This function returns the numeric value represented by expr. */
SELECT TO_NUMBER('234.89'), TO_NUMBER(1E-3) FROM dual;

-- TO_TIMESTAMP(<c> [,<fmt> [,<nlsparm>] ])
/* The return value is of the TIMESTAMP datatype. */
SELECT TO_TIMESTAMP('30-SEP-2007 08:51:23.456',
'DD-MON-YYYY HH24:MI:SS.FF')
FROM dual;

-- TO_TIMESTAMP(<c> [,<fmt> [,<nlsparm>] ])
/* The return datatype is TIMESTAMP WITH TIME ZONE. */
SELECT TO_TIMESTAMP_TZ('30-SEP-2007 08:51:23.456',
		'DD-MON-YYYY HH24:MI:SS.FF') TS_TZ_Example
FROM dual;

-- TO_YMINTERVAL(<c>)
/* This function returns c converted into an INTERVAL YEAR TO MONTH datatype. */
SELECT SYSDATE,
SYSDATE+TO_YMINTERVAL('01-03') "+15 months",
SYSDATE-TO_YMINTERVAL('00-03') "-3 months"
FROM dual;

-- UNISTR(<c>)
/* This function returns c in Unicode in the database Unicode character set. */
SELECT UNISTR('\00A3'), UNISTR('\00F1'), UNISTR('ca\00F1on')
FROM dual;

-- DECODE(x ,m1, r1 [,m2 ,r2]…[,d])
/* x is an expression. m1
is a matching expression to compare with x. If m1 is equivalent to x, then r1 is returned;
otherwise, additional matching expressions (m2, m3, m4, and so on) are compared, if they
are included, and the corresponding result (r2, r3, r4, and so on) is returned. If no match is
found and the default expression d is included, then d is returned.*/
SELECT country_id, country_name, region_id,
		DECODE(region_id, 1, 'Europe',
						  2, 'Americas',
						  3, 'Asia',
							 'Other') Region
FROM countries
WHERE SUBSTR(country_id,1,1) = 'I'
		OR SUBSTR(country_id,2,1) = 'R';

-- GREATEST(exp_list)
/* This function returns the expression that sorts highest in the 
datatype of the first expression. */
SELECT GREATEST('01-ARP-08','30-DEC-01','12-SEP-09')
FROM dual;

-- SELECT GREATEST(345, ‘XYZ’, 2354) FROM dual; -- Error
SELECT GREATEST('XYZ', 345, 2354) FROM dual;

-- LEAST(exp_list)
/* This function returns the expression that sorts lowest in the 
datatype of the first expression */
SELECT LEAST(SYSDATE,'15-MAR-2002','17-JUN-2002') oldest
FROM dual;

/* The following SQL is used to calculate a bonus of 15 percent of salary to employees,
with a maximum bonus at 500 and a minimum bonus at 400: */
SELECT last_name, salary, GREATEST(LEAST(salary*0.15, 500), 400) bonus
FROM employees
WHERE department_id IN (30, 10)
ORDER BY last_name;

/* To remember the comparison rules for trailing and leading space in character
literals, think “leading equals least.” */

-- NULLIF(x1 , x2)
/* This function returns NULL if x1 equals x2; otherwise, 
it returns x1. If x1 is NULL, NULLIF returns NULL. */
SELECT ename, mgr, comm
		NULLIF(comm,0) test1,
		NULLIF(0,comm) test2,
		NULLIF(mgr,comm) test3
FROM scott.emp
WHERE empno IN (7844,7839,7654,7369);

-- SYS_GUID()
/* GUID() returns a 32-bit hexadecimal representation of the 16-byte RAW value. */
SELECT SYS_GUID() FROM DUAL;

-- UID
/* returns the integer user ID for the current user connected to
the session. */
SELECT username, account_status
FROM dba_users
WHERE user_id = UID;

-- USER
/* returns a character string containing the username for the
current user.*/
SELECT default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = USER;