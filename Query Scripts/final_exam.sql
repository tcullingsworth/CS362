CREATE TABLE orders(
oid INT IDENTITY,
order_qty INT,
inventory_id INT,
CONSTRAINT pk_order_id PRIMARY KEY(oid)
);
GO

CREATE TABLE inventory(
iid INT IDENTITY,
name VARCHAR(50),
CONSTRAINT pk_inventory_id PRIMARY KEY(iid)
);
GO

INSERT INTO orders VALUES
(5, 1),
(3, 2),
(5, 1),
(3, 2),
(7, 3);

INSERT INTO inventory VALUES
('widget'),
('nut'),
('bolt');


SELECT * FROM orders;

SELECT * FROM inventory;

SELECT o.oid AS "Oder Number",
	   o.inventory_id AS "Inventory ID",
       i.name AS "Inventory Name",
	   o.order_qty AS "Quantity"
FROM orders o
JOIN inventory i ON i.iid = o.inventory_id;

SELECT TOP(1) o.inventory_id AS "Inventory ID",
	          i.name AS "Inventory Name",
              SUM(o.order_qty) AS "Quantity"
FROM orders o
JOIN inventory i ON i.iid = o.inventory_id
GROUP BY o.inventory_id,
		 i.name
ORDER BY "Quantity" DESC;


SELECT  o.inventory_id AS "Inventory ID",
	          i.name AS "Inventory Name",
              SUM(order_qty) AS "Quantity"
FROM orders o
JOIN inventory i ON i.iid = o.inventory_id
GROUP BY o.inventory_id,
		 i.name;

UPDATE orders SET order_qty = 15
WHERE oid = 4;



