--#기본키 PRIMARY KEY
--데이터베이스(테이블) = { 개체(ENTITIY), 관계(RELATIONSHIP)의 집합}
	--기본키 primary key 개체를 식별하는 고유의 값--모든 테이블에는 기본키 값을 저장하는 필드(속성)가 받드시 존재
--CROSS JION 
SELECT * FROM [HumanResources].[Department] CROSS JOIN [Person].[AddressType]

--UNION -- 두개의 테이블의 합친다.( 두 테이블의 필드의 개수가 동일하여야 합니다. )
SELECT [BusinessEntityID], [LoginID]  FROM [HumanResources].[Employee]
UNIOM
SELECT [DepartmentID], [Name] FROM [HumanResources].[Department]
