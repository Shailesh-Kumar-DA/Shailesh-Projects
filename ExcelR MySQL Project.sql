create database Adventure;
use Adventure;

#-------------------------------------------------------------------------------#
# total sales amount ,total production cost ,Total profit , tota quantity of order-------------------------------------------------------(1)

SELECT 
    CONCAT('$',
            CONCAT(ROUND(SUM(SalesAmount) / 1000000, 2),
                    'M')) AS 'Total Sales Amt.',
    CONCAT('$',
            CONCAT(ROUND(SUM(TotalProductCost) / 1000000, 2),
                    'M')) AS 'Total production cost',
    CONCAT('$',
            CONCAT(ROUND((SUM(SalesAmount) - SUM(TotalProductCost)) / 1000000,
                            2),
                    'M')) AS 'Total profit Gain',
    SUM(OrderQuantity) AS 'Total Qty Of Order'
FROM
    (SELECT 
        *
    FROM
        factinternetsales UNION SELECT 
        *
    FROM
        fact_internet_sales_new) fact;
#-------------------------------------------------------------------------------#
# sales amount wise top 10 customer-----------------------------------------(2)

ALTER TABLE customer ADD COLUMN customerFullName TEXT;
UPDATE customer 
SET 
    customerFullName = CONCAT_WS(' ', FirstName, MiddleName, LastName);

SELECT 
    customerFullName, sales_amt
FROM
    (SELECT 
        b.customerFullName,
            CONCAT('$', ROUND(SUM(a.SalesAmount) / 1000, 2), 'K') sales_amt,
            ROUND(SUM(a.SalesAmount) / 1000, 2) AS test
    FROM
        (SELECT 
        *
    FROM
        factinternetsales UNION SELECT 
        *
    FROM
        fact_internet_sales_new) AS a
    JOIN customer AS b ON b.CustomerKey = a.CustomerKey
    GROUP BY 1
    ORDER BY 3 DESC
    LIMIT 10) sub;

#---------------------------------------------------------------------------------#
# Month wise total sales amount, total production cost, total profit gain , total qty of order----------------------------------------------------------------(3)

SELECT 
    d.EnglishMonthName,
    CONCAT('$',
            CONCAT(ROUND(SUM(s.SalesAmount) / 1000000, 2),
                    'M')) AS sales_Amt,
    CONCAT('$',
            CONCAT(ROUND(SUM(TotalProductCost) / 1000000, 2),
                    'M')) AS 'Total production cost',
    CONCAT('$',
            CONCAT(ROUND((SUM(SalesAmount) - SUM(TotalProductCost)) / 1000000,
                            2),
                    'M')) AS 'Total profit Gain',
    SUM(OrderQuantity) AS 'Total Qty Of Order'
FROM
    (SELECT 
        *
    FROM
        factinternetsales UNION SELECT 
        *
    FROM
        fact_internet_sales_new) AS s
        JOIN
    date d ON d.DateKey = s.OrderDateKey
GROUP BY 1;

#---------------------------------------------------------------------------------#
 # Quarter wise total sales amount, total production cost, total profit gain , total qty of order----------------------------------------------(4)
    
SELECT 
    d.CalendarQuarter,
    CONCAT('$',
            CONCAT(ROUND(SUM(s.SalesAmount) / 1000000, 2),
                    'M')) AS sales_Amt,
    CONCAT('$',
            CONCAT(ROUND(SUM(TotalProductCost) / 1000000, 2),
                    'M')) AS 'Total production cost',
    CONCAT('$',
            CONCAT(ROUND((SUM(SalesAmount) - SUM(TotalProductCost)) / 1000000,
                            2),
                    'M')) AS 'Total profit Gain',
    SUM(OrderQuantity) AS 'Total Qty Of Order'
FROM
    (SELECT 
        *
    FROM
        factinternetsales UNION SELECT 
        *
    FROM
        fact_internet_sales_new) AS s
        JOIN
    date d ON d.DateKey = s.OrderDateKey
GROUP BY 1
ORDER BY 1;

#---------------------------------------------------------------------------------#
# year wise total sales amount, total production cost, total profit gain , total qty of order----------------------------------------------(5)
     
SELECT 
    d.FiscalYear,
    CONCAT('$',
            CONCAT(ROUND(SUM(s.SalesAmount) / 1000000, 2),
                    'M')) AS sales_Amt,
    CONCAT('$',
            CONCAT(ROUND(SUM(TotalProductCost) / 1000000, 2),
                    'M')) AS 'Total production cost',
    CONCAT('$',
            CONCAT(ROUND((SUM(SalesAmount) - SUM(TotalProductCost)) / 1000000,
                            2),
                    'M')) AS 'Total profit Gain',
    SUM(OrderQuantity) AS 'Total Qty Of Order'
FROM
    (SELECT 
        *
    FROM
        factinternetsales UNION SELECT 
        *
    FROM
        fact_internet_sales_new) AS s
        JOIN
    date d ON d.DateKey = s.OrderDateKey
GROUP BY 1
ORDER BY 1;

#---------------------------------------------------------------------------------#
 # sales territory region wise wise total sales amount, total production cost, total profit gain , total qty of order----------------------------------------------(6)
    
SELECT 
    t.salesterritoryregion,
    CONCAT('$',
            CONCAT(ROUND(SUM(s.SalesAmount) / 1000000, 2),
                    'M')) AS sales_Amt,
    CONCAT('$',
            CONCAT(ROUND(SUM(s.TotalProductCost) / 1000000, 2),
                    'M')) AS Total_product_cost,
    CONCAT('$',
            CONCAT(ROUND((SUM(s.SalesAmount) - SUM(s.TotalProductCost)) / 1000000,
                            2),
                    'M')) AS Total_profit_gain,
    SUM(OrderQuantity) AS 'Total Qty Of Order'
FROM
    (SELECT 
        *
    FROM
        factinternetsales UNION SELECT 
        *
    FROM
        fact_internet_sales_new) AS s
        JOIN
    salesterritory t ON t.salesterritorykey = s.salesterritorykey
GROUP BY 1
ORDER BY 5 DESC;