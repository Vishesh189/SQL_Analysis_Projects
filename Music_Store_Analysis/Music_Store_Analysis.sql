-- Question Set 1 - Easy

-- 1. Who is the senior most employee based on job title?

SELECT title, first_name||' '||last_name AS full_name FROM employee
ORDER BY levels DESC
LIMIT 1;

-- 2. Which countries have the most Invoices?

SELECT billing_country, COUNT(*) AS total_billing FROM invoice
GROUP BY billing_country
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 3. What are top 3 values of total invoice?

SELECT invoice_id, total FROM invoice
ORDER BY total DESC
LIMIT 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music 
-- Festival in the city we made the most money. Write a query that returns one city that 
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice 
-- totals

SELECT billing_city, SUM(total)AS total_invoice FROM invoice
GROUP BY billing_city
ORDER BY total_invoice DESC
LIMIT 1;

-- 5. Who is the best customer? The customer who has spent the most money will be 
-- declared the best customer. Write a query that returns the person who has spent the 
-- most money

SELECT c.first_name||' '||c.last_name AS full_name, sum(i.total) from customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id
GROUP BY c.customer_id 
ORDER BY SUM(i.total) DESC
LIMIT 1;


-- Question Set 2 – Moderate

-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music 
-- listeners. Return your list ordered alphabetically by email starting with A

SELECT DISTINCT c.first_name, c.last_name,  c.email FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id
JOIN invoice_line AS iline ON i.invoice_id = iline.invoice_id
WHERE track_id IN(SELECT track_id FROM track
				   JOIN genre ON track.genre_id = genre.genre_id
			       WHERE genre.name LIKE 'Rock')
ORDER BY c.email;

-- 2. Let's invite the artists who have written the most rock music in our dataset. Write a 
-- query that returns the Artist name and total track count of the top 10 rock bands

SELECT DISTINCT a.artist_id, a.name, COUNT(*) AS total_songs FROM track AS t

JOIN album AS ab ON ab.album_id = t.album_id
JOIN artist AS a ON a.artist_id = ab.artist_id
JOIN genre AS g ON g.genre_id = t.genre_id
WHERE g.name LIKE 'Rock'
GROUP BY a.artist_id 
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first

SELECT name, milliseconds FROM track
WHERE milliseconds > (SELECT  AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;


-- Question Set 3 – Advance

-- 1. Find how much amount spent by each customer on artists? Write a query to return
-- customer name, artist name and total spent

WITH best_selling_artist AS(
	SELECT ar.artist_id, ar.name, SUM(iline.unit_price * iline.quantity) AS total_sales
	FROM invoice_line iline

	JOIN track t ON t.track_id = iline.track_id
	JOIN album al ON al.album_id = t.album_id
	JOIN artist ar ON ar.artist_id = al.artist_id
	GROUP BY 1 
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT  c.first_name, c.last_name, bsa.name, SUM(iline.unit_price * iline.quantity) FROM customer AS c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line iline ON i.invoice_id = iline.invoice_id
JOIN track t ON t.track_id = iline.track_id
JOIN album al ON al.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = al.artist_id
GROUP BY 1, 2, 3 
ORDER BY 4 DESC;

-- 2. We want to find out the most popular music Genre for each country. We determine the 
-- most popular genre as the genre with the highest amount of purchases. Write a query 
-- that returns each country along with the top Genre. For countries where the maximum 
-- number of purchases is shared return all Genres

WITH popular_genre AS (
	SELECT COUNT(iline.quantity) AS purchases, c.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(iline.quantity) DESC) AS row_no
	FROM customer c
	
	JOIN invoice i ON c.customer_id = i.customer_id
	JOIN invoice_line  iline ON i.invoice_id = iline.invoice_id
	JOIN track t ON t.track_id = iline.track_id
	JOIN genre ON genre.genre_id = t.genre_id
	GROUP BY 2, 3, 4
)
SELECT * FROM popular_genre 
WHERE row_no = 1;

-- 3. Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all 
-- customers who spent this amount

WITH top_customer AS( 
	SELECT c.first_name, c.last_name, c.country, SUM(i.total),
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY SUM(i.total) DESC)
	FROM customer c
	JOIN invoice i ON c.customer_id = i.customer_id
	GROUP BY 1, 2, 3
)
SELECT * FROM top_customer
WHERE row_number = 1;