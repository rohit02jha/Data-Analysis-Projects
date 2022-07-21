## Sales Insights Data Analysis Project

### Data Analysis Using SQL

1.  -- For depicting all customer records

    `SELECT * FROM customers;`

1.  -- Total number of customers

    `SELECT count(*) FROM customers;`

1.  -- Transactions for Chennai market

    `SELECT * FROM transactions where market_code='Mark001';`

1.  -- Distinct products that were sold in chennai

    `SELECT distinct product_code FROM transactions where market_code='Mark001';`

1.  -- Transactions where currency is in USD

    `SELECT * from transactions where currency="USD"`

1.  -- Transactions in 2020 inner joined by date table

    `SELECT transactions.*, date.* FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020;`

1.  -- Total revenue in year 2020,

    `SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and transactions.currency="INR\r" or transactions.currency="USD\r";`

1.  -- Total revenue in year 2020, January Month,

    `SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and and date.month_name="January" and (transactions.currency="INR\r" or transactions.currency="USD\r");`

1.  -- Total revenue in year 2020 in Chennai

    `SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and transactions.market_code="Mark001";`
