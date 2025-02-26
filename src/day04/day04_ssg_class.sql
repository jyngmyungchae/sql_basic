-- 두 개 이상의 테이블을 이용한 SQL질의 방법
-- 박지성 고객이 주문한 도서의 총구매액은 38000
-- Join 은 한 테이블의 행을 다른 테이블의 행에 연결하여 두 개 이상의 테이블을 결합하는 연산

SELECT * FROM customer , orders;
select count(custid) from customer;  -- 5명
select count(orderid) from orders;   -- 10건
-- 5 x 10 = 50  (조건이 없는 테이블간의 조인을 Cross Join)

-- 고객과 고객의 주문에 관한 데이터를 모두 출력하시오. (동등조인 equi join)
SELECT * FROM customer , orders where customer.custid = orders.custid order by customer.custid;
select * from customer;
select * from orders;

-- 3.23
SELECT c.name , o.saleprice
from customer c, orders o where c.custid = o.custid;

-- 3.24
SELECT c.name, sum(saleprice)
FROM customer c, orders o
WHERE c.custid = o.custid
GROUP BY c.name
order by c.name;
-- 3.25
SELECT c.name, b.bookname
FROM  customer c, orders o , book b
WHERE c.custid = o.custid and o.bookid = b.bookid;

-- 3.26
select * from book;
select * from orders;
select * from customer;

SELECT c.name, b.bookname , b.price
FROM  customer c, orders o , book b
WHERE c.custid = o.custid and o.bookid = b.bookid and b.price>= 20000;

-- 3.27 외부조인(outer join)

SELECT c.name, o.saleprice
FROM  customer c LEFT OUTER JOIN orders o
                                 on c.custid = o.custid;


-- 직원들의 직속상사의 정보를 출력하시오   (selft join)
SELECT staff.last_name, staff.job_id, manager.last_name, manager.job_id
FROM employees staff, employees manager
WHERE staff.manager_id = manager.employee_id;


SELECT MAX(price) from book;
select bookname from book where price = 35000;
-- 두 개의 질의를 하나의 질의로 만들 수는 없을까 ?  subquery(부속질의 = 중첩질의 (nested query) 로 해결가능하다.
select bookname
from book
where price =(SELECT MAX(price) from book);
-- subquery 결과는 테이블로 반환됨

-- 단일행 - 단일열(1x1)  연산자 =
-- 다중행 - 단일열(nx1)  연산자 in 도서를 구매한 적이 있는 고객의 이름을 출력하세요
-- 단일행 - 다중열(1xn)
-- 다중행- 다중열(nxn)

-- 도서를 구매한 적이 있는 고객의 이름을 출력하세요
SELECT custid from orders;
SELECT name from customer where custid in(1,2,3,4);

select name
from customer
where custid in(select custid from orders);



SELECT name
FROM customer
where custid in(select custid from orders where bookid IN
                                                (select bookid from book where publisher ='대한미디어'));

-- 1 select distinct publisher from book where publisher ='대한미디어';

-- 2 select custid from orders where bookid in (3,4);

-- 3 select name from customer where custid in (1);

-- 부속질의 간에는 상하관계가 있다. 먼저 하위부속질의를 실행하고, 그 결과를 이용하여 상위 부속질의를 실행한다.

-- 상관부속질의 (correlated subquery)  상위 부속질의와 하위 부속질의가 독립적이지 않고 서로 관련을 맺고 있다.

select * from book  where publisher  = '굿스포츠' ;
select  publisher , avg(price) from book group by publisher;
select * from book where price >= 7000;

SELECT b1.bookname , b1.price
FROM   book b1   -- 튜플변수
WHERE  b1.price > (
    select avg(b2.price)
    from  book b2
    where  b2.publisher = b1.publisher
);