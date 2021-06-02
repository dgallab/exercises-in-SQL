-- Daniel Gallab
-- hw6
-- use an already defined database
-- and create a query to be able to answer
-- each question regarding the database


use cpsc321_DB;

-- q1
-- finds the total number of films by category ordered from most to least.
-- Give the name of each category.

-- we do a complex join to join film and film category by id, then again to join category
-- using category_id
SELECT COUNT(*), category_id, category.name
FROM film JOIN film_category USING (film_id) JOIN category USING (category_id)
GROUP BY category_id
ORDER BY COUNT(*) DESC
LIMIT 5;

-- q2
-- finds the number of films acted in by each actor ordered from highest number of films to
-- lowest. For each actor, give their first and last name.

-- only one join is necessary
SELECT COUNT(*), first_name, last_name
FROM film_actor JOIN actor USING (actor_id)
GROUP BY actor_id
ORDER BY COUNT(*) DESC
LIMIT 5;

-- q3
-- For each ‘G’ rated film, finds the number of times it has been rented.
-- The result should be sorted from most rented to least rented.

-- We need a find a way to join the film with a table that can give us rows
-- each indicating instances a film was rented. Three tables are necessary.
-- We know that for every inventory_id instance, there is a rental id associated with it
-- and since every rental has a different id, and since we know the different inventory ids
-- correspond with a specific movie (because that is what we joined it on), the number of rental
-- ids we count will be the number of rentals for that movie. And to get all of the rental ids,
-- we must find all the inventory ids associated with each movie
SELECT COUNT(*) AS number_of_rents, film.title
FROM film JOIN inventory USING (film_id) JOIN rental USING (inventory_id)
WHERE film.rating = 'G'
GROUP BY film.film_id
ORDER BY COUNT(*) DESC
LIMIT 5;


-- q4
-- finds the first and last names of customers that have rented at least ten ‘G’ rated films.
-- (a customer who rented the same G rated film 10 times would show up)

-- We need to do 3 joins in order to join the film information with a time a customer rented it
-- Notice how the only way to do this (as in similar examples) is to do a join on inventory_id
SELECT rental.customer_id, customer.first_name, customer.last_name
FROM film JOIN inventory USING (film_id) JOIN rental USING (inventory_id) JOIN customer USING (customer_id)
WHERE film.rating = 'G'
GROUP BY customer_id
HAVING COUNT(rental.rental_id)>9
LIMIT 5;

-- q5
-- finds the total sales (of payments) for each film category. Give the name of each category.

-- to find the payment amount for each film category, we need to group films based on category
-- and for each film in a category, we look up its inventory ids, then the corresponding rental ids,
-- then the corresponding payments
SELECT SUM(payment.amount), category.name
FROM film_category JOIN film USING (film_id) JOIN category USING (category_id) JOIN inventory USING (film_id)
JOIN rental USING (inventory_id) JOIN payment USING (rental_id)
GROUP BY category_id
LIMIT 5;

-- q6
-- finds the film (or films if there is a tie) that have been rented the most number of times.
-- You cannot use limit and your query must return only the film(s) rented the most number of
-- times (not the second, third, etc). Return the film id and title.

-- similar structure as example in class. We use the structure of the first
-- query as the nested query, but by using the ALL keyword with >= allows us
-- to retrieve the film with the most rentals
SELECT film.film_id, film.title
FROM film JOIN inventory USING (film_id) JOIN rental USING (inventory_id)
GROUP BY film_id
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
FROM film JOIN inventory USING (film_id) JOIN rental USING (inventory_id)
GROUP BY film_id);
-- q7
-- finds the store (or stores) that have the most rentals. You cannot use limit and your query
-- must return only the store(s) that have the most rentals (not the second most, third most,
-- etc). Return the store id.

-- very similar to q6, and we instead look at all the rentals within each store
SELECT store.store_id
FROM customer JOIN store USING (store_id) JOIN rental USING (customer_id)
GROUP BY store.store_id
HAVING COUNT(*)>= ALL (SELECT COUNT(*)
FROM customer JOIN store USING (store_id) JOIN rental USING (customer_id)
GROUP BY store.store_id);

-- q8
-- finds the title of the most rented ‘G rated film(s).

-- note the similarity between q6 and q7
SELECT film.title
FROM film JOIN inventory USING (film_id) JOIN rental USING (inventory_id)
WHERE film.rating = 'G'
GROUP BY film.film_id
HAVING COUNT(*)>= ALL (SELECT COUNT(*)
FROM film JOIN inventory USING (film_id) JOIN rental USING (inventory_id)
WHERE film.rating = 'G'
GROUP BY film.film_id);

-- q9
-- finds the total sales (of payments) for each store ordered from highest to lowest total sales.

-- compare with q5. Instead of grouping by film category, we are grouping by store
-- and to retrieve all of the sales, we find all the customers associated with the store,
-- then find all their rentals to which we join with payment
SELECT SUM(payment.amount)
FROM customer JOIN rental USING (customer_id) JOIN payment USING (rental_id)
GROUP BY customer.store_id
ORDER BY SUM(payment.amount) DESC;

-- q10
-- For each staff member, find the movies and the total number of times that they were rented to
-- customers by the staff member. Return the first and last name of each staff member, the title
-- of the movie, and the number of times the movie was rented by the staff member. The results
-- should be ordered by staff member last name followed by first name. For each staff member,
-- the movies that they have rented should be ordered from most rented to least rented.

-- We want to group by 2 things this time. We do not want to know how many times a staff member
-- rented a movie to a customer, but how many times per movie
-- ORDER BY clause operates by order. First we order by staff name, then we order by rental frequency
SELECT staff.last_name, staff.first_name, film.title, COUNT(rental.rental_id)
FROM film JOIN inventory USING (film_id) JOIN rental USING (inventory_id) JOIN staff USING(staff_id)
GROUP BY staff.staff_id, film.film_id
ORDER BY staff.last_name, staff.first_name, COUNT(rental.rental_id) DESC
LIMIT 5;

