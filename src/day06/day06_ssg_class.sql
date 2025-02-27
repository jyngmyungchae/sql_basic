set @myvar1 = 5;
set @myvar2 = 6;
set @myvar3 = 7;
set @myvar4 = 8;
set @myvarName = '이름 ==>';

SELECT @myvar1 + @myvar2;
SELECT @myvarName, memberName FROM membertbl;
select * from membertbl;
insert into membertbl values (1,'ssg','서울');
commit;

use 극장;
create table movie(
                      movie_id int,
                      movie_title varchar(50),
                      movie_director varchar(30),
                      movie_star varchar(30),
                      movie_script longtext,
                      movie_film longblob
) default charset=utf8mb4;   -- LONGBLOB,LONGTEXT 형식의 한글 처리 문제가 없게 하기 위해 설정

INSERT INTO movie values(1,'쉰들러 리스트','스필버그','리암 니슨',load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Schindler.txt'),load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Schindler.mp4'));
INSERT INTO movie values(2,'쇼생크탈출','프랭크 다라본트','팀 로빈슨/모건 프리먼',load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Shawshank.txt'),load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Shawshank.mp4'));
INSERT INTO movie values(3,'라스트모히칸','마이클 만','다니엘 데이 루이스',load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Mohican.txt'),load_file('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Mohican.mp4'));
commit;
select * from movie;

-- movie_script 와 movie_film 이 null 인 이유
-- 1) 최대 패킷 크기가 설정된 시스템 변수  max_allowed_packet 값 확인
SHOW variables like 'max_allowed_packet';    -- 4MByte 기본 설정
 -- my.ini(my.cnf) 시스템 변수값=>  내가 원하는 값으로 max_allowed_packet = 1024M;
-- 2) 파일 업로드/다운로드 할 폴더 경로를 별도로 허용해 주어야 한다. 시스템 변수 secure_file_priv 확인
SHOW variables like 'secure_file_priv';
-- # Secure File Priv.
-- my.ini(my.cnf) 시스템 변수값=>  내가 원하는 값으로 secure-file-priv="C:/movies/";
use 극장;
select * from movie;
TRUNCATE movie;
drop table movie;


-- ------------------------------------------------------------
use shopdb;

-- 피벗 테이블 : 한 열에 여러값을 출력하고, 이를 여러 열로 변환하여 테이블로 반환하는 방식

create table pivotTest(
                          userName CHAR(10),
                          season CHAR(2),
                          amount int
);

insert into pivotTest values
                          ('김범수','겨울',10),('유노윤호','여름',15),
                          ('김범수','가을',25),('김범수','봄',3),
                          ('김범수','봄',37),('윤종신','겨울',40),
                          ('김범수','여름',14),('김범수','겨울',22),('윤종신','여름',64);
commit;
select * from pivotTest;

SELECT username,
       SUM(if(season='봄',amount,0)) AS 봄,
       SUM(if(season='여름',amount,0)) AS 여름,
       SUM(if(season='가을',amount,0)) AS 가을,
       SUM(if(season='겨울',amount,0)) AS 겨울,
       SUM((amount)) AS 합계
FROM pivotTest Group by username;

-- JSON 데이터 (JavaScript Object Notation) : 웹과 모바일 응용 프로그램에서 데이터 교환을 위한 개방형 표준 데이터 포맷
-- 속성 : 값
-- {
--      "아이디" : "winder",
--      "이름" : "ssg"
--   }
-- MYSQL JSON 관련된 다양한 내장 함수 제공
select * from membertbl;
select json_object('memberID',memberid,'memberName',membername) as 'json값' from membertbl;

SET @json = '{
             "membertbl" :
             [
                      {"memberID":2,"membername":"신세계1"},
                      {"memberID":3,"membername":"신세계1"},
                      {"memberID":4,"membername":"신세계3"}
             ]
     }';

SELECT JSON_VALID(@json) as JSON_VALID;         -- JSON_VALID() :
SELECT JSON_SEARCH(@json,'one','신세계1') as JSON_SEARCH;  -- 해당 member의 저장 위치를 확인
SELECT JSON_SEARCH(@json,'all','신세계1') as JSON_SEARCH;

CREATE TABLE usertbl -- 회원 테이블
( userID  	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  name    	VARCHAR(10) NOT NULL, -- 이름
  birthYear   INT NOT NULL,  -- 출생년도
  addr	  	CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  mobile1	CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2	CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 키
  mDate    	DATE  -- 회원 가입일
);
CREATE TABLE buytbl -- 회원 구매 테이블(Buy Table의 약자)
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID  	CHAR(8) NOT NULL, -- 아이디(FK)
   prodName 	CHAR(6) NOT NULL, --  물품명
   groupName 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 단가
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (userID) REFERENCES usertbl(userID)
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

SELECT COUNT(*) FROM USERTBL;   -- result : 10 row
SELECT COUNT(*) FROM BUYTBL;    -- result : 12 row

COMMIT;

-- @json_user 변수에 usertbl 이름으로  윤종신, 이승기, 임재범의 이름과 키를 저장하는 json 객체를 생성하세요
SET @json_user = '
      {
         "usertbl":
         [
             {"name":"윤종신", "height":170, "address":"서울시 성북구"},
             {"name":"이승기", "height":178,"address":"경기도 성남시"},
             {"name":"임재범", "height":185,"address":"서울시 동작구"}

          ]

      } ';
-- 여러분들이 생성하신 json_user 객체가 json형식에 맞게 정의되었는지 확인해주세요 .   result => 1
SELECT JSON_VALID(@json_user) as 형식확인;

SELECT JSON_INSERT(@json_user,'$.usertbl[0].mDate','2024-03-26');
SELECT JSON_REMOVE(@json_user,'$.usertbl[0]') as 윤종신삭제;
SELECT JSON_REPLACE(@json_user,'$.usertbl[0].name','김승기');


create table jsontest(person json);
desc jsontest;
insert into jsontest values('{"name":"윤종신", "height":170, "address":"서울시 성북구"}');
select * from jsontest;



SELECT * FROM USERTBL WHERE NAME ='김범수';
-- 김범수 회원이 구매한 물품리스트를 출력 => 김범수 회원이 여러명 있을 수 있으므로 김범수 회원의 아이디를 확인 후 쿼리문을 작성하는게 정확합니다.
SELECT  *
FROM buytbl
         inner join usertbl
                    on buytbl.userid = usertbl.userid
WHERE buytbl.userid = 'KBS';

-- 구매한 기록이 있는 회원들의 정보만 출력하세요

SELECT  distinct usertbl.name
FROM buytbl
         inner join usertbl
                    on buytbl.userid = usertbl.userid
order by usertbl.userid;
-- 우리 쇼핑몰에서 한번이라도 구매한 기록이 있는 회원들에게 쿠폰지급, 안내문 발송

SELECT  distinct u.name
FROM usertbl u
where exists(
    select * from buytbl b where u.userid = b.userid
);

-- 전체회원의 구매 기록을 출력 (단, 구매 기록이 없는 회원도 출력)
SELECT u.userid, u.name, b.prodname
FROM usertbl u
         LEFT OUTER JOIN buytbl b
                         on u.userid = b.userid
order by u.userid;



SELECT u.userid, u.name, b.prodname
FROM buytbl b
         RIGHT OUTER JOIN usertbl u
                          on u.userid = b.userid
order by u.userid;

-- 구매이력이 아예 없는 회원 출력

SELECT u.userid, u.name, b.prodname
FROM usertbl u
         LEFT OUTER JOIN buytbl b
                         on u.userid = b.userid
WHERE b.prodname is null
order by u.userid;

create table ghostmember(
                            SELECT u.userid, u.name, b.prodname
                            FROM usertbl u
                            LEFT OUTER JOIN buytbl b
                            on u.userid = b.userid
                            WHERE b.prodname is null
                            order by u.userid
);
select * from ghostmember;
desc ghostmember;

alter table ghostmember add constraint pk_ghostmember primary key (userid);

-- 서브 쿼리  : 쿼리 안에 또 다른 쿼리 (중첩 쿼리)
-- 조건 : 1.  반드시 소괄호() 감싸 사용한다.  2. 서브쿼리는 주쿼리를 실행하기 전에 1번만 실행된다. 3. 비교연사자와 함께 서브쿼리를 사용하면 서브쿼리의 위치는 오른쪽이어야 한다.
--       4. 서브 쿼리 내부에서는 order by 문을 사용할 수 없다.

-- 다중행 연산자 :
--  1) IN : 서브 쿼리의 결과에 존재하는 임의의 값과 동일한 조건 검색
--    2) ANY : 서브 쿼리의 결과에 존재하는 어느 하나의 값이라도 만족하는 조건 검색
--    3) ALL : 서브 쿼리의 결과에 존재하는 모든 값을 만족하는 조건 검색
--    4) EXISTS : 서브 쿼리의 결과를 만족하는 값이 존재하는지 여부 확인

use sakila;

   -- customer 테이블 참조하여 (이름)이 first_name 'ROSA' 고객의 정보를 출력하시오(subquery)

SELECT *
FROM customer
WHERE customer_id = (SELECT customer_id from customer where first_name = 'ROSA' );


-- customer 테이블 참조하여 (이름)이 first_name 'ROSA','ANA' 고객의 정보를 출력하시오(subquery)
SELECT *
FROM customer
WHERE customer_id = (SELECT customer_id from customer where first_name IN ('ROSA','ANA') );
-- 에러 결과가 1개 이상의 ROW 반환되었으므로 = 동등연산자로는 연산을 할 수 없다.
SELECT customer_id from customer where first_name IN ('ROSA','ANA1');
-- 서브 쿼리에서 다중행 리턴

SELECT *
FROM customer
WHERE customer_id IN (SELECT customer_id from customer where first_name IN ('ROSA','ANA') );

-- film   film_category  category

desc category;
select * from category limit 10;
desc film_category;
select * from film_category limit 10;
desc film;

-- 위의 3개의 테이블을 조인하여 category가 'Action' 인 film_id 와 제목(title) 출력하세요 (조인, 서브쿼리 작성해주세요)

SELECT  a.film_id, a.title
FROM film as a
         inner join film_category as b on a.film_id = b.film_id
         inner join category as c on b.category_id = c.category_id
WHERE c.name = 'Action';

-- 스칼라 서브쿼리
SELECT film_id, title
FROM film
WHERE film_id IN
      (
          SELECT film_id
          FROM film_category as a  inner join category as b on a.category_id = b.category_id where b.name = 'Action');


-- ANY
-- customer_id 가 112, 181 인 회원의 정보 출력
SELECT * FROM customer WHERE customer_id = ANY (
    SELECT customer_id FROM customer WHERE first_name IN ('ROSA','ANA'));

-- customer_id 가 112, 181 보다 작은 값을 조회하여 출력
SELECT * FROM customer WHERE customer_id < ANY (
    SELECT customer_id FROM customer WHERE first_name IN ('ROSA','ANA'));

-- customer_id 가 112 , 181 인 데이터보다 큰 값을 조회하여 출력
SELECT * FROM customer WHERE customer_id > ANY (
    SELECT customer_id FROM customer WHERE first_name IN ('ROSA','ANA'));

-- EXISTS 문은 서브쿼리의 결괏값이 있는지 없는지를 확인해서 1행이라도 있으면 TRUE 없으면 FALSE를 반환함
-- 서브 쿼리의 결과가 1행이라도 있으면 TRUE 가 되어 주쿼리를 실행함.
-- 서브 쿼리의 결과가 FALSE 라면 주쿼리는 실행되지 않음
-- NOT EXISTS 는 EXISTS  반대로 동작함
SELECT * FROM customer
WHERE EXISTS (SELECT customer_id FROM customer where first_name in('ROSA','ANA'));

SELECT * FROM customer
WHERE NOT EXISTS (SELECT customer_id FROM customer where first_name in('ROSA','ANA'));

-- ALL   where customer_id  =112 and customer_id =181
SELECT * FROM customer
WHERE customer_id = all (SELECT customer_id FROM customer where first_name in('ROSA','ANA'));

-- FROM 문에 서브 쿼리 사용   (인라인뷰) -> inline view
-- FROM 절에 서브쿼리를 사용하면 그 결과는 테이블처럼 사용되어 다른 테이블과 다시 조인하여 사용할 수 있다.
-- 쿼리를 논리적으로 격리한다.

SELECT a.film_id, a.title , x.name
FROM film as a INNER JOIN (
    SELECT b.film_id, c.name
    FROM film_category as b
             inner join category as c on b.category_id =c.category_id
    where c.name ='Action')as x;















