-- SQL inquiry 3.1.1
SELECT COUNT(Customer_ID), EXTRACT(MONTH FROM MembershipDate) AS Month
FROM STARBUCKS_DB.STBX_CUSTOMER
GROUP BY Month;

-- SQL inquiry 3.1.2
SELECT City, Province, COUNT(Customer_ID) Num_Customer
FROM STARBUCKS_DB.STBX_CUSTOMER
GROUP BY City, Province
ORDER BY Num_Customer DESC;

-- SQL inquiry 3.1.3
SELECT 
    C.Customer_ID, 
    SUM(O.TotalAmount) AS TotalSpend, 
    SUM(R.RewardsRedeemed) AS TotalRewardsRedeemed,
    COUNT(R.Order_ID) AS RewardsRedemptionFrequency
FROM STBX_CUSTOMER C
JOIN STBX_ORDER O ON C.Customer_ID = O.Customer_ID
JOIN CONNECTWITH R ON O.Order_ID = R.Order_ID
GROUP BY C.Customer_ID
ORDER BY TotalSpend DESC, TotalRewardsRedeemed DESC;

-- SQL inquiry 3.1.4
SELECT 
    Program_ID, 
    AVG(RewardsRedeemed) AS AveragePointsRedeemed
FROM 
    CONNECTWITH
GROUP BY 
    Program_ID;

-- SQL inquiry 3.2.1
SELECT EXTRACT(YEAR_MONTH FROM date) AS YearAndMonth, SUM(O.TotalAmount) AS TotalRevenue
FROM STBX_ORDER AS O
JOIN CX_TRANSACTIONS AS T ON EXTRACT(YEAR_MONTH FROM O.date) = EXTRACT(YEAR_MONTH FROM date)
GROUP BY YearAndMonth
ORDER BY YearAndMonth;

-- SQL inquiry 3.2.2
SELECT P.Product_name, SUM(T.Quantity) AS UnitsSold
FROM STBX_PRODUCT P
JOIN TRAN_CONTAINS TC  ON P.Product_ID = TC.Product_ID
JOIN CX_TRANSACTIONS T ON TC.Transaction_ID = T.Transaction_ID
GROUP BY P.Product_name
ORDER BY UnitsSold DESC;

-- SQL inquiry 3.2.3
SELECT P.Product_Type, SUM(T.TotalAmount) AS TotalRevenue
FROM STBX_PRODUCT P
JOIN TRAN_CONTAINS TC ON P.Product_ID = TC.Product_Id
JOIN CX_TRANSACTIONS T ON TC.Transaction_ID = T.Transaction_ID
GROUP BY P.Product_Type
ORDER BY TotalRevenue DESC;

-- SQL inquiry 3.2.4
SELECT C.City, C.Province, SUM(T.TotalAmount) AS TotalRevenue
FROM STBX_CUSTOMER C
JOIN STBX_ORDER O ON C.Customer_ID = O.Customer_ID
JOIN CX_TRANSACTIONS T ON T.Order_ID = O.Order_ID
GROUP BY C.City, C.Province
ORDER BY TotalRevenue DESC;

-- SQL inquiry 3.2.5
SELECT PaymentMethod, COUNT(Order_ID) AS NumberOfTransactions
FROM STBX_ORDER
GROUP BY PaymentMethod
ORDER BY NumberOfTransactions DESC;

-- SQL inquiry 3.3.1
SELECT P.Product_Type, AVG(F.Rating) AS AverageRating
FROM STBX_FEEDBACK F
JOIN STBX_PRODUCT P ON F.Product_ID = P.Product_ID
GROUP BY P.Product_Type;

-- SQL inquiry 3.3.2
-- Highest satisfaction
SELECT Product_Name, AverageRating
FROM (
    SELECT P.Product_name, AVG(F.Rating) AS AverageRating
    FROM STBX_FEEDBACK F
    JOIN STBX_PRODUCT P ON F.Product_ID = P.Product_ID
    GROUP BY P.Product_Name
    ORDER BY AverageRating DESC
    LIMIT 5
) AS TopRatings;

SELECT Product_Name, AverageRating
FROM (
    SELECT P.Product_name, AVG(F.Rating) AS AverageRating
    FROM STBX_FEEDBACK F
    JOIN STBX_PRODUCT P ON F.Product_ID = P.Product_ID
    GROUP BY P.Product_Name
    ORDER BY AverageRating ASC
    LIMIT 5
) AS BottomRatings;


-- SQL inquiry 3.3.3
-- For positive feedback
SELECT P.Product_Name, F.Comment
FROM STBX_FEEDBACK F
JOIN STBX_PRODUCT P ON F.Product_ID = P.Product_ID
WHERE F.Rating >= 4;

-- For negative feedback
SELECT P.Product_Name, F.Comment
FROM STBX_FEEDBACK F
JOIN STBX_PRODUCT P ON F.Product_ID = P.Product_ID
WHERE F.Rating <= 2;

-- SQL inquiry 3.3.4
SELECT P.Product_name, AVG(F.Rating) AS AverageFeedbackRating, SUM(T.TotalAmount) AS TotalSales
FROM STBX_PRODUCT P
JOIN STBX_FEEDBACK F ON P.Product_ID = F.Product_ID
JOIN TRAN_CONTAINS TC on TC.Product_ID = P.Product_ID
JOIN CX_TRANSACTIONS T ON TC.Transaction_ID = T.Transaction_ID
GROUP BY P.Product_Name
ORDER BY AverageFeedbackRating DESC, TotalSales DESC;

-- SQL inquiry 3.3.5
SELECT 
    P.Product_Type, 
    AVG(F.Rating) AS AverageFeedback, 
    SUM(T.TotalAmount) AS TotalSales
FROM 
    STBX_FEEDBACK F
    JOIN STBX_PRODUCT P ON F.Product_ID = P.Product_ID
                 JOIN TRAN_CONTAINS TC on TC.Product_ID = P.Product_ID
    JOIN CX_TRANSACTIONS T ON T.Transaction_ID = TC.Transaction_ID
GROUP BY 
    P.Product_Type
ORDER BY 
    AverageFeedback DESC, 
    TotalSales DESC;