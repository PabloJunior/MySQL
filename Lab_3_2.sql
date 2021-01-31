/* Найти имена сотрудников, получивших за годы начисления зарплаты минимальную зарплату. */
SELECT EMP.EMPNAME, SALARY.SALVALUE FROM EMP NATURAL JOIN SALARY 
WHERE SALARY.SALVALUE = (SELECT MIN(SALARY.SALVALUE) FROM SALARY);


/* Найти имена сотрудников, работавших или работающих в тех же отделах, в
которых работал или работает сотрудник с именем RICHARD MARTIN. */
SELECT EMP.EMPNAME FROM EMP 
NATURAL JOIN CAREER WHERE CAREER.DEPTNO   
IN ( SELECT CAREER.DEPTNO  FROM CAREER 
NATURAL JOIN EMP WHERE EMP.EMPNAME = 'RICHARD MARTIN')   
AND EMP.EMPNAME != 'RICHARD MARTIN'   
GROUP BY EMP.EMPNAME;


/* Найти имена сотрудников, работавших или работающих в тех же отделах и
должностях, что и сотрудник 'RICHARD MARTIN' */
SELECT EMP.EMPNAME FROM EMP 
NATURAL JOIN CAREER WHERE (CAREER.DEPTNO, CAREER.JOBNO)   
IN (SELECT CAREER.DEPTNO, CAREER.JOBNO FROM CAREER 
NATURAL JOIN EMP WHERE EMP.EMPNAME = 'RICHARD MARTIN')   
AND EMP.EMPNAME != 'RICHARD MARTIN'   
GROUP BY EMP.EMPNAME;


/* Найти сведения о номерах сотрудников, получивших за какой-либо месяц 
зарплату большую, чем средняя зарплата за 2007 г. или большую чем средняя 
зарплата за 2008г. */
SELECT DISTINCT EMPNO FROM SALARY 
WHERE SALVALUE > ANY( (SELECT AVG(SALVALUE) FROM SALARY WHERE YEAR=2007 ), 
(SELECT AVG(SALVALUE) FROM SALARY WHERE YEAR=2008 ) );


/* Найти сведения о номерах сотрудников, получивших зарплату за какой-либо месяц 
большую, чем средние зарплаты за все годы начислений. */
SELECT DISTINCT EMPNO FROM SALARY   
WHERE SALVALUE > ALL (SELECT AVG(SALVALUE) FROM SALARY GROUP BY YEAR) ;


/* Определить годы, в которые начисленная средняя зарплата 
была больше средней зарплаты за все годы начислений. */
SELECT YEAR FROM SALARY GROUP BY YEAR   
HAVING AVG(SALVALUE) > (SELECT AVG(SALVALUE) FROM SALARY);


/* Определить номера отделов, в которых работали или 
работают сотрудники, имеющие начисления зарплаты. */ 
SELECT DISTINCT DEPTNO FROM DEPT
WHERE DEPTNO IN (SELECT DEPTNO FROM CAREER
NATURAL JOIN EMP NATURAL JOIN SALARY WHERE SALARY.SALVALUE IS NOT NULL)
ORDER BY DEPTNO;


/* Определить номера отделов, в которых работали или 
работают сотрудники, имеющие начисления зарплаты. */
SELECT DISTINCT DEPTNO FROM CAREER 
WHERE EXISTS (SELECT * FROM SALARY WHERE SALARY.EMPNO = CAREER.EMPNO) 
AND DEPTNO IS NOT NULL 
ORDER BY DEPTNO;


/* Определить номера отделов, для сотрудников 
которых не начислялась зарплата. */
SELECT DISTINCT DEPTNO FROM CAREER 
WHERE NOT EXISTS (SELECT * FROM SALARY WHERE SALARY.EMPNO = CAREER.EMPNO) 
AND DEPTNO IS NOT NULL 
ORDER BY DEPTNO;


/* Вывести сведения о карьере сотрудников с указанием 
названий и адресов отделов вместо номеров отделов. */
SELECT E.EMPNAME, D.DEPTNAME, D.DEPTADDR, C.STARTDATE,C.ENDDATE FROM EMP E 
NATURAL JOIN CAREER C 
NATURAL JOIN DEPT D;


/* Определить целую часть средних зарплат, по годам начисления */
SELECT YEAR, AVG(SALVALUE) AS AVERAGE_SALVALUE,  
CAST(AVG(SALVALUE) AS NUMBER(5)) AS INT_AVERAGE_SALVALUE  
FROM SALARY GROUP BY YEAR ORDER BY YEAR;


/* Разделите сотрудников на возрастные группы: 
A) возраст 20-30 лет; B) 31-40 лет; C) 41-50;    D) 51-60 или возраст не определён. */
SELECT EMPNAME,FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) AS AGE,   
CASE  
    WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) >= 20   
     AND FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) <= 30 THEN 'A'   
    WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) >= 31   
     AND FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) <= 40 THEN 'B'   
    WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) >= 41   
     AND FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) <= 50 THEN 'C'   
    WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) >= 51   
     AND FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12) <= 60 THEN 'D'   
    WHEN BIRTHDATE IS NULL THEN 'D'   
    ELSE 'D'  
END AS AGE_GROUP FROM EMP;


/* Перекодируйте номера отделов, добавив перед номером отдела 
буквы BI для номеров <=20, буквы LN для номеров >=30. */
SELECT DEPTNO,  
CASE 
    WHEN DEPTNO <= 20 THEN CONCAT('BI', CAST(DEPTNO AS VARCHAR(5)))  
    WHEN DEPTNO >= 30 THEN CONCAT('LN', CAST(DEPTNO AS VARCHAR(5)))  
    ELSE CAST(DEPTNO AS VARCHAR(5)) 
END AS CHANGED_DEPTNO FROM DEPT;


/* Выдать информацию о сотрудниках из таблицы EMP, 
заменив отсутствие данного о дате рождения датой '01-01-1000'. */
SELECT EMPNAME, BIRTHDATE,   
COALESCE(BIRTHDATE, TO_DATE('01-01-1000', 'DD-MM-YYYY')) AS CHANGED_BIRTHDATE   
FROM EMP;

