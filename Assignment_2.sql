/*
1. Product Sales
You need to create a report on whether customers who purchased the product named 
'2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)
*/



SELECT DISTINCT C.customer_id, first_name, last_name,
CASE 
	WHEN C.customer_id IN(SELECT C.customer_id
						  FROM product.product AS A
							INNER JOIN sale.order_item AS B
							ON A.product_id = B.product_id
							INNER JOIN sale.orders AS C
							ON B.order_id = C.order_id
							INNER JOIN sale.customer AS D
							ON C.customer_id = D.customer_id
						  WHERE A.product_name =  'Polk Audio - 50 W Woofer - Black')
   THEN 'Yes'
   ELSE 'No'
END AS Other_Product
FROM product.product AS A
	INNER JOIN sale.order_item AS B
	ON A.product_id = B.product_id
	INNER JOIN sale.orders AS C
	ON B.order_id = C.order_id
	INNER JOIN sale.customer AS D
	ON C.customer_id = D.customer_id
WHERE A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
ORDER BY C.customer_id;


/*
2. Conversion Rate
Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements 
given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.

a.    Create above table (Actions) and insert values,

b.    Retrieve count of total Actions and Orders for each Advertisement Type,

c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting 
as float by multiplying by 1.0.

*/


--a.Create above table (Actions) and insert values


CREATE TABLE Actions
(
Visitor_ID BIGINT,
Adv_Type VARCHAR(20),
Action VARCHAR(20),
);


INSERT Actions VALUES
 (1,  'A' , 'Left')
,(2,  'A'  , 'Order')
,(3,  'B' , 'Left')
,(4,  'A' , 'Order')
,(5,  'A' , 'Review')
,(6,  'A' , 'Left')
,(7, 'B', 'Left')
,(8, 'B', 'Order')
,(9, 'B', 'Review')
,(10, 'A', 'Review')


SELECT *
FROM Actions



--b.Retrieve count of total Actions and Orders for each Advertisement Type


SELECT 
    Adv_Type,
    COUNT(Action) AS Total_Actions,
    COUNT(CASE WHEN Action = 'Order' THEN 1 END) AS Total_Orders
FROM 
    Actions
GROUP BY 
    Adv_Type;




--c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting 
--as float by multiplying by 1.0


SELECT Adv_Type, FORMAT(SUM(CASE WHEN Action = 'Order' THEN 1 END)*1.0/COUNT(*),'N2') AS Conversion_Rate
FROM Actions
GROUP BY Adv_Type


