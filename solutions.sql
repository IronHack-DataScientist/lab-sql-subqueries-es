-- Respuesta 1
SELECT COUNT(*) AS num_copies
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = 'El Jorobado Imposible';

-- Respuesta 2
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Respuesta 3
SELECT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Viaje Solo';

-- Respuesta 4
SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- Respuesta 5
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
WHERE customer.address_id IN (
    SELECT address.address_id
    FROM address
    WHERE address.city_id IN (
        SELECT city.city_id
        FROM city
        WHERE city.country_id = (
            SELECT country.country_id
            FROM country
            WHERE country.country = 'Canada'
        )
    )
);

--Respuesta 5 con Joins
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- Respuesta 6
SELECT film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT actor_id
    FROM (
        SELECT actor_id, COUNT(*) AS num_movies
        FROM film_actor
        GROUP BY actor_id
        ORDER BY num_movies DESC
        LIMIT 1
    ) AS most_prolific
);

-- Respuesta 7
SELECT film.title
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- Respuesta 8
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
    SELECT AVG(total_amount)
    FROM (SELECT SUM(amount) AS total_amount FROM payment GROUP BY customer_id) AS customer_totals
);