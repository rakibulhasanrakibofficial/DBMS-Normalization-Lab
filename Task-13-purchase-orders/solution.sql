-- TASK 13: PURCHASE ORDERS
CREATE TABLE t13_supplier (supplier_id VARCHAR(10) PRIMARY KEY, supplier_name VARCHAR(100) NOT NULL);
CREATE TABLE t13_category (category_id VARCHAR(10) PRIMARY KEY, category_name VARCHAR(50) NOT NULL);
CREATE TABLE t13_product (sku VARCHAR(10) PRIMARY KEY, product_name VARCHAR(100) NOT NULL, category_id VARCHAR(10) NOT NULL, FOREIGN KEY (category_id) REFERENCES t13_category(category_id));
CREATE TABLE t13_purchase_order (po_id VARCHAR(10) PRIMARY KEY, supplier_id VARCHAR(10) NOT NULL, FOREIGN KEY (supplier_id) REFERENCES t13_supplier(supplier_id));
CREATE TABLE t13_po_detail (po_id VARCHAR(10) NOT NULL, sku VARCHAR(10) NOT NULL, qty INT NOT NULL, PRIMARY KEY (po_id,sku), FOREIGN KEY (po_id) REFERENCES t13_purchase_order(po_id), FOREIGN KEY (sku) REFERENCES t13_product(sku));
INSERT INTO t13_supplier VALUES ('S1','Eastern Foods'),('S2','Delta Packaging'),('S3','Green Fields');
INSERT INTO t13_category VALUES ('GRC','Grocery'),('PKG','Packaging'),('CLN','Cleaning');
INSERT INTO t13_product VALUES ('SKU-A1','Basmati Rice 25kg','GRC'),('SKU-A2','Lentils 10kg','GRC'),('SKU-B1','Carton Box L','PKG'),('SKU-C1','Disinfectant 5L','CLN');
INSERT INTO t13_purchase_order VALUES ('PO10','S1'),('PO11','S2'),('PO12','S3');
INSERT INTO t13_po_detail VALUES ('PO10','SKU-A1',40),('PO10','SKU-A2',25),('PO11','SKU-B1',500),('PO12','SKU-A1',30),('PO12','SKU-C1',12);