--ДЗ 1

-- 1. Выбрать все данные из таблицы customers

SELECT *
FROM customers c;

-- 2. Выбрать все записи из таблицы customers, но только колонки "имя контакта" и "город"

SELECT contact_name, city
FROM customers c;

--3. Выбрать все записи из таблицы orders, но взять две колонки: идентификатор заказа и колонку, значение в которой мы рассчитываем как разницу между датой отгрузки и датой формирования заказа.

SELECT order_id, shipped_date - order_date AS difference
FROM orders;

--4. Выбрать все уникальные города в которых "зарегистрированы" заказчики

SELECT DISTINCT city
FROM customers c 

--5. Выбрать все уникальные сочетания городов и стран в которых "зарегистрированы" заказчики

SELECT DISTINCT city, country 
FROM customers c 

--6. Посчитать кол-во заказчиков

SELECT COUNT(*)
FROM customers c 

--7. Посчитать кол-во уникальных стран в которых "зарегестрированы" заказчики

SELECT COUNT(DISTINCT country)
FROM customers c 

/*---------------------------------------------------------------------------------------------------------------------------------------------*/

--ДЗ 2

--1. Выбрать все заказы из стран France, Austria, Spain

SELECT *
FROM orders o 
WHERE ship_country IN ('France', 'Austria', 'Spain') 

-- 2. Выбрать все заказы, отсортировать по required_date (по убыванию) и отсортировать по дате отгрузке (по возрастанию)
 SELECT *
 FROM orders o 
 ORDER BY required_date DESC, shipped_date 

 -- 3. Выбрать минимальное кол-во  единиц товара среди тех продуктов, которых в продаже более 30 единиц.

 SELECT MIN(units_in_stock) 
 FROM products p 
 WHERE units_in_stock >30
 
-- 4. Выбрать максимальное кол-во единиц товара среди тех продуктов, которых в продаже более 30 единиц.
 
 SELECT MAX (units_in_stock) 
 FROM products p 
 WHERE units_in_stock >30
 
-- 5. Найти среднее значение дней уходящих на доставку с даты формирования заказа в USA

 SELECT AVG(shipped_date - order_date) AS delivery_days 
 FROM orders
 WHERE ship_country = 'USA'
 
-- 6. Найти сумму, на которую имеется товаров (кол-во * цену) причём таких, которые планируется продавать и в будущем (см. на поле discontinued)

SELECT SUM(unit_price * units_in_stock)
FROM products p 
WHERE discontinued <> 1

/*---------------------------------------------------------------------------------------------------------------------------------------------*/
--ДЗ 3
--1. Выбрать все записи заказов в которых наименование страны отгрузки начинается с 'U'

SELECT * 
FROM orders o 
WHERE ship_country LIKE 'U%'

--2. Выбрать записи заказов (включить колонки идентификатора заказа, идентификатора заказчика, веса и страны отгузки), которые должны быть отгружены в страны имя которых начинается с 'N', отсортировать по весу (по убыванию) и вывести только первые 10 записей.

SELECT order_id, customer_id, freight, ship_country 
FROM orders o 
WHERE ship_country LIKE 'N%' 
ORDER BY freight DESC
LIMIT 10; 

--3. Выбрать записи работников (включить колонки имени, фамилии, телефона, региона) в которых регион неизвестен

SELECT first_name, last_name, home_phone, region 
FROM employees e 
WHERE region IS NULL 

--4. Подсчитать кол-во заказчиков регион которых известен

SELECT COUNT(*)
FROM customers c
WHERE region IS NOT NULL 

--5. Подсчитать кол-во поставщиков в каждой из стран и отсортировать результаты группировки по убыванию кол-ва

SELECT country, COUNT(*) 
FROM suppliers s 
GROUP BY country 
ORDER BY COUNT (*) DESC

--6. Подсчитать суммарный вес заказов (в которых известен регион) по странам, затем отфильтровать по суммарному весу (вывести только те записи где суммарный вес больше 2750) и отсортировать по убыванию суммарного веса.

SELECT ship_country, SUM(freight) AS sum_freight  
FROM orders o 
WHERE ship_region IS NOT NULL
GROUP BY ship_country 
HAVING SUM(freight) > 2750
ORDER BY SUM(freight) DESC

--7. Выбрать все уникальные страны заказчиков и поставщиков и отсортировать страны по возрастанию

SELECT country 
FROM customers c
UNION 
SELECT country 
FROM suppliers s
ORDER BY country 

--8. Выбрать такие страны в которых "зарегистированы" одновременно и заказчики и поставщики и работники.

SELECT country 
FROM customers c
INTERSECT 
SELECT country 
FROM suppliers s
INTERSECT 
SELECT country  
FROM employees e 
ORDER BY country 

--9. Выбрать такие страны в которых "зарегистированы" одновременно заказчики и поставщики, но при этом в них не "зарегистрированы" работники.

SELECT country 
FROM customers c
INTERSECT 
SELECT country 
FROM suppliers s
EXCEPT 
SELECT country  
FROM employees e 
 
/*--------------------------------------------------------------------*/
--ДЗ 4 

--1. Найти заказчиков и обслуживающих их заказы сотрудников таких, что и заказчики и сотрудники из города London, а доставка идёт компанией Speedy Express. Вывести компанию заказчика и ФИО сотрудника.

SELECT c.company_name, e.last_name || ' ' || e.first_name AS ФИО 
FROM customers c 
JOIN orders o ON o.customer_id = c.customer_id 
JOIN employees e ON o.employee_id  =e.employee_id 
JOIN shippers s ON s.shipper_id = o.ship_via 
WHERE (c.city  = 'London' AND e.city = 'London') AND s.company_name LIKE 'Speedy%' 

--2. Найти активные (см. поле discontinued) продукты из категории Beverages и Seafood, которых в продаже менее 20 единиц. Вывести наименование продуктов, кол-во единиц в продаже, имя контакта поставщика и его телефонный номер.

SELECT p.product_name, p.units_in_stock, s.contact_name, s.phone 
FROM products p 
JOIN categories c ON c.category_id = p.category_id
JOIN suppliers s ON s.supplier_id =p.supplier_id 
WHERE c.category_name IN ('Beverages', 'Seafood') AND discontinued = 0 AND units_in_stock < 20
ORDER BY units_in_stock 

--3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и order_id.

SELECT distinct contact_name, order_id
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL
ORDER BY contact_name;

--4. Переписать предыдущий запрос, использовав симметричный вид джойна (подсказка: речь о LEFT и RIGHT).

SELECT contact_name, order_id
FROM orders
RIGHT JOIN customers USING(customer_id)
WHERE order_id IS NULL
ORDER BY contact_name;