--in�� ������ ���ǰ˻��� �����ϴ�, OR�� Ȯ�� �������̴�.
--SELECT*FROM [Sales].[Store] WHERE [SalesPersonID]=277 OR [SalesPersonID]=283 OR [SalesPersonID]=290 
--SELECT*FROM [Sales].[Store] WHERE [SalesPersonID] IN (277,281,283,290) 
SELECT*FROM [Sales].[Store] WHERE [SalesPersonID] NOT IN (277,281,283,290)