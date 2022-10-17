**1. Соединение INNER JOIN**  
Результат запроса формируется так:

* каждая строка одной таблицы сопоставляется с каждой строкой второй таблицы;
* для полученной «соединённой» строки проверяется условие соединения;
* если условие истинно, в таблицу результата добавляется соответствующая «соединённая» строка;

~~~
SELECT title, name_author
FROM 
    author INNER JOIN book
    ON author.author_id = book.author_id;
~~~~    

**2. Внешнее соединение LEFT и RIGHT OUTER JOIN**  
Результат запроса формируется так:

* в результат включается внутреннее соединение (INNER JOIN) первой и второй таблицы в соответствии с условием;
* затем в результат добавляются те записи первой таблицы, которые не вошли во внутреннее соединение на шаге 1, для таких записей соответствующие поля второй таблицы заполняются значениями NULL.

~~~
SELECT name_author, title 
FROM author LEFT JOIN book
     ON author.author_id = book.author_id
ORDER BY name_author;  
~~~

**3. Перекрестное соединение CROSS JOIN** 

Результат запроса формируется так: каждая строка одной таблицы соединяется с каждой строкой другой таблицы, формируя  в результате все возможные сочетания строк двух таблиц.
```
SELECT name_author, name_genre
FROM 
    author, genre;
```    
**4. Запросы на выборку из нескольких таблиц** 

```
SELECT title, name_author, name_genre, price, amount
FROM
    author 
    INNER JOIN  book ON author.author_id = book.author_id
    INNER JOIN genre ON genre.genre_id = book.genre_id
WHERE price BETWEEN 500 AND 700;

```

