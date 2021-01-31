/* Поднимите нижнюю границу минимальной заработной платы в таблице JOB до 1000$. */

SELECT * FROM JOB;

UPDATE JOB
SET MINSALARY = 1000
WHERE MINSALARY < 1000;

SELECT * FROM JOB;


/* Поднимите минимальную зарплату в таблице JOB на 10% 
для всех специальностей, кроме финансового директора. */

SELECT * FROM JOB;

UPDATE JOB
SET MINSALARY = 1.1 * MINSALARY
WHERE JOBNAME NOT IN ('FINANCIAL DIRECTOR');

SELECT * FROM JOB;


/* Поднимите минимальную зарплату в таблице JOB на 10% для клерков и 
на 20% для финансового директора (одним оператором). */

SELECT * FROM JOB;

UPDATE JOB SET MINSALARY =
CASE
    WHEN JOBNAME = 'CLERK' THEN 1.1*MINSALARY
    WHEN JOBNAME = 'FINANCIAL DIRECTOR' THEN 1.2*MINSALARY
    ELSE MINSALARY
END;

SELECT * FROM JOB;
 

/* Установите минимальную зарплату финансового директора 
равной 90% от зарплаты исполнительного директора. */

SELECT * FROM JOB;

UPDATE JOB
SET MINSALARY = 0.9 * (SELECT MINSALARY FROM JOB
WHERE JOBNAME = 'EXECUTIVE DIRECTOR')
WHERE JOBNAME = 'FINANCIAL DIRECTOR';

SELECT * FROM JOB;



/* Приведите в таблице EMP имена служащих, 
начинающиеся на букву ‘J’, к нижнему регистру. */

SELECT * FROM EMP;

UPDATE EMP
SET EMPNAME = LOWER(EMPNAME)
WHERE EMPNAME LIKE 'J%';

SELECT * FROM EMP;



/* Измените в таблице EMP имена служащих, состоящие из двух слов, 
так, чтобы оба слова в имени начинались с заглавной буквы, а продолжались прописными. */

SELECT * FROM EMP;

UPDATE EMP
SET EMPNAME=INITCAP(EMPNAME)
WHERE EMPNAME LIKE('% %');

SELECT * FROM EMP;


/* Приведите в таблице EMP имена служащих к верхнему регистру. */
 
SELECT * FROM EMP;

UPDATE EMP
SET EMPNAME=UPPER(EMPNAME);

SELECT * FROM EMP;

/* Перенесите отдел исследований (RESEARCH) в тот же город, 
в котором расположен отдел продаж (SALES). */

SELECT * FROM DEPT;

UPDATE DEPT
SET DEPTADDR = (SELECT DEPTADDR FROM DEPT
WHERE DEPTNAME = 'SALES')
WHERE DEPTNAME = 'RESEARCH';

SELECT * FROM DEPT;

/* Добавьте нового сотрудника в таблицу EMP. Его имя и фамилия должны совпадать с Вашими, 
записанными латинскими буквами согласно паспорту, дата рождения также совпадает с Вашей. */

SELECT * FROM EMP;

INSERT INTO EMP (EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID)
VALUES (7999, 'PAVEL MOUSORSKY', TO_DATE('04-06-1999','DD-MM-YYYY'),'');

SELECT * FROM EMP;

/* Определите нового сотрудника (см. предыдущее задание) на работу в бухгалтерию
(отдел ACCOUNTING), начиная с текущей даты.

Отмечу, что из результатов задания 8 видно, что отдел ACCOUNTING имеет DEPTNO 10. 
В свою очередь, анализируя таблицу CAREER, видно, что DEPTNO 10 соответствуют следующие 
значения поля JOBNO: 1004, 1003, 1001. Исходя из таблицы JOB эти значения кодируют 
следующие профессии соответственно: CLERK, SALESMAN, MANAGER.

SELECT * FROM CAREER;


INSERT INTO CAREER (JOBNO, EMPNO, DEPTNO, STARTDATE, ENDDATE)
VALUES ((SELECT JOBNO FROM JOB WHERE JOBNAME = 'CLERK'),
(SELECT EMPNO FROM EMP WHERE EMPNAME = 'PAVEL MOUSORSKY'),
(SELECT DEPTNO FROM DEPT WHERE DEPTNAME = 'ACCOUNTING'),
SYSDATE, NULL);

SELECT * FROM CAREER;


/* Удалите все записи из таблицы TMP_EMP. Добавьте в нее информацию о сотрудниках, 
которые работают клерками в настоящий момент.

DROP TABLE TMP_EMP; 
CREATE TABLE TMP_EMP AS
(SELECT * FROM EMP);
DELETE FROM TMP_EMP;

INSERT INTO TMP_EMP (EMPNO, EMPNAME, BIRTHDATE, MANAGER_ID)
SELECT EMP.EMPNO, EMP.EMPNAME, EMP.BIRTHDATE, EMP.MANAGER_ID
FROM EMP JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO
JOIN JOB ON CAREER.JOBNO = JOB.JOBNO
WHERE JOBNAME = 'CLERK' AND ENDDATE IS NULL;
SELECT * FROM TMP_EMP;


/* Добавьте в таблицу TMP_EMP информацию о тех сотрудниках, 
которые уже не работают на предприятии, а в период работы занимали только одну должность. */

SELECT * FROM TMP_EMP;

INSERT INTO TMP_EMP SELECT EM.* FROM EMP EM
INNER JOIN CAREER CA ON EM.EMPNO = CA.EMPNO
WHERE CA.ENDDATE IS NOT NULL
AND EM.EMPNO IN (SELECT E.EMPNO FROM EMP E
    INNER JOIN CAREER C ON E.EMPNO = C.EMPNO
    GROUP BY E.EMPNO
    HAVING COUNT(C.JOBNO) = 1
);

SELECT * FROM TMP_EMP;


/* Выполните тот же запрос для тех сотрудников, которые никогда 
не приступали к работе на предприятии. */

SELECT * FROM TMP_EMP;

INSERT INTO TMP_EMP SELECT * FROM EMP E
WHERE E.EMPNO IN (SELECT EMPNO FROM CAREER
WHERE STARTDATE IS NULL);

SELECT * FROM TMP_EMP;


/* Удалите все записи из таблицы TMP_JOB и добавьте в нее информацию 
по тем специальностям, которые не используются в настоящий момент на предприятии. */

DROP TABLE TMP_JOB; 
CREATE TABLE TMP_JOB AS
(SELECT * FROM JOB);
DELETE FROM TMP_JOB;

INSERT INTO TMP_JOB 
SELECT * FROM JOB 
WHERE JOBNO NOT IN (SELECT JOBNO FROM CAREER); 
SELECT * FROM TMP_JOB;

/* Начислите зарплату в размере 120% минимального должностного оклада 
всем сотрудникам, работающим на предприятии. Зарплату начислять по должности, 
занимаемой сотрудником в настоящий момент и отнести ее на прошлый месяц относительно текущей даты.

Поскольку на поле YEAR таблицы SALARY стоит ограничение, позволяющее задать год ввода 
лишь от 1988 до 2016, что не позволяет выдать зарплату в 2020-ом году, то зарплату буду начислять 
на 1988, дабы избежать путаницы с уже имеющимися в таблице значениями. Посему исходное и окончательное 
состояния таблицы будут отсортированы по годам по убыванию. */

SELECT * FROM SALARY
ORDER BY YEAR DESC;

INSERT INTO SALARY (EMPNO, SALVALUE, MONTH, YEAR)
SELECT C.EMPNO, 1.2 * J.MINSALARY, (EXTRACT(MONTH FROM SYSDATE) - 1) AS MONTH, 1988 /* (EXTRACT(YEAR FROM SYSDATE)-4) AS YEAR */
FROM CAREER C INNER JOIN JOB J ON C.JOBNO = J.JOBNO
WHERE C.STARTDATE IS NOT NULL AND C.ENDDATE IS NULL;

SELECT * FROM SALARY
ORDER BY YEAR DESC;

/* Удалите данные о зарплате за прошлый год.
Поскольку на поле YEAR таблицы SALARY стоит ограничение, позволяющее задать год ввода 
лишь от 1988 до 2016, то «прошлым годом» будет считаться конечный 2016-ый. */

SELECT * FROM SALARY
ORDER BY YEAR DESC;

DELETE FROM SALARY WHERE YEAR = 2016; /* EXTRACT(YEAR FROM CURRENT_DATE)-1*/

SELECT * FROM SALARY
ORDER BY YEAR DESC;


/* Удалите информацию о карьере сотрудников, которые в настоящий момент уже не работают 
на предприятии, но когда-то работали. */

SELECT * FROM CAREER;

DROP TABLE TMP_CAREER; 
CREATE TABLE TMP_CAREER AS
(SELECT EMPNO FROM CAREER
WHERE STARTDATE IS NOT NULL
AND ENDDATE IS NOT NULL
OR ENDDATE<=CURRENT_DATE);

DELETE FROM CAREER
WHERE EMPNO IN (SELECT * FROM TMP_CAREER);

SELECT * FROM CAREER;


/* Удалите информацию о начисленной зарплате сотрудников, 
которые в настоящий момент уже не работают на предприятии 
(можно использовать результаты работы предыдущего запроса) */

SELECT * FROM SALARY;

DELETE FROM SALARY
WHERE EMPNO IN (SELECT * FROM TMP_CAREER);

SELECT * FROM SALARY; 

/* Удалите записи из таблицы EMP для тех сотрудников, 
которые никогда не приступали к работе на предприятии. */

SELECT * FROM EMP;

DELETE FROM EMP
WHERE EMPNO IN
(SELECT EMPNO
FROM CAREER
WHERE STARTDATE IS NULL);

SELECT * FROM EMP;

 
