/*
EcommerceDW — Analytical SQL Queries
SQL Server / T-SQL

IMPORTANT:
These queries assume the following model names:
FactTransactions, DimDate, DimProduct, DimChannel, DimStatus.
Check foreign-key and column names against your actual schema before running.
*/

-- 1. Validate fact table row count
SELECT COUNT(*) AS FactTransactionRows
FROM dbo.FactTransactions;


-- 2. Count transactions by status
SELECT
    ds.StatusName,
    COUNT(*) AS TransactionCount
FROM dbo.FactTransactions AS ft
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
GROUP BY ds.StatusName
ORDER BY TransactionCount DESC;


-- 3. Completed transactions: revenue, profit, and profit margin
SELECT
    COUNT(*) AS CompletedTransactions,
    SUM(ft.RevenueUSD) AS TotalRevenueUSD,
    SUM(ft.ProfitUSD) AS TotalProfitUSD,
    CAST(
        100.0 * SUM(ft.ProfitUSD) / NULLIF(SUM(ft.RevenueUSD), 0)
        AS DECIMAL(10, 2)
    ) AS ProfitMarginPct
FROM dbo.FactTransactions AS ft
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
WHERE ds.StatusName = 'Completed';


-- 4. Revenue by product category (completed transactions only)
SELECT
    dp.Category,
    SUM(ft.RevenueUSD) AS TotalRevenueUSD
FROM dbo.FactTransactions AS ft
JOIN dbo.DimProduct AS dp
    ON ft.ProductKey = dp.ProductKey
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
WHERE ds.StatusName = 'Completed'
GROUP BY dp.Category
ORDER BY TotalRevenueUSD DESC;


-- 5. Profit by product category (completed transactions only)
SELECT
    dp.Category,
    SUM(ft.ProfitUSD) AS TotalProfitUSD
FROM dbo.FactTransactions AS ft
JOIN dbo.DimProduct AS dp
    ON ft.ProductKey = dp.ProductKey
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
WHERE ds.StatusName = 'Completed'
GROUP BY dp.Category
ORDER BY TotalProfitUSD DESC;


-- 6. Revenue by sales channel (completed transactions only)
SELECT
    dc.ChannelName,
    SUM(ft.RevenueUSD) AS TotalRevenueUSD,
    COUNT(*) AS CompletedTransactions
FROM dbo.FactTransactions AS ft
JOIN dbo.DimChannel AS dc
    ON ft.ChannelKey = dc.ChannelKey
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
WHERE ds.StatusName = 'Completed'
GROUP BY dc.ChannelName
ORDER BY TotalRevenueUSD DESC;


-- 7. Monthly revenue trend (completed transactions only)
-- Uses Year + MonthNumber to keep months in chronological order.
SELECT
    dd.[Year],
    dd.MonthNumber,
    dd.MonthName,
    SUM(ft.RevenueUSD) AS TotalRevenueUSD
FROM dbo.FactTransactions AS ft
JOIN dbo.DimDate AS dd
    ON ft.DateKey = dd.DateKey
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
WHERE ds.StatusName = 'Completed'
GROUP BY dd.[Year], dd.MonthNumber, dd.MonthName
ORDER BY dd.[Year], dd.MonthNumber;


-- 8. Transaction count by payment method (completed transactions only)
SELECT
    dpm.PaymentMethodName,
    COUNT(*) AS CompletedTransactions
FROM dbo.FactTransactions AS ft
JOIN dbo.DimPaymentMethod AS dpm
    ON ft.PaymentMethodKey = dpm.PaymentMethodKey
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
WHERE ds.StatusName = 'Completed'
GROUP BY dpm.PaymentMethodName
ORDER BY CompletedTransactions DESC;


-- 9. Transaction distribution by status (all statuses)
SELECT
    ds.StatusName,
    COUNT(*) AS TransactionCount,
    CAST(
        100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (), 0)
        AS DECIMAL(10, 2)
    ) AS PercentOfTransactions
FROM dbo.FactTransactions AS ft
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
GROUP BY ds.StatusName
ORDER BY TransactionCount DESC;


-- 10. December 2023 vs December 2024: completed sales comparison
SELECT
    dd.[Year],
    SUM(ft.RevenueUSD) AS TotalRevenueUSD,
    COUNT(*) AS CompletedTransactions,
    AVG(ft.RevenueUSD) AS AvgRevenuePerTransaction
FROM dbo.FactTransactions AS ft
JOIN dbo.DimDate AS dd
    ON ft.DateKey = dd.DateKey
JOIN dbo.DimStatus AS ds
    ON ft.StatusKey = ds.StatusKey
WHERE ds.StatusName = 'Completed'
  AND dd.[Year] IN (2023, 2024)
  AND dd.MonthNumber = 12
GROUP BY dd.[Year]
ORDER BY dd.[Year];
