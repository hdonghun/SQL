SELECT [ProductID],[BusinessEntityID],[StandardPrice],[OnOrderQty] FROM [Purchasing].[ProductVendor]
WHERE [OnOrderQty] IS NOT NULL
--IS NULL : ���� ���� �������� ���� ���¸� ��Ÿ����. 
