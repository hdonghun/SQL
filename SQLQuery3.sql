USE [week_2_test]
GO

INSERT INTO [dbo].[works]
           ([person_name]
           ,[company_name]
           ,[salary])
     VALUES
           (<person_name, nchar(10),>
           ,<company_name, nchar(10),>
           ,<salary, int,>)
GO


insert into works
values
('Jack','Alibaba',40054),
('Li','Baidu',50098),
('Zhang','BytyDance',60987);