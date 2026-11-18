-- TASK 13: PURCHASE ORDERS
-- Source relation: PO_LINE_EXPORT
-- Question: Normalize PO_LINE_EXPORT into 1NF, 2NF and 3NF.
--
-- Business rules:
-- 1. A purchase order is placed with one supplier and has one line per product,
--    each with a quantity.
-- 2. A supplier has one name.
-- 3. A product has one name and belongs to one category; a category has one name.
--
-- Candidate key of PO_LINE_EXPORT: (POID, SKU)
-- Functional dependencies:
-- POID -> SupplierID
-- SupplierID -> SupplierName
-- SKU -> ProductName, CategoryID
-- CategoryID -> CategoryName
-- (POID, SKU) -> Qty
--
-- 1NF: All values are atomic; one row represents one product line in an order.
-- 2NF: Remove partial dependencies on POID and SKU from the composite key.
-- 3NF: Remove transitive dependencies SupplierID -> SupplierName and
--      CategoryID -> CategoryName.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop all Task 13 tables in child-to-parent order.
DROP TABLE IF EXISTS t13_po_detail;
DROP TABLE IF EXISTS t13_purchase_order;
DROP TABLE IF EXISTS t13_product;
DROP TABLE IF EXISTS t13_supplier;
DROP TABLE IF EXISTS t13_category;

DROP TABLE IF EXISTS t13_2nf_po_line;
DROP TABLE IF EXISTS t13_2nf_purchase_order;
DROP TABLE IF EXISTS t13_2nf_product;

DROP TABLE IF EXISTS t13_1nf_po_line;

-- =====================================================
-- FIRST NORMAL FORM (1NF)
-- =====================================================
-- Every column contains a single atomic value.
-- The primary key is the combination of POID and SKU.

CREATE TABLE t13_1nf_po_line (
    po_id VARCHAR(10) NOT NULL,
    sku VARCHAR(10) NOT NULL,
    supplier_id VARCHAR(10) NOT NULL,
    supplier_name VARCHAR(100) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category_id VARCHAR(10) NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (po_id, sku)
);

INSERT INTO t13_1nf_po_line VALUES
('PO10','SKU-A1','S1','Eastern Foods','Basmati Rice 25kg','GRC','Grocery',40),
('PO10','SKU-A2','S1','Eastern Foods','Lentils 10kg','GRC','Grocery',25),
('PO11','SKU-B1','S2','Delta Packaging','Carton Box L','PKG','Packaging',500),
('PO12','SKU-A1','S3','Green Fields','Basmati Rice 25kg','GRC','Grocery',30),
('PO12','SKU-C1','S3','Green Fields','Disinfectant 5L','CLN','Cleaning',12);

SELECT * FROM t13_1nf_po_line;

-- =====================================================
-- SECOND NORMAL FORM (2NF)
-- =====================================================
-- (POID, SKU) is a composite key.
-- POID determines supplier information, while SKU determines product
-- and category information. These partial dependencies are separated.
-- Transitive dependencies are intentionally left for the 3NF step.

CREATE TABLE t13_2nf_purchase_order (
    po_id VARCHAR(10) PRIMARY KEY,
    supplier_id VARCHAR(10) NOT NULL,
    supplier_name VARCHAR(100) NOT NULL
);

CREATE TABLE t13_2nf_product (
    sku VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id VARCHAR(10) NOT NULL,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE t13_2nf_po_line (
    po_id VARCHAR(10) NOT NULL,
    sku VARCHAR(10) NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (po_id, sku),
    FOREIGN KEY (po_id) REFERENCES t13_2nf_purchase_order(po_id),
    FOREIGN KEY (sku) REFERENCES t13_2nf_product(sku)
);

INSERT INTO t13_2nf_purchase_order VALUES
('PO10','S1','Eastern Foods'),
('PO11','S2','Delta Packaging'),
('PO12','S3','Green Fields');

INSERT INTO t13_2nf_product VALUES
('SKU-A1','Basmati Rice 25kg','GRC','Grocery'),
('SKU-A2','Lentils 10kg','GRC','Grocery'),
('SKU-B1','Carton Box L','PKG','Packaging'),
('SKU-C1','Disinfectant 5L','CLN','Cleaning');

INSERT INTO t13_2nf_po_line VALUES
('PO10','SKU-A1',40),
('PO10','SKU-A2',25),
('PO11','SKU-B1',500),
('PO12','SKU-A1',30),
('PO12','SKU-C1',12);

SELECT * FROM t13_2nf_purchase_order;
SELECT * FROM t13_2nf_product;
SELECT * FROM t13_2nf_po_line;

-- =====================================================
-- THIRD NORMAL FORM (3NF)
-- =====================================================
-- Remove transitive dependencies:
-- SupplierID -> SupplierName
-- CategoryID -> CategoryName

CREATE TABLE t13_supplier (
    supplier_id VARCHAR(10) PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL
);

CREATE TABLE t13_category (
    category_id VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE t13_product (
    sku VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES t13_category(category_id)
);

CREATE TABLE t13_purchase_order (
    po_id VARCHAR(10) PRIMARY KEY,
    supplier_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES t13_supplier(supplier_id)
);

CREATE TABLE t13_po_detail (
    po_id VARCHAR(10) NOT NULL,
    sku VARCHAR(10) NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (po_id, sku),
    FOREIGN KEY (po_id) REFERENCES t13_purchase_order(po_id),
    FOREIGN KEY (sku) REFERENCES t13_product(sku)
);

INSERT INTO t13_supplier VALUES
('S1','Eastern Foods'),
('S2','Delta Packaging'),
('S3','Green Fields');

INSERT INTO t13_category VALUES
('GRC','Grocery'),
('PKG','Packaging'),
('CLN','Cleaning');

INSERT INTO t13_product VALUES
('SKU-A1','Basmati Rice 25kg','GRC'),
('SKU-A2','Lentils 10kg','GRC'),
('SKU-B1','Carton Box L','PKG'),
('SKU-C1','Disinfectant 5L','CLN');

INSERT INTO t13_purchase_order VALUES
('PO10','S1'),
('PO11','S2'),
('PO12','S3');

INSERT INTO t13_po_detail VALUES
('PO10','SKU-A1',40),
('PO10','SKU-A2',25),
('PO11','SKU-B1',500),
('PO12','SKU-A1',30),
('PO12','SKU-C1',12);

-- Verify final 3NF tables.
SELECT * FROM t13_supplier;
SELECT * FROM t13_category;
SELECT * FROM t13_product;
SELECT * FROM t13_purchase_order;
SELECT * FROM t13_po_detail;
