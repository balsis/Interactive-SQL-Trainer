**<h2>Основы реляционной модели и SQL</h2>**

**1. Выборка всех данных из таблицы**  
```
SELECT * FROM book;
```
**2. Выборка отдельных столбцов**  
```
SELECT title, amount FROM book;
```
**3. Выборка новых столбцов и присвоение им новых имен**  
```
SELECT title AS Название, amount`   
`FROM book;
```
**4. Выборка данных с созданием вычисляемого столбца**  
```
SELECT title, author, price, amount,  
    price * amount AS total
FROM book;
```
**5. Выборка данных, вычисляемые столбцы, математические функции**

* CEILING(x) --возвращает наименьшее целое число, большее или равное **x** (округляет до целого числа в большую сторону);	
* ROUND(x, k) - округляет значение **x** до **k** знаков после запятой,если **k** не указано – **x** округляется до целого;	
* FLOOR(x) - возвращает наибольшее целое число, меньшее или равное **x** (округляет до  целого числа в меньшую сторону);
* POWER(x, y)	возведение **x** в степень **y**;	
* SQRT(x) - квадратный корень из **x**;	
* DEGREES(x) - конвертирует значение **x** из радиан в градусы;	
* RADIANS(x) - конвертирует значение **x** из градусов в радианы;
* ABS(x)- модуль числа **x**;
* PI() - pi = 3.1415926.	 

```
SELECT title, price, 
    (price*18/100)/(1+18/100) AS tax, 
    price/(1+18/100) AS price_tax 
FROM book;
```

**6. Выборка данных, вычисляемые столбцы, логические функции**
```
SELECT title, amount, price, 
    IF(amount<4, price*0.5, price*0.7) AS sale
FROM book;
```

**7. Выборка данных по условию**
```
SELECT title, price 
FROM book
WHERE price < 600;
```

**8. Выборка данных, логические операции**
```
SELECT title, author, price 
FROM book
WHERE price > 600 AND author = 'Булгаков М.А.';
```
**9. Выборка данных, операторы BETWEEN, IN**
```
SELECT title, amount 
FROM book
WHERE amount BETWEEN 5 AND 14;
```
```
SELECT title, price 
FROM book
WHERE author IN ('Булгаков М.А.', 'Достоевский Ф.М.');
```
**10. Выборка данных с сортировкой**  
ASC - по возрастанию (по умолчанию);  
DESC - по убыванию.

```
SELECT title, author, price
FROM book
ORDER BY title;
```
**11. Выборка данных, оператор LIKE**   
% - Любая строка, содержащая ноль или более символов;  
_ (подчеркивание) - Любой одиночный символ.  

```
SELECT title 
FROM book
WHERE title LIKE 'Б%';
```
```
SELECT title FROM book 
WHERE title LIKE "_____"
```
```
SELECT title FROM book 
WHERE title NOT LIKE "% %";   
```
**12. Выбор уникальных элементов столбца**
```
SELECT DISTINCT author
FROM book;
```
```
SELECT  author
FROM book
GROUP BY author;
```
**13. Выборка данных, групповые функции SUM и COUNT**  
```
SELECT author, SUM(amount)
FROM book
GROUP BY author;
```
**14. Выборка данных, групповые функции MIN, MAX и AVG**
```
SELECT author, MIN(price) AS min_price
FROM book
GROUP BY author;
```
**15. Выборка данных c вычислением, групповые функции**
```
SELECT author, SUM(price * amount) AS Стоимость
FROM book
GROUP BY author;
```
**16. Вычисления по таблице целиком**
```
SELECT SUM(amount) AS Количество
FROM book;
```
**17. Выборка данных по условию, групповые функции**  
* В запросах с групповыми функциями вместо WHERE используется ключевое слово HAVING , которое размещается после оператора GROUP BY.
* Только в HAVING можно писать условия по агрегатным функциям (SUM, COUNT, MAX, MIN и т. д.) 
* в HAVING можно наложить условия на результаты группировки, потому что порядок исполнения запроса устроен таким образом, что на этапе, когда выполняется WHERE, ещё нет групп, а HAVING выполняется уже после формирования групп. 
```
SELECT author,
    MIN(price) AS Минимальная_цена, 
    MAX(price) AS Максимальная_цена
FROM book
GROUP BY author
HAVING SUM(price * amount) > 5000; 
```
**18. Выборка данных по условию, групповые функции, WHERE и HAVING**
Порядок выполнения SQL запроса на выборку(на примере Postgre):   
1) FROM - определяется таблица;
2) WHERE - отбираются записи по условию;
3) GROUP BY - отобранные данные агрегируются;
4) HAVING - из агрегированных записей выбираются те, которые удовлетворяют условию;
5) SELECT - формируются данные результирующей выборки;
6) ORDER BY - результирующая выборка сортируется.
```
SELECT author,
    MIN(price) AS Минимальная_цена,
    MAX(price) AS Максимальная_цена
FROM book
WHERE author <> 'Есенин С.А.'
GROUP BY author
HAVING SUM(amount) > 10;
```
Порядок обработки в различных СУБД:  
__MySQL__: FROM => WHERE = SELECT = GROUP BY = HAVING = ORDER BY = LIMIT.   

__PostgreSQL__: FROM => WHERE = GROUP BY = HAVING = SELECT = DISTINCT = ORDER BY = LIMIT.

**19. Вложенный запрос, возвращающий одно значение**
```
SELECT title, author, price, amount
FROM book
WHERE price = (
         SELECT MIN(price) 
         FROM book
      );
```
**20. Использование вложенного запроса в выражении**
```
SELECT title, author, amount 
FROM book
WHERE ABS(amount - (SELECT AVG(amount) FROM book)) >3;
```
**21. Вложенный запрос, оператор IN**  
IN - определяет, совпадает ли значение столбца с одним из значений, содержащихся во вложенном запросе;  
NOT IN - выражение истинно, если значение столбца не содержится во вложенном запросе.
```
SELECT title, author, amount, price
FROM book
WHERE author IN (
        SELECT author 
        FROM book 
        GROUP BY author 
        HAVING SUM(amount) >= 12
      );
```
**22. Вложенный запрос, операторы ANY и ALL**
```
SELECT title, author, amount, price
FROM book
WHERE amount < ALL (
        SELECT AVG(amount) 
        FROM book 
        GROUP BY author 
      );
```
**23. Вложенный запрос после SELECT**
```
SELECT title, author, amount, 
    (
     SELECT AVG(amount) 
     FROM book
    ) AS Среднее_количество 
FROM book
WHERE abs(amount - (SELECT AVG(amount) FROM book)) >3;
```

**24. Создание пустой таблицы**
```
CREATE TABLE supply (
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT
);
```
**25. Добавление записей в таблицу**

```
INSERT INTO book (title, author, price, amount) 
VALUES 
    ('Война и мир','Толстой Л.Н.', 1070.20, 2),
    ('Анна Каренина', 'Толстой Л.Н.', 599.90, 3);
```
**26. Добавление записей из другой таблицы**
```
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply;

SELECT * FROM book;
```

**27. Добавление записей, вложенные запросы**
```
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE title NOT IN (
        SELECT title 
        FROM book
      );

SELECT * FROM book;
```
**28. Запросы на обновление**
```
UPDATE book 
SET price = 0.7 * price;

SELECT * FROM book;
```

**29. Запросы на обновление нескольких столбцов**
```
UPDATE book 
SET amount = amount - buy,
    buy = 0;

SELECT * FROM book;
```

**30. Запросы на обновление нескольких таблиц**
```
UPDATE book, supply 
SET book.amount = book.amount + supply.amount
WHERE book.title = supply.title AND book.author = supply.author;

SELECT * FROM book;
```

**31. Запросы на удаление**
```
DELETE FROM supply 
WHERE title IN (
        SELECT title 
        FROM book
      );

SELECT * FROM supply;
```
**32. Запросы на создание таблицы**

```
CREATE TABLE ordering AS
SELECT author, title, 5 AS amount
FROM book
WHERE amount < 4;

SELECT * FROM ordering;
```

**33. Оператор LIMIT**
~~~
SELECT *
FROM trip
ORDER BY  date_first
LIMIT 1;
~~~