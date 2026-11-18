-- TASK 8: FOOD DELIVERY
-- Source relation: DELIVERY_EXPORT
-- Question: Normalize DELIVERY_EXPORT into 1NF, 2NF and 3NF.
--
-- BUSINESS RULES:
-- 1. An order is placed by one customer at one restaurant on one date.
-- 2. Items and Quantities are position-matched lists:
--    the first quantity belongs to the first item.
--    An item appears at most once per order.
-- 3. A customer has one name; a restaurant has one name.
--
-- FUNCTIONAL DEPENDENCIES:
-- OrderID -> OrderDate, CustID, RestID
-- CustID -> CustName
-- RestID -> RestName
-- (OrderID, ItemName) -> Quantity
--
-- Candidate key after expanding the lists: (OrderID, ItemName)
-- No separate menu-item attributes or item identifier are given,
-- so ItemName is used as the item identifier within each order.
--
-- 1NF: Expand Items and Quantities into one atomic item per row.
-- 2NF: Separate order header data from order-item data.
-- 3NF: Remove CustName and RestName transitive dependencies.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop Task 8 tables in child-to-parent order.
DROP TABLE IF EXISTS t8_order_item;
DROP TABLE IF EXISTS t8_delivery_order;
DROP TABLE IF EXISTS t8_customer;
DROP TABLE IF EXISTS t8_restaurant;

DROP TABLE IF EXISTS t8_2nf_order_item;
DROP TABLE IF EXISTS t8_2nf_delivery_order;

DROP TABLE IF EXISTS t8_1nf_delivery_export;

-- =========================================================
-- FIRST NORMAL FORM (1NF)
-- =========================================================
-- Items and Quantities are expanded position by position.
-- One row represents one item in one order.
-- Composite primary key: (OrderID, ItemName).

CREATE TABLE t8_1nf_delivery_export (
    order_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    cust_id VARCHAR(10) NOT NULL,
    cust_name VARCHAR(100) NOT NULL,
    rest_id VARCHAR(10) NOT NULL,
    rest_name VARCHAR(100) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, item_name)
);

-- O1: Chicken Biryani -> 2, Borhani -> 1
-- O4: Margherita Pizza -> 2, Garlic Bread -> 2
INSERT INTO t8_1nf_delivery_export VALUES
('O1','2026-10-01','C1','Nabila Roy','R1','Spice Hub','Chicken Biryani',2),
('O1','2026-10-01','C1','Nabila Roy','R1','Spice Hub','Borhani',1),
('O2','2026-10-01','C2','Shafiq Alam','R2','Pizza Corner','Margherita Pizza',1),
('O3','2026-10-03','C1','Nabila Roy','R1','Spice Hub','Chicken Biryani',1),
('O4','2026-10-04','C3','Ishrat Zaman','R2','Pizza Corner','Margherita Pizza',2),
('O4','2026-10-04','C3','Ishrat Zaman','R2','Pizza Corner','Garlic Bread',2);

SELECT * FROM t8_1nf_delivery_export;

-- =========================================================
-- SECOND NORMAL FORM (2NF)
-- =========================================================
-- Remove partial dependencies from (OrderID, ItemName):
-- OrderID -> OrderDate, CustID, CustName, RestID, RestName
-- (OrderID, ItemName) -> Quantity
--
-- Customer and restaurant names are retained in the order header
-- at this stage. Their transitive dependencies are removed in 3NF.

CREATE TABLE t8_2nf_delivery_order (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE NOT NULL,
    cust_id VARCHAR(10) NOT NULL,
    cust_name VARCHAR(100) NOT NULL,
    rest_id VARCHAR(10) NOT NULL,
    rest_name VARCHAR(100) NOT NULL
);

CREATE TABLE t8_2nf_order_item (
    order_id VARCHAR(10) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, item_name),
    FOREIGN KEY (order_id) REFERENCES t8_2nf_delivery_order(order_id)
);

INSERT INTO t8_2nf_delivery_order VALUES
('O1','2026-10-01','C1','Nabila Roy','R1','Spice Hub'),
('O2','2026-10-01','C2','Shafiq Alam','R2','Pizza Corner'),
('O3','2026-10-03','C1','Nabila Roy','R1','Spice Hub'),
('O4','2026-10-04','C3','Ishrat Zaman','R2','Pizza Corner');

INSERT INTO t8_2nf_order_item VALUES
('O1','Chicken Biryani',2),
('O1','Borhani',1),
('O2','Margherita Pizza',1),
('O3','Chicken Biryani',1),
('O4','Margherita Pizza',2),
('O4','Garlic Bread',2);

SELECT * FROM t8_2nf_delivery_order;
SELECT * FROM t8_2nf_order_item;

-- =========================================================
-- THIRD NORMAL FORM (3NF)
-- =========================================================
-- Remove transitive dependencies:
-- CustID -> CustName
-- RestID -> RestName
--
-- Final 3NF relations:
-- CUSTOMER(CustID, CustName)
-- RESTAURANT(RestID, RestName)
-- DELIVERY_ORDER(OrderID, OrderDate, CustID, RestID)
-- ORDER_ITEM(OrderID, ItemName, Quantity)

CREATE TABLE t8_customer (
    cust_id VARCHAR(10) PRIMARY KEY,
    cust_name VARCHAR(100) NOT NULL
);

CREATE TABLE t8_restaurant (
    rest_id VARCHAR(10) PRIMARY KEY,
    rest_name VARCHAR(100) NOT NULL
);

CREATE TABLE t8_delivery_order (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE NOT NULL,
    cust_id VARCHAR(10) NOT NULL,
    rest_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES t8_customer(cust_id),
    FOREIGN KEY (rest_id) REFERENCES t8_restaurant(rest_id)
);

CREATE TABLE t8_order_item (
    order_id VARCHAR(10) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, item_name),
    FOREIGN KEY (order_id) REFERENCES t8_delivery_order(order_id)
);

INSERT INTO t8_customer VALUES
('C1','Nabila Roy'),
('C2','Shafiq Alam'),
('C3','Ishrat Zaman');

INSERT INTO t8_restaurant VALUES
('R1','Spice Hub'),
('R2','Pizza Corner');

INSERT INTO t8_delivery_order VALUES
('O1','2026-10-01','C1','R1'),
('O2','2026-10-01','C2','R2'),
('O3','2026-10-03','C1','R1'),
('O4','2026-10-04','C3','R2');

INSERT INTO t8_order_item VALUES
('O1','Chicken Biryani',2),
('O1','Borhani',1),
('O2','Margherita Pizza',1),
('O3','Chicken Biryani',1),
('O4','Margherita Pizza',2),
('O4','Garlic Bread',2);

-- Verify all final 3NF tables.
SELECT * FROM t8_customer;
SELECT * FROM t8_restaurant;
SELECT * FROM t8_delivery_order;
SELECT * FROM t8_order_item;

-- Reconstruct the original order details using JOINs.
SELECT
    o.order_id,
    o.order_date,
    c.cust_id,
    c.cust_name,
    r.rest_id,
    r.rest_name,
    oi.item_name,
    oi.quantity
FROM t8_delivery_order AS o
JOIN t8_customer AS c ON o.cust_id = c.cust_id
JOIN t8_restaurant AS r ON o.rest_id = r.rest_id
JOIN t8_order_item AS oi ON o.order_id = oi.order_id
ORDER BY o.order_id, oi.item_name;
