/* Требуется представить имя каждого сотрудника таблицы EMP, а также имя его руководителя.
Выполните рефлексивное соединение (самосоединение) таблицы EMP. 
SELECT T1.EMPNAME || ' WORKS FOR ' || T2.EMPNAME AS EMP_MANAGER
FROM EMP T1, EMP T2 WHERE T1.MANAGER_ID = T2.EMPNO;
 

/* Требуется представить имя каждого сотрудника таблицы EMP 
(даже сотрудника, которому не назначен руководитель) и имя его руководителя.
Используйте ключевые слова иерархических запросов START WITH, CONNECT BY PRIOR. */
SELECT EMPNAME || ' REPORTS TO ' || PRIOR EMPNAME AS "Walk Top Down" FROM EMP 
START WITH MANAGER_ID IS NULL CONNECT BY PRIOR EMPNO = MANAGER_ID

 
/* Требуется показать иерархию от CLARK до JOHN KLINTON.
Используйте функцию SYS_CONNECT_BY_PATH получите CLARK и его руководителя ALLEN, 
затем руководителя ALLEN ― JOHN KLINTON. А также ключевые слова иерархических запросов LEVEL, START WITH, 
CONNECT BY PRIOR; функцию LTRIM. */
SELECT REVERSE(LTRIM(SYS_CONNECT_BY_PATH(REVERSE(EMPNAME), '>--'), '>--')) AS LEAF__BRANCH__ROOT
FROM EMP WHERE EMPNAME = 'CLARK' START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPNO = MANAGER_ID;


/* Требуется получить результирующее множество, описывающее иерархию всей таблицы */
SELECT LTRIM(SYS_CONNECT_BY_PATH(EMPNAME, '-->'), '-->') AS EMP_TREE
FROM EMP START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPNO = MANAGER_ID;
 

/* Требуется показать уровень иерархии каждого сотрудника.
Используйте ключевые слова иерархических запросов LEVEL, START WITH, 
CONNECT BY PRIOR; функцию LPAD. */
SELECT LPAD(' ', 2 * (LEVEL - 1), '_') || EMPNAME AS ORG_CHART
FROM EMP START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPNO = MANAGER_ID;


/* Требуется найти всех служащих, которые явно или  неявно подчиняются ALLEN */
SELECT EMPNAME FROM EMP
WHERE EMPNAME != 'ALLEN'
START WITH EMPNAME = 'ALLEN'
CONNECT BY PRIOR EMPNO = MANAGER_ID;
 
