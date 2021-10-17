--INNER JOIN을 명시해서, 작성
SELECT * FROM [Production].[Product] AS PP INNER JOIN [Production].[ProductDescription] AS PD
ON PP.PRODUCTID=PD.ProductDescriptionID
--특별히 JOIN을 안해도, 기본적으로 INNER JOIN이 된다. > INNER JOIN을 명시하지 않고 ,(쉼표)로 나타내고, 그에 따라 ON이 아니라 WHERE 조건을 사용한다.
SELECT * FROM [Production].[Product] AS PP , [Production].[ProductDescription] AS PD
WHERE PP.PRODUCTID=PD.ProductDescriptionID
