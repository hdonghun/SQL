--LEFT(X1,X2)
--RIGHT(X1,X2)
--SUBSTRING(X1,X2,X3)
SELECT Comments, LEFT(Comments,10) AS L_TEST, RIGHT(Comments,10) AS R_TEST, 
				SUBSTRING(Comments,5,15) AS S_TEST FROM [Production].[ProductReview]
