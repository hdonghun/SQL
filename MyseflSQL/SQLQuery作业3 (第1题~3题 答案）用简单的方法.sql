--1¹ø 
use university go 
insert into department
values
('Biology','Watson',90000),
('Comp.Sci','Taylor',100000),
('Elec.Eng','Taylor',85000),
('Finance','Painter',120000),
('History','Painter',50000),
('Music','Packard',80000),
('Physics','Watson',70000);

insert into student
values
(00128,'Zhang','Comp.Sci',102),
(12345,'Shankar','Comp.Sci',32),
(19991,'Brandt','History',80),
(23121,'Chavez','Finance',110),
(44553,'Peltier','Physics',56),
(45678,'Levy','Physics',46),
(54321,'Williams','Comp.Sci',54),
(55739,'Sanchez','Music',38),
(70557,'Snow','Physics',0),
(76543,'Brown','Comp.Sci',58),
(76653,'Aoi','Elec.Eng',60),
(98765,'Bourikas','Elec.Eng',98),
(98988,'Tanaka','Biology',120);
--------------------------------------------------------------------------------------------------------------------------------------
--2¹ø
select building from department
select distinct budget from department
select dept_name from department where budget >=90000;
select dept_name, building from department where building like '%r';
select name from student where dept_name='Comp.Sci' and tot_cred=102;
select ID, name, tot_cred from student where dept_name='Comp.Sci';
--------------------------------------------------------------------------------------------------------------------------------------
--3¹ø
select avg(budget) as avgbudget from department
select dept_name, budget from department where budget >= all(select budget from department) or budget <= all(select budget from department);
select count(ID) as nstu, avg(tot_cred) as avgcred from student group by dept_name order by avg(tot_cred) desc;
select dept_name, avg(tot_cred) as avgcred from student group by dept_name having avg(tot_cred)>50;


