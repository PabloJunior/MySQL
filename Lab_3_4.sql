/* Добавление, вычитание дней, месяцев, лет 
Требуется используя значения столбца START_DATE получить дату 
за десять дней до и после приема на работу, пол года до и 
после приема на работу, год до и после приема на работу сотрудника JOHN KLINTON.

Для вычисления дней используйте стандартное сложение и вычитание, 
а для операций над месяцами и годами функцию ADD_MONTHS. */

SELECT 
    STARTDATE - 10 AS "10 DAYS BEFORE",
    STARTDATE + 10 AS "-10 DAYS PAST",
    ADD_MONTHS(STARTDATE, -6) AS "HALF OF THE YEAR BEFORE",
    ADD_MONTHS(STARTDATE, 6) AS "HALF OF THE YEAR PAST",
    ADD_MONTHS(STARTDATE, -12) AS "YEAR BEFORE",
    ADD_MONTHS(STARTDATE, 12) AS "YEAR PAST"
FROM EMP E INNER JOIN CAREER C ON E.EMPNO = C.EMPNO
WHERE E.EMPNAME = 'JOHN KLINTON';


/* Определение количества дней между двумя датами.
Требуется найти разность между двумя датами и представить результат в днях. 
Вычислите разницу в днях между датами приема на работу сотрудников JOHN MARTIN и ALEX BOUSH.

Используйте два вложенных запроса, чтобы найти значения START_DATE для JOHN MARTIN 
и ALEX BOUSH, затем вычтите одну дату из другой. */

SELECT MONTHS_BETWEEN(JOHN_STARTDATE, ALEX_STARTDATE) AS DATE_DIFFERENCE
FROM (
	SELECT STARTDATE AS JOHN_STARTDATE
   	FROM EMP E INNER JOIN CAREER C
   	ON E.EMPNO = C.EMPNO WHERE E.EMPNAME = 'JOHN KLINTON'
),
(
	SELECT STARTDATE AS ALEX_STARTDATE
	FROM EMP E INNER JOIN CAREER C
	ON E.EMPNO = C.EMPNO WHERE E.EMPNAME = 'ALEX BOUSH'
);



/* Определение количества месяцев или лет между датами 
Требуется найти разность между двумя датами в месяцах и в годах.

Чтобы найти разницу между двумя датами в месяцах используйте функцию MONTHS_BETWEEN. */

SELECT MONTHS_BETWEEN(JOHN_STARTDATE, ALEX_STARTDATE) AS DIFF_MONTH, 
MONTHS_BETWEEN(JOHN_STARTDATE, ALEX_STARTDATE) / 12 AS DIFF_YEARS
FROM (
	SELECT STARTDATE AS JOHN_STARTDATE
   	FROM EMP E INNER JOIN CAREER C
   	ON E.EMPNO = C.EMPNO WHERE E.EMPNAME = 'JOHN KLINTON'
),
(
	SELECT STARTDATE AS ALEX_STARTDATE
	FROM EMP E INNER JOIN CAREER C
	ON E.EMPNO = C.EMPNO WHERE E.EMPNAME = 'ALEX BOUSH'
);


/* Определение интервала времени между текущей и следующей записями
Требуется определить интервал времени в днях между двумя датами. 
Для каждого сотрудника 20-го отделf найти сколько дней прошло между датой его приема на работу 
и датой приема на работу следующего сотрудника.

Используйте оконную функцию LEAD OVER. */

SELECT EMPNAME, STARTDATE, NEXT_STARTDATE - STARTDATE AS DIFF FROM (
	SELECT STARTDATE, EMPNAME, LEAD(STARTDATE) OVER (ORDER BY STARTDATE) AS NEXT_STARTDATE
    FROM DEPT D
    INNER JOIN CAREER C ON C.DEPTNO = D.DEPTNO
    INNER JOIN EMP E ON C.EMPNO = E.EMPNO
    WHERE D.DEPTNO = 20
);



/* Определение количества дней в году
Требуется подсчитать количество дней в году по столбцу START_DATE.

Используйте функцию TRUNC для нахождения начала года, 
а ADD_MONTHS – для нахождения начала следующего года. */

SELECT STARTDATE, TO_NUMBER(TO_CHAR(STARTDATE, 'YYYY')) AS YEAR,
ADD_MONTHS(TRUNC(STARTDATE, 'Y'), 12) - TRUNC(STARTDATE, 'Y') AS DAYS_IN_YEAR
FROM CAREER;


/* Извлечение единиц времени из даты
Требуется разложить текущую дату на день, месяц, год, секунды, минуты, часы. 
Результаты вернуть в численном виде.

Используйте функции TO_CHAR и TO_NUMBER; форматы ‘hh24’, ‘mi’, ‘ss’, ‘dd’, ‘mm’, 
‘yyyy’ для секунд, минут, часов, дней, месяцев, лет соответственно. */

SELECT
   TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) HOUR,
   TO_NUMBER(TO_CHAR(SYSDATE, 'MI')) MIN,
   TO_NUMBER(TO_CHAR(SYSDATE, 'SS')) SEC,
   TO_NUMBER(TO_CHAR(SYSDATE, 'DD')) DAY,
   TO_NUMBER(TO_CHAR(SYSDATE, 'MM')) MTH,
   TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) YEAR
FROM DUAL;


/* Определение первого и последнего дней месяца
Требуется получить первый и последний дни текущего месяца.

Используйте функцию LAST_DAY. */

SELECT TRUNC(SYSDATE, 'MM') AS FIRST_DAY, LAST_DAY(SYSDATE) AS LAST_DAY FROM DUAL;


/* Выбор всех дат года, выпадающих на определенный день недели
Требуется возвратить даты начала и конца каждого из четырех кварталов данного года.

С помощью функции ADD_MONTHS найдите начальную и конечную даты каждого квартала. 
Для представления квартала, которому соответствует та или иная начальная 
и конечная даты, используйте псевдостолбец ROWNUM. */

SELECT ROWNUM AS QUARTAL,
ADD_MONTHS(TRUNC(SYSDATE, 'Y'), (ROWNUM - 1) * 3) AS START_DATE,
ADD_MONTHS(TRUNC(SYSDATE, 'Y'), ROWNUM * 3) - 1 AS END_DATE
FROM DUAL CONNECT BY LEVEL <= 4;


/* Выбор всех дат года, выпадающих на определенный день недели
Требуется найти все даты года, соответствующие заданному дню недели. 
Сформируйте список понедельников текущего года. */
SELECT * FROM (
	SELECT TRUNC(SYSDATE, 'Y') + LEVEL - 1 DY
	FROM DUAL
	CONNECT BY LEVEL <= ADD_MONTHS(TRUNC(SYSDATE, 'Y'), 12) - TRUNC(SYSDATE, 'Y')
)
WHERE TO_CHAR(DY, 'DY') = 'MON';

/* Создание календаря
Требуется создать календарь на текущий месяц. 
Календарь должен иметь семь столбцов в ширину и пять строк вниз.

Чтобы возвратить все дни текущего месяца используйте рекурсивный оператор CONNECT_BY. 
Затем разбейте месяц на недели по выбранному дню с помощью выражений CASE и функций MAX. */

SELECT
MAX(CASE DW WHEN 2 THEN DM END) AS MO,
MAX(CASE DW WHEN 3 THEN DM END) AS TU,
MAX(CASE DW WHEN 4 THEN DM END) AS WE,
MAX(CASE DW WHEN 5 THEN DM END) AS TH,
MAX(CASE DW WHEN 6 THEN DM END) AS FR,
MAX(CASE DW WHEN 7 THEN DM END) AS SA,
MAX(CASE DW WHEN 1 THEN DM END) AS SU
FROM (SELECT * FROM (
	SELECT
	TO_CHAR(TRUNC(SYSDATE, 'MM') + LEVEL - 1, 'IW') AS WK,
    TO_CHAR(TRUNC(SYSDATE, 'MM') + LEVEL - 1, 'DD') AS DM,
    TO_NUMBER(TO_CHAR(TRUNC(SYSDATE, 'MM') + LEVEL - 1, 'D')) AS DW,
    TO_CHAR(TRUNC(SYSDATE, 'MM') + LEVEL - 1, 'MM') AS CURR_MTH,
    TO_CHAR(SYSDATE, 'MM') AS MTH FROM DUAL
    CONNECT BY LEVEL <=31
   ) WHERE CURR_MTH = MTH
) GROUP BY WK ORDER BY WK;

