############################
##### EVALUACIÓN FINAL #####
####### MÓDULO 2. SQL ######
##ZARA VALENTINOVA PASHOVA##
############################

/* BASE DE DATOS SAKILA:
Para este ejercicio utilizaremos la bases de datos Sakila que hemos estado utilizando durante el repaso de
SQL. Es una base de datos de ejemplo que simula una tienda de alquiler de películas. Contiene tablas como
film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre
otras. Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan
para realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas. */

USE sakila;

-- EJERCICIO 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
	FROM film; -- Nota: no hay nombres de películas duplicados.

-- EJERCICIO 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
	FROM film
    WHERE rating="PG-13";

-- EJERCICIO 3:  Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, `description`
	FROM film
    WHERE `description` LIKE "%amazing%"; -- Nota: "%amazing%" significa cualquier cosa antes y después de amazing o nada, por lo que sería redundante incluir OR.

-- EJERCICIO 4: Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title
	FROM film
    WHERE length > 120;

-- EJERCICIO 5: Recupera los nombres de todos los actores.
SELECT first_name
	FROM actor;
    
-- EJERCICIO 6: Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE "%Gibson%";
    
-- Otra posibilidad:
SELECT first_name, last_name
	FROM actor
    WHERE last_name REGEXP "Gibson";

-- EJERCICIO 7: Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name, actor_id
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20; -- Nota: otra manera de hacerlo sería con WHERE actor_id>=10 AND actor_id<=20; Duda: El resultado muestra un registro con valor NULL (posiblemente debido a algún join anteriormente creado), no consigo excluir ese registro (he probado con "AND first_name IS NOT NULL" y otras condiciones similares).

-- EJERCICIO 8: Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title
	FROM film
    WHERE NOT rating="R" AND NOT rating="PG-13"; -- Nota: usamos AND dado que ambas condiciones se tienen que cumplir a la vez.
    
 -- Otra posibilidad: 
SELECT title
	FROM film
	WHERE rating <> "R" AND rating <> "PG-13";

-- EJERCICIO 9: Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.      
SELECT COUNT(title) AS Recuento, rating AS Clasificación
	FROM film
	GROUP BY Clasificación;    

-- EJERCICIO 10: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- Tablas: customer, rental, inventory, film
SELECT c.customer_id, c.first_name, c.last_name, COUNT(f.title) AS total_peliculas
	FROM customer AS c
	INNER JOIN rental AS r 
		ON c.customer_id = r.customer_id -- INNER JOIN porque queremos solo los clientes que han alquilado películas.
	INNER JOIN inventory AS i 
		ON r.inventory_id = i.inventory_id 
	INNER JOIN film AS f 
		ON i.film_id = f.film_id -- INNER JOIN porque queremos solo las películas que están en el inventario.
    GROUP BY c.customer_id;

-- EJERCICIO 11: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- Tablas: film, film_category, category, inventory, rental
SELECT COUNT(r.rental_id) AS total_alquileres, c.`name` AS categoria
	FROM film AS f
    INNER JOIN film_category AS f_c
    USING (film_id)
    INNER JOIN category AS c
    USING (category_id)
    INNER JOIN inventory AS i
    USING (film_id)
	INNER JOIN rental AS r
    USING (inventory_id)
	GROUP BY c.`name`; -- Nota: name no es palabra reservada, pero SQL la marca en azul. Para evitar confusiones, la hemos puesto entre comillas.

-- EJERCICIO 12: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT AVG(length) AS promedio_duracion, rating AS clasificacion
	FROM film
    GROUP BY rating;
    
-- EJERCICIO 13: Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- Tablas: film, film_actor, actor
SELECT a.first_name, a.last_name
	FROM actor AS a
	INNER JOIN film_actor AS f_a
	USING (actor_id)
	INNER JOIN film AS f
	USING (film_id)
	WHERE f.title="Indian Love";
    
-- EJERCICIO 14: Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title
	FROM film
    WHERE `description` LIKE "%dog%" OR `description` LIKE "%cat%";

-- EJERCICIO 15: Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
-- Tablas: actor, film_actor
SELECT a.first_name, a.last_name, f_a.film_id
	FROM actor AS a
    LEFT JOIN film_actor AS f_a -- aquí usamos LEFT JOIN para que, en caso de que hubiera actores que no aparecen en ninguna película de film_actor, pudieramos visualizar estos registros.
    USING (actor_id)
    WHERE f_a.film_id IS NULL;
    
-- EJERCICIO 16: Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010; -- Nota: otra manera de hacerlo sería con WHERE release_year>=2005 AND release_year<=2010; Tras hacer algunas comprobaciones (SELECT DISTINCT release_year FROM film), hemos visto que todas las peliculas se lanzaron en 2006, por lo que la query muestra todos los títulos de la tabla.

-- EJERCICIO 17: Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- Tablas: film, film_category, category
SELECT f.title
	FROM film AS f
    INNER JOIN film_category AS f_c
    USING (film_id)
    INNER JOIN category AS c
    USING (category_id)
    WHERE c.`name`="Family";
 
-- EJERCICIO 18: Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
-- Tablas: actor, film_actor, film
SELECT a.first_name, a.last_name
	FROM actor AS a
	INNER JOIN film_actor AS f_a
	USING (actor_id)
	INNER JOIN film AS f
	USING (film_id)
    GROUP BY a.actor_id
	HAVING COUNT(f.title)> 10;
    
-- EJERCICIO 19:  Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title, rating, length
	FROM film
    WHERE rating="R" AND length> 120;
    
-- EJERCICIO 20: Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- Tablas: film, film_category, category
 SELECT c.`name` AS categoria, AVG(f.length) AS promedio_duracion
	FROM film AS f
    INNER JOIN film_category AS f_c
    USING (film_id)
    INNER JOIN category AS c
    USING (category_id)
    GROUP BY c.`name`
    HAVING AVG(f.length)>120;

-- EJERCICIO 21: Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
-- Tablas: actor, film_actor, film
 SELECT a.first_name AS nombre_actor, COUNT(f.title) AS cantidad_peliculas
	FROM actor AS a
	INNER JOIN film_actor AS f_a
	USING (actor_id)
	INNER JOIN film AS f
	USING (film_id)
    GROUP BY nombre_actor
	HAVING COUNT(f.title)>=5;   
    
 -- EJERCICIO 22: Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
 -- Tablas: film, inventory, rental
WITH  TitleRental AS ( -- la creación de la CTE no tiene tanto sentido aquí porque hacemos uso de ella solo una vez. No obstante, si tuvieramos que usar este código varias veces, ahorraríamos tiempo.
 SELECT title, rental_id
	FROM film
    INNER JOIN inventory
    USING (film_id)
    INNER JOIN rental
    USING (inventory_id)) 
SELECT title
    FROM TitleRental 
    WHERE rental_id IN (SELECT rental_id
				FROM rental
				WHERE DATEDIFF(return_date, rental_date) > 5);
                
-- EJERCICIO 23: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.              
-- Tablas: actor, film_actor, film, film_category, category
 SELECT first_name, last_name
	FROM actor
    WHERE actor_id NOT IN (SELECT actor_id
									FROM actor
									JOIN film_actor 
                                    USING (actor_id)
									JOIN film_category 
                                    USING (film_id)
									JOIN category  AS c
                                    USING (category_id) 
									WHERE c.`name` = 'Horror');            

-- EJERCICIO 24: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
-- Tablas film, film_category, category
SELECT title
	FROM film AS f
    INNER JOIN film_category AS f_c
    USING (film_id)
    INNER JOIN category AS c
    USING (category_id)
	WHERE f.length>180 AND c.`name`="Comedy"; 
    
############################
##### EVALUACIÓN FINAL #####
####### MÓDULO 2. SQL ######
##ZARA VALENTINOVA PASHOVA##
############################
    
    
    
    
    
    
    
    
    
    
    