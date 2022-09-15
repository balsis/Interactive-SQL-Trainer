--1. Создать таблицу author следующей структуры:

|     Поле    |          Тип, описание         |
|:-----------:|:------------------------------:|
| author_id   | INT PRIMARY KEY AUTO_INCREMENT |
| name_author | VARCHAR(50)                    |

CREATE TABLE author(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author varchar(50)
);

--2. Заполнить таблицу author. В нее включить следующих авторов:

Булгаков М.А.
Достоевский Ф.М.
Есенин С.А.
Пастернак Б.Л.

INSERT INTO author(name_author)
VALUES 
    ('Булгаков М.А.'),
    ('Достоевский Ф.М.'),
    ('Есенин С.А.'),
    ('Пастернак Б.Л.');
SELECT * FROM author;

Query result:
+-----------+------------------+
| author_id | name_author      |
+-----------+------------------+
| 1         | Булгаков М.А.    |
| 2         | Достоевский Ф.М. |
| 3         | Есенин С.А.      |
| 4         | Пастернак Б.Л.   |
+-----------+------------------+

--3. Перепишите запрос на создание таблицы book , чтобы ее структура соответствовала структуре, показанной на логической схеме (таблица genre уже создана, порядок следования столбцов - как на логической схеме в таблице book, genre_id  - внешний ключ) . Для genre_id ограничение о недопустимости пустых значений не задавать. В качестве главной таблицы для описания поля  genre_idиспользовать таблицу genre следующей структуры:

Поле	        Тип, описание
genre_id	    INT PRIMARY KEY AUTO_INCREMENT
name_genre	    VARCHAR(30)

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id), 
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) 
);
