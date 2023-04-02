--1. В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». Установить текущую дату в качестве даты выполнения попытки.

INSERT INTO attempt (student_id , subject_id , date_attempt , result ) 
SELECT 
    (SELECT student_id FROM student WHERE name_student LIKE 'Баранов%'),   
    (SELECT subject_id FROM subject WHERE name_subject = 'Основы баз данных'),
    NOW(),
    NULL;

SELECT * FROM attempt;

Query result:
+------------+------------+------------+--------------+--------+
| attempt_id | student_id | subject_id | date_attempt | result |
+------------+------------+------------+--------------+--------+
| 1          | 1          | 2          | 2020-03-23   | 67     |
| 2          | 3          | 1          | 2020-03-23   | 100    |
| 3          | 4          | 2          | 2020-03-26   | 0      |
| 4          | 1          | 1          | 2020-04-15   | 33     |
| 5          | 3          | 1          | 2020-04-15   | 67     |
| 6          | 4          | 2          | 2020-04-21   | 100    |
| 7          | 3          | 1          | 2020-05-17   | 33     |
| 8          | 1          | 2          | 2022-11-04   | NULL   |
+------------+------------+------------+--------------+--------+

--2. Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в таблицу testing. id последней попытки получить как максимальное значение id из таблицы attempt.

INSERT INTO testing(attempt_id, question_id, answer_id)
SELECT (SELECT MAX(attempt.attempt_id) FROM attempt), question_id, NULL
  FROM question INNER JOIN attempt USING(subject_id)
 WHERE subject_id = (SELECT subject_id FROM attempt
                     ORDER BY attempt_id DESC
                     LIMIT 1)                    
 ORDER BY RAND()
 LIMIT 3;

 Query result:
+------------+------------+-------------+-----------+
| testing_id | attempt_id | question_id | answer_id |
+------------+------------+-------------+-----------+
| 1          | 1          | 9           | 25        |
| 2          | 1          | 7           | 19        |
| 3          | 1          | 6           | 17        |
| 4          | 2          | 3           | 9         |
| 5          | 2          | 1           | 2         |
| 6          | 2          | 4           | 11        |
| 7          | 3          | 6           | 18        |
| 8          | 3          | 8           | 24        |
| 9          | 3          | 9           | 28        |
| 10         | 4          | 1           | 2         |
| 11         | 4          | 5           | 16        |
| 12         | 4          | 3           | 10        |
| 13         | 5          | 2           | 6         |
| 14         | 5          | 1           | 2         |
| 15         | 5          | 4           | 12        |
| 16         | 6          | 6           | 17        |
| 17         | 6          | 8           | 22        |
| 18         | 6          | 7           | 21        |
| 19         | 7          | 1           | 3         |
| 20         | 7          | 4           | 11        |
| 21         | 7          | 5           | 16        |
| 22         | 8          | 9           | NULL      |
| 23         | 8          | 7           | NULL      |
| 24         | 8          | 8           | NULL      |
+------------+------------+-------------+-----------+

--3. Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), далее необходимо вычислить результат(запрос) и занести его в таблицу attempt для соответствующей попытки.  Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до целого.

UPDATE attempt
    SET result = (SELECT ROUND(SUM(is_correct)/3*100, 0)
        FROM answer INNER JOIN testing ON answer.answer_id = testing.answer_id
        WHERE attempt_id = 8)
    WHERE attempt_id = 8;

Query result:
+------------+------------+------------+--------------+--------+
| attempt_id | student_id | subject_id | date_attempt | result |
+------------+------------+------------+--------------+--------+
| 1          | 1          | 2          | 2020-03-23   | 67     |
| 2          | 3          | 1          | 2020-03-23   | 100    |
| 3          | 4          | 2          | 2020-03-26   | 0      |
| 4          | 1          | 1          | 2020-04-15   | 33     |
| 5          | 3          | 1          | 2020-04-15   | 67     |
| 6          | 4          | 2          | 2020-04-21   | 100    |
| 7          | 3          | 1          | 2020-05-17   | 33     |
| 8          | 1          | 2          | 2020-06-12   | 67     |
+------------+------------+------------+--------------+--------+

--4. Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из таблицы testing, которая создавалась следующим запросом:

CREATE TABLE testing (
    testing_id INT PRIMARY KEY AUTO_INCREMENT, 
    attempt_id INT, 
    question_id INT, 
    answer_id INT,
    FOREIGN KEY (attempt_id)  REFERENCES attempt (attempt_id) ON DELETE CASCADE
);

DELETE FROM attempt
WHERE date_attempt < '2020-05-01';
SELECT * FROM attempt

Query result:
+------------+------------+------------+--------------+--------+
| attempt_id | student_id | subject_id | date_attempt | result |
+------------+------------+------------+--------------+--------+
| 7          | 3          | 1          | 2020-05-17   | 33     |
| 8          | 1          | 2          | 2020-06-12   | 67     |
+------------+------------+------------+--------------+--------+