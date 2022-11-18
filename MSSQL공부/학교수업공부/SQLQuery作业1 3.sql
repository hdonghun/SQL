CREATE  DATABASE week_2_test use  week_2_test
go
create  table employee (
person_name  varchar(20)  not null  primary  key, street  varchar(100),
city  varchar(100), )

create  table works (
person_name  varchar(20)  not null, company_name  varchar(20)  not null, salary  int,
)
create  table company (
company_name  varchar(20)  not null, city  varchar(100),
)

insert into  works values
('Jack','Alibaba',40054), ('Li','Baidu',50098),
('Zhang','BytyDance',60987); select *  from  works

select person_name,salary  from  works
