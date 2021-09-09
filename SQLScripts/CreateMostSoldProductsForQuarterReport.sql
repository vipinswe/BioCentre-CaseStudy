
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'MostSoldProductsForQuarterReport' AND type = 'U') 
    DROP TABLE Sales.MostSoldProductsForQuarterReport;
    CREATE TABLE Sales.MostSoldProductsForQuarterReport
    (
        ID                      INT NOT NULL IDENTITY(1,1),
        Quarter                 NVARCHAR(8) NOT NULL,
        Product1Name            NVARCHAR(250) NOT NULL,
        Total1Quantity          INT NOT NULL,
        Product2Name            NVARCHAR(250) NOT NULL,
        Total2Quantity          INT NOT NULL,
        Product3Name            NVARCHAR(250) NOT NULL,
        Total3Quantity          INT NOT NULL,
        ProductsTotalInQuarter  INT NOT NULL,
        PRIMARY KEY (ID)
    )