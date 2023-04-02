-- INNER JOIN 
--1. Вывести наименование продуктов, название компаний-поставщиков и количество единиц товара в наличии для каждого продукта и отсортировать результаты по количеству единиц товара в наличии по убыванию

SELECT p.product_name, s.company_name, p.units_in_stock  
FROM products p 
INNER JOIN suppliers s ON p.supplier_id  = s.supplier_id   
ORDER BY units_in_stock DESC

--2. Вывести название категории продукта и суммарное количество единиц товара в наличии для каждой категории продукта. 
-- Результаты должны быть отсортированы по убыванию количества единиц товара в наличии для каждой категории продукта, и вывести только первые 5 записей

SELECT c.category_name, SUM(p.units_in_stock)
FROM products p INNER JOIN categories c 
ON p.category_id = c.category_id 
GROUP BY c.category_name 
ORDER BY SUM(p.units_in_stock) DESC 
LIMIT 5

--3. Вывести название категории продукта и сумму продаж для каждой категории продукта, не снятого с производства.   
-- Результаты должны быть cгруппированы по названию категории и отфильтрованы по сумме продаж, большей, чем 5000. 
-- Результаты должны быть отсортированы по убыванию суммы продаж:

SELECT c.category_name, SUM(p.units_in_stock * p.unit_price)
FROM products p INNER JOIN categories c 
ON p.category_id = c.category_id
WHERE discontinued  <> 1
GROUP BY c.category_name 
HAVING SUM(p.units_in_stock * p.unit_price) > 5000
ORDER BY SUM(p.units_in_stock * p.unit_price) DESC

--4. Выбрать информацию о заказах и связанных с ними сотрудниках.

SELECT o.order_id, o.customer_id, e.first_name, e.last_name, e.title 
FROM orders o INNER JOIN employees e 
ON o.employee_id = e.employee_id 

--5. Выберите информацию о продуктах в деталях заказов, включая название продукта, цену за единицу, количество, скидку и страну доставки.

SELECT o.order_id, p.product_name, o.ship_country, p.unit_price, od.quantity, od.discount  
FROM orders o 
INNER JOIN order_details od ON o.order_id = od.order_id 
INNER JOIN products p ON p.product_id = od.product_id 

--6. Напишите запрос, который извлекает данные о заказах в США и связанных с ними продуктах, клиентах и сотрудниках:

SELECT contact_name, company_name, phone, first_name, last_name, title,
	order_date, product_name, ship_country, p.unit_price, quantity, discount
FROM orders o 
JOIN order_details od ON o.order_id = od.order_id
JOIN products p  ON od.product_id = p.product_id
JOIN customers c  ON o.customer_id = c.customer_id
JOIN employees e  ON o.employee_id = e.employee_id
WHERE ship_country = 'USA';

/*-------------------------------------------------------------------------------------------*/

-- LEFT JOIN 
--1. Выбрать название компании поставщика и название товара, который он поставляет. 
-- Если у поставщика нет товаров, то он также должен быть включен в результат с пустым значением в поле название товара. 
--Отсортировать результаты по названию компании поставщика в алфавитном порядке.

SELECT s.company_name, p.product_name 
FROM suppliers s 
LEFT JOIN products p ON s.supplier_id = p.supplier_id 

--2. Найдите названия компаний-клиентов, у которых нет заказов в базе данных. 

SELECT c.company_name, o.order_id 
FROM customers c 
LEFT JOIN orders o 
ON o.customer_id = c.customer_id 
WHERE o.order_id IS NULL

SELECT company_name, o.order_id 
FROM orders o
RIGHT JOIN customers c  ON o.customer_id = c.customer_id
WHERE order_id IS NULL;

--3. Выбрать фамилии всех сотрудников и id заказов, которые не были обработаны ни одним из сотрудников.

SELECT e.last_name, o.order_id 
FROM employees e 
LEFT JOIN orders o 
ON e.employee_id = o.employee_id 
WHERE o.order_id IS NULL;

/*-------------------------------------------------------------------------------------------*/
-- SELF JOIN - это тип соединения таблицы, в котором одна таблица объединяется с собой самой, но при этом используются разные псевдонимы (alias) для идентификации каждого экземпляра таблицы.

CREATE TABLE employee2 (
	employee_id int PRIMARY KEY,
	first_name varchar(256) NOT NULL,
	last_name varchar(256) NOT NULL,
	manager_id int,
	FOREIGN KEY (manager_id) REFERENCES employee(employee_id);
);

INSERT INTO employee2
(employee_id, first_name, last_name, manager_id)
VALUES 
(1, 'Windy', 'Hays', NULL),
(2, 'Ava', 'Christensen', 1),
(3, 'Hassan', 'Conner', 1),
(4, 'Anna', 'Reeves', 2),
(5, 'Sau', 'Norman', 2),
(6, 'Kelsie', 'Hays', 3),
(7, 'Tory', 'Goff', 3),
(8, 'Salley', 'Lester', 3);

SELECT e.first_name || ' ' || e.last_name AS employee,
	   m.first_name || ' ' || m.last_name AS manager
FROM employee e
LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY manager;

/*-------------------------------------------------------------------------------------------*/
-- USING 

SELECT contact_name, company_name, phone, first_name, last_name, title,
	order_date, product_name, ship_country, p.unit_price, quantity, discount
FROM orders o 
JOIN order_details od USING (order_id)
JOIN products p USING (product_id)
JOIN customers c USING (customer_id)
JOIN employees e USING (employee_id)
WHERE ship_country = 'USA';


-- NATURAL JOIN 

SELECT order_id, customer_id, first_name, last_name, title
FROM orders
NATURAL JOIN employees;

-- ALIAS  - нельзя пользоваться в WHERE, HAVING

SELECT COUNT(DISTINCT country) AS country
FROM employees;

SELECT category_id, SUM(units_in_stock) AS units_in_stock
FROM products
GROUP BY category_id
ORDER BY units_in_stock DESC
LIMIT 5;

SELECT category_id, SUM(unit_price * units_in_stock) AS total_price
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY total_price DESC;