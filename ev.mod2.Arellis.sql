USE sakila

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT *
FROM film;

		-- Si queremos ver los nombres solo una vez (sin repetición) Usamos DISTINCT para que nos devuelva valores unicos.

SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"

SELECT*
FROM film

SELECT title, rating
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM film
WHERE description LIKE '%amazing%'

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT*
FROM film

SELECT title, length
FROM film
WHERE length > 120;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.


SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor
WHERE last_name LIKE '%Gibson%'

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".

SELECT title AS titulo_de_pelicula, rating AS clasificacion
FROM film
WHERE rating NOT IN('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT*
FROM film

SELECT rating, COUNT(film_id) AS total_peliculas
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
-- nombre y apellido junto con la cantidad de películas alquiladas.

SELECT*
FROM rental;
SELECT*
FROM customer;

SELECT r.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquiladas
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id 
GROUP BY r.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la
-- categoría junto con el recuento de alquileres.

SELECT*
FROM rental;
SELECT*
FROM inventory;
SELECT*
FROM film_category;
SELECT*
FROM category;

SELECT c.name, COUNT(r.rental_id) AS cantidad
FROM rental r
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
INNER JOIN film_category fc
ON i.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
-- muestra la clasificación junto con el promedio de duración.

SELECT*
FROM film;

SELECT rating, AVG(length) AS duracion_promedia
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT*
FROM actor;
SELECT*
FROM film_actor;
SELECT*
FROM film;

SELECT a.first_name, a.last_name, f.title
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title, description
FROM film
WHERE description LIKE '%dog%' OR '%cat%'   -- usamos like para especificar la busqueda en la que dog o cat puedan tener palabras por delante o detras

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
-- A-

SELECT*
FROM actor;
SELECT*
FROM film_actor;

SELECT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL 

-- B- 

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
WHERE a.actor_id NOT IN (                                    -- SEGUNDA OPCION. PREGUNTAR¿?
	SELECT fa.actor_id
	FROM film_actor fa
);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

USE sakila

SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT*
FROM film;
SELECT*
FROM film_category;
SELECT*
FROM category;

SELECT f.title, c.name
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'family'

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT *
FROM actor;
SELECT *
FROM film_actor;

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT*
FROM film

SELECT title, rating, length
FROM film
WHERE rating = 'R' AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
-- minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT * 
FROM category;
SELECT * 
FROM film_category;
SELECT *
FROM  film;

SELECT c.name, AVG(f.length) AS duracion_media
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor
-- junto con la cantidad de películas en las que han actuado.

SELECT* 
FROM actor;
SELECT*
FROM film_actor;

SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) >= 5

-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una
-- subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
-- las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una
-- fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)

SELECT * 
FROM film;
SELECT * 
FROM inventory;
SELECT * 
FROM rental;

-- DATEDIFF: segun chat GPT, calcula la diferencia entre dos fechas. Nos ayuda a saber cuantos días han pasado entre ambas fechas
-- primero quiero saber cuales fueron alquiladas mas de 5 dias y con la pista nos ayudaremos! 
-- OPCION A

SELECT DISTINCT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM inventory
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM rental
        WHERE DATEDIFF(return_date, rental_date) > 5
    )
);

-- OPCION B

SELECT f.title AS peliculas_alquiladas
FROM film f
WHERE f.film_id IN (
	SELECT i.film_id
    FROM rental r 
    INNER JOIN inventory i
    ON i.inventory_id = r.inventory_id
    WHERE DATEDIFF(r.return_date, r.rental_date) > 5
);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT * 
FROM actor;
SELECT * 
FROM film_actor;
SELECT *
FROM film_category;
SELECT * 
FROM category;

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN(
	SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc
    ON fa.film_id = fc.film_id
    INNER JOIN category c
    ON  fc.category_id = c.category_id
    WHERE c.name = 'horror'
    ); 
    
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180
-- minutos en la tabla film con subconsultas.

SELECT * 
FROM film;
SELECT *
FROM film_category;
SELECT * 
FROM category;

SELECT f.title AS pelicula, f.length AS duracion
FROM film f
WHERE f.film_id IN (
	SELECT fc.film_id
    FROM film_category fc
    INNER JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name = 'comedy' AND f.length > 180
    );