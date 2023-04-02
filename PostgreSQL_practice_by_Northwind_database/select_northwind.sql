--1. Напишите запрос для получения итоговой стоимости каждого продукта, учитывая его текущее количество на складе и цену за единицу товара

SELECT product_id, product_name, unit_price*units_in_stock 
FROM products p;

--2. Напишите запрос для получения списка всех уникальных городов, где работают сотрудники компании.

SELECT DISTINCT city 
FROM employees e 

--3. Напишите запрос для получения общего количества уникальных стран, в которых проживают сотрудники компании.

SELECT COUNT(DISTINCT country) AS Всего_стран 
FROM employees e 

--4. Напишите запрос для получения списка всех уникальных городов и стран, в которых работают сотрудники компании.

SELECT DISTINCT city, country 
FROM employees e 

--5. Напишите запрос для получения общего количества заказов, которые были сделаны в компании.

SELECT COUNT(*)
FROM orders o 


/*---------------------------------------------------------------------------------------------------*/

--1. Напишите запрос для получения списка компаний из США с указанием контактного лица и номера телефона.
SELECT company_name, contact_name, phone 
FROM customers c 
WHERE country = 'USA';

--2. Напишите запрос для подсчета количества продуктов, у которых цена за единицу товара превышает 20.
SELECT COUNT(*)
FROM products p  
WHERE unit_price >20;

--3. Напишите запрос для получения списка всех продуктов, которые сняты с производства.

SELECT * 
FROM products p 
WHERE discontinued = 1;

--4. Напишите запрос для получения списка всех клиентов, не находящихся в городе Берлин.

SELECT *
FROM customers c 
WHERE city <> 'Berlin';

--5. Напишите запрос для получения списка всех заказов, которые были сделаны после 1 марта 1998 года.

SELECT * 
FROM orders o 
WHERE order_date >= '1998-03-01';

--6. Напишите запрос для получения списка всех продуктов, у которых цена за единицу товара больше 25 и количество товаров на складе больше 40.

SELECT *
FROM products p 
WHERE unit_price > 25 AND units_in_stock > 40;

--7. Напишите запрос для получения списка всех клиентов, находящихся в городах Берлин, Лондон или Сан-Франциско.

SELECT * 
FROM customers c 
WHERE city = 'Berlin' OR city = 'London' OR city = 'San Francisco'

--8. Напишите запрос для получения списка всех заказов, которые были отправлены 30.04.1998 и имеют вес доставки менее 75 или более 150.

SELECT *
FROM orders o 
WHERE shipped_date > '1998-04-30' AND (freight < 75  OR freight > 150)

--9. Напишите запрос для получения списка всех заказов, у которых вес доставки составляет от 20 до 40.

SELECT * 
FROM orders o 
WHERE freight BETWEEN 20 AND 40;

--10. Напишите запрос для получения списка всех заказов, которые были сделаны в апреле 1998 года.

SELECT * 
FROM orders o
WHERE order_date  BETWEEN '1998-04-01' AND '1998-04-30'

--11. Напишите запрос для получения списка всех клиентов из США, Германии и Канады.

SELECT * 
FROM customers c 
WHERE country IN ('USA' ,'Germany', 'Canada')

--12. Напишите запрос для получения списка всех клиентов, не из США и Германии.

SELECT *
FROM customers c 
WHERE country NOT IN ('USA', 'Germany')

--13. Напишите запрос для получения списка всех уникальных стран, в которых есть клиенты, отсортированных по названию страны в алфавитном порядке.

SELECT DISTINCT country 
FROM customers c 
ORDER BY 1;

--14. Напишите запрос для получения списка всех уникальных пар город-страна клиентов, отсортированных сначала по названию страны в алфавитном порядке, а затем по названию города в обратном порядке.

SELECT DISTINCT country,city 
FROM customers c 
ORDER BY 1,2 DESC;

--15. Напишите запрос для получения списка всех заказов, которые были отправлены в Лондон, отсортированных по дате заказа в порядке возрастания.

SELECT ship_city, order_date 
FROM orders o 
WHERE ship_city = 'London'
ORDER BY order_date;

--16. Найдите дату самого раннего заказа, который был отправлен в Лондон.

SELECT MIN(order_date)
FROM orders o 
WHERE ship_city = 'London';

--17. Найдите дату самого позднего заказа, который был отправлен в Лондон.

SELECT MAX(order_date)
FROM orders o 
WHERE ship_city = 'London'

--18. Найдите среднюю цену на все продукты, которые не сняты с производства,

SELECT AVG(unit_price)
FROM products p  
WHERE discontinued <> 1;

--19. Найдите общее количество единиц товара в наличии на складе для всех продуктов

SELECT SUM(units_in_stock)
FROM products p 

/*---------------------------------------------------------------------*/

-- 1. Выбрать фамилию и имя сотрудников, чьё имя заканчивается на букву "n"..

SELECT last_name, first_name 
FROM employees e 
WHERE first_name LIKE '%n'

-- 2. Выбрать фамилию и имя сотрудников, чья фамилия заканчивается на букву "n".

SELECT last_name, first_name 
FROM employees e 
WHERE last_name LIKE '%n'

--3. Выбрать фамилию и имя сотрудников, чья фамилия содержит "uch" с одним символом перед ним.

SELECT last_name, first_name 
FROM employees e 
WHERE last_name LIKE '_uch%'

--4. Выбрать первые 10 строк из таблицы продуктов.

SELECT *
FROM products p 
LIMIT 10;

--5. Выбрать город и регион доставки из заказов, где регион не указан.

SELECT ship_city, ship_region 
FROM orders o 
WHERE ship_region IS NULL

--6. Выбрать город и регион доставки из заказов, где регион указан.

SELECT ship_city, ship_region 
FROM orders o 
WHERE ship_region IS NOT NULL;

--7. Выбрать все поля из таблицы заказов, где стоимость доставки превышает 50 единиц.

SELECT *  
FROM orders o 
WHERE freight > 50

--8. Выбрать страну доставки и количество заказов из таблицы заказов, где стоимость доставки превышает 50 единиц, сгруппированные по стране и упорядоченные по убыванию количества заказов.
SELECT ship_country, count(ship_country)  
FROM orders o 
WHERE freight > 50
GROUP BY ship_country 
ORDER BY 2 DESC

--9. Выбрать идентификатор категории и сумму количества товаров в наличии из таблицы продуктов, сгруппированные по категории и ограниченные первыми 5 строками.

SELECT category_id, SUM(units_in_stock)
FROM products p 
GROUP BY category_id 
LIMIT 5;

--10. Выбрать идентификатор категории и сумму стоимости товаров в наличии из таблицы продуктов, исключая товары, которые больше не производятся, сгруппированные по категории, у которых сумма стоимости больше 5000 и упорядоченные по возрастанию суммы стоимости.

SELECT category_id, SUM(unit_price * units_in_stock) 
FROM products p 
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) 

/*_______________________________________________________________________________________________*/

-- UNION - объединение результатов двух запросов
--1. Выбрать все записи для получения списка всех уникальных стран, где  проживают либо сотрудники компании, либо  клиенты компании.*/
SELECT country 
FROM customers c 
UNION
SELECT country 
FROM employees e; 

--2. Получить список всех стран, где живут как заказчики, так и сотрудники компании
SELECT country 
FROM customers c 
UNION ALL
SELECT country 
FROM employees e 

-- INTERSECT - пересечение двух запросов , позволяет получить только те строки, которые присутствуют в обоих запросах.
--3. Вывести список стран, где есть как клиенты, так и поставщики.

SELECT country 
FROM customers c 
INTERSECT 
SELECT country 
FROM suppliers s  

-- EXCEPT - исключение или разница между запросами, для извлечения записей, которые есть в первом запросе, но отсутствуют во втором запросе 
--4. Получить список стран, где проживают только клиенты, но не сотрудники 
SELECT country 
FROM customers c 
EXCEPT 
SELECT country 
FROM suppliers s  

