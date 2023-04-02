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
--4. Выбрать компании и имена заказчиков, которые делали заказы весом от 50 до 100

SELECT company_name, contact_name
FROM customers
WHERE EXISTS (SELECT customer_id FROM orders
              WHERE customer_id=customers.customer_id AND
              freight BETWEEN 50 AND 100);

-- 5. Выбрать компании и имена заказчиков, которые делали заказы между 1-м февраля 95года и 15-м февраля того же года
            
SELECT company_name, contact_name
FROM customers
WHERE EXISTS (SELECT customer_id FROM orders o
              WHERE customer_id=customers.customer_id AND
               o.order_date BETWEEN '1995-02-01' AND '1995-02-15');

-- 6. Выбрать компании и имена заказчиков, которые НЕ делали заказы между 1-м февраля 95года и 15-м февраля того же года

SELECT company_name, contact_name
FROM customers
WHERE NOT EXISTS (SELECT customer_id FROM orders o
              WHERE customer_id=customers.customer_id AND
               o.order_date BETWEEN '1995-02-01' AND '1995-02-15');
               
-- 7. Выбрать продукты которые не покупались в период с 1-го февраля 95года и 15-м февраля того же года
              
SELECT product_name 
FROM products
WHERE NOT EXISTS (SELECT orders.order_id FROM orders
                  JOIN order_details USING(order_id)
              	  WHERE order_details.product_id=products.product_id AND
                  order_date BETWEEN '1995-02-01' AND '1995-02-15');       


-- 8. Выбрать все уникальные компании заказчиков которые делали заказы на более чем 40 единиц товаров

SELECT DISTINCT company_name
FROM customers
JOIN orders USING(customer_id)
JOIN order_details USING(order_id)
WHERE quantity > 40;

-- использование ANY 
SELECT DISTINCT company_name 
FROM customers
WHERE customer_id = ANY(SELECT customer_id FROM orders
					   JOIN order_details USING(order_id)
					   WHERE quantity > 40);

   
-- 9. Выбрать такие продукты, количество которых больше среднего по заказам

SELECT AVG(quantity)
FROM order_details;		
					  
SELECT DISTINCT product_name, quantity
FROM products
JOIN order_details USING(product_id)
WHERE quantity >
	  (SELECT AVG(quantity)
	   FROM order_details);
	   
	   
-- 10. Найти все продукты количество которых больше среднего значения количества заказанных товаров из групп, полученных группированием по product_id

SELECT AVG(quantity)
FROM order_details
GROUP BY product_id;

SELECT DISTINCT product_name, quantity
FROM products
JOIN order_details USING(product_id)
WHERE quantity > ALL
	  (SELECT AVG(quantity)
	   FROM order_details
	   GROUP BY product_id)
ORDER BY quantity;              	 
