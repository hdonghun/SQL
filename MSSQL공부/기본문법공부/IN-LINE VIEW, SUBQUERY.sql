--������ �ӽ� ���̺��� �����ؼ� �����Ͱ������� , �ַ� FROM�ڿ� �����ȴ�.
SELECT * FROM
(SELECT[Color], COUNT([Color]) AS CC, AVG([ListPrice]) AS ALP, SUM([ListPrice]) AS SLP
FROM [Production].[Product] WHERE [Color] IS NOT NULL GROUP BY [Color]) AS TT
WHERE CC>10

--���� ���� SUBQUERY, �ַ� ������WHERE�ڿ� �����ȴ�.
SELECT* FROM [HumanResources].[EmployeeDepartmentHistory] WHERE [DepartmentID] IN
(SELECT [DepartmentID] FROM [HumanResources].[Department] WHERE [GroupName]='Sales and Marketing')

SELECT [DepartmentID] FROM [HumanResources].[Department] WHERE [GroupName]='Sales and Marketing'
