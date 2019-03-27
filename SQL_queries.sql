USE sakila;

-- Display first and last names from actor table
SELECT first_name, last_name FROM actor;

-- Display the first and last name of each actor in uppercase in a new column
SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name FROM actor;

-- find the ID number, first name, and last name of an actor, for "Joe."
SELECT first_name, last_name
FROM actor
WHERE first_name LIKE "Joe%";

-- Find all actors whose last name contain the letters GEN
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%GEN%";

-- Find all actors whose last names contain the letters LI
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE "%LI%";

-- display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan" , "Bangladesh" , "China");

-- add column 'description' as blob datatype
ALTER TABLE actor
ADD Description BLOB;

-- delete 'description' column
ALTER TABLE actor
DROP Description;

--  List the last names of actors, as well as how many actors have that last name
SELECT last_name, COUNT(last_name) 
FROM actor
GROUP BY last_name;

-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT last_name, COUNT(last_name) 
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) <=2;

--  The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Fix the record.
SELECT first_name, last_name, actor_id FROM actor
WHERE first_name= "GROUCHO" AND last_name= "Williams";

DELETE FROM actor 
WHERE actor_id=172;

INSERT INTO actor (first_name, last_name)
VALUES ("HARPO", "WILLIAMS");

-- Change Harpo back to Groucho
SELECT first_name, last_name, actor_id FROM actor
WHERE first_name= "Harpo" AND last_name= "Williams";

DELETE FROM actor 
WHERE actor_id=201;
    
INSERT INTO actor (first_name, last_name)
VALUES ("GROUCHO", "WILLIAMS");

-- query the schema for the address table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='address';

-- join staff and address tbales
SELECT staff.first_name, staff.last_name, staff.address_id, address.address
FROM staff
INNER JOIN address ON
address.address_id=staff.address_id;

-- find total amount rung up by staff in August 2005
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount), payment.payment_date
FROM staff
INNER JOIN payment ON
staff.staff_id=payment.staff_id
WHERE payment.payment_date LIKE "2005-08%"
GROUP BY staff.staff_id;

-- find the number of actors in each film
SELECT film.title, film.film_id, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON
film.film_id=film_actor.film_id
GROUP BY film.title;

-- How many copies of 'Hunchback Impossible' are in inventory
SELECT title, film_id FROM film WHERE title="Hunchback Impossible";

SELECT COUNT(film_id) FROM inventory WHERE film_id=439;

-- Find the total paid by each customer
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM customer
INNER JOIN payment ON
customer.customer_id=payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name ASC;

-- find films that start with k and q in english
SELECT name="English"
FROM language
WHERE language_id IN
(
 SELECT language_id
 FROM film
 WHERE title IN
  (
   SELECT title 
   FROM film
   WHERE title like ("K%", "Q%")
   )
);

-- display all the actors in 'Alone Trip'
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN
(
 SELECT actor_id 
 FROM film_actor
 WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title= "Alone Trip"
   )
);

-- get names and email addresses for Canadian customers 20
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address ON
address.address_id=customer.address_id
WHERE city_id IN
(
 SELECT city_id
 FROM address
 WHERE city_id IN
  (
  SELECT city_id 
  FROM city
  WHERE country_id IN
   (
   SELECT country_id 
   FROM city
   WHERE country_id IN
    (
    SELECT country_id 
    FROM country
    WHERE country_id=20
    )
   ) 
  )
 ); 
 
 -- Identify all family movies
SELECT title 
FROM film
WHERE film_id IN
 (
 SELECT film_id 
 FROM film
 WHERE film_id IN
  (
	SELECT film_id
    FROM film_category
    WHERE category_id IN
     (
      SELECT category_id
      FROM film_category
      WHERE category_id IN
       (
       SELECT category_id 
       FROM category
       WHERE name="Family"
       )
      )
     )
    ); 

-- How much business in dollars did each store bring in
SELECT SUM(amount)
FROM payment p
INNER JOIN rental r
ON (r.rental_id=p.rental_id)
INNER JOIN inventory i
ON (i.inventory_id= r.inventory_id)
INNER JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

SELECT SUM(amount)
FROM payment p,
rental r,
inventory i,
store s
where 
r.rental_id=p.rental_id and
i.inventory_id= r.inventory_id and
s.store_id = i.store_id
GROUP BY s.store_id;





 