-- =========================================================
-- TASK 15: STREAMING INVOICES
-- Normalize INVOICE_FLAT into 1NF, 2NF and 3NF
-- DBMS: MySQL 8.0+
-- =========================================================

-- Clean up old tables so this script can be run again.
DROP TABLE IF EXISTS t15_invoice_line;
DROP TABLE IF EXISTS t15_invoice;
DROP TABLE IF EXISTS t15_subscriber_device;
DROP TABLE IF EXISTS t15_item;
DROP TABLE IF EXISTS t15_subscriber;
DROP TABLE IF EXISTS t15_country;

DROP TABLE IF EXISTS t15_2_invoice_line;
DROP TABLE IF EXISTS t15_2_subscriber_device;
DROP TABLE IF EXISTS t15_2_item;
DROP TABLE IF EXISTS t15_2_invoice;

DROP TABLE IF EXISTS t15_invoice_flat_1nf;

-- =========================================================
-- 1NF
-- Rule: Each cell contains one atomic value.
-- Devices are separated into individual rows.
-- Candidate/Primary key: (invoice_id, item_code, device)
-- =========================================================

CREATE TABLE t15_invoice_flat_1nf (
    invoice_id VARCHAR(10) NOT NULL,
    item_code VARCHAR(20) NOT NULL,
    item_desc VARCHAR(100) NOT NULL,
    sub_id VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    tax_pct DECIMAL(5,2) NOT NULL,
    device VARCHAR(50) NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (invoice_id, item_code, device)
);

-- Each invoice line is repeated for each registered device
-- so that every device value is atomic.
INSERT INTO t15_invoice_flat_1nf VALUES
('INV-1','PLAN-STD','Standard Plan','S1','Bangladesh',5,'TV-01',1),
('INV-1','PLAN-STD','Standard Plan','S1','Bangladesh',5,'Phone-07',1),
('INV-1','ADD-4K','4K Upgrade','S1','Bangladesh',5,'TV-01',1),
('INV-1','ADD-4K','4K Upgrade','S1','Bangladesh',5,'Phone-07',1),
('INV-2','PLAN-BAS','Basic Plan','S2','India',18,'Laptop-02',1),
('INV-3','PLAN-STD','Standard Plan','S1','Bangladesh',5,'TV-01',1),
('INV-3','PLAN-STD','Standard Plan','S1','Bangladesh',5,'Phone-07',1),
('INV-3','ADD-MEM','Extra Member','S1','Bangladesh',5,'TV-01',2),
('INV-3','ADD-MEM','Extra Member','S1','Bangladesh',5,'Phone-07',2);

SELECT * FROM t15_invoice_flat_1nf;

-- =========================================================
-- 2NF
-- Rule: Must be in 1NF and have no partial dependency.
-- Split attributes that depend on only part of the
-- composite key into separate tables.
-- =========================================================

CREATE TABLE t15_2_invoice (
    invoice_id VARCHAR(10) PRIMARY KEY,
    sub_id VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL,
    tax_pct DECIMAL(5,2) NOT NULL
);

CREATE TABLE t15_2_item (
    item_code VARCHAR(20) PRIMARY KEY,
    item_desc VARCHAR(100) NOT NULL
);

CREATE TABLE t15_2_invoice_line (
    invoice_id VARCHAR(10) NOT NULL,
    item_code VARCHAR(20) NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (invoice_id, item_code),
    FOREIGN KEY (invoice_id) REFERENCES t15_2_invoice(invoice_id),
    FOREIGN KEY (item_code) REFERENCES t15_2_item(item_code)
);

CREATE TABLE t15_2_subscriber_device (
    sub_id VARCHAR(10) NOT NULL,
    device VARCHAR(50) NOT NULL,
    PRIMARY KEY (sub_id, device)
);

INSERT INTO t15_2_invoice
SELECT DISTINCT invoice_id, sub_id, country, tax_pct
FROM t15_invoice_flat_1nf;

INSERT INTO t15_2_item
SELECT DISTINCT item_code, item_desc
FROM t15_invoice_flat_1nf;

INSERT INTO t15_2_invoice_line
SELECT DISTINCT invoice_id, item_code, qty
FROM t15_invoice_flat_1nf;

INSERT INTO t15_2_subscriber_device
SELECT DISTINCT sub_id, device
FROM t15_invoice_flat_1nf;

-- Check 2NF tables.
SELECT * FROM t15_2_invoice;
SELECT * FROM t15_2_item;
SELECT * FROM t15_2_invoice_line;
SELECT * FROM t15_2_subscriber_device;

-- =========================================================
-- 3NF
-- Rule: Must be in 2NF and have no transitive dependency.
-- Functional dependencies:
-- sub_id -> country
-- country -> tax_pct
-- Therefore, country and tax_pct are stored separately.
-- =========================================================

CREATE TABLE t15_country (
    country VARCHAR(50) PRIMARY KEY,
    tax_pct DECIMAL(5,2) NOT NULL
);

CREATE TABLE t15_subscriber (
    sub_id VARCHAR(10) PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    FOREIGN KEY (country) REFERENCES t15_country(country)
);

CREATE TABLE t15_invoice (
    invoice_id VARCHAR(10) PRIMARY KEY,
    sub_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (sub_id) REFERENCES t15_subscriber(sub_id)
);

CREATE TABLE t15_item (
    item_code VARCHAR(20) PRIMARY KEY,
    item_desc VARCHAR(100) NOT NULL
);

CREATE TABLE t15_invoice_line (
    invoice_id VARCHAR(10) NOT NULL,
    item_code VARCHAR(20) NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (invoice_id, item_code),
    FOREIGN KEY (invoice_id) REFERENCES t15_invoice(invoice_id),
    FOREIGN KEY (item_code) REFERENCES t15_item(item_code)
);

CREATE TABLE t15_subscriber_device (
    sub_id VARCHAR(10) NOT NULL,
    device VARCHAR(50) NOT NULL,
    PRIMARY KEY (sub_id, device),
    FOREIGN KEY (sub_id) REFERENCES t15_subscriber(sub_id)
);

-- Populate the final 3NF tables from the 2NF tables.
INSERT INTO t15_country
SELECT DISTINCT country, tax_pct
FROM t15_2_invoice;

INSERT INTO t15_subscriber
SELECT DISTINCT sub_id, country
FROM t15_2_invoice;

INSERT INTO t15_invoice
SELECT invoice_id, sub_id
FROM t15_2_invoice;

INSERT INTO t15_item
SELECT item_code, item_desc
FROM t15_2_item;

INSERT INTO t15_invoice_line
SELECT invoice_id, item_code, qty
FROM t15_2_invoice_line;

INSERT INTO t15_subscriber_device
SELECT sub_id, device
FROM t15_2_subscriber_device;

-- =========================================================
-- FINAL 3NF RESULT
-- =========================================================

SELECT * FROM t15_country;
SELECT * FROM t15_subscriber;
SELECT * FROM t15_invoice;
SELECT * FROM t15_item;
SELECT * FROM t15_invoice_line;
SELECT * FROM t15_subscriber_device;

-- Complete invoice report with subscriber, country, tax,
-- item description and quantity.
SELECT
    i.invoice_id,
    i.sub_id,
    s.country,
    c.tax_pct,
    il.item_code,
    it.item_desc,
    il.qty
FROM t15_invoice AS i
JOIN t15_subscriber AS s ON i.sub_id = s.sub_id
JOIN t15_country AS c ON s.country = c.country
JOIN t15_invoice_line AS il ON i.invoice_id = il.invoice_id
JOIN t15_item AS it ON il.item_code = it.item_code
ORDER BY i.invoice_id, il.item_code;

-- Registered devices for each subscriber.
SELECT sub_id, device
FROM t15_subscriber_device
ORDER BY sub_id, device;
