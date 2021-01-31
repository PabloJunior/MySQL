/* Выдать информацию о местоположении отдела продаж (SALES) компании. */
SELECT  DEPTNAME, DEPTADDR FROM  DEPT     
WHERE  DEPTNAME  =  'SALES';


/* Выдать информацию об отделах, расположенных в Chicago и New York. */
SELECT  * FROM  DEPT   
WHERE  DEPTADDR  IN ('CHICAGO', 'NEW YORK');


/* Найти минимальную заработную плату, начисленную в 2009 году. */
SELECT MIN(SALVALUE) FROM SALARY   
WHERE YEAR = 2009;


/* Выдать информацию обо всех работниках, родившихся не позднее 1 января 1960 года. */
SELECT * FROM EMP  
WHERE BIRTHDATE <= TO_DATE('01-01-1960','DD-MM-YYYY');


/* Подсчитать число работников, сведения о которых имеются в базе данных. */
SELECT COUNT(*) FROM EMP;


/* Найти работников, чьё имя состоит из одного слова. 
Имена выдать на нижнем регистре, с удалением стоящей справа буквы t. */
SELECT RTRIM(LOWER(EMPNAME), 't')  AS RESULT FROM EMP  
WHERE EMPNAME NOT LIKE('% %');


/* Выдать информацию о работниках, указав дату рождения в формате 
день(число), месяц(название), год(название). */
SELECT EMPNAME, EMPNO, TO_CHAR(BIRTHDATE, 'DD-MONTH-YEAR') AS BIRTHDATE FROM EMP;


/* Тоже, но год числом */
SELECT EMPNAME, EMPNO, TO_CHAR(BIRTHDATE, 'DD-MONTH-YYYY') AS BIRTHDATE FROM EMP;


/* Выдать информацию о должностях, изменив названия 
должности “CLERK” и “DRIVER” на “WORKER”. */
SELECT JOBNO,    
CASE    
    WHEN JOBNAME IN ('CLERK','DRIVER') THEN 'WORKER'      
    ELSE JOBNAME  
END AS JOBNAME, MINSALARY FROM JOB;


/* Определите среднюю зарплату за годы, в которые были начисления 
не менее чем за три месяца. */
SELECT YEAR, AVG(SALVALUE) FROM SALARY   
GROUP BY YEAR HAVING COUNT(MONTH) >2;


/* Выведете ведомость получения зарплаты с указанием имен служащих. */
SELECT EMP.EMPNAME, SALARY.MONTH, SALARY.SALVALUE 
FROM EMP, SALARY WHERE EMP.EMPNO = SALARY.EMPNO;


/* Укажите сведения о начислении сотрудникам зарплаты, попадающей в вилку: 
минимальный оклад по должности - минимальный оклад по должности плюс пятьсот. 
Укажите соответствующую вилке должность */
SELECT EMP.EMPNAME, JOB.JOBNAME, SALARY.SALVALUE, JOB.MINSALARY 
FROM SALARY, EMP, CAREER, JOB 
WHERE SALARY.EMPNO=EMP.EMPNO 
AND CAREER.EMPNO=EMP.EMPNO 
AND JOB.JOBNO=CAREER.JOBNO 
AND SALARY.SALVALUE BETWEEN JOB.MINSALARY AND JOB.MINSALARY + 500;


/* Укажите сведения о заработной плате, совпадающей с минимальными окладами 
по должностям (с указанием этих должностей). */
SELECT EMP.EMPNAME, SALARY.SALVALUE, JOB.JOBNAME, JOB.MINSALARY FROM SALARY    
INNER JOIN EMP ON SALARY.EMPNO = EMP.EMPNO    
INNER JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO    
INNER JOIN JOB ON CAREER.JOBNO = JOB.JOBNO  
WHERE SALARY.SALVALUE = JOB.MINSALARY;


/* Найдите сведения о карьере сотрудников с указанием вместо номера 
сотрудника его имени. */
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP  
NATURAL JOIN CAREER;


/* Найдите сведения о карьере сотрудников с указанием вместо 
номера сотрудника его имени */
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP  
INNER JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO;


/* Выдайте сведения о карьере сотрудников с указанием их имён, 
наименования должности, и названия отдела. */
SELECT EMP.EMPNAME, DEPT.DEPTNAME, JOB.JOBNAME, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP 
INNER JOIN CAREER ON CAREER.EMPNO = EMP.EMPNO 
INNER JOIN JOB ON CAREER.JOBNO = JOB.JOBNO  
INNER JOIN DEPT ON CAREER.DEPTNO = DEPT.DEPTNO;


/*  Выдайте сведения о карьере сотрудников с указанием их имён. */
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP   
LEFT JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO;


/* Составьте запрос с использованием противоположного вида соединения. */
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP   
RIGHT JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO;


/* Составьте запрос с использованием полного внешнего соединения. */
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP   
FULL JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO;

