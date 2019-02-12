USE sakila;

# 1a. Display the first and last names of all actors from the table `actor`

SELECT 
	first_name, last_name
FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT
	  UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT
	actor_id, first_name, last_name
FROM actor AS a
WHERE a.first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters `GEN`:

SELECT * FROM actor WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

SELECT *
FROM actor WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a.

ALTER TABLE actor
ADD description BLOB(50);
SELECT *
FROM actor;

# 3b.

ALTER TABLE actor
DROP description
;
SELECT * FROM actor
;

# 4a.

SELECT
	last_name, COUNT(last_name)
FROM actor
GROUP BY last_name ;

# 4b.

SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2;

# 4c. 

SELECT *
FROM actor;
UPDATE actor 
SET first_name = 'HARPO'
WHERE actor_id = 172
;
# 4d. 
SELECT *
FROM actor;
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

SELECT * from actor WHERE actor_id = 172;

# 5a.
	SHOW CREATE TABLE address;

#6a.

SELECT 
	s.first_name, s.last_name, a.address
FROM address AS a
JOIN staff AS s ON
	a.address_id = s.address_id
;
# 6b

SELECT
	first_name, 
	last_name ,
	SUM(amount) AS 'Total Rung Up Aug 2005'
FROM payment AS p
JOIN staff AS s ON
	p.staff_id = s.staff_id
WHERE p.payment_date LIKE '%2005-08%'
GROUP BY first_name, last_name

;

# 6c 

SELECT
	f.title,
    COUNT(fa.actor_id) AS 'ActorsCount'
FROM film_actor AS fa
INNER JOIN film AS f USING (film_id)
GROUP BY f.title
ORDER BY ActorsCount DESC;

# 6d
SELECT
	store_id,
    COUNT(store_id) AS "HICopies"
FROM inventory
WHERE film_id = (SELECT film_ID FROM film WHERE title = 'Hunchback Impossible')
GROUP BY store_id;

# 6e

SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(amount) AS 'TotPaid'
FROM payment AS p
INNER JOIN customer c ON
	p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY last_name ASC;


# 7a

SELECT * FROM language;
SELECT title FROM film WHERE language_id = 1 AND (title LIKE 'K%' OR title LIKE 'Q%');

# 7b/7c UNSURE

# 7d
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category 
	WHERE category_id IN (
		Select category_id FROM category WHERE name = 'Family'));
        
# 7e

SELECT title, COUNT(film_id) AS freq_rented
FROM inventory AS i
INNER JOIN film AS f
	USING(film_id)
GROUP BY title, film_id
ORDER BY freq_rented DESC

;
# 7f

SELECT staff_id , SUM(amount)
FROM payment
GROUP BY staff_id;

# 7g
SELECT store_id, address, city, country
FROM country AS c
JOIN(
	SELECT store_id, address, city, country_id
    FROM city AS cy
    INNER JOIN(
		SELECT store_id, city_id, address_id, address
        FROM store AS s
        INNER JOIN address USING
			(address_id)) AS id1 USING (city_id)) AS id2 USING(country_id);
            
# 7h

SELECT SUm(amount) AS totsalescat, name
FROM
	(SELECT
		inventory_id, film_id, category_id, name
	FROM inventory AS i
	JOIN (
		SELECT category_id, film_id, name
		FROM film_category AS fc
		INNER JOIN category as c USING (category_id)) AS d USING(film_id)
		)AS g
        
INNER JOIN (
	SELECT rental_id, amount, inventory_id
    FROM payment 
    INNER JOIN rental AS r
	USING(rental_id)) AS ri USING (inventory_id)

GROUP BY name
ORDER BY totsalescat DESC
;
    
CREATE VIEW cat_film_id AS
	SELECT inventory_id, film_id, category_id, name
    FROM inventory AS i
    INNER JOIN(
		SELECT category_id, film_id, name
        FROM film_category AS fc
        INNER JOIN category AS C
			USING(category_id)) AS ci USING(film_id);
            
            
CREATE VIEW inv_id_amt AS
	SELECT rental_id , amount, inventory_id
    FROM payment
    INNER JOIN rental USING (rental_id);
    
CREATE VIEW top_sales_by_category AS
	SELECT SUM(amount) AS total_sales_category, name
    FROM inv_id_amount
    INNER JOIN cat_film_id USING (inventory_id)
    GROUP BY name
    ORDER BY total_sales_category DESC
    
#8b

SELECT * FROM top_sales_by_category;

#8c 
DROP View top_sales_by_category;