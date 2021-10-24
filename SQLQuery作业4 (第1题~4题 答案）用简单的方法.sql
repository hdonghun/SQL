--1번 문제
use university insert into [dbo].[instructor.teaches]
values
(10101,'Srinivasan','Comp.Sci.',65000,'CS-101',1,'Fall',2009),
(10101,'Srinivasan','Comp.Sci.',65000,'CS-315',1,'Spring',2010),
(10101,'Srinivasan','Comp.Sci.',65000,'CS-347',1,'Fall',2009),
(12121,'Wu','Finance',90000,'FIN-201',1,'Spring',2010),
(15151,'Mozart','Music',40000,'MU-199',1,'Spring',2010),
(22222,'Einstein','Physics',95000,'PHY-101',1,'Fall',2009),
(32343,'El Said','History',60000,'HIS-351',1,'Spring',2010),
(45565,'Katz','Comp.Sci.',75000,'CS-101',1,'Spring',2010),
(45565,'Katz','Comp.Sci.',75000,'CS-319',1,'Spring',2010),
(76766,'Crick','Biology',72000,'BIO-101',1,'Summer',2009),
(76766,'Crick','Biology',72000,'BIO-301',1,'Summer',2010),
(10101,'Brandt','Comp.Sci.',92000,'CS-190',1,'Spring',2009),
(10101,'Brandt','Comp.Sci.',92000,'CS-190',2,'Spring',2009),
(10101,'Brandt','Comp.Sci.',92000,'CS-319',2,'Spring',2010),
(10101,'Kim','Elec.Eng.',80000,'EE-181',1,'Spring',2009);
---------------------------------------------------------------------------------------------------------------------------
--2번 문제
select name,course_id from [dbo].[instructor.teaches]
where semester='Spring' and year=2009;

select dept_name, AVG(salary) as avg_salary
from [dbo].[instructor.teaches] group by dept_name order by avg_salary asc;

select dept_name, avg_salary
from(select dept_name,AVG(salary) as avg_salary from [dbo].[instructor.teaches]
group by dept_name) b where avg_salary >= 60000

select dept_name,avg_salary
from(select  dept_name,AVG(salary) as avg_salary from [dbo].[instructor.teaches]
where year=2010 group by dept_name)b
where avg_salary <= 70000
---------------------------------------------------------------------------------------------------------------------------
--3번문제
select course_id from [dbo].[instructor.teaches]
where semester='Spring' and year=2010; 

(select course_id
from [dbo].[instructor.teaches]
where semester='Fall' and year=2009) intersect
(select course_id
from [dbo].[instructor.teaches]
where semester='Spring' and year=2010);


(select course_id from [dbo].[instructor.teaches] where semester='Spring' and year=2010) except
(select course_id from  [dbo].[instructor.teaches] where semester='Fall' and year=2009);

select ID from [dbo].[instructor.teaches] where 
salary < some(select salary from [dbo].[instructor.teaches] 
where dept_name ='Comp.Sci.');

select name from [dbo].[instructor.teaches]
where salary < all(select salary from [dbo].[instructor.teaches] 
where dept_name='Comp.Sci');
---------------------------------------------------------------------------------------------------------------------------
--4번 문제
UPDATE [dbo].[instructor.teaches]
set salary = salary*0.9;

update [dbo].[instructor.teaches]
set salary = salary*0.95 where salary > 70000;

delete from [dbo].[instructor.teaches] where salary >= 70000;
