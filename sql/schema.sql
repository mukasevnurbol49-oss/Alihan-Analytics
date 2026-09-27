DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    sale_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    branch VARCHAR(50) NOT NULL,
    manager VARCHAR(100) NOT NULL,
    customer VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(14,2) NOT NULL CHECK (unit_price >= 0),
    revenue NUMERIC(16,2) NOT NULL CHECK (revenue >= 0),
    payment_method VARCHAR(50) NOT NULL
);
CREATE INDEX idx_sales_order_date ON sales(order_date);
CREATE INDEX idx_sales_branch ON sales(branch);
CREATE INDEX idx_sales_product ON sales(product);
CREATE INDEX idx_sales_customer ON sales(customer);

