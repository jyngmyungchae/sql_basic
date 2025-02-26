--  문제 1 모든 사원은 직속 상사 및 직속 직원을 갖는다. 단, 최상위 또는 최하위 직원은 직속 상사 및 직원이 없다. 소속된 사원 중 어떤 사원의 상사로 근무 중인 사원의 총수를 출력하시오(1행)
SELECT COUNT(distinct manager_id) "직속 상사"
FROM Employees;

select employee_id, last_name  , manager_id from employees;

-- 문제2
-- 각 사원이 소속된 부서별로 급여 합계, 급여 평균, 급여 최댓값, 급여 최솟값을 집계하고자 한다. 계산된 출력 값은 여섯 자리와 세 자리 구분기호, $ 표시와 함께 출력하고 부서번호의 오름차순 정렬하시오. 단, 부서에 소속되지 않은 사원에 대한 정보는 제외하고,
-- 출력 시 머리글은 부서아이디, 급여합계, 급여평균, 급여최댓값, 급여최솟값 별칭(alias) 처리하시오(11행)


SELECT department_id as 부서아이디,
       CONCAT('$', FORMAT(SUM(salary), 0)) as "급여 합계",
       CONCAT('$', FORMAT(AVG(salary), 1)) as "급여 평균",
       CONCAT('$', FORMAT(MAX(salary), 0)) as "급여 최댓값",
       CONCAT('$', FORMAT(MIN(salary), 0)) as "급여 최솟값"
FROM Employees
WHERE department_id is NOT NULL
GROUP BY department_id;



-- 문제 3
-- 사원들의 업무별 전체 급여 평균이 $10,000보다 큰 경우를 조회하여 업무, 급여 평균을 출력하시오. 단 업무에 사원(CLERK)이 포함된 경우는 제외하고 전체 급여 평균이 높은 순서대로 출력하시오(7행)

SELECT job_id, avg(salary) as "급여평균"
FROM Employees
WHERE  job_id NOT LIKE '%CLERK%'
GROUP BY job_id
HAVING avg(salary) > 10000
ORDER BY avg(salary) DESC;

