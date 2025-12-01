
--날짜 ##################################################################################
select sysdate from dual;
select sysdate-1,sysdate,sysdate+1,sysdate+100 from dual;

select * from board
where bdate>'2025/11/01';

--                           //오전, 오후 표시     //24시간 표시
select name, to_char(sdate,'yyyy-mm-dd am hh24:mi:ss') from stuscore;

-- 월기준 : 15일 이전 :1, 15일 이후 : 1개월 추가
select hire_date, round(hire_date,'month') from employees;
-- 월기준 : 1일로 변경
select hire_date, trunc(hire_date,'month') from employees order by hire_date;

-- 요일기준 : 수요일 기준으로 이전 일요일 또는 이후 일요일로 변경
select hire_date, round(hire_date,'day') from employees;
select bdate, round(bdate,'day') from board;

-- board테이블에서 입력한 게시글 기준 1일을 출력
select bdate, trunc(bdate,'month') from board order by bdate;


-- 게시글 2024-12-01 ~ 2025-05-31 까지 게시글을 출력
select bdate,trunc(bdate,'day'),bdate-30 from board 
where 
    bdate between '2024/12/01' and '2025/05/31' order by bdate;

-- 개월수 계산 : months_between
select sysdate,sdate,
trunc(months_between(sysdate,sdate))||'개월'
from stuscore;    

-- add_months : 특정 개월수를 더한 날짜확인
select name,sdate,add_months(sdate,6) from stuscore;

-- 월기준 1월, 일기준 1일 설정
select hire_date, trunc(hire_date,'month')||'~'||last_day(hire_date) from employees;

select sysdate, next_day(sysdate,1) from dual;



-- 컬럼 합치기 ##################################################################################
select concat(btitle,bcontent) from board;
select btitle||bcontent from board;

select * from member;
select id||'-'||pw||'-'||name from member;


-- 가장 오래 근무한 사원순으로 출력
select sysdate - hire_date as hdate from employees order by hdate;

-- board 현재 게시글 날짜가 얼마나 지났는지 출력
-- 소수점 2자리에서 반올림
select * from board;
select btitle, round(sysdate-bdate,2) p from board order by p;

-- 버림
select btitle, trunc(sysdate-bdate,4) p from board order by p;




-- 문자열 함수 ##################################################################################
-- length : 문자길이
select name,length(name),lengthb(name) from stuscore;

-- substr : 문자자르기 (컬럼명, 시작위치, 개수)
select name,substr(name,0,2) from stuscore;

-- s1423, s2798 숫자의 합
select to_number(substr('s1423',2,4)),to_number(substr('s2798',2,4)) from dual;
select to_number(substr('s1423',2,4))+to_number(substr('s2798',2,4)) from dual;

-- instr함수
select name from member 
where name like '%ni%' ;

select name, instr(name,'n') from member where instr(name,'n') != 0;

-- trim, ltrim, rtrim
select '     abc        ' from dual;
select ltrim('     abc        ') from dual;
select rtrim('     abc        ') from dual;
select trim('     abc        ') from dual;

-- replace
select replace('     ab   c        ',' ','') from dual;

-- rpad, lpad
select id,pw from member;
select id,rpad(pw,10,'*') from member;
select id,rpad(substr(pw,1,2),4,'*') as pw from member;

-- 이중쿼리 ######################################################################################
create table stu(
sno number(4),
name varchar2(100),
sdate date,
sdate2 date
);

insert into stu(sno, name, sdate) select sno,name,sdate from stuscore;

select sno,name,sdate,add_months(sdate,120) from stu;

update stu a set a.sdate2 = (select add_months(b.sdate,120) from stu b where a.sno = b.sno);


-- 순위 : rank()함수 #############################################################################
select sno,name,total,rank() over(order by total desc)from stuscore;
select sno,name,total,rank() from stuscore;


-- 형변환 함수 : to_chat(), to_number(), to_date() ################################################
-- to_char()
--                                           // 천단위 표시 L : 원화표시, $ : 달러표시
select salary,length(salary),to_char(salary*12,'L999,999,999') sal,to_char(salary*12*1473) from employees;
select max(length(salary*12)) from employees;


select sdate,to_char(sdate,'yyyy-mm-dd hh24:mi:ss') from stuscore;
select sdate,to_char(sdate,'yyyy-mm-dd hh24:mi:ss day') from stuscore;
select sdate,to_char(sdate,'yyyy-mm-dd hh24:mi:ss mon day') from stuscore;

select sdate,to_char(sdate,'mm') from stuscore;
select sdate,to_char(sdate,'yyyy/mm/dd') from stuscore;
select sdate,to_char(sdate,'mm'),substr(to_char(sdate,'yyyy/mm/dd'),6,2) from stuscore;

select phone, substr(phone,1,instr(phone,'-')-1),substr(phone,instr(phone,'-')+1,3),substr(phone,instr(phone,'-',-1)+1,4) from member;


-- to_date() : 문자열을 날짜로 변경
-- 문자열을 날짜타입으로 변경하는 이유 : 날짜와 날짜사이의 간격, 특정날짜를 더하기 등..
select sysdate-'20251027' from dual; -- error
select sysdate-to_date('20251127','yyyymmdd') from dual;
select add_months(to_date('20251127','yyyymmdd'),1) from dual;
select months_between(sysdate,to_date('20251027','yyyymmdd')) from dual;

-- to_number() 문자열을 숫자로 변경
select to_number('3000') from dual;
select '20,000','30,000' from dual;
select to_number('20,000','99,999'),to_number(replace('30,000',',','')) from dual;


-- 그룹함수  count, max, min, count, sum #######################################################
-- 그룹함수는 일반 열의 컬럼과 함께 사용할수 없음
select median(salary) from employees;
select count(kor), avg(kor), max(kor),min(kor),median(kor),variance(kor),stddev(kor) from stuscore;
select count(*) from employees;

select sum(salary),avg(salary) from employees;
select max(salary),min(salary) from employees;

select department_id,salary from employees;
select sum(salary),round(avg(salary),2),max(salary),min(salary),count(salary) from employees where department_id = 50;
select emp_name,department_id from employees where salary = (select max(salary) from employees where department_id = 50);

select max(salary) from employees;
select emp_name from employees where salary = (select max(salary) from employees);

select round(avg(salary)) from employees; --6462
select emp_name,salary from employees where salary >= (select avg(salary) from employees) 
order by salary;

select count(1) from stuscore where kor >= (select avg(kor) from stuscore);
-- count(*)
select * from employees where manager_id is null;
select count(*) from employees;



-- 527-***-1397 출력
select phone, instr(phone,'-',-1) from member;
select phone, replace(phone,substr(phone,instr(phone,'-'),5),'-***-') from member;

-- 11** rpad()
select id, rpad(substr(pw,1,length(pw)-2),length(pw),'*') from member;

select name, length(name),nvl(substr(name,1,length(name)-2),substr(name,1,1)) from member;
select name,rpad(nvl(substr(name,1,length(name)-2),substr(name,1,1)),length(name),'*') from member;


-- ####################################################################################################
-- 제약조건 : primary key, foreign key, not null, unique, check
-- primary key : null불가, 중복불가
-- foreign key : 다른테이블에 primary key 등록이 되어애 FK로 등록가능
-- not null : null 불가, 중복가능
-- unique : null 가능, 중복불가
-- check : 설정값만 입력가능

create table mem (
id varchar2(100) primary key,
pw varchar2(100) not null,
name varchar2(100) unique,
phone char(13),
gender nvarchar2(2) check(gender in ('남자','여자')),
hobby varchar2(100),
mdate date
);

insert into mem values(
'aaa','1111','홍길동','010-1111-1111','남자','게임',sysdate
);

insert into mem values(
'bbb','1111',null,'010-1111-1111','남자','게임',sysdate
);

insert into mem values(
'ccc','1111',null,'010-1111-1111','여자','게임',sysdate
);

insert into mem values(
'ddd','1111',null,'010-1111-1111','여자','게임',sysdate
);

insert into mem (id,pw,gender) values('fff','1111','여자');


create table board2 as select * from board;


-- foreign key 등록
alter table board2 add constraint fk_mem_board2_id foreign key(id)
references mem(id)
;

-- mem테이블, board2테이블 id컬럼이 연결
-- mem 테이블에 없는 id board2에 id로 등록이 불가
-- mem테이블을 board2의 id가 삭제되지 않으면 mem테이블 삭제할수 없음