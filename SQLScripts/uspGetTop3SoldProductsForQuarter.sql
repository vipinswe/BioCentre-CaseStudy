/**********************************************************************************************************
Description: This procedure generates top 3 sold products for each quarter and total number of all products
Author: Vipin Vipin
Created Date: 09.09.2021
***********************************************************************************************************/
CREATE OR ALTER PROCEDURE dbo.uspGetTop3SoldProductsForQuarter
AS 
BEGIN 
    BEGIN TRY
        WITH CTE_Sales AS
        (
            SELECT
            SUM(SOD.OrderQty) TotalQty
            ,P.Name ProductName
            ,CONCAT(CAST(DATEPART(YY, SOH.OrderDate) AS VARCHAR),' Q',CAST(DATEPART(QQ, SOH.OrderDate) AS VARCHAR)) AS Quarter
            ,Row_Number() OVER(PARTITION BY CONCAT(CAST(DATEPART(YY, SOH.OrderDate) AS VARCHAR),' Q',CAST(DATEPART(QQ, SOH.OrderDate) AS VARCHAR)) ORDER BY sum(SOD.OrderQty) DESC) AS Rank
            FROM sales.SalesOrderDetail SOD
            INNER JOIN sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID
            INNER JOIN Production.Product P ON P.ProductID = SOD.ProductID
            GROUP BY P.Name, CONCAT(CAST(DATEPART(YY, SOH.OrderDate) AS VARCHAR),' Q',CAST(DATEPART(QQ, SOH.OrderDate) AS VARCHAR))
        )
        ,AllProductsInQuater
        AS
        (
            SELECT
            SUM(SOD.OrderQty) [Total Number of All Products In Quarter]
            ,CONCAT(CAST(DATEPART(YY, SOH.OrderDate) AS VARCHAR),' Q',CAST(DATEPART(QQ, SOH.OrderDate) AS VARCHAR)) Quarter
            FROM sales.SalesOrderDetail SOD
            INNER JOIN sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID
            GROUP BY CONCAT(CAST(DATEPART(YY, SOH.OrderDate) AS VARCHAR),' Q',CAST(DATEPART(QQ, SOH.OrderDate) AS VARCHAR))
        )
        SELECT S.Quarter
        ,Product1Name = MAX(CASE WHEN S.Rank = 1 THEN S.ProductName END )
        ,Product1TotalQty = MAX(CASE WHEN S.Rank = 1 THEN S.TotalQty END )
        ,Product2Name = MAX(CASE WHEN S.Rank = 2 THEN S.ProductName END )
        ,Product2TotalQty = MAX(CASE WHEN S.Rank = 2 THEN S.TotalQty END )
        ,Product3Name = MAX(CASE WHEN S.Rank = 3 THEN S.ProductName END )
        ,Product3TotalQty = MAX(CASE WHEN S.Rank = 3 THEN S.TotalQty END )
        ,[Total Number of All Products In Quarter]
        FROM CTE_Sales AS S
        INNER JOIN AllProductsInQuater APQ ON s.Quarter=APQ.Quarter
        WHERE Rank <=3
        GROUP BY S.Quarter,APQ.[Total Number of All Products In Quarter]
        
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
