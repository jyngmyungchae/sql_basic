 -- HR 부서의 어떤 사원은 급여정보를 조회하는 업무를 맡고 있다. Tucker 사원보다 급여 를 많이 받고 있는 사원의 성과 이름(Name으로 별칭), 업무, 급여를 출력하시오
 SELECT CONCAT(first_name, ' ', last_name) as "Name", job_id, salary
 FROM Employees
 WHERE salary > (SELECT salary
 FROM Employees e
 WHERE last_name = 'Tucker');


 SELECT CONCAT(first_name, ' ', last_name) as "Name", job_id, salary, hire_date
 FROM Employees e1
 WHERE salary IN(SELECT min(salary)
 FROM Employees e2
 WHERE e1.job_id=e2.job_id
 GROUP BY job_id);

-- 사원의 급여 정보 중 업무별 최소 급여를 받는 사원의 성과 이름(Name으로 별칭), 업무,급여, 입사일을 출력하시오

select concat(e1.first_name, ' ', e1.last_name) as 'Name',
       e1.job_id,
       e1.salary,
       e1.hire_date
from employees e1
where e1.salary in (select min(e2.salary) from employees e2 group by e2.job_id);

-- 소속 부서의 평균 급여보다 많은 급여를 받는 사원의 성과 이름(Name으로 별칭), 급여,부서번호, 업무를 출력하시오
elect concat(e1.first_name, ' ', e1.last_name) as 'Name',
       e1.salary,
       e1.department_id,
       e1.job_id
from employees e1
where e1.salary > (select avg(e2.salary) from employees e2 group by e1.department_id);

-- 사원들의 지역별 근무 현황을 조회하고자 한다. 도시 이름이 영문 'O'로 시작하는 지역에 살고 있는 사원의 사번, 성과 이름(Name으로 별칭), 업무, 입사일을 출력하시오
 SELECT employee_id, CONCAT(first_name, ' ', last_name) as "Name", job_id, hire_date
 FROM Employees
 WHERE department_id IN (
 SELECT department_id
 FROM Departments
 WHERE location_id IN (
 SELECT location_id
 FROM Locations
WHERE city LIKE 'O%'));



-- 시애틀에 사는 사람 중 커미션을 버는 모든 사람들의 LAST_NAME, 부서 명, 지역 ID 및 도시 명을 조회한다.

SELECT  LAST_NAME
        , DEPARTMENT_NAME
        , L.LOCATION_ID
        , CITY , E.COMMISSION_PCT
FROM    EMPLOYEES E
        , DEPARTMENTS D
        , LOCATIONS L
-- WHERE   E.COMMISSION_PCT IS NOT NULL
WHERE     E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND     D.LOCATION_ID = L.LOCATION_ID
AND     L.CITY = "Seattle";

-- 더 좋은 방법 pk로 검색하기
SELECT  LAST_NAME
        , DEPARTMENT_NAME
        , L.LOCATION_ID
        , CITY
FROM    EMPLOYEES E
        , DEPARTMENTS D
        , LOCATIONS L
WHERE   E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND     D.LOCATION_ID = L.LOCATION_ID
AND     L.LOCATION_ID = (
                          SELECT  LOCATION_ID
                          FROM    LOCATIONS
                          WHERE   CITY = 'Seattle'
                        );


-- LAST_NAME 이 DAVIES 인 사람보다 후에 고용된 사원들의 LAST_NAME 및 HIRE_DATE 을 조회한다.
SELECT  LAST_NAME, HIRE_DATE
FROM    EMPLOYEES
WHERE   HIRE_DATE >=  (
                        SELECT  HIRE_DATE
                        FROM    EMPLOYEES
                        WHERE   LAST_NAME = 'Davies'
                      )
ORDER   BY HIRE_DATE;

-- 매니저로 근무하는 사원들의 총 수를 조회한다.
SELECT  COUNT(EMPLOYEE_ID)
FROM    EMPLOYEES
WHERE   EMPLOYEE_ID IN  (
                          SELECT  DISTINCT MANAGER_ID
                          FROM    EMPLOYEES
                          WHERE   MANAGER_ID IS NOT NULL
                        );

SELECT  COUNT(DISTINCT MANAGER_ID)
FROM    EMPLOYEES;

-- LAST_NAME 이 Zlotkey 와 동일한 부서에 근무하는 모든 사원들의 사번 및 고용날짜를 조회한다.
SELECT  EMPLOYEE_ID
        , HIRE_DATE
FROM    EMPLOYEES
WHERE   DEPARTMENT_ID IN  (
                            SELECT  DEPARTMENT_ID
                            FROM    EMPLOYEES
                            WHERE   LAST_NAME = 'Zlotkey'
                          )
AND     LAST_NAME != 'Zlotkey';