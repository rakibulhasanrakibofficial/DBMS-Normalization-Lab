-- TASK 8: FOOD DELIVERY
-- Normalize DELIVERY_EXPORT into 1NF, 2NF and 3NF.
-- MySQL Shell SQL mode

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Remove old tables so this file can be run again.
DROP TABLE IF EXISTS t08_order_item;
DROP TABLE IF EXISTS t08_order;
DROP TABLE IF EXISTS t08_customer;
DROP TABLE IF EXISTS t08_restaurant;
DROP TABLE IF EXISTS t08_2nf_order_item;
DROP TABLE IF EXISTS t08_2nf_order;
DROP TABLE IF EXISTS t08_1nf;

-- ==================== 1NF ====================
-- Each item and its quantity are stored in a separate row.
-- Primary Key: (OrderID, ItemName)

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
-- Order details depend only on OrderID.
-- Item quantity depends on (OrderID, ItemName).
-- Customer and Restaurant names remain here; they are separated in 3NF.

CREATE TABLE t08_2nf_order (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE,
    cust_id VARCHAR(10),
    cust_name VARCHAR(100),
    rest_id VARCHAR(10),
    rest_name VARCHAR(100)
);

CREATE TABLE t08_2nf_order_item (
    order_id VARCHAR(10),
    item_name VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, item_name),
    FOREIGN KEY (order_id) REFERENCES t08_2nf_order(order_id)
);

INSERT INTO t08_2nf_order VALUES
('O1','2026-10-01','C1','Nabila Roy','R1','Spice Hub'),
('O2','2026-10-01','C2','Shafiq Alam','R2','Pizza Corner'),
('O3','2026-10-03','C1','Nabila Roy','R1','Spice Hub'),
('O4','2026-10-04','C3','Ishrat Zaman','R2','Pizza Corner');

INSERT INTO t08_2nf_order_item VALUES
('O1','Chicken Biryani',2),
('O1','Borhani',1),
('O2','Margherita Pizza',1),
('O3','Chicken Biryani',1),
('O4','Margherita Pizza',2),
('O4','Garlic Bread',2);

SELECT * FROM t08_2nf_order;
SELECT * FROM t08_2nf_order_item;

-- ==================== 3NF ====================
-- Remove transitive dependencies:
-- CustID -> CustName
-- RestID -> RestName
-- OrderID -> OrderDate, CustID, RestID
-- (OrderID, ItemName) -> Quantity

CREATE TABLE t08_customer (
    cust_id VARCHAR(10) PRIMARY KEY,
    cust_name VARCHAR(100)
);

CREATE TABLE t08_restaurant (
    rest_id VARCHAR(10) PRIMARY KEY,
    rest_name VARCHAR(100)
);

CREATE TABLE t08_order (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE,
    cust_id VARCHAR(10),
    rest_id VARCHAR(10),
    FOREIGN KEY (cust_id) REFERENCES t08_customer(cust_id),
    FOREIGN KEY (rest_id) REFERENCES t08_restaurant(rest_id)
);

CREATE TABLE t08_order_item (
    order_id VARCHAR(10),
    item_name VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, item_name),
    FOREIGN KEY (order_id) REFERENCES t08_order(order_id)
);

INSERT INTO t08_customer VALUES
('C1','Nabila Roy'),
('C2','Shafiq Alam'),
('C3','Ishrat Zaman');

INSERT INTO t08_restaurant VALUES
('R1','Spice Hub'),
('R2','Pizza Corner');

INSERT INTO t08_order VALUES
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
SELECT * FROM t08_order;
SELECT * FROM t08_order_item;
