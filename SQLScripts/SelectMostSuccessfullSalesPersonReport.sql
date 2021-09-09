SELECT Top5Success.[Year]
    ,Top5Success.[Salesperson Name]
    ,Top5Success.Surname
    ,Top5Success.[Number Of Orders]
    ,Top5Success.[Total Price Of Orders]
    ,Top5Success.[Total Number of Orders in year]
    ,Top5Success.[Total Price Of Orders in Year]
FROM 
(
    SELECT DISTINCT DATEPART(YY,SOH.OrderDate) Year
        ,P.FirstName AS 'Salesperson Name'
        ,P.LastName AS Surname, sum(SOD.OrderQty) 'Number Of Orders'
        ,SUM(SOD.LineTotal) 'Total Price Of Orders'
        ,MAX(Totaltable.OrderQuantity) as 'Total Number of Orders in year'
        ,MAX(Totaltable.TotPrice) as 'Total Price Of Orders in Year'
        ,RANK() OVER   
                (PARTITION BY DATEPART(YY, SOH.OrderDate) ORDER BY sum(SOD.OrderQty) DESC) AS Rank
    FROM Sales.SalesOrderHeader SOH INNER JOIN Person.Person P ON SOH.SalesPersonID = P.BusinessEntityID
    INNER JOIN Sales.SalesOrderDetail SOD ON SOD.SalesOrderID = SOH.SalesOrderID
    INNER JOIN (SELECT DATEPART(YY,SOH.OrderDate) Year
                    ,sum(SOD.OrderQty) OrderQuantity
                    ,sum(SOD.LineTotal) TotPrice 
                FROM Sales.SalesOrderHeader SOH 
                INNER JOIN Person.Person P ON SOH.SalesPersonID = P.BusinessEntityID
                INNER JOIN Sales.SalesOrderDetail SOD ON SOD.SalesOrderID = SOH.SalesOrderID 
                GROUP BY DATEPART(YY,SOH.OrderDate)) AS Totaltable ON Totaltable.[Year] = DATEPART(YY,SOH.OrderDate)
    GROUP BY DATEPART(YY,SOH.OrderDate), P.FirstName, P.LastName
) AS Top5Success
WHERE Rank <= 5