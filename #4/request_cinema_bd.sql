-- Мои функциональные запросы --
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

    