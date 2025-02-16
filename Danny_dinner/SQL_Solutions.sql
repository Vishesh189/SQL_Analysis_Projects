/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

--Answer 1
SELECT sales.customer_id, SUM(menu.price) AS total
FROM sales
JOIN menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY total DESC;


--Answer 2
SELECT customer_id, COUNT(DISTINCT(order_date))AS visiting_days
FROM sales
GROUP BY customer_id
ORDER BY visiting_days DESC;


--Answer 3
WITH row_no AS(
    select sales.customer_id, sales.order_date, menu.product_name,
	ROW_NUMBER() OVER(
	    PARTITION BY sales.customer_id 
		ORDER BY sales.order_date, sales.product_id) 
	  AS ROW_num
    FROM sales
	join menu on sales.product_id = menu.product_id)
SELECT customer_id, product_name AS first_order
FROM row_no
where row_num = 1;


--Answer 4
SELECT menu.product_id, menu.product_name, COUNT(sales.product_id) total_purchase
FROM sales
JOIN menu ON sales.product_id = menu.product_id 
GROUP BY menu.product_id,menu.product_name
ORDER BY total_purchase DESC
LIMIT 1;


--Answer 5
WITH row_count AS (SELECT sales.customer_id, menu.product_name, count(sales.product_id) AS order_count,
    ROW_NUMBER() OVER(
	    PARTITION BY sales.customer_id 
		ORDER BY count(sales.product_id) DESC) 
	 AS row_num
    FROM sales 
    JOIN menu ON sales.product_id = menu.product_id
	GROUP BY sales.customer_id, menu.product_id, menu.product_name)
SELECT customer_id, product_name, order_count
FROM row_count
WHERE row_num = 1 
ORDER BY customer_id, order_count DESC;


--Answer 6
WITH row_count AS ( SELECT sales.customer_id, members.join_date, sales.order_date,sales.product_id,
    ROW_NUMBER() OVER(
	    PARTITION BY sales.customer_id 
		ORDER BY sales.order_date ASC) 
	AS row_num
   FROM sales
   JOIN members ON sales.customer_id = members.customer_id
   WHERE order_date >= join_date )
SELECT row_count.customer_id, row_count.join_date, row_count.order_date, menu.product_name, row_num
FROM row_count
JOIN menu ON row_count.product_id = menu.product_id
AND ROW_NUM = 1
ORDER BY customer_id, order_date ASC;


--Answer 6 type 2
SELECT sales.customer_id, members.join_date, sales.order_date, menu.product_name
FROM sales
JOIN members ON sales.customer_id = members.customer_id
JOIN menu ON sales.product_id = menu.product_id
WHERE sales.order_date = (
    SELECT MIN(order_date)
    FROM sales AS s2
    WHERE s2.customer_id = sales.customer_id
      AND s2.order_date >= members.join_date
)
ORDER BY sales.customer_id;


--Answer 7
SELECT sales.customer_id, members.join_date, sales.order_date, menu.product_name
FROM sales
JOIN members ON sales.customer_id = members.customer_id
JOIN menu ON sales.product_id = menu.product_id
WHERE 
sales.order_date = (
    SELECT MAX(order_date)
    FROM sales AS s2
    WHERE s2.customer_id = sales.customer_id
      AND s2.order_date < members.join_date
)
ORDER BY sales.customer_id;


--Answer 7 type 2
WITH row_count AS ( SELECT sales.customer_id, members.join_date, sales.order_date,sales.product_id,
    ROW_NUMBER() OVER(
	    PARTITION BY sales.customer_id 
		ORDER BY sales.order_date DESC) 
	AS row_num
   FROM sales
   JOIN members ON sales.customer_id = members.customer_id
   WHERE order_date < join_date )
SELECT row_count.customer_id, row_count.join_date, row_count.order_date, menu.product_name, row_num
FROM row_count
JOIN menu ON row_count.product_id = menu.product_id
AND ROW_NUM = 1
ORDER BY customer_id, order_date DESC;


--Answer 8
SELECT sales.customer_id , count(sales.product_id),SUM(menu.price)
FROM sales 
JOIN menu ON sales.product_id = menu.product_id
JOIN members ON sales.customer_id = members.customer_id
WHERE sales.order_date < members.join_date 
GROUP BY sales.customer_id
ORDER BY customer_id;


--Answer 9 
WITH other_sum AS (SELECT sales.customer_id ,SUM(menu.price) AS total_price
FROM sales 
JOIN menu ON sales.product_id = menu.product_id
WHERE menu.product_name != 'sushi'
GROUP BY sales.customer_id),
sushi_sum AS (SELECT sales.customer_id ,SUM(menu.price) AS sushi_price
FROM sales 
JOIN menu ON sales.product_id = menu.product_id
WHERE menu.product_name = 'sushi'
GROUP BY sales.customer_id)
SELECT other_sum.customer_id, (other_sum.total_price + COALESCE(sushi_sum.sushi_price, 0)) AS price_sum, 
((other_sum.total_price * 10) + (COALESCE(sushi_sum.sushi_price,0) * 20)) AS points 
FROM other_sum
LEFT JOIN sushi_sum ON sushi_sum.customer_id = other_sum.customer_id
ORDER BY other_sum.customer_id;


--Answer 9 type 2
WITH sales_with_points AS (
    SELECT 
        sales.customer_id, sales.order_date, menu.product_name, menu.price,
        CASE 
            WHEN menu.product_name = 'sushi' THEN 2
            ELSE 1
        END AS multiplier
    FROM sales
    JOIN menu ON sales.product_id = menu.product_id)
SELECT 
    customer_id,
    SUM(price * 10 * multiplier) AS total_points
FROM sales_with_points
GROUP BY customer_id;


--Answer 10
WITH sales_point AS (
    SELECT
	    sales.customer_id, sales.order_date, menu.product_name, menu.price,
		CASE
		    WHEN sales.order_date BETWEEN members.join_date AND (members.join_date + INTERVAL '6 Days' ) THEN 2
			WHEN menu.product_name = 'sushi' THEN 2
			ELSE 1
	    END AS multiplier
	FROM sales
	JOIN menu ON sales.product_id = menu.product_id
    JOIN members ON sales.customer_id = members.customer_id
	WHERE sales.order_date<= '2021-01-31'
)
SELECT customer_id, SUM(price * 10 * multiplier) AS pionts
FROM sales_point
GROUP BY customer_id;


 
 --Bonous question 1
 SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE 
        WHEN members.join_date IS NOT NULL THEN 'Y' 
        ELSE 'N' 
    END AS member
FROM 
    sales s
JOIN 
    menu m ON s.product_id = m.product_id
LEFT JOIN 
    members ON s.customer_id = members.customer_id 
             AND s.order_date >= members.join_date
ORDER BY 
    s.customer_id, s.order_date;


--Bonous question 2
WITH ranked_sales AS (
    SELECT 
        s.customer_id, s.order_date, m.product_name, m.price,
        CASE 
            WHEN members.customer_id IS NOT NULL THEN 'Y' 
            ELSE 'N' 
        END AS member,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id, 
            CASE WHEN members.customer_id IS NOT NULL THEN 1 ELSE NULL END
            ORDER BY s.order_date
        ) AS ranking
    FROM 
        sales s
    JOIN 
        menu m ON s.product_id = m.product_id
    LEFT JOIN 
        members ON s.customer_id = members.customer_id 
                  AND s.order_date >= members.join_date
)
SELECT 
    customer_id, order_date, product_name, price, member,
	CASE 
        WHEN member = 'Y' THEN ranking 
        ELSE NULL 
    END AS ranking
    
FROM 
    ranked_sales
ORDER BY 
    customer_id, order_date;
