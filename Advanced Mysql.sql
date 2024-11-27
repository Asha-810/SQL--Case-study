CREATE TABLE customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    pizza_id INTEGER,
    exclusions VARCHAR(4),
    extras VARCHAR(4),
    order_date TIMESTAMP
);

INSERT INTO customer_orders (order_id, customer_id, pizza_id, exclusions, extras, order_date) VALUES
(1, 101, 1, NULL, NULL, '2021-01-01 18:05:02.000'),
(2, 101, 1, NULL, NULL, '2021-01-01 19:00:52.000'),
(3, 102, 1, NULL, NULL, '2021-01-02 23:51:23.000'),
(3, 102, 2, NULL, NULL, '2021-01-02 23:51:23.000'),
(4, 103, 1, '4', NULL, '2021-01-04 13:23:46.000'),
(4, 103, 1, '4', NULL, '2021-01-04 13:23:46.000'),
(4, 103, 2, '4', NULL, '2021-01-04 13:23:46.000'),
(5, 104, 1, NULL, '1', '2021-01-08 21:00:29.000'),
(6, 101, 2, NULL, NULL, '2021-01-08 21:03:13.000'),
(7, 105, 2, NULL, '1', '2021-01-08 21:20:29.000'),
(8, 102, 1, NULL, NULL, '2021-01-09 23:54:33.000'),
(9, 103, 1, '4', '1,5', '2021-01-10 11:22:59.000'),
(10, 104, 2, NULL, NULL, '2021-01-11 18:34:49.000'),
(10, 104, 1, '2,6', '1,4', '2021-01-11 18:34:49.000');

SELECT * FROM pizzarunner.customer_orders;

CREATE TABLE customer_orders_temp AS
SELECT 
  order_id, 
  customer_id, 
  pizza_id, 
  CASE
	  WHEN exclusions IS null OR exclusions LIKE 'null' THEN ' '
	  ELSE exclusions
	  END AS exclusions,
  CASE
	  WHEN extras IS NULL or extras LIKE 'null' THEN ' '
	  ELSE extras
	  END AS extras,
	order_date
FROM pizzarunner.customer_orders;

select * from customer_orders_temp;

CREATE TABLE runner_orders (
    order_id INTEGER,
    runner_id INTEGER,
    pickup_time VARCHAR(19),
    distance VARCHAR(7),
    duration VARCHAR(10),
    cancellation VARCHAR(23)
);


insert into runner_orders
(order_id, runner_id, pickup_time, distance, duration, cancellation) values
(1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', NULL),
(2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', NULL),
(3, 1, '2021-01-03 00:12:37', '13.4km', '20 mins', NULL),
(4, 2, '2021-01-04 13:53:03', '23.4', '40', NULL),
(5, 3, '2021-01-08 21:10:57', '10', '15', NULL),
(6, 3, NULL, NULL, NULL, 'Restaurant Cancellation'),
(7, 2, '2021-01-08 21:30:45', '25km', '25mins', NULL),
(8, 2, '2021-01-10 00:15:02', '23.4 km', '15 minute', NULL),
(9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
(10, 1, '2021-01-11 18:50:20', '10km', '10minutes', NULL);

select * from  runner_orders;

CREATE TABLE runner_orders_temp AS
SELECT 
  order_id, 
  runner_id,  
  CASE
	  WHEN pickup_time  LIKE 'null' THEN ' '
	  ELSE pickup_time
	  END AS pickup_time,
  CASE
	  WHEN distance LIKE 'null' THEN ' '
	  WHEN distance LIKE '%km' THEN TRIM('km' from distance)
	  ELSE distance 
    END AS distance,
  CASE
	  WHEN duration LIKE 'null' THEN ' '
	  WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
	  WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
	  WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
	  ELSE duration
	  END AS duration,
  CASE
	  WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ' '
	  ELSE cancellation
	  END AS cancellation
FROM pizzarunner.runner_orders;


select*FROM runner_orders_temp;

ALTER TABLE runner_orders_temp
modify column pickup_time datetime ,
modify column distance FLOAT,
modify COLUMN duration INT;

#A. Pizza Metrics
#1. How many pizzas were ordered?

SELECT COUNT(*) AS pizza_order_count
FROM customer_orders_temp;

#2. How many unique customer orders were made?

select count(distinct order_id) as unique_order_count from customer_orders_temp;

#3. How many successful orders were delivered by each runner?

select runner_id ,count( order_id) as successful_orders from runner_orders_temp where distance != 0 group by runner_id;

#4. How many of each type of pizza was delivered?

SELECT 
  p.pizza_name, 
  COUNT(c.pizza_id) AS delivered_pizza_count
FROM customer_orders AS c
JOIN  runner_orders AS r
  ON c.order_id = r.order_id
JOIN pizza_names AS p
  ON c.pizza_id = p.pizza_id
WHERE r.distance != 0
GROUP BY p.pizza_name;

#5. How many Margherita and Pepperoni were ordered by each customer?

SELECT 
  c.customer_id, 
  p.pizza_name, 
  COUNT(p.pizza_name) AS order_count
FROM customer_orders AS c
JOIN pizza_names AS p
  ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;

#6. What was the maximum number of pizzas delivered in a single order?

WITH pizza_count_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.pizza_id) AS pizza_per_order
  FROM customer_orders AS c
  JOIN runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id
)

SELECT 
  MAX(pizza_per_order) AS pizza_count
FROM pizza_count_cte;

SELECT 
    c.order_id, 
    COUNT(c.pizza_id) AS pizza_per_order
  FROM customer_orders AS c
  JOIN runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id;

#7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
  c.customer_id,
  SUM(
    CASE WHEN c.exclusions <> ' ' OR c.extras <> ' ' THEN 1
    ELSE 0
    END) AS at_least_1_change,
  SUM(
    CASE WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1 
    ELSE 0
    END) AS no_change
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;

#8. How many pizzas were delivered that had both exclusions and extras?

SELECT  
  SUM(
    CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1
    ELSE 0
    END) AS pizza_count_w_exclusions_extras
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.distance >= 1 
  AND exclusions <> ' ' 
  AND extras <> ' ';

#9. What was the total volume of pizzas ordered for each hour of the day?

SELECT 
  HOUR (order_date) AS hour_of_day, 
  COUNT(order_id) AS pizza_count
FROM customer_orders
GROUP BY HOUR (order_date);


select* from customer_orders;

#10. What was the volume of orders for each day of the week?




SELECT 
  DAYNAME(DATE_ADD(order_date, INTERVAL 2 DAY)) AS day_of_week,
  COUNT(order_id) AS total_pizzas_ordered
FROM customer_orders
GROUP BY DAYOFWEEK(DATE_ADD(order_date, INTERVAL 2 DAY)), 
         day_of_week
ORDER BY DAYOFWEEK(DATE_ADD(order_date, INTERVAL 2 DAY));

#B. 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)


SELECT 
  WEEK(registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY WEEK(registration_date);


#2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH time_taken_cte AS (
  SELECT 
    c.order_id, 
    c.order_date, 
    r.pickup_time, 
    TIMESTAMPDIFF(MINUTE, c.order_date, r.pickup_time) AS pickup_minutes
  FROM customer_orders AS c
  JOIN runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
)

SELECT 
  AVG(pickup_minutes) AS avg_pickup_minutes
FROM time_taken_cte
WHERE pickup_minutes > 1;

#3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH prep_time_cte AS (
  SELECT 
    c.order_id, 
    COUNT(c.order_id) AS pizza_order, 
    c.order_date, 
    r.pickup_time, 
    TIMESTAMPDIFF(MINUTE, c.order_date, r.pickup_time) AS prep_time_minutes
  FROM customer_orders AS c
  JOIN runner_orders AS r
    ON c.order_id = r.order_id
  WHERE r.distance != 0
  GROUP BY c.order_id, c.order_date, r.pickup_time
)

SELECT 
  pizza_order, 
  AVG(prep_time_minutes) AS avg_prep_time_minutes
FROM prep_time_cte
WHERE prep_time_minutes > 1
GROUP BY pizza_order;

#4. Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT 
  c.customer_id, 
  AVG(r.distance) AS avg_distance
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.duration != 0
GROUP BY c.customer_id;

#5. What was the difference between the longest and shortest delivery times for all orders?

SELECT 
  order_id, duration
FROM runner_orders_temp
WHERE duration not like ' ';

SELECT 
  MAX(CAST(duration AS DECIMAL)) - MIN(CAST(duration AS DECIMAL)) AS delivery_time_difference
FROM runner_orders_temp
WHERE duration != '';

#6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
  r.runner_id, 
  c.customer_id, 
  c.order_id, 
  COUNT(c.order_id) AS pizza_count, 
  r.distance, (r.duration / 60) AS duration_hr , 
  ROUND((r.distance/r.duration * 60), 2) AS avg_speed
FROM runner_orders_temp AS r
JOIN customer_orders_temp AS c
  ON r.order_id = c.order_id
WHERE distance != 0
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;

#7. What is the successful delivery percentage for each runner?

SELECT 
  runner_id, 
  ROUND(100 * SUM(
    CASE WHEN distance = 0 THEN 0
    ELSE 1 END) / COUNT(*), 0) AS success_perc
FROM runner_orders
GROUP BY runner_id;






