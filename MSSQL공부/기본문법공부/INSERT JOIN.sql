--1. SELECT INTO 테이블 복사(복사본 테이블을 이용)
SELECT * INTO B FROM A , #A에 있는 데이터, 구조 모든것이 복사 된다.
SELECT * INTO [HumanResources].[Department2]  FROM [HumanResources].[Department]
SELECT * FROM [HumanResources].[Department2]

-- 2. 서브쿼를 이용하여 대량 입력 방법.
DELETE * FROM [HumanResources].[Department2]
SELECT* FROM [HumanResources].[Department2]
INSERT INTO [HumanResources].[Department2] SELECT [Name] , [GroupName] , [ModifiedDate] FROM [HumanResources].[Department]
DepartmentID를 제외한 3개의 필드만 가져온다.
SELECT * FROM [HumanResources].[Department2]