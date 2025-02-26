-- 1 . 운영자적 관점 SQL : 집계 (aggregate) ->  집계함수(aggregate function) 제공
-- 집계함수란 테이블의 각 열에 대해 계산하는 함수

-- 3-15 고객(customer)이 주문한 도서의 총판매액을 구해보자
SELECT sum(saleprice) as '총매출'
FROM orders;
-- 3-16
select custid from customer where name ='김연아';
select sum(saleprice)as '총매출' from orders where custid = 2;
-- 3.17
SELECT SUM(saleprice) as 'Total',
        AVG(saleprice) as 'AVERAGE',
        MIN(saleprice) as 'MINIMUM',
        MAX(saleprice) as 'MAXIMUM'
FROM orders;

-- 3-18  count()-> 행의 개수를 셈  count(*) 전체 튜플의 수 반환하는데 Null을 제하고 반환
SELECT COUNT(orderid) from orders;


-- 강사 수업자료 > 02 MySQL 데이터베이스 > data > sakila_db 다운로드
-- sakiladb 생성 , saikila 사용자를 만들어  sakiladb에 대한 모든 접근 권한을  부여해 주세요
-- sakila 계정으로 접속하여
-- sakila-schema.sql 을 이용하여 테이블을 생성한 후
-- sakiladb 테이블에 맞도록 해당 데이터 sakila-data.sql을 이용하여 데이터를 삽입해주세요

-- GROUP BY절 사용하면 속성값이 같은 값끼리 그룹을 만들 수 있다.

SELECT * FROM customer;

-- 3-19
SELECT custid as 고객아이디, count(bookid) as '도서수량', sum(saleprice) as '총액'
FROM Orders
GROUP BY custid;

select custid, bookid,saleprice from orders order by custid;
-- SELECT문 수행 순서
select custid as '고객아이디', count(bookid) as 도서수량 , saleprice , bookid  -- (5)
from orders   -- 1)
where saleprice >= 8000  -- 2)
group by custid   -- 3)
having count(bookid) >=2   -- 4)
order by custid;   -- (6)



select bookid, custid, sum(saleprice)
from orders
group by bookid;
