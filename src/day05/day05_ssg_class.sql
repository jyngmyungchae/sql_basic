-- 데이터조작어(DML) : SELECT, DELETE,UPDATE,INSERT
-- 데이터 정의어 (DDL) : CREATE, DROP,ALTER

-- testdb database를 생성하여 ssg@localhost 계정이 객체에 대한 모든 권한을 처리할 수 있도록
use testdb;

-- 테이블명: test_create_table 생성하시오, 컬럼은 co1_1 int, col_2 varchar(50), col_3 datetime 이다.
create table test_create_table(col_1 int, col_2 varchar(50), col_3 datetime);

-- test_create_table 에   1, 'testSQL' , '2025-01-01' 데이터를 입력하세요
INSERT INTO test_create_table(col_1,col_2,col_3) values (1, 'testSQL' , '2025-01-01');
INSERT INTO test_create_table(col_1,col_2,col_3) values (1, 'testSQL' , now());
INSERT INTO test_create_table(col_1,col_2,col_3) values (1, 'testSQL' , now());
INSERT INTO test_create_table(col_1,col_2,col_3) values (1, 'testSQL' , now());
INSERT INTO test_create_table(col_1,col_2,col_3) values (1, 'testSQL' , now());

INSERT INTO test_create_table values (1, 'testSQL' , now());

INSERT INTO test_create_table(col_1,col_2) values (1,'3');

INSERT INTO test_create_table(col_2,col_1,col_3) values ('testSQL', 1 , now());

-- 입력된 데이터 확인하세요
SELECT * FROM test_create_table;
rollback;
commit;

-- 여러 데이터를 한번에 삽입
INSERT INTO test_create_table
VALUES(8, 'testSQL' , now()),(9, 'testSQL' , now()),(null, 'testSQL' , now());

--   test_create_table 의 col_1의 컬럼속성을 변경  col_1 의 속성을 int => smallint  not null 속성 추가
alter table test_create_table modify col_1 smallint not null;
desc test_create_table;


 -- UPDATE 문으로 데이터 수정
  -- UPDATE 테이블이름 SET 열1, 열2, 열3 (WHERE  [열 = 조건]);
SELECT * FROM test_create_table;

UPDATE test_create_table SET col_2 = 'testSQL_UPDATE'  where col_1 = 5;


-- COMMIT 시에는 반영된 데이터 값을 되돌릴 수 없다.
-- DML 작업시 특히 DELETE 작업시 COMMIT 작업은 신중히, 최소시 ROLLBACK 하면 한단계 취소

-- DELETE FROM 테이블 이름;
-- DELETE FROM 테이블 이름 WHERE  열 = 조건;

CREATE TABLE NEWBOOK(
                        bookid integer,
                        bookname varchar(20),
                        publisher varchar(20),
                        price integer,
                        primary key(bookid)
);

ALTER TABLE NEWBOOK modify BOOKNAME varchar(20) NOT NULL;
ALTER TABLE NEWBOOK modify PUBLISHER varchar(20) UNIQUE;
ALTER TABLE NEWBOOK modify PRICE INTEGER DEFAULT 10000 CHECK(PRICE > 1000);


-- ALTER TABLE newbook
-- MODIFY COLUMN bookname VARCHAR(20) NOT NULL,
-- MODIFY COLUMN publisher VARCHAR(20) UNIQUE,
-- MODIFY COLUMN price INTEGER DEFAULT 10000 CHECK(PRICE > 1000);


CREATE TABLE NEWCUSTOMER(
                            custid integer primary key,
                            name varchar(40),
                            address varchar(40),
                            phone varchar(30)
);

CREATE TABLE NEWOrders(
                          ORDERID INTEGER,
                          custid integer not null,
                          bookid integer not null,
                          saleprice integer,
                          orderdate date,
                          primary key (orderid)

);

drop table newbook;
drop table newcustomer;

-- foreign key (관계 해제)  => 테이블을 기준, 데이터베이스 기준 외래키 확인

select * from information_schema.table_constraints where table_name = 'neworders';

alter table neworders drop foreign key neworders_ibfk_1;
alter table neworders drop foreign key fk_custid;


alter table neworders add constraint fk_bookid foreign key(bookid) references newbook(bookid) on delete cascade;
alter table neworders add constraint fk_custid foreign key(custid) references newcustomer(custid) on delete cascade;

select * from newcustomer;
insert into newcustomer values(1,'sss','korea','010-000-0000');
insert into newcustomer values(1,'sss','korea','010-000-0000');
update newcustomer set custid = 2 where custid = 1;
delete from newcustomer where custid = 1;
commit;

-- newbook 테이블   책 한권 저장
desc newbook;
insert into newbook values(1,'한 눈으로 보는 세계사','민음사',15000);
insert into newbook values(2,'동아시아사','민음사',10000);

-- neworders 테이블에 custid 1인 고객이 bookid 1 인 책을 주문했다. 해당 데이터를 입력
desc neworders;


-- neworders 테이블에 orderid에 auto_increment 속성을 추가
alter table neworders modify orderid int not null auto_increment;

insert into neworders values(null,1,1,9000,now());
update neworders set bookid = 2 where custid = 1;
delete from neworders where custid = 2;
rollback;
select * from neworders;
select * from newbook;




USE SSGDB;
DROP TABLE customer;



CREATE TABLE Book (
                      bookid		INTEGER PRIMARY KEY,
                      bookname	VARCHAR(40),
                      publisher	VARCHAR(40),
                      price		INTEGER
);

CREATE TABLE  Customer (
                           custid		INTEGER PRIMARY KEY,
                           name		VARCHAR(40),
                           address		VARCHAR(50),
                           phone		VARCHAR(20)
);


CREATE TABLE Orders (
                        orderid INTEGER PRIMARY KEY,
                        custid  INTEGER,
                        bookid  INTEGER,
                        saleprice INTEGER,
                        orderdate DATE,
                        FOREIGN KEY (custid) REFERENCES Customer(custid),
                        FOREIGN KEY (bookid) REFERENCES Book(bookid)
);


INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구 아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '배구 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');
INSERT INTO Customer VALUES (3, '김연경', '대한민국 경기도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000, STR_TO_DATE('2024-07-01','%Y-%m-%d'));
INSERT INTO Orders VALUES (2, 1, 3, 21000, STR_TO_DATE('2024-07-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, STR_TO_DATE('2024-07-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (4, 3, 6, 6000, STR_TO_DATE('2024-07-04','%Y-%m-%d'));
INSERT INTO Orders VALUES (5, 4, 7, 20000, STR_TO_DATE('2024-07-05','%Y-%m-%d'));
INSERT INTO Orders VALUES (6, 1, 2, 12000, STR_TO_DATE('2024-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (7, 4, 8, 13000, STR_TO_DATE( '2024-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (8, 3, 10, 12000, STR_TO_DATE('2024-07-08','%Y-%m-%d'));
INSERT INTO Orders VALUES (9, 2, 10, 7000, STR_TO_DATE('2024-07-09','%Y-%m-%d'));
INSERT INTO Orders VALUES (10, 3, 8, 13000, STR_TO_DATE('2024-07-10','%Y-%m-%d'));

-- 여기는 3장에서 사용되는 Imported_book 테이블
CREATE TABLE Imported_Book (
                               bookid		INTEGER,
                               bookname	VARCHAR(40),
                               publisher	VARCHAR(40),
                               price		INTEGER
);
INSERT INTO Imported_Book VALUES(21, 'Zen Golf', 'Pearson', 12000);
INSERT INTO Imported_Book VALUES(22, 'Soccer Skills', 'Human Kinetics', 15000);

COMMIT;

select * from orders;



CREATE TABLE  Cust_addr (
                            addrid 	  INTEGER PRIMARY KEY,
                            custid      INTEGER,
                            address     VARCHAR(50),
                            phone       VARCHAR(20),
                            changeday		DATE,
                            FOREIGN KEY (custid) REFERENCES Customer(custid)
);

alter table cust_addr modify addrid integer auto_increment;

INSERT INTO Cust_addr VALUES (null,1, '영국 에인트호번', '010-5000-0001', STR_TO_DATE('2003-07-01','%Y-%m-%d'));
INSERT INTO Cust_addr VALUES (null,1, '영국 맨체스터', '010-5000-0002', STR_TO_DATE('2005-07-01','%Y-%m-%d'));
INSERT INTO Cust_addr VALUES (null,1, '영국 에인트호번', '010-5000-0003', STR_TO_DATE('2013-07-01','%Y-%m-%d'));
INSERT INTO Cust_addr VALUES (null,1, '영국 퀸즈파크', '010-5000-0004', STR_TO_DATE('2021-07-01','%Y-%m-%d'));

commit;


CREATE TABLE Cart (
                      cartid INTEGER PRIMARY KEY,
                      custid  INTEGER,
                      bookid  INTEGER,
                      cartdate DATE,
                      FOREIGN KEY (custid) REFERENCES Customer(custid),
                      FOREIGN KEY (bookid) REFERENCES Book(bookid)
);


INSERT INTO Cart VALUES (1, 1, 1, STR_TO_DATE('2024-07-01','%Y-%m-%d'));
INSERT INTO Cart VALUES (2, 1, 3, STR_TO_DATE('2024-07-03','%Y-%m-%d'));
INSERT INTO Cart VALUES (3, 1, 5, STR_TO_DATE('2024-07-03','%Y-%m-%d'));
INSERT INTO Cart VALUES (4, 1, 6, STR_TO_DATE('2024-07-04','%Y-%m-%d'));
commit;