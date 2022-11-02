--1. Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном по номеру заказа и названиям книг виде.

SELECT buy_book.buy_id, title, price, buy_book.amount
FROM 
    client 
    INNER JOIN buy ON client.client_id=buy.client_id
    INNER JOIN buy_book ON buy_book.buy_id=buy.buy_id
    INNER JOIN book ON buy_book.book_id=book.book_id
WHERE name_client LIKE "Баранов%"
ORDER BY buy_book.buy_id, title

Query result:
+--------+--------------------+--------+--------+
| buy_id | title              | price  | amount |
+--------+--------------------+--------+--------+
| 1      | Идиот              | 460.00 | 1      |
| 1      | Мастер и Маргарита | 670.99 | 1      |
| 1      | Черный человек     | 570.20 | 2      |
| 4      | Игрок              | 480.50 | 1      |
+--------+--------------------+--------+--------+

--2. Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.

SELECT name_author, title, COUNT(buy_book.amount) AS Количество
FROM author
     INNER JOIN book ON author.author_id = book.author_id
     LEFT JOIN buy_book ON book.book_id=buy_book.book_id
GROUP BY book.book_id
ORDER BY name_author, title

Query result:
+------------------+-----------------------+------------+
| name_author      | title                 | Количество |
+------------------+-----------------------+------------+
| Булгаков М.А.    | Белая гвардия         | 1          |
| Булгаков М.А.    | Мастер и Маргарита    | 2          |
| Достоевский Ф.М. | Братья Карамазовы     | 0          |
| Достоевский Ф.М. | Игрок                 | 1          |
| Достоевский Ф.М. | Идиот                 | 2          |
| Есенин С.А.      | Стихотворения и поэмы | 0          |
| Есенин С.А.      | Черный человек        | 1          |
| Пастернак Б.Л.   | Лирика                | 1          |
+------------------+-----------------------+------------+

--3. Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.

SELECT name_city, COUNT(buy_id) AS Количество
FROM 
    buy
    INNER JOIN client ON buy.client_id=client.client_id
    INNER JOIN city ON client.city_id=city.city_id
GROUP BY name_city
ORDER BY Количество DESC, name_city;
Оптимальнее: 

SELECT name_city, COUNT(buy_id) AS Количество
FROM 
    buy
	INNER JOIN client USING(city_id)
	INNER JOIN buy USING(client_id)
GROUP BY name_city
ORDER BY Количество DESC, name_city;

Query result:
+-----------------+------------+
| name_city       | Количество |
+-----------------+------------+
| Владивосток     | 2          |
| Москва          | 1          |
| Санкт-Петербург | 1          |
+-----------------+------------+

--4. Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.

SELECT buy_book.buy_id, name_client, SUM(buy_book.amount*price) AS Стоимость
FROM book
     JOIN buy_book USING (book_id)
     JOIN buy USING (buy_id)
     JOIN client USING (client_id)
GROUP BY buy_book.buy_id
ORDER BY buy_id

Query result:
+--------+----------------+-----------+
| buy_id | name_client    | Стоимость |
+--------+----------------+-----------+
| 1      | Баранов Павел  | 2271.39   |
| 2      | Семенонов Иван | 1037.98   |
| 3      | Абрамова Катя  | 2131.49   |
| 4      | Баранов Павел  | 480.50    |
+--------+----------------+-----------+

--5. Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.

SELECT buy_id, name_step
FROM  
    step
    JOIN buy_step USING (step_id)
WHERE date_step_beg IS NOT NULL AND date_step_end IS NULL
ORDER BY buy_id 

Query result:
+--------+-----------------+
| buy_id | name_step       |
+--------+-----------------+
| 2      | Транспортировка |
| 3      | Доставка        |
| 4      | Оплата          |
+--------+-----------------+

--6. В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город (рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.

SELECT buy_id, DATEDIFF(date_step_end, date_step_beg) AS Количество_дней, IF(DATEDIFF(date_step_end, date_step_beg) > days_delivery,DATEDIFF(date_step_end, date_step_beg)-days_delivery,0) AS Опоздание
FROM 
    buy_step 
    JOIN buy USING (buy_id)
    JOIN client USING (client_id)
    JOIN city USING (city_id)
WHERE date_step_end IS NOT NULL AND step_id=3
ORDER BY buy_id

Query result:
+--------+-----------------+-----------+
| buy_id | Количество_дней | Опоздание |
+--------+-----------------+-----------+
| 1      | 14              | 2         |
| 3      | 4               | 0         |
+--------+-----------------+-----------+

--7. Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.

SELECT DISTINCT name_client
    FROM client 
    JOIN buy USING (client_id)
    JOIN buy_book USING (buy_id)
    JOIN book USING (book_id)
    JOIN author USING (author_id)
WHERE name_author LIKE 'Достоевский%'
ORDER BY name_client

Query result:
+---------------+
| name_client   |
+---------------+
| Абрамова Катя |
| Баранов Павел |


--8. Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. Последний столбец назвать Количество.

    SELECT name_genre, SUM(buy_book.amount) AS Количество
    FROM genre
        JOIN book USING (genre_id)
        JOIN buy_book USING (book_id)
    GROUP BY name_genre
    HAVING SUM(buy_book.amount) = (
        SELECT MAX(Количество)
        FROM ( 
            SELECT name_genre, SUM(buy_book.amount) AS Количество
            FROM genre
                JOIN book USING (genre_id)
                JOIN buy_book USING (book_id)
            GROUP BY name_genre
            ) query_
                                    )


Query result:
+------------+------------+
| name_genre | Количество |
+------------+------------+
| Роман      | 7          |
+------------+------------+