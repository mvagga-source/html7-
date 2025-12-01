

-- primery key ////////////////////////////////////////////////
-- 데이터 : 자료의 집합, 정보 : 유용한 자료
-- 무결성 제약조건 : 데이터 입력시 잘못된 데이터의 입력을 제약

-- primery key 수정
--                   // 별칭
alter table mem2 add constraint pk_mem2_id primary key(id);

-- primery key 등록
create table mem3(
id varchar2(100) primary key,
pw varchar2(100)
);


-- foreign key //////////////////////////////////////////////

select * from board;
select * from board3;

-- foreign key 수정
create table board3 as select * from board;

alter table mem2 add constraint pk_mem2_id primary key(id);

alter table board3 
add constraint fk_board3_mem2_id foreign key(id) references mem2(id);

-- foreign key 삭제
alter table board3 drop constraint fk_board3_mem2_id;

-- foreign key 등록
create table board4(
bno number(4) primary key,
btitle varchar2(1000) not null,
bcontent clob,
id varchar2(100),
constraint fk_board4_mem2_id foreign key(id) references mem2(id)
);

drop table board4;

select * from board3;

insert into board3 values(
board_seq.nextval,'제목','내용','abc',board_seq.currval,0,0,0,'1.jpg',sysdate
);

-- 1. foreign key 기본 삭제 방법
select * from mem2 where id='aaa';
select * from board3 where id='aaa';

-- 관련자료 삭제 후
delete from board3 where id='aaa';
-- 해당 ID 삭제 가능
delete from mem2 where id='aaa';

rollback;

-- 2. 부모키 삭제시 foreign key가 등록된 데이터 모두삭제

alter table board3 drop constraint fk_board3_mem2_id;

delete from mem2 where id='aaa';

alter table board3 
add constraint fk_board3_mem2_id foreign key(id) references mem2(id)
on delete casecade
;

-- 3. 부모가 삭제시 foreign key가 등록된 id null 처리
delete from mem2 where id='aaa';

alter table board3 
add constraint fk_board3_mem2_id foreign key(id) references mem2(id)
on delete set null
;

select * from board3 ;

drop table board2;
drop table board3;
drop table mem;

create table mem(
id varchar2(100) primary key,
pw varchar2(100) not null,
name varchar2(100) unique,
phone char(13) default '010-0000-0000',
gender nvarchar2(2) check(gender in('남자','여자')),
hobby varchar2(100) default '게임',
age number(3) check (age between 0 and 120)
);

insert into mem(id,pw,gender) values ('aaa','1111','남자');


-- 논리 / 조건 //////////////////////////////////////////////

create table stuscore2 as select * from stuscore;
select * from stuscore2;
alter table stuscore2 add leader nvarchar2(2);

update stuscore2 set leader='반장' where sno = 104;

-- decode 조건이 같은 경우만 실행
select sno,name,
    decode(sno,10,'반장',
               20,'부반장',
               30,'총무',
               40,'총무2') as leader2 from stuscore2;

-- case when 비교연산자 사용가능
select sno,name,
    case when sno<=10 then '반장'
         when sno>=20 then '부반장'
         when sno>=30 then '총무'
         end as leader2 from stuscore2;

alter table stuscore2 add event date;
alter table stuscore2 add rank nvarchar2(1);
select sdate,last_day(sdate),trunc(sdate,'month') from stuscore2;

select sdate,event,last_day(sdate) from stuscore2;
select * from stuscore2;

update stuscore2 a set a.event=last_day(sdate);
update stuscore2 a set a.event=(select last_day(sdate) from stuscore2 b where a.sno = b.sno );

update stuscore2 a set rank = (
case when avg>=90 then 'A'
         when avg>=80 then 'B'
         when avg>=70 then 'C'
         when avg>=60 then 'D'
         --when avg<60 then 'F'
         else 'F'
         end
); 

alter table stuscore2 modify sdate invisible;
alter table stuscore2 modify leader invisible;
alter table stuscore2 modify event invisible;
alter table stuscore2 modify rank invisible;

alter table stuscore2 modify rank visible;
alter table stuscore2 modify sdate visible;
alter table stuscore2 modify leader visible;
alter table stuscore2 modify event visible;

select * from stuscore2 order by sno;
-- 클래스 컬럼을 1개 추가
-- 1~10까지 1반

alter table stuscore2 add class varchar2(10);
alter table stuscore2 modify class varchar2(10);
select * from stuscore2;

update stuscore2 set class = (
    case when sno between 1 and 10 then '1반'
    when sno between 11 and 20 then '2반'
    when sno between 21 and 30 then '3반'
    when sno between 31 and 40 then '4반'
    when sno between 41 and 50 then '5반'
    when sno between 51 and 60 then '6반'
    when sno between 61 and 70 then '7반'
    when sno between 71 and 80 then '8반'
    when sno between 81 and 90 then '9반'
    when sno between 91 and 100 then '10반'
    else '기타'
    end
);

-- rank 순위
select sno,name,total from stuscore2;
select rank() over(order by total desc) rank from stuscore2;



-- to_date() : 연산이 가능함, 문자형식의 날짜를 날짜형으로 변경 필요
select to_char(sum(kor),'9,999'), round(avg(kor),2), max(kor), min(kor), count(kor) from stuscore2;

-- 단일컬럼과 그룹함수는 같이 사용 불가

-- group by 단일컬럼
-- max(kor) 이름을 기준으로 최대국어점수 출력
select * from stuscore2;

select avg(avg) from stuscore2;

-- 반별평균
-- 그룸컬럼의 조건절은 where에서 사용 할수 없음
-- 그룸컬럼의 조건절은 having에 입력해야 함
select class, avg(avg) from stuscore2 
where 
    group by class 
    having avg(avg)<=52.33;


select salary, department_id from employees order by department_id;

select sum(salary) from employees;
select avg(salary) from employees;

--                               부서별 평균
select department_id,sum(salary),avg(salary) from employees 
group by department_id 
having avg(salary) >= (select avg(salary) from employees) -- 이중쿼리
order by department_id;




select count(*) from member, board;
select * from member, board;
select count(*) from board;

-- ################################################################################################################

-- cross join (inner join, outer join) ////////////////////////////////////////
select * from employees, departments;

-- inner join : equi-join, non equi-join, self join
-- outer join : null join



-- iner join /////////////////////////////////////////
-- 1. equi join. (동일한 컬럼이 존재)
select 
    EMP_NAME,
    employees.DEPARTMENT_ID,
    DEPARTMENT_NAME
from employees, departments
where employees.DEPARTMENT_ID = departments.DEPARTMENT_ID
;
-- join 시 공통컬럼 외 다른 컬럼의 내용이 바뀌면 변경된 내용을 가져옴
select 
    member.id,
    name,
    phone,
    bno,
    btitle 
from board, member
where member.id = board.id
;

-- 2. non-equi join : 같은 컬럼이 없고 두 테이블을 조인하는 방법

create table scoregrade(
grade char(1),
lowgrade number(8,5),
highgrade number(8,5)
);

insert into scoregrade values ('A',90,100);
insert into scoregrade values ('B',80,89.99999);
insert into scoregrade values ('C',70,79.99999);
insert into scoregrade values ('D',60,69.99999);
insert into scoregrade values ('F',0,59.99999);

commit;

drop table scoregrade;

select sno,name,kor,eng,math,total,avg,sdate from stuscore;
select grade,lowgrade,highgrade from scoregrade;

select name,avg,grade 
from stuscore a, scoregrade b
where avg between lowgrade and highgrade
;

-- salgrade
-- '대표','부사장','부장','과장','대리','사원'

select emp_name, salary from employees
order by salary desc
;

with salgrade as (
select '대표' as grade,20000 as lowgrade,50000 as heighgrad from dual union all
select '부사장',13000,19999 from dual union all
select '부장',10000,12999 from dual union all
select '과장',8000,9999 from dual union all
select '대리',6000,7999 from dual union all
select '사원',0,5999 from dual
)
select emp_name, salary, grade
from salgrade,employees
where salary between lowgrade and heighgrad
;

select * from stuscore2;
alter table stuscore2 drop column rank;
alter table stuscore2 drop column leader;

select a.*, grade 
from stuscore2 a, scoregrade
where avg between lowgrade and highgrade;

alter table stuscore2 add grade char(1);

update stuscore2 a set grade = (select b.grade from scoregrade b where a.avg between lowgrade and highgrade);

commit;

select * from stuscore2;
select * from scoregrade;


-- self join : 같은 테이블을 2개 사용할때

select a.employee_id, a.emp_name, a.manager_id, b.emp_name 
from employees a, employees b 
where a.manager_id = b.employee_id;

-- outer join : self join의 누락된 null값도 출력, null값이 존재하는 반대편에 (+)를 넣어줌

select a.employee_id, a.emp_name, a.manager_id, b.emp_name 
from employees a, employees b 
where a.manager_id = b.employee_id(+);

select count(1) from employees;


-- ansi join ////////////////////////////////////////////////////////////////////
-- ansi equi join
select emp_name, department_id, department_name 
from employees inner join departments
using(department_id)
;
-- equi join(위와 동일)
select emp_name, department_id, department_name 
from employees, departments
where department_id = department_id
;

-- natural join


-- ansi outer join
select emp_name, a.department_id, department_name 
from employees a right outer join departments b
on a.department_id = b.department_id
;
select emp_name, a.department_id, department_name 
from employees a left outer join departments b
on a.department_id = b.department_id
;
select emp_name, a.department_id, department_name 
from employees a full outer join departments b
on a.department_id = b.department_id
;
select emp_name, department_id, department_name 
from employees full outer join departments
using(department_id)
;


-- rownum 순번 출력 //////////////////////////////////////////////////////////
select * from member;
select rownum,a.* from member a;

select * from board order by bno
;

-- rownum : 쿼리 한건씩 조회후 번호 설정
select rownum, a.* from board5 a 
where rownum between 11 and 20 order by bno;

-- rownum 응용
-- 번호 부여 후 정렬순으로 진행되어 정렬 먼저 실행 후 번호 부여 실행
select rownum rnum,a.* from (select * from board5 order by bno asc) a
;
select * from 
(
    select rownum rnum,a.* from -- 순번 설정
    (select * from board5 order by bno asc) a -- 정렬
)
where rnum between 21 and 30;

-- row_number() 응용 // 정렬이 있는 경우 사용
select row_number() over(order by bno asc) rnum,a.* from board5 a;

select * from 
(
    select row_number() over(order by bno asc) rnum,a.* from board5 a -- 순번 설정 및 정렬
)
where rnum between 21 and 30;

-- rank() : 중복순위 ,  dense_rank() : 중복순위 다음 순번 부여
select rank() over(order by total desc) r,
    dense_rank() over(order by total desc) d,
    name,total 
from stuscore;

-- rank() update
update stuscore a set rank=(
    select ranks from(
        select sno,rank() over(order by total desc) ranks from stuscore
    )b where a.sno = b.sno
);
select * from stuscore order by total desc;