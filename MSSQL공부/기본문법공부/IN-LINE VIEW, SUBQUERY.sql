--가상의 임시 테이블을 생성해서 데이터가져오기 , 주로 FROM뒤에 설정된다.
SELECT * FROM
(SELECT[Color], COUNT([Color]) AS CC, AVG([ListPrice]) AS ALP, SUM([ListPrice]) AS SLP
FROM [Production].[Product] WHERE [Color] IS NOT NULL GROUP BY [Color]) AS TT
WHERE CC>10

--서브 쿼리 SUBQUERY, 주로 조건절WHERE뒤에 설정된다.
SELECT* FROM [HumanResources].[EmployeeDepartmentHistory] WHERE [DepartmentID] IN
(SELECT [DepartmentID] FROM [HumanResources].[Department] WHERE [GroupName]='Sales and Marketing')

SELECT [DepartmentID] FROM [HumanResources].[Department] WHERE [GroupName]='Sales and Marketing'
