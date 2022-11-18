--SELECT[StockedQty]*[OrderQty],[OrderQty]-[ReceivedQty]FROM [Purchasing].[PurchaseOrderDetail]
--SELECT*FROM [Purchasing].[PurchaseOrderDetail] WHERE [StockedQty]*[OrderQty]>30003
SELECT[CountryRegionCode],[Name],[CountryRegionCode]+' AND '+[Name] FROM[Person].[CountryRegion]