-- root 계정으로 ssgdb 사용자 정의 데이터베이스 생성
create database ssgdb;
create database testdb;
create database 극장;

-- ssgdb 데이터베이스를 사용하는 사용자 'ssg' 사용자 패스워드 'ssg1234'
create user ssg@localhost identified by 'ssg1234';


-- ssg@localhost 사용자에게 ssgdb의 모든 권한을 부여한다.
grant all privileges on ssgdb. * to ssg@localhost;
grant all privileges on testdb. * to ssg@localhost;
grant all privileges on 극장. * to ssg@localhost;

-- 현재 적용 설정을 최종 반영
commit;
flush privileges;
-- 데이터베이스 리스트 보기
show databases;

-- 데이터베이스 ssgdb 사용(선택)하기
use ssgdb;

-- id와 name 필드를 가진 'test'테이블을 생성
-- id 의 타입은 smallint 이며 null 값을 허용하지 않으며, 자동으로 1씩 증가하는 기본키 이다.
-- name 의 타입은 문자열로 사이즈는 20으로 null을 허용하지 않는다.
create table test(id smallint unsigned not null auto_increment primary key, name varchar(20) not null );

-- test 테이블의 모든 정보 리스트를 출력하라
select * from test;

-- test 테이블에 id 는  1 , name 에는 'sample test data2' 를 입력
insert into test(id,name) values (1,'sample test data2');

insert into test(id,name) values (null,'sample test data2');
-- 최종 입력한 리스트를 데이터베이스에 반영한다.
commit;

select * from orders;

use employees;
select salary from salaries;
