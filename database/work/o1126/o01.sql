
-- 필드 숨김 및 보이기 (필드 순서 변경 가능)
-- invisible 후 visible 시 필드는 맨뒤에 위치함
alter table student3 modify kor invisible;
alter table student3 modify eng invisible;
alter table student3 modify math invisible;
alter table student3 modify total invisible;
alter table student3 modify avg invisible;
alter table student3 modify sdate invisible;

alter table student3 modify sdate visible;
alter table student3 modify kor visible;
alter table student3 modify eng visible;
alter table student3 modify math visible;
alter table student3 modify total visible;
alter table student3 modify avg visible;

-- 테이블 삭제
drop table student3;

-- like 검색 ( _ , % )
select emp_name from employees where lower(emp_name) like '%ge%';

--                                             // 특수문자(_) 검색 필요시 escape 사용
select job_id from employees where job_id like '%#_M%' escape '#';

select * from employees where lower(emp_name) like '%z%' or lower(email) like '%z%';


-- null값 처리

select nvl(manager_id,0) from employees;

--                        // 필드가 숫자타입인 경우 문자형식으로 변형 후 nvl처리
select nvl(manager_id,0), nvl(to_char(manager_id),'ceo') from employees;

select 
    to_char(salary,'999,999,999') as salary, 
    commission_pct, 
    to_char((salary + (salary*nvl(commission_pct,0)))*1473,'999,999,999') as pay 
from employees;


-- 정렬 : asc 순차정렬 - null 가장 마지막, desc 역순정렬 - null 가장 먼저

select emp_name from employees order by emp_name desc


--// 숫자 함수

-- 절대값
select 10, abs(-10) abs from dual;

-- 버림(floor), 반올림(round, ceil)
select floor(10.598) floor, round(10.598) round, ceil(10.598) ceil from dual;

-- 반올림(round)                    //10.59                //10.589                  // 40
select round(10.5887) round1, round(10.5887,2) round2,round(10.5887,3) round3, round(35.5887,-1) round3
from dual;

-- 버림 : trunc(값, 자릿수)
--            // 34.56           // 34.567           //30
select trunc(34.5678,2) , trunc(34.5678,3) , trunc(34.5678,-1) 
from dual;

-- 나머지 : mod
select mod(27,2), mod(27,5) from dual;
--                            // 홀수 아이디 출력
select * from employees where mod(employee_id,2) = 1;





--## 시퀀스 함수

create sequence member_seq
increment by 1
start with 1 -- start 1~
minvalue 1
maxvalue 9999
nocycle -- 9999 over error
cache 20 -- 메모리에 시퀀스값 미리 할당
; 

create sequence employee_seq 
increment by 1
start with 1
minvalue 1
maxvalue 9999
nocycle
nocache
;

-- 시퀀스 수정
alter sequence employee_seq increment by 2;

-- 시퀀스 삭제
drop sequence employee_seq;

-- nextval : 번호 증가
select member_seq.nextval from dual;
-- currval : 번호 확인
select member_seq.currval from dual;




create table board(
    bno number(4) primary key,
    btitle varchar2(2000),
    bcontent clob, -- clob : 4Gb, varchar2 : 4000byte 130자
    id varchar2(100),
    bgroup number(4),
    bstep number(4),
    bindent number(4),
    bhit number(4),
    bfile varchar2(1000),
    bdate date
);

