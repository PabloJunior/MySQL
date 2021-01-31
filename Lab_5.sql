/* Создайте представление, содержащее данные о сотрудниках пенсионного
возраста. */

DROP VIEW PENSIONERS;

CREATE VIEW PENSIONERS AS
SELECT EMPNAME, BIRTHDATE, MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12 AS AGE 
FROM EMP WHERE MONTHS_BETWEEN(SYSDATE, BIRTHDATE) / 12 >= 60;

SELECT * FROM PENSIONERS;


/* Создайте представление, содержащее данные об уволенных сотрудниках:
имя сотрудника, дата увольнения, отдел, должность. */

DROP VIEW DISMISSED;

CREATE VIEW DISMISSED AS
SELECT EMP.EMPNAME, CAREER.ENDDATE, DEPT.DEPTNAME, JOB.JOBNAME
FROM EMP NATURAL JOIN CAREER NATURAL JOIN DEPT NATURAL JOIN JOB
WHERE CAREER.ENDDATE IS NOT NULL;

SELECT * FROM DISMISSED;


/* Создайте представление, содержащее имя сотрудника, должность,
занимаемую сотрудником в данный момент, суммарную заработную плату
сотрудника за третий квартал 2010 года. Первый столбец назвать Sotrudnik,
второй – Dolzhnost, третий – Itogo_3_kv. */

DROP VIEW KVARTAL;

CREATE VIEW KVARTAL (SOTRUDNIK, DOLZHNOST, ITOGO_3_KV) AS
SELECT E.EMPNAME, J.JOBNAME, SUM(S.SALVALUE)
FROM JOB J NATURAL JOIN CAREER NATURAL JOIN EMP E NATURAL JOIN SALARY S
WHERE S.YEAR = 2010 AND S.MONTH BETWEEN 7 AND 9
GROUP BY E.EMPNAME, J.JOBNAME;

SELECT * FROM KVARTAL;


/* На основе представления из задания 2 и таблицы SALARY создайте
представление, содержащее данные об уволенных сотрудниках, которым
зарплата начислялась более 2 раз. В созданном представлении месяц
начисления зарплаты и сумма зарплаты вывести в одном столбце, в качестве
разделителя использовать запятую. */

DROP VIEW DISMISSED2;

CREATE VIEW DISMISSED2 (EMPNAME, ENDATE, DEPTNAME, JOBNAME, MONTH_AND_SUM) AS
SELECT D.EMPNAME, D.ENDDATE, D.DEPTNAME, D.JOBNAME, S.MONTH || ', ' || S.SALVALUE
FROM DISMISSED D NATURAL JOIN SALARY S WHERE S.EMPNO IN
(SELECT EMPNO FROM DISMISSED NATURAL JOIN SALARY
GROUP BY EMPNO HAVING COUNT(SALVALUE) > 2);


SELECT * FROM DISMISSED2;

