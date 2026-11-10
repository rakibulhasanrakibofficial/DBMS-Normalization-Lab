-- TASK 3: E-COMMERCE ORDERS
CREATE TABLE t03_customer (customer_id VARCHAR(10) PRIMARY KEY, customer_name VARCHAR(100) NOT NULL);
CREATE TABLE t03_product (product_name VARCHAR(100) PRIMARY KEY);
CREATE TABLE t03_order (order_id INT PRIMARY KEY, order_date DATE NOT NULL, customer_id VARCHAR(10) NOT NULL, FOREIGN KEY (customer_id) REFERENCES t03_customer(customer_id));
CREATE TABLE t03_order_detail (order_id INT NOT NULL, product_name VARCHAR(100) NOT NULL, quantity INT NOT NULL, PRIMARY KEY (order_id, product_name), FOREIGN KEY (order_id) REFERENCES t03_order(order_id), FOREIGN KEY (product_name) REFERENCES t03_product(product_name));
INSERT INTO t03_customer VALUES ('C21','Sadia Islam'),('C22','Mehedi Hasan'),('C23','Joya Das');
INSERT INTO t03_product VALUES ('USB Cable'),('Phone Case'),('Wireless Mouse');
INSERT INTO t03_order VALUES (5001,'2026-09-10','C21'),(5002,'2026-09-11','C22'),(5003,'2026-09-12','C21'),(5004,'2026-09-14','C23');
INSERT INTO t03_order_detail VALUES (5001,'USB Cable',2),(5001,'Phone Case',1),(5002,'Wireless Mouse',1),(5003,'Wireless Mouse',1),(5004,'Phone Case',3),(5004,'USB Cable',1);
