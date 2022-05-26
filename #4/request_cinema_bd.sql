-- МОИ ФУНКЦИОНАЛЬНЫЕ ЗАПРОСЫ --
-- #1 Вывести список всех фильмов, показываемых в кинотеатре --
SELECT m.`name` AS films
FROM cinemas c
INNER JOIN cinema_halls ch
ON c.id = ch.cinema_id
INNER JOIN sessions s
ON ch.id = s.cinema_hall_id
INNER JOIN movies m
ON m.id = s.movie_id
WHERE c.`name` = "Cinema 5";

-- #2 Вывести список всех сеансов за опредлённую дату (не позже текущей) --
SELECT m.`name` AS film,
		s.duration AS duration, 
		s.ticket_price AS price, 
		s.session_date_time AS date_time
FROM movies m
INNER JOIN sessions s 
ON s.movie_id = m.id
WHERE s.session_date_time = "2022-04-08 10:30:00";

-- #3 Вывести список продуктов в кинотеатре и их остаток --
SELECT p.`name`, p.price, ptc.`number`, c.`name`
FROM products p
INNER JOIN product_to_cinema ptc
ON p.id = ptc.product_id
INNER JOIN cinemas c
ON c.id = ptc.cinema_id
WHERE c.`name` = "5 stars";

-- #4 Вывести список всех кинозалов в кинотеатре --
SELECT c.`name`, ch.`number`, ch.number_raws, ch.number_seats
FROM cinemas c
INNER JOIN cinema_halls ch
ON c.id = ch.cinema_id
WHERE c.`name` = "IMAX";

-- #5 Вывести список всего персонала кинотеатра --
SELECT c.`name` AS cinema, s.full_name, pos.`name` AS positions
FROM staffs s
INNER JOIN cinemas c
ON c.id = s.cinema_id
INNER JOIN positions pos
ON s.position_id = pos.id
WHERE c.`name` = '"Moscow"';

-- #6 Рассчитать прибыль от одного показа --
SELECT movies.`name`, SUM(ticket_price) AS `Доход с показа`
FROM sessions
INNER JOIN spectator_to_session
ON spectator_to_session.session_id = sessions.id
INNER JOIN spectators
ON spectator_to_session.spectator_id = spectators.id
INNER JOIN movies
ON movies.id = sessions.movie_id
GROUP BY duration;

/* Для одного кинотеатра
SELECT SUM(ticket_price) AS `Доход с показа`
FROM sessions
INNER JOIN spectator_to_session
ON spectator_to_session.session_id = sessions.id
INNER JOIN spectators
ON spectator_to_session.spectator_id = spectators.id
INNER JOIN movies
ON movies.id = sessions.movie_id
WHERE sessions.id = 1;
*/

-- #7 Рассчитать кол-во занятых мест --
SELECT COUNT(ticket_price) AS `Количество занятых мест`
FROM sessions
INNER JOIN spectator_to_session
ON spectator_to_session.session_id = sessions.id
INNER JOIN spectators
ON spectator_to_session.spectator_id = spectators.id
WHERE sessions.id = 1;

-- #8 Рассчитать прибыль буфета за день --
SELECT SUM(ptc.`number`*p.price) AS 'Доход буфета за день'
FROM cinemas c
INNER JOIN product_to_cinema ptc
ON ptc.cinema_id = c.id
INNER JOIN products p
ON p.id = ptc.product_id
WHERE c.id = 1;

-- #9 Вычислить максимально возможную прибыль всех сеансов за один день --
WITH tmp (col1, col2) AS
(
	SELECT sessions.session_date_time, SUM(ticket_price) AS 'Максимальный доход за день с показа'
	FROM sessions
	INNER JOIN spectator_to_session
	ON sessions.id = spectator_to_session.session_id
	INNER JOIN spectators
	ON spectators.id = spectator_to_session.spectator_id
	GROUP BY sessions.session_date_time
)
SELECT MAX(col2) FROM tmp;

-- #10 Вычислить максимальное кол-во человек за день на всех сеансах --
WITH cet (col1, col2) AS 
(
	SELECT ses.session_date_time, COUNT(ses.id)
	FROM sessions ses
	INNER JOIN spectator_to_session sts
	ON sts.session_id = ses.id
	INNER JOIN spectators spe
	ON spe.id = sts.spectator_id
	GROUP BY ses.session_date_time
)
SELECT MAX(col2) AS `Максимальное количество людей на показе` FROM cet;

/* Выводит все дни 
SELECT ses.session_date_time, COUNT(ses.id)
FROM sessions ses
INNER JOIN spectator_to_session sts
ON sts.session_id = ses.id
INNER JOIN spectators spe
ON spe.id = sts.spectator_id
GROUP BY ses.session_date_time;
*/

-- #11 Вычислить кол-во человек за день --
SELECT COUNT(ses.id) AS `Кол-во людей за день` 
FROM sessions ses
INNER JOIN spectator_to_session sts
ON ses.id = sts.session_id
INNER JOIN spectators spc
ON spc.id = sts.spectator_id
WHERE ses.session_date_time = '2022-04-08 10:30:00';

-- ЗАПРОСЫ UPDATE --
-- #12 ОБновим названия фильма, в которых букву "o" заменим на "A" -- 
UPDATE movies
	SET `name` = REPLACE(`name`, 'o', 'A')
    -- SET `name` = REPLACE(`name`, 'A', 'o')
	WHERE id = 4;
-- SET SQL_SAFE_UPDATES = 1; -- Для того чтобы убрать опцию безопасного обновления (0 - выкл., 1 - вкл)

-- #13 Исправить дату на другую --
UPDATE sessions
	SET session_date_time = '2022-04-08 10:30:00'
    WHERE session_date_time = '2022-08-04 12:12:12';
-- SET SQL_SAFE_UPDATES = 1; 

-- #14 Исправить возрсатное ограничение в фильмах, в которых есть сочетание букв "Th" --
UPDATE movies
	SET age_restriction = 1000
    WHERE `name` LIKE "Th%";
-- SET SQL_SAFE_UPDATES = 1; 

-- #15 Увеличить в два раза длительность фильма, если стоимость билета больше 200 рублей --
UPDATE sessions
	SET duration = duration * 2
    -- SET duration = duration / 2
    WHERE ticket_price > 200; 
-- SET SQL_SAFE_UPDATES = 1; 

-- #16 Изменить название фильма на "Unknow" если он называется "Dog" --
UPDATE movies
	SET `name` = "Unknow"
    WHERE `name` = "Dog";
-- SET SQL_SAFE_UPDATES = 1; 

-- ЗАПРОСЫ DELETE --
-- Создадим 5 некоректных данных --
INSERT INTO cinemas (adress, `name`) -- cinema
VALUES ('TEST', 'TEST');

INSERT INTO positions (`name`) -- positions
VALUE ('TEST');

INSERT INTO sessions (duration, ticket_price, session_date_time, cinema_hall_id, movie_id) -- sessions
VALUES (0, 0, '2012-12-12 12:12:12', 1, 1);
 
INSERT INTO products (`name`, price) -- product 
VALUES ('TEST', 0);

INSERT INTO spectators (full_name, gender, age) -- spectators
VALUES ('TEST', 'test', 0);

-- #17 Удаляем кинотеатр с инменем "TEST" --
DELETE FROM cinemas 
WHERE `name` = "TEST";
-- SET SQL_SAFE_UPDATES = 0; 

-- #18 Удаляем должность с инменем "TEST" --
DELETE FROM positions 
WHERE `name` = "TEST";
-- SET SQL_SAFE_UPDATES = 0; 

-- #19 Удаляем сессию с длительностью 0 --
DELETE FROM sessions 
WHERE duration = 0;
-- SET SQL_SAFE_UPDATES = 0; 

-- #20 Удаляем продукт с инменем "TEST" --
DELETE FROM products 
WHERE `name` = "TEST";
-- SET SQL_SAFE_UPDATES = 0; 

-- #21 Удаляем зрителя с инменем "TEST" --
DELETE FROM spectators 
WHERE full_name = "TEST";
-- SET SQL_SAFE_UPDATES = 1; 

-- ЗАПРОСЫ С SELECT И ДРУГИМИ КОНСТРУКЦИЯМИ --
-- #22 Найти все фильмы, которые выпускались в 2021 году или в 2020 --
SELECT `name`, production_year
FROM movies
WHERE production_year IN(2020, 2021);

-- #23 Найти все фильмы, в которых содержиться конструкция 'The' или 'ed' --
SELECT *
FROM movies
WHERE `name` LIKE 'The%'
OR `name` LIKE '%ed%';

-- #24 Вывести сессии без повторений по дате --
SELECT DISTINCT session_date_time 
FROM sessions
ORDER BY session_date_time;

-- #25 Найти кинотеатр, которые находятся в Москве --
SELECT `name`
FROM cinemas
WHERE adress LIKE '%Moscow%';

-- #26 Найти продукты, которые не стоят 230 рублей и стоят больше 100 --
SELECT `name`, price
FROM products
WHERE price <> 230
AND price > 100;

-- #27 Показать зрителей, старше 13 лет --
SELECT full_name, age
FROM spectators
WHERE age > 13;

-- #28 Показать фильмы, с взрастным ограничением от 16 до 18 лет --
SELECT `name`, age_restriction
FROM movies
WHERE age_restriction BETWEEN 16 AND 18;

-- #29 Вывести всех мужчин зрителей --
SELECT full_name
FROM spectators
WHERE gender = "male";

-- #30 Вывести всех женьщин зрителей --
SELECT full_name
FROM spectators
WHERE gender = "female";

-- #31 Вывести кинозалы, у которых есть либо 10 мест, либо 12 в ряду --
SELECT `number`, number_raws, number_seats
FROM cinema_halls
WHERE number_seats/number_raws IN(10, 12);

-- #32  Вывести фильмы с длительностью больше 6000 сек или меньше 8000 сек --
SELECT ticket_price, duration
FROM sessions
WHERE duration BETWEEN 6000 AND 8000;

-- #33 Вывести фильмы определённой студии --
SELECT `name`, name_studio
FROM movies
WHERE name_studio = "Netlix";

-- #34 Вывести список сессий, которые стоят больше 400 рублей --
SELECT ticket_price
FROM sessions
WHERE ticket_price > 400;

-- #35 Вывести фильмы с определённой датой релиза --
SELECT `name`, release_date
FROM movies
WHERE release_date = "2022-04-08";

-- #36 Вывести кинозалы, которые имеют четные номера
SELECT `number`
FROM cinema_halls
WHERE MOD(`number`, 2) = 0;
