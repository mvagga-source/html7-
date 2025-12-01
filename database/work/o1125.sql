


오라클 : varchar2, number, sysdate
MySQL : varchar, int, datetime


-- 신규 user등록
create user c##user1 identified by 1111;

-- user 권한 설정
grant connect,resource,dba to c##user1;

-- c## 명령어 생략 가능
alter session set "_ORACLE_SCRIPT"=true;

-- ora_user 생성
create user ora_user identified by 1111;
grant connect,resource,dba to ora_user;

-- ora_user2 생성
create user ora_user2 identified by 1111;
grant connect,resource,dba to ora_user2;


-- 테이블의 타입 확인
desc member;
-- 전체 테이블 확인
select * from tab;


--## ddl 테이블 생성, 수정, 삭제
create table member(
 id varchar2(100) primary key,
 pw varchar2(100),
 name varchar2(50)
);

--// 테이블 삭제
drop user c##user1;

--// 테이블 변경
-- 컬럼 추가
alter table student add sdate date;
-- 컬럼 삭제
alter table student drop column sdate;
-- 컬럼 수정 (입력된 데이터 크기 아래로 변경 불가)
alter table student modify name varchar2(1000);


--## dml 테이블안의 데이터 추가,삭제,수정,검색 할때 명령어
select, update, delete, insert 는 임시저장만 됨, commit 실행 필요


-- 날짜 타입은 비교 가능, 날짜 문자타입은 비교 불가
update student set sdate = '2025-01-01';
update student set sdate = sysdate;
select sysdate+100 from dual;
select sysdate-100 from dual;

-- 연산
update student set kor=70 where sno = 1;
update student set total=kor+eng+math,avg=(kor+eng+math)/3 where sno = 1;

-- 별칭
select emp_name,salary,salary*1474,salary*1474*12 from employees;
select emp_name,salary,salary*1474 as kor_salary ,salary*1474*12 as year_salary from employees;

-- 테이블 복사(데이터 포함)
create table student2 as select * from student;

-- 테이블 복사(데이터 불포함 - 구조만 복사)
create table student3 as select * from student where 1=2;
  -- 컬럼이 다를 경우
insert into student3 (sno,name,kor,eng,math,sdate) select sno,name,kor,eng,math,sdate from student;
  -- 컬럼이 같을 경우
insert into student2 select * from student;


-- null(무한대)값에 사칙연산시 null값으로 변경됨
nvl(컬럼명, 대체할 값);


select seoul_stu.stuno,name,birth,phone,address,enroll_date,write_date,grade,grade_no,class_no 
from seoul_stu, seoul_grade
where seoul_stu.stuno=seoul_grade.stuno;

select *
from seoul_stu, seoul_grade
where seoul_stu.stuno=seoul_grade.stuno;


create table product(
    product_id number(10) not null,  -- 상품 고유번호
    product_name varchar2(200) not null,  -- 상품명
    category varchar2(100), -- 카테고리
    price number(12,2) default 0, -- 단가
    stock_qty number(10) default 0, -- 재고수량
    use_yn char(1) default 'Y', -- 사용여부
    reg_date date default sysdate, -- 등록일
    mod_date date default sysdate -- 수정일
);




