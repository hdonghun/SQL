--1. SELECT INTO ���̺� ����(���纻 ���̺��� �̿�)
SELECT * INTO B FROM A , #A�� �ִ� ������, ���� ������ ���� �ȴ�.
SELECT * INTO [HumanResources].[Department2]  FROM [HumanResources].[Department]
SELECT * FROM [HumanResources].[Department2]

-- 2. �������� �̿��Ͽ� �뷮 �Է� ���.
DELETE * FROM [HumanResources].[Department2]
SELECT* FROM [HumanResources].[Department2]
INSERT INTO [HumanResources].[Department2] SELECT [Name] , [GroupName] , [ModifiedDate] FROM [HumanResources].[Department]
DepartmentID�� ������ 3���� �ʵ常 �����´�.
SELECT * FROM [HumanResources].[Department2]