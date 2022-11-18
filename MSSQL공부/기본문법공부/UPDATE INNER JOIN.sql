--1.
--[Purchasing].[PurchaseOrderDetail]���� �� ���� �ݾ��� ���� ���Ҵ� 5���� ��ǰ�� Ȯ���ϰ� ���������� ����Ͽ� �ش� ��ǰ�� �ܰ��� 10% �λ��Ͽ� 
--[Production].[Product] ���̺��� [ListPrice]�� �����Ͻÿ�.

UPDATE [Production].[Product] SET ListPrice = ListPrice*1.1 WHERE ProductID IN 
(SELECT TOP 5 ProductID AS ST FROM [Purchasing].[PurchaseOrderDetail] GROUP BY ProductID ORDER BY SUM(LINETOTAL) DESC)

SELECT ProductID, ListPrice FROM [Production].[Product] WHERE ProductID IN 
(SELECT TOP 5 ProductID AS ST FROM [Purchasing].[PurchaseOrderDetail] GROUP BY ProductID ORDER BY SUM(LINETOTAL) DESC)
319	0.00
936	68.299
939	68.299
948	117.15
907	117.15

319	0.00
936	82.6418
939	82.6418
948	141.7515
907	141.7515

--2. UPDATE INNER JOIN
SELECT * FROM [HumanResources].[Department2]
SELECT * FROM [HumanResources].[Department]

UPDATE [HumanResources].[Department2] SET Name=B.Name
FROM [HumanResources].[Department2] A, [HumanResources].[Department] B WHERE A.[DepartmentID]=B.[DepartmentID]	