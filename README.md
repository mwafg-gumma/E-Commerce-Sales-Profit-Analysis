
# EcommerceDW — E-Commerce Data Warehouse & Power BI Dashboard

## Project Overview
EcommerceDW is an end-to-end analytics project built to practice data engineering and business intelligence workflows. The project uses e-commerce source files, SQL Server for staging and dimensional modeling, and Power BI to create an interactive executive dashboard.

## Business Objectives
- Monitor completed sales revenue and profit.
- Compare revenue across product categories and sales channels.
- Track monthly revenue trends.
- Understand transaction distribution by payment method and transaction status.
- Explore results using Year and Category filters.

## Tools
- Microsoft Excel — initial data exploration
- SQL Server Management Studio (SSMS) / T-SQL — staging, data checks, and analytical queries
- Power BI Desktop — data model, DAX measures, visuals, and dashboard
- GitHub — project version control and documentation

## Data Model
The analytical model uses a transaction-level fact table and dimension tables:

- `FactTransactions` — one row per source transaction record
- `DimDate` — date attributes such as year, month name, and month number
- `DimProduct` — product and category attributes
- `DimCustomer` — customer attributes
- `DimChannel` — sales channel
- `DimPaymentMethod` — payment method
- `DimStatus` — transaction status

The dashboard's sales and profit KPIs use completed transactions only. The status distribution visual includes all transaction statuses so completed, cancelled, and refunded transactions can be compared.

## Key Power BI Measures
```DAX
Total Revenue =
CALCULATE(
    SUM(FactTransactions[RevenueUSD]),
    DimStatus[StatusName] = "Completed"
)
```

```DAX
Total Profit =
CALCULATE(
    SUM(FactTransactions[ProfitUSD]),
    DimStatus[StatusName] = "Completed"
)
```

```DAX
Completed Transactions =
CALCULATE(
    COUNTROWS(FactTransactions),
    DimStatus[StatusName] = "Completed"
)
```

```DAX
Profit Margin % =
DIVIDE([Total Profit], [Total Revenue], 0)
```

## Dashboard
The Executive Overview includes:
- Total Revenue
- Total Profit
- Completed Transactions
- Profit Margin %
- Monthly Revenue Trend
- Revenue by Product Category
- Profit by Product Category
- Revenue by Sales Channel
- Transactions by Payment Method
- Transaction Status Distribution
- Revenue vs. Profit by Category
- Interactive Year and Category slicers

## Selected Results
Based on the completed-transaction analysis:
- Completed transactions: **87,825**
- Total revenue: **$46,508,818.70**
- Total profit: **$15,746,378.84**
- Profit margin: approximately **33.86%**

These figures are expected to match the Power BI KPIs when no slicers are applied.

## Repository Structure
```text
EcommerceDW/
├── README.md
├── EcommerceDW.pbix
├── documentation/
│   ├── img/
│   │   └── dashboard.png
│   └── queries/
│       └── ecommerce_analysis.sql
└── data/
    └── (optional: small, non-sensitive sample files only)
```

## How to Reproduce
1. Download the source dataset files from their original source.
2. Load the source files into SQL Server staging tables.
3. Run the data validation and transformation scripts used in the project.
4. Build the fact and dimension tables.
5. Open `EcommerceDW.pbix` in Power BI Desktop.
6. If needed, update the SQL Server connection in Power BI to match your local server and database.
7. Refresh the model and use the slicers to explore the dashboard.

## Notes
- The SQL script in `documentation/queries/ecommerce_analysis.sql` is a curated set of analytical examples for the project. Check the join-key and column names against your actual SQL Server schema before running it.
- Do not upload database passwords, credentials, private connection strings, or large raw datasets to a public repository.
- Add your actual Power BI screenshot to `documentation/img/dashboard.png`.
