-- Контрольные запросы после импорта данных
SELECT COUNT(*) AS row_count FROM sales;
SELECT SUM(revenue) AS total_revenue, SUM(quantity) AS units_sold FROM sales;
SELECT COUNT(*) AS invalid_revenue_rows FROM sales WHERE revenue <> quantity * unit_price;
SELECT COUNT(*) AS rows_with_missing_values FROM sales
WHERE order_date IS NULL OR branch IS NULL OR manager IS NULL OR customer IS NULL
   OR product IS NULL OR category IS NULL OR quantity IS NULL OR unit_price IS NULL
   OR revenue IS NULL OR payment_method IS NULL;
SELECT MIN(order_date) AS first_order_date, MAX(order_date) AS last_order_date FROM sales;
SELECT COUNT(DISTINCT branch) AS branches, COUNT(DISTINCT product) AS products,
       COUNT(DISTINCT category) AS categories,
       COUNT(DISTINCT payment_method) AS payment_methods
FROM sales;

