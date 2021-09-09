IF EXISTS (SELECT * FROM sys.tables WHERE name = 'MostSuccessfullSalesPersonReport' AND type = 'U') 
    DROP TABLE Sales.MostSuccessfullSalesPersonReport;
CREATE TABLE Sales.MostSuccessfullSalesPersonReport
(
    ID                          INT NOT NULL IDENTITY(1,1),
    Year                        NVARCHAR(4) NOT NULL,
    SalespersonName             NVARCHAR(250) NOT NULL,
    Surname                     NVARCHAR(250) NOT NULL,
    NumberOfOrders              INT NOT NULL,
    TotalPriceOfOrders          NUMERIC(38,6) NOT NULL,
    TotalNumberOfOrdersInYear   INT NOT NULL,
    TotalPriceOfOrdersInYear    NUMERIC(38,6) NOT NULL,
    PRIMARY KEY (ID)
)