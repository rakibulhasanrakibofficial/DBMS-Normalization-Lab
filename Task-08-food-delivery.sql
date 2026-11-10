-- TASK 8: FOOD DELIVERY
CREATE TABLE t08_customer (customer_id VARCHAR(10) PRIMARY KEY, customer_name VARCHAR(100) NOT NULL);
CREATE TABLE t08_restaurant (restaurant_id VARCHAR(10) PRIMARY KEY, restaurant_name VARCHAR(100) NOT NULL);
CREATE TABLE t08_order (order_id VARCHAR(10) PRIMARY KEY, order_date DATE NOT NULL, customer_id VARCHAR(10) NOT NULL, restaurant_id VARCHAR(10) NOT NULL, FOREIGN KEY (customer_id) REFERENCES t08_customer(customer_id), FOREIGN KEY (restaurant_id) REFERENCES t08_restaurant(restaurant_id));
CREATE TABLE t08_order_detail (order_id VARCHAR(10) NOT NULL, item_name VARCHAR(100) NOT NULL, quantity INT NOT NULL, PRIMARY KEY (order_id,item_name), FOREIGN KEY (order_id) REFERENCES t08_order(order_id));
INSERT INTO t08_customer VALUES ('C1','Nabila Roy'),('C2','Shafiq Alam'),('C3','Ishrat Zaman');
INSERT INTO t08_restaurant VALUES ('R1','Spice Hub'),('R2','Pizza Corner');
INSERT INTO t08_order VALUES ('O1','2026-10-01','C1','R1'),('O2','2026-10-01','C2','R2'),('O3','2026-10-03','C1','R1'),('O4','2026-10-04','C3','R2');
INSERT INTO t08_order_detail VALUES ('O1','Chicken Biryani',2),('O1','Borhani',1),('O2','Margherita Pizza',1),('O3','Chicken Biryani',1),('O4','Margherita Pizza',2),('O4','Garlic Bread',2);