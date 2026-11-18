-- TASK 13: PURCHASE ORDERS
-- Normalize PO_LINE_EXPORT into 1NF, 2NF and 3NF.
--
-- Functional dependencies:
-- POID -> SupplierID
-- SupplierID -> SupplierName
-- SKU -> ProductName, CategoryID
-- CategoryID -> CategoryName
-- (POID, SKU) -> Qty
--
-- 1NF: Each field contains one atomic value.
-- 2NF: Supplier and product details are separated from the composite-key PO line.
-- 3NF: SupplierName and CategoryName are stored with their own determinant tables.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Remove old tables so this script can be executed again.
DROP TABLE IF EXISTS t13_po_detail;
DROP TABLE IF EXISTS t13_purchase_order;
DROP TABLE IF EXISTS t13_product;
DROP TABLE IF EXISTS t13_supplier;
DROP TABLE IF EXISTS t13_category;

-- 3NF tables
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

-- Sample data from the given PO_LINE_EXPORT table
INSERT INTO t13_supplier VALUES
('S1', 'Eastern Foods'),
('S2', 'Delta Packaging'),
('S3', 'Green Fields');

INSERT INTO t13_category VALUES
('GRC', 'Grocery'),
('PKG', 'Packaging'),
('CLN', 'Cleaning');

INSERT INTO t13_product VALUES
('SKU-A1', 'Basmati Rice 25kg', 'GRC'),
('SKU-A2', 'Lentils 10kg', 'GRC'),
('SKU-B1', 'Carton Box L', 'PKG'),
('SKU-C1', 'Disinfectant 5L', 'CLN');

INSERT INTO t13_purchase_order VALUES
('PO10', 'S1'),
('PO11', 'S2'),
('PO12', 'S3');

INSERT INTO t13_po_detail VALUES
('PO10', 'SKU-A1', 40),
('PO10', 'SKU-A2', 25),
('PO11', 'SKU-B1', 500),
('PO12', 'SKU-A1', 30),
('PO12', 'SKU-C1', 12);

-- Verify normalized data
SELECT * FROM t13_supplier;
SELECT * FROM t13_category;
SELECT * FROM t13_product;
SELECT * FROM t13_purchase_order;
SELECT * FROM t13_po_detail;
