--1. Выбрать названия компаний для стран, соответствующих стране из которой заказчики

SELECT company_name 
FROM suppliers s 
WHERE country IN (
	SELECT DISTINCT country
	FROM customers c)

SELECT DISTINCT suppliers.company_name
FROM suppliers
JOIN customers USING(country)

--2. Вывести сумму единиц товара, разбитых на группы и лимитировать результирующий набор числом минимальным из product_id +4

SELECT category_name, SUM(units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT (SELECT MIN(product_id) + 4 FROM products)

--3. Вывести такие товары, количество которого в наличии больше чем в среднем

SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock > (SELECT AVG(units_in_stock)
 						FROM products)
ORDER BY units_in_stock

-- WHERE EXISTS 
--4. 