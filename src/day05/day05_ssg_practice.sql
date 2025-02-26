
use ssgdb;

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
 CONSTRAINT fk_orders_custid FOREIGN KEY (custid) REFERENCES Customer(custid),
 CONSTRAINT fk_orders_bookid FOREIGN KEY (bookid) REFERENCES Book(bookid)
);
drop table cust_addr;
CREATE TABLE  Cust_addr (
custid      INTEGER,
addrid 	   INTEGER ,
address     VARCHAR(50),
phone       VARCHAR(20),
changeday	DATE,
PRIMARY KEY(addrid),
CONSTRAINT fk_cust_addr_custid  FOREIGN KEY (custid) REFERENCES Customer(custid)
);
alter table cust_addr modify addrid integer auto_increment;
-- 복합키 일경우 오토인크리먼트 전략이 안먹힌다. 이미 addrid로  충분히 식별이 기능하므로 현재 드린 데이터를 기준으로 위 처럼 처리 해주면 됩니다.


CREATE TABLE Cart (
  cartid INTEGER ,
  custid  INTEGER,
  bookid  INTEGER,
  cartdate DATE,
  PRIMARY KEY(cartid),
  CONSTRAINT fk_cart_custid FOREIGN KEY (custid) REFERENCES Customer(custid),
  CONSTRAINT fk_cart_bookid FOREIGN KEY (bookid) REFERENCES Book(bookid)
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

INSERT INTO Cust_addr(addrid,custid,address,phone,chanageday)
           VALUES (NULL,1, '영국 에인트호번', '010-5000-0001', STR_TO_DATE('2003-07-01','%Y-%m-%d'));
INSERT INTO Cust_addr VALUES (NULL,1, '영국 맨체스터', '010-5000-0002', STR_TO_DATE('2005-07-01','%Y-%m-%d'));
INSERT INTO Cust_addr VALUES (NULL,1, '영국 에인트호번', '010-5000-0003', STR_TO_DATE('2013-07-01','%Y-%m-%d'));
INSERT INTO Cust_addr VALUES (NULL,1, '영국 퀸즈파크', '010-5000-0004', STR_TO_DATE('2021-07-01','%Y-%m-%d'));

INSERT INTO Cart VALUES (1, 1, 1, STR_TO_DATE('2024-07-01','%Y-%m-%d'));
INSERT INTO Cart VALUES (2, 1, 3, STR_TO_DATE('2024-07-03','%Y-%m-%d'));
INSERT INTO Cart VALUES (3, 1, 5, STR_TO_DATE('2024-07-03','%Y-%m-%d'));
INSERT INTO Cart VALUES (4, 1, 6, STR_TO_DATE('2024-07-04','%Y-%m-%d'));
commit;


-- 1) 고객번호 1번의 주소 변경 내역을 모두 나타내시오
SELECT DISTINCT address, changedat FROM Cust_addr WHERE custid=1 ORDER BY changedat ASC;

-- 2) 고객번호 1번의 전화번호 변경 내역을 모두 나타내시오.
SELECT DISTINCT phone, changedat FROM Cust_addr WHERE custid=1 ORDER BY changedat ASC;

-- 3)고객번호 1번의 가입 당시 전화번호를 나타내시오. 단, 가입 당시 전화번호는 주소 이력 (history) 중 가장 오래된 것을 찾는다. 주소 변경 이력이 없으면 현재 주소를 반환한다.
SELECT DISTINCT phone, changedat FROM Cust_addr
WHERE custid=1 AND
addrid=(SELECT MIN(addrid) FROM Cust_addr WHERE custid=1);

-- 4) 고객번호 1번의 ‘2024년01월01일’ 당시 전화번호를 나타내시오. 단. 주소 이력 중 changeday 속성값이 ‘2024년02월01일’보다 오래된 첫 번째 값을 찾는다.
SELECT DISTINCT phone FROM Cust_addr
WHERE custid=1 AND changedat <= '2024/02/01' AND
addrid = (SELECT MAX(addrid) FROM Cust_addr
WHERE custid=1 AND changedat <= '2024/02/01');


-- 5) 고객번호 1번의 cart에 저장된 도서 중 주문한 도서를 구하시오.
SELECT bookid FROM Cart WHERE custid=1 AND
bookid NOT IN (SELECT bookid FROM Orders WHERE custid=1);

-- 6) 고객번호 1번의 cart에 저장된 도서 중 주문하지 않는 도서를 구하시오.
SELECT bookid FROM Cart WHERE custid=1 AND
bookid IN (SELECT bookid FROM Orders WHERE custid=1);

-- 7) 고객번호 1번의 cart에 저장된 도서의 정가의 합을 구하시오.
SELECT SUM(price) FROM Book, Cart WHERE Book.bookid=Cart.bookid;