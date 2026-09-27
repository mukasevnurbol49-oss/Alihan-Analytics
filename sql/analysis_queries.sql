-- 01. Общие KPI
SELECT SUM(revenue) total_revenue, COUNT(*) orders, SUM(quantity) units_sold,
       ROUND(AVG(revenue),2) average_order_value FROM sales;

-- 02. Продажи по месяцам
SELECT DATE_TRUNC('month',order_date)::date month, SUM(revenue) revenue,
       COUNT(*) orders, SUM(quantity) units_sold
FROM sales GROUP BY 1 ORDER BY 1;

-- 03. Рост к предыдущему месяцу
WITH m AS (SELECT DATE_TRUNC('month',order_date)::date month, SUM(revenue) revenue
FROM sales GROUP BY 1)
SELECT month,revenue,LAG(revenue) OVER(ORDER BY month) previous_month,
ROUND(100.0*(revenue-LAG(revenue) OVER(ORDER BY month)) /
NULLIF(LAG(revenue) OVER(ORDER BY month),0),1) growth_pct FROM m ORDER BY month;

-- 04. Рейтинг филиалов
SELECT branch,SUM(revenue) revenue,COUNT(*) orders,SUM(quantity) units_sold,
DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) revenue_rank
FROM sales GROUP BY branch ORDER BY revenue_rank;

-- 05. Доля филиалов
SELECT branch,SUM(revenue) revenue,
ROUND(100.0*SUM(revenue)/SUM(SUM(revenue)) OVER(),1) revenue_share_pct
FROM sales GROUP BY branch ORDER BY revenue DESC;

-- 06. Категории
SELECT category,SUM(revenue) revenue,SUM(quantity) units_sold,COUNT(*) orders,
ROUND(AVG(revenue),2) average_order_value
FROM sales GROUP BY category ORDER BY revenue DESC;

-- 07. Товары
SELECT product,category,SUM(revenue) revenue,SUM(quantity) units_sold,COUNT(*) orders
FROM sales GROUP BY product,category ORDER BY revenue DESC;

-- 08. Топ-5 товаров по выручке
SELECT product,SUM(revenue) revenue FROM sales GROUP BY product ORDER BY revenue DESC LIMIT 5;

-- 09. Топ-5 товаров по количеству
SELECT product,SUM(quantity) units_sold FROM sales GROUP BY product ORDER BY units_sold DESC LIMIT 5;

-- 10. Лучший товар каждого филиала
WITH x AS (SELECT branch,product,SUM(revenue) revenue FROM sales GROUP BY branch,product),
r AS (SELECT *,ROW_NUMBER() OVER(PARTITION BY branch ORDER BY revenue DESC,product) rn FROM x)
SELECT branch,product,revenue FROM r WHERE rn=1 ORDER BY branch;

-- 11. Рейтинг менеджеров
SELECT manager,SUM(revenue) revenue,COUNT(*) orders,ROUND(AVG(revenue),2) average_order_value,
DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) revenue_rank
FROM sales GROUP BY manager ORDER BY revenue_rank;

-- 12. Способы оплаты
SELECT payment_method,SUM(revenue) revenue,COUNT(*) orders,
ROUND(100.0*SUM(revenue)/SUM(SUM(revenue)) OVER(),1) revenue_share_pct
FROM sales GROUP BY payment_method ORDER BY revenue DESC;

-- 13. Диапазоны стоимости заказа
SELECT CASE WHEN revenue<100000 THEN 'До 100K' WHEN revenue<500000 THEN '100K–499K'
WHEN revenue<1000000 THEN '500K–999K' ELSE '1M+' END order_value_band,
COUNT(*) orders,SUM(revenue) revenue FROM sales GROUP BY 1 ORDER BY MIN(revenue);

-- 14. Клиенты с пятью и более покупками
SELECT customer,COUNT(*) orders,SUM(revenue) revenue,ROUND(AVG(revenue),2) average_order_value
FROM sales GROUP BY customer HAVING COUNT(*)>=5 ORDER BY revenue DESC;

-- 15. Топ-10 клиентов
SELECT customer,SUM(revenue) revenue,COUNT(*) orders,
DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) customer_rank
FROM sales GROUP BY customer ORDER BY customer_rank LIMIT 10;

-- 16. Месячная выручка филиалов
SELECT DATE_TRUNC('month',order_date)::date month,branch,SUM(revenue) revenue
FROM sales GROUP BY 1,branch ORDER BY 1,branch;

-- 17. Скользящее среднее за три месяца
WITH m AS (SELECT DATE_TRUNC('month',order_date)::date month,SUM(revenue) revenue
FROM sales GROUP BY 1)
SELECT month,revenue,ROUND(AVG(revenue) OVER(ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2)
rolling_3_month_avg FROM m ORDER BY month;

-- 18. Доля товаров и накопительная доля
WITH p AS (SELECT product,SUM(revenue) revenue FROM sales GROUP BY product)
SELECT product,revenue,ROUND(100.0*revenue/SUM(revenue) OVER(),1) revenue_share_pct,
ROUND(100.0*SUM(revenue) OVER(ORDER BY revenue DESC,product)/SUM(revenue) OVER(),1)
cumulative_revenue_share_pct FROM p ORDER BY revenue DESC;

-- 19. Средний чек по способам оплаты
SELECT payment_method,ROUND(AVG(revenue),2) average_order_value,
MIN(revenue) minimum_order_value,MAX(revenue) maximum_order_value
FROM sales GROUP BY payment_method ORDER BY average_order_value DESC;

-- 20. Лучший и худший месяц каждого филиала
WITH bm AS (SELECT branch,DATE_TRUNC('month',order_date)::date month,SUM(revenue) revenue
FROM sales GROUP BY branch,2), r AS (SELECT *,
ROW_NUMBER() OVER(PARTITION BY branch ORDER BY revenue DESC,month) strongest_rank,
ROW_NUMBER() OVER(PARTITION BY branch ORDER BY revenue,month) weakest_rank FROM bm)
SELECT branch,MAX(month) FILTER(WHERE strongest_rank=1) strongest_month,
MAX(revenue) FILTER(WHERE strongest_rank=1) strongest_revenue,
MAX(month) FILTER(WHERE weakest_rank=1) weakest_month,
MAX(revenue) FILTER(WHERE weakest_rank=1) weakest_revenue
FROM r GROUP BY branch ORDER BY branch;

