

-- rank() //////////////////////////////////////////////////////////////////////////////


select * from member;
select * from employees;

select row_number() over(order by id asc),a.* from member a;
select * from (select * from employees where emp_name like '%a%') where salary >= 7000;

select rank() over(order by total desc) r,
    dense_rank() over(order by total desc) d,
    name,total 
from stuscore;



alter table stuscore add rank number(3) default '0';
select rank() over(order by total desc) rank,sno,name,total from stuscore;
select rank() over(order by total desc) rank from stuscore;

update stuscore a set rank=(
    select ranks from(
        select sno,rank() over(order by total desc) ranks from stuscore
    )b where a.sno = b.sno
);
select * from stuscore order by total desc;

create table stuscore3 as select * from stuscore;

update stuscore3 set rank = 0;
select * from stuscore3 order by total desc;

--alter table stuscore3 add grade nchar(1) default 'D';

--//등수 입력
select * from scoregrade;
update stuscore3 a set a.grade = (select b.grade from scoregrade b where a.avg between b.lowgrade and b.highgrade);

select * from stuscore3 order by avg desc;

--// 순위 입력
update stuscore3 a set rank = (
select ranks from (
    select rank() over(order by avg desc) as ranks,sno from stuscore3
)b where a.sno = b.sno
)
;



