
/*
 Please work on questions below according to SampleRetail Database.

*/

--1.  By using view get the average sales by staffs and years using the AVG() aggregate function

WITH T1 AS (
			SELECT C.first_name, C.last_name, YEAR(B.order_date) AS [year], quantity*list_price AS amount
			FROM sale.order_item AS A
				INNER JOIN 
				sale.orders AS B
				ON A.order_id = B.order_id
				INNER JOIN 
				sale.staff AS C
				ON B.staff_id = C.staff_id
)
SELECT DISTINCT T1.first_name, T1.last_name, T1.year,
		AVG(amount) OVER (PARTITION BY first_name, last_name, [year] ORDER BY first_name) AS avg_amount
FROM T1


--2.  Select the annual amount of product produced according to brands (use window functions).

SELECT DISTINCT B.brand_name, A.model_year, 
	   COUNT(A.product_id) OVER(PARTITION BY A.brand_id, A.model_year ORDER BY B.brand_name) AS annual_amount_brands
FROM product.product AS A
	INNER JOIN product.brand AS B
	ON A.brand_id = B.brand_id




--3.  Select the least 3 products in stock according to stores.

WITH T1 AS(
			SELECT C.store_name, A.product_name, B.quantity,
				ROW_NUMBER() OVER(PARTITION BY B.store_id ORDER BY product_name) AS least_3
			FROM product.product AS A
				INNER JOIN product.stock AS B
				ON A.product_id = B.product_id
				INNER JOIN sale.store AS C
				ON B.store_id = C.store_id
			WHERE quantity = 1 
)
SELECT *
FROM T1
WHERE least_3 < 4
ORDER BY store_name

--4. Calculates the average number of sales orders made by each staff member in the year 2020.

SELECT AVG(order_count) AS average_staff
FROM (
    SELECT COUNT(DISTINCT order_id) AS order_count
    FROM sale.orders 
    WHERE YEAR(order_date) = 2020
    GROUP BY staff_id
) AS subquery;


--5.  Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.

WITH T1 AS(
			SELECT product_id, product_name, B.brand_id, list_price,
				ROW_NUMBER() OVER(PARTITION BY B.brand_id ORDER BY list_price DESC) AS price_rank
			FROM product.product AS A
				INNER JOIN product.brand AS B
				ON A.brand_id = B.brand_id
)
SELECT *
FROM T1
WHERE price_rank <= 3