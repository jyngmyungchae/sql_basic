-- 1.숫자함수
-- ABS() 숫자의 절댓값을 반환
-- 상수값 -78 과 +78 을 대상으로 ABS함수를 수행하여라 (절댓값)
SELECT ABS(-78) , ABS(+78) FROM DUAL;  -- 오라클일 경우 DUAL(가상테이블)
SELECT ABS(-78) , ABS(+78);  -- MYSQL일 경우

-- 10   10.1  -10.1     10   11  -10   CEIL() => 올림함수
SELECT CEIL(10),CEIL(10.1),CEIL(-10.1);

SELECT ceiling(3.14) AS ceil_value;
SELECT floor(3.14) AS floor_value;

-- TRUNCATE() => 숫자를 지정한 소수점 자리수로 잘라낸다. (반올림을 하지 않는다.)
SELECT truncate(3.141592,2) as truncate_ex;

-- 4.875 를 소수 첫째 자리까지 반올림한 값을 구하시오
SELECT ROUND(4.875,1);
-- MOD() => 숫자의 나머지를 반환하는 함수
SELECT MOD(10,3) AS 나머지;

-- 고객별 평균 주문 금액을 (백원 단위)로 반올림한 값을 구하시오
-- SELECT custid '고객번호',  ROUND(SUM(saleprice)/COUNT(*), -2) '평균금액'
SELECT custid '고객번호',  ROUND(AVG(saleprice), -2) '평균금액'
FROM Orders
GROUP BY custid;

SELECT TRIM('=' FROM '==FROM=FROM==');

-- 한문자가 차지하는 바이트의 기준은 데이터베이스시스템에 따라 다르게 적용되는데
-- UTF-8 환경에서는 알파벳 'a' 1byte,  한글 '가' =>  3바이트 로 저장된다.
-- 그러므로 순수한 문자의 수를 알기위해서는 CHAR_LENGTH(문자열) 사용한다.
-- 공백도 하나의 문자로 취급됩니다.

SELECT LENGTH('SSSSSGGGG ');
SELECT CHAR_LENGTH('신세계');
SELECT LENGTH('신세계');

SELECT * FROM BOOK;

SELECT bookid, replace(bookname,'야구','농구') bookname
FROM BOOK;

-- 굿스포츠에서 출판한 도서의 제목과 제목의 글자 수를 확인하세요
SELECT bookname '제목' , CHAR_LENGTH(bookname) 문자수, LENGTH(bookname) 바이트수
FROM Book
WHERE publisher = '굿스포츠';

SELECT SUBSTR(name,1,1) 성 , COUNT(*) 인원 from customer GROUP BY SUBSTR(name,1,1);

-- 3) 날짜 시간 함수

SELECT SYSDATE();
SELECT NOW();

--
SELECT orderid 주문번호, orderdate 주문일, ADDDATE(orderdate, interval 10 DAY) 구매확정일
FROM Orders;

SELECT orderid 주문번호,  date_format(orderdate,'%Y-%m-%d') 주문일
FROM ORDERS
WHERE orderdate = STR_TO_DATE('20240707','%Y%m%d');

CREATE TABLE mybook(bookid int , price int);
INSERT INTO mybook values(1,10000), (2,20000),(3, null);
commit;
select * from mybook;



select price + 100 from mybook where bookid = 3;
select sum(price) , avg(price),count(*) ,count(price)
from mybook
where bookid >= 4;

-- NULL 값을 확인하는 방법  (IN NULL , IS NOT NULL) 아니다 => <>

SELECT * FROM MYBOOK WHERE PRICE IS NULL;
SELECT * FROM MYBOOK WHERE PRICE = '';

-- IFNULL 함수 => NULL값을 다른 값으로 치환하여 연산한다.
SELECT * FROM CUSTOMER;

SELECT name 이름, ifnull(phone ,'연락처없음') 전화번호
FROM CUSTOMER;

SELECT BOOKID 북아이디, IFNULL(PRICE,0) FROM MYBOOK;

SET   @seq:=9;
SELECT (@seq:=@seq+1) 순번 ,custid , name, phone
FROM CUSTOMER;
-- WHERE  @seq < 2;

use sakila;

-- customer 테이블에서 고객의 이름이 저장된 first_name열을 조회
desc customer;
-- customer_id  고객을 유일하게 식별하는 식별자
-- store_id  store테이블에서 고객의 '홈스토어'를 식별하는 외래키
-- first_name : 이름 last_name : 성
-- email : 고객의 이메일
-- address_id :   address 테이블에서 고객의 주소를 식별하는 외래키
-- active : 고객이 활성화된 고객인지 여부가 저장
-- create_date : 고객이 시스템에 가입된 날
-- last_update : 행이 수정되었거나 가장 최근 업데이트된 시간이 저장

-- 전체 열 조회 select * from customer;   자제 요망

-- ex) 크기 50byte 데이터를 저장할 수 있는 열이 50개 , 행이 1만개 가정하면
--     쿼리 1줄이 => 50byte x 50 column x 10000 row = 25,000,000byte  => 약25MB

-- DESC,  DESCRIBE
-- SHOW COLUMNS FROM SAKILA.customer;  MYSQL에서만 지원되는 명령어

-- payment 테이블에서 customer_id, amount 열을 조회하는데
-- customer_id 그룹화(고객별) , 그룹별로 amount 의 값을 합한 결과를 내림차순 정렬한 결과에 따라 ROW_NUMBER함수로 순위를 부여
use sakila;

SELECT  customer_id, count(customer_id) from payment group by customer_id;

--  순위 함수 ROW_NUMBER() : 모든 행에 유일한 값으로 순위를 부여 ( 함수를 실행한 결과에 같은 순위가 없다. 만약 같은 순위가 있다면 정렬 순서에 따라 순위를 다르게 부여함)
-- 순위를 부여하기 위해 OVER (ORDER BY 열)
-- ROW NUMBER() OVER ([PARTITION BY 열] ORDER BY 열)

SELECT ROW_NUMBER() OVER(ORDER BY amount DESC) AS num , customer_id , amount
FROM(
        SELECT customer_id , SUM(amount) as amount FROM payment GROUP BY customer_id
    ) as x;


SELECT ROW_NUMBER() OVER(ORDER BY amount DESC ,customer_id DESC) AS num , customer_id , amount
FROM(
        SELECT customer_id , SUM(amount) as amount FROM payment GROUP BY customer_id
    ) as x;

SELECT staff_id , ROW_NUMBER() OVER(PARTITION BY staff_id ORDER BY amount DESC, customer_id ASC) as num, customer_id, amount
FROM (
         SELECT customer_id , staff_id , SUM(amount) as amount FROM payment GROUP BY customer_id , staff_id
     ) as x;

-- RANK() 우선순위를 고려하지 않고 순위를 부여하는 함수
-- RANK() OVER([PARTITIOON BY 열] ORDER BY 열)

SELECT RANK() OVER(ORDER BY amount DESC) as num , customer_id , amount
FROM(
        SELECT  customer_id , sum(amount) as amount from payment group by customer_id
    ) as x;