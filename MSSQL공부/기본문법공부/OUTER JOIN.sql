SELECT * FROM [HumanResources].[EmployeeDepartmentHistory] 
SELECT * FROM  [HumanResources].[Department]

SELECT * FROM [HumanResources].[EmployeeDepartmentHistory] AS A LEFT OUTER JOIN [HumanResources].[Department] AS B
ON A.[DepartmentID] = B.[DepartmentID]