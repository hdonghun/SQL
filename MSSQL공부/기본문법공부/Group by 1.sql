SELECT DISTINCT(City) AS DT_TEST FROM [Person].[Address]

SELECT GENDER, COUNT(Gender) AS COUNTER_GENDER FROM [HumanResources].[Employee] GROUP BY GENDER

SELECT VendorID, COUNT(VendorID) AS CU_TEST FROM [Purchasing].[PurchaseOrderHeader] GROUP BY VendorID ORDER BY COUNT(VendorID) DESC
