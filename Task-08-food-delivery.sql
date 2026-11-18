-- TASK 8: FOOD DELIVERY
-- Question: Normalize DELIVERY_EXPORT into 1NF, 2NF and 3NF.
-- MySQL Shell (SQL mode)

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Remove old tables so this file can be run again.
DROP TABLE IF EXISTS t08_order_item;
DROP TABLE IF EXISTS t08_delivery_order;
DROP TABLE IF EXISTS t08_restaurant;
DROP TABLE IF EXISTS t08_customer;
DROP TABLE IF EXISTS t08_order_item_2nf;
DROP TABLE IF EXISTS t08_order_2nf;
DROP TABLE IF EXISTS t08_1nf;

-- ==================== 1NF ====================
-- Items and Quantities are separated into individual rows.
-- Primary key: (OrderID, ItemName)

CREATE TABLE t08_1nf (
    order_id VARCHAR(10),
    order_date DATE,
    cust_id VARCHAR(10),
    cust_name VARCHAR(100),
    rest_id VARCHAR(10),
    rest_name VARCHAR(100),
    item_name VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, item_name)
);

INSERT INTO t08_1nf VALUES
('O1','2026-10-01','C1','Nabila Roy','R1','Spice Hub','Chicken Biryani',2),
('O1','2026-10-01','C1','Nabila Roy','R1','Spice Hub','Borhani',1),
('O2','2026-10-01','C2','Shafiq Alam','R2','Pizza Corner','Margherita Pizza',1),
('O3','2026-10-03','C1','Nabila Roy','R1','Spice Hub','Chicken Biryani',1),
('O4','2026-10-04','C3','Ishrat Zaman','R2','Pizza Corner','Margherita Pizza',2),
('O4','2026-10-04','C3','Ishrat Zaman','R2','Pizza Corner','Garlic Bread',2);

SELECT * FROM t08_1nf;

-- ==================== 2NF ====================
-- OrderID determines order details.
-- (OrderID, ItemName) determines Quantity.
-- Therefore, separate order information from item information.
-- Customer and restaurant names remain here until 3NF.

CREATE TABLE t08_order_2nf (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE,
    cust_id VARCHAR(10),
    cust_name VARCHAR(100),
    rest_id VARCHAR(10),
    rest_name VARCHAR(100)
);

CREATE TABLE t08_order_item_2nf (
    order_id VARCHAR(10),
    item_name VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, item_name),
    FOREIGN KEY (order_id) REFERENCES t08_order_2nf(order_id)
);

INSERT INTO t08_order_2nf VALUES
('O1','2026-10-01','C1','Nabila Roy','R1','Spice Hub'),
('O2','2026-10-01','C2','Shafiq Alam','R2','Pizza Corner'),
('O3','2026-10-03','C1','Nabila Roy','R1','Spice Hub'),
('O4','2026-10-04','C3','Ishrat Zaman','R2','Pizza Corner');

INSERT INTO t08_order_item_2nf VALUES
('O1','Chicken Biryani',2),
('O1','Borhani',1),
('O2','Margherita Pizza',1),
('O3','Chicken Biryani',1),
('O4','Margherita Pizza',2),
('O4','Garlic Bread',2);

SELECT * FROM t08_order_2nf;
SELECT * FROM t08_order_item_2nf;

-- ==================== 3NF ====================
-- Remove transitive dependencies:
-- CustID -> CustName
-- RestID -> RestName
-- Final tables: CUSTOMER, RESTAURANT, DELIVERY_ORDER, ORDER_ITEM.

CREATE TABLE t08_customer (
    cust_id VARCHAR(10) PRIMARY KEY,
    cust_name VARCHAR(100) NOT NULL
);

CREATE TABLE t08_restaurant (
    rest_id VARCHAR(10) PRIMARY KEY,
    rest_name VARCHAR(100) NOT NULL
);

CREATE TABLE t08_delivery_order (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE NOT NULL,
    cust_id VARCHAR(10) NOT NULL,
    rest_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES t08_customer(cust_id),
    FOREIGN KEY (rest_id) REFERENCES t08_restaurant(rest_id)
);

CREATE TABLE t08_order_item (
    order_id VARCHAR(10),
    item_name VARCHAR(100),
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, item_name),
    FOREIGN KEY (order_id) REFERENCES t08_delivery_order(order_id)
);

INSERT INTO t08_customer VALUES
('C1','Nabila Roy'),
('C2','Shafiq Alam'),
('C3','Ishrat Zaman');

INSERT INTO t08_restaurant VALUES
('R1','Spice Hub'),
('R2','Pizza Corner');

INSERT INTO t08_delivery_order VALUES
('O1','2026-10-01','C1','R1'),
('O2','2026-10-01','C2','R2'),
('O3','2026-10-03','C1','R1'),
('O4','2026-10-04','C3','R2');

INSERT INTO t08_order_item VALUES
('O1','Chicken Biryani',2),
('O1','Borhani',1),
('O2','Margherita Pizza',1),
('O3','Chicken Biryani',1),
('O4','Margherita Pizza',2),
('O4','Garlic Bread',2);

-- Display final 3NF tables.
SELECT * FROM t08_customer;
SELECT * FROM t08_restaurant;
SELECT * FROM t08_delivery_order;
SELECT * FROM t08_order_item;

-- Check the complete order information.
SELECT o.order_id, o.order_date, c.cust_id, c.cust_name,
       r.rest_id, r.rest_name, i.item_name, i.quantity
FROM t08_delivery_order AS o
JOIN t08_customer AS c ON o.cust_id = c.cust_id
JOIN t08_restaurant AS r ON o.rest_id = r.rest_id
JOIN t08_order_item AS i ON o.order_id = i.order_id
ORDER BY o.order_id, i.item_name;
