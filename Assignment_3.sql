
/*
Discount Effects

Using SampleRetail database generate a report, including product IDs and discount effects on 
whether the increase in the discount rate positively impacts the number of orders for the products.

For this, statistical analysis methods can be used. However, this is not expected.

In this assignment, you are expected to generate a solution using SQL with a logical approach. 

*/



WITH T1 AS (
SELECT product_id, discount, SUM(quantity) orders
FROM sale.order_item 
GROUP BY product_id, discount

),
T2 AS (
SELECT *, 
	AVG(discount) OVER(PARTITION BY product_id) AS avg_discount,
	AVG(orders) OVER(PARTITION BY product_id) AS avg_orders,
	discount - AVG(discount) OVER(PARTITION BY product_id) AS discount_minus_avg,
	orders - AVG(orders) OVER(PARTITION BY product_id) AS orders_minus_avg,
	(discount - AVG(discount) OVER(PARTITION BY product_id))*(orders - AVG(orders) OVER(PARTITION BY product_id)) AS discount_minus_avg_times_orders_minus_avg
FROM T1
),
T3 AS (
SELECT DISTINCT product_id,
	ROUND(STDEVP(discount) OVER(PARTITION BY product_id),3) AS std_discount,
	ROUND(STDEVP(orders) OVER(PARTITION BY product_id),3) AS std_orders,
	CAST(SUM(discount_minus_avg_times_orders_minus_avg) OVER(PARTITION BY product_id)/COUNT(product_id) OVER(PARTITION BY product_id) AS DECIMAL (4,3)) AS Covariance
FROM T2
),
T4 AS(
SELECT P.product_id,
	ROUND(CASE WHEN Covariance<>0 THEN Covariance/(std_discount*std_orders) ELSE 0 END,3) AS Correlation
FROM T3
	RIGHT JOIN product.product AS P
	ON T3.product_id = P.product_id
)
SELECT product_id,
	CASE
		WHEN Correlation > 0 THEN 'Positive'
		WHEN Correlation < 0 THEN 'Negative'
		ELSE 'Neutral'
    END AS Discount_Effect
FROM T4


