	--SELECT * FROM[HumanResources].[Department]
	--AS를 통해서 컬럼의 이름을 설정해주거나 설정해준다.
	--SELECT 100+100 AS A_SUM, 100-100 AS A_MIN, 100*100 AS A_MUL, 100/100 AS A_DIV
	--특정 결과를 AS로 컬럼의 별칭을 설정해준다.
	SELECT NAME,ListPrice,LISTPRICE*1.1 AS U_PRICE FROM [Production].[Product] WHERE ListPrice>999