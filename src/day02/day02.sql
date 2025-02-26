-- 요구사항

-- 1. shopdb 데이터베이스를 생성해 주세요

--  ssg계정으로 접속하여
-- 2. 회원테이블(memberTBL)
--    memberID 문자열 8글자 널을 허용하지 않음
--    memberName 문자열 10글자   널을 허용하지 않음
--    memberAddress  문자열20 글자  널 허용

--    제품테이블(productTBL)
--    productName 문자 (4글자) 널 허용하지 않음
--    cost   숫자(INT)  널 허용하지 않음
--    makeDate 날짜(DATE)  널 허용
use shopdb;
create table memberTBL(
                          memberID varchar(8) not null,
                          memberName varchar(10) not null,
                          memberAddress varchar(20),
                          primary key(memberID)
);
drop table productTBL;

CREATE TABLE productTBL(
    -- productID int auto_increment ,
                           productName varchar(4) not null,
                           cost int not null,
                           makeDate date
    -- primary key(productID)
);

desc productTBL;
-- 테이블 수정 (productID 새로운 컬럼 추가)
alter table productTBL ADD COLUMN productID int not null unique;
-- 테이블 수정 ( productID 컬럼 삭제)
alter table productTbl drop column productID;

alter TABLE productTBL CHANGE COLUMN cost price int;

-- productName 컬럼 앞에 productID 컬럼을 추가
ALTER TABLE productTBL ADD COLUMN productID int not null first;

-- 테이블에 지정 컬럼 뒤에 추가
alter table productTBL ADD COLUMN descript varchar(100) not null after price;

-- 컬럼 타입 변경
ALTER TABLE productTBL MODIFY COLUMN price smallint;

use ssgdb;

show tables;
select bookname, price
from book;

select  price , bookname
from book;

desc book;

select bookid,bookname,publisher,price
from book ;

select all publisher
from book;

select distinct publisher
from book;

SELECT *
FROM book
WHERE price < 20000;

-- 3-5
SELECT *
FROM book
WHERE price between 10000 AND 20000;

SELECT *
FROM book
WHERE price >= 10000 AND price <= 20000;


-- 3-6
SELECT *
FROM book
WHERE publisher NOT IN('굿스포츠','대한미디어');

SELECT *
FROM book
WHERE publisher = '굿스포츠' OR publisher ='대한미디어';

-- 문자열의 패턴을 비교할때 LIKE 연산자 사용  일부문자가 포함된 문자열 검색 %
SELECT *
FROM  book
WHERE bookname LIKE '축구의 역사';


select bookname from book;

-- 3-8
SELECT publisher ,bookname
FROM  book
WHERE bookname LIKE '%축구%';

-- 3-9
SELECT *
FROM book
WHERE bookname LIKE '__의%';

-- 3-10
SELECT *
FROM BOOK
WHERE  bookname Like '%축구%' and price>= 20000;

-- 3-11
SELECT *
FROM  book
WHERE  publisher IN('굿스포츠','대한미디어');

-- 3-12  order by 컬럼 오름차순(asc) 내리차순(desc)
SELECT *
FROM BOOK
order by price desc;

-- 3-13 order by 절을 사용하면 특정순서를 지정하여 출력할 수 있다.

SELECT *
FROM BOOK
order by price, bookname;

-- 3-14
SELECT *
FROM BOOK
order by price desc, publisher desc;
