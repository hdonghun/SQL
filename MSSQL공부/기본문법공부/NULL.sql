SELECT [ProductID],[BusinessEntityID],[StandardPrice],[OnOrderQty] FROM [Purchasing].[ProductVendor]
WHERE [OnOrderQty] IS NOT NULL
--IS NULL : 아직 값이 정해지지 않은 상태를 나타낸다. 
