-- CREATE DATABASE CALLED pizza_runner

CREATE DATABASE pizza_runner;
USE pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners
( runner_id INTEGER PRIMARY KEY,
registration_date DATE);

INSERT INTO runners
( runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2024-01-15');
  
  SELECT *
  FROM runners;
  
DROP TABLE IF EXISTS customer_orders;

CREATE TABLE customer_orders 
(order_id INTEGER PRIMARY KEY ,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP);
  
INSERT INTO customer_orders
(order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '102', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '103', '1', '', '', '2020-01-02 23:51:23'),
  ('4', '104', '2', '', NULL, '2020-01-02 23:51:23'),
  ('5', '105', '1', '4', '', '2020-01-04 13:23:46'),
  ('6', '106', '1', '4', '', '2020-01-04 13:23:46'),
  ('7', '107', '2', '4', '', '2020-01-04 13:23:46'),
  ('8', '108', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('9', '109', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('10', '110', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('11', '111', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('12', '112', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('13', '113', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('14', '114', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
SELECT *
FROM customer_orders;

DROP TABLE customer_orders_temp;

CREATE TEMPORARY TABLE customer_orders_temp AS
SELECT order_id, customer_id, pizza_id,
CASE
WHEN exclusions = '' THEN NULL
WHEN exclusions = 'null' THEN NULL
ELSE exclusions
END AS exclusions,
CASE
WHEN extras = '' THEN NULL
WHEN extras = 'null' THEN NULL
ELSE extras
END AS extras, order_time
FROM customer_orders;

SELECT * 
FROM customer_orders_temp;

DROP TABLE customer_orders_temp;

DROP TABLE IF EXISTS runner_orders;
  
CREATE TABLE runner_orders 
(order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23));
  
  -- adding the foreign keys to the table
  ALTER TABLE runner_orders
  ADD CONSTRAINT fk_order_id
  FOREIGN KEY (order_id)
  REFERENCES customer_orders (order_id);
  
  ALTER TABLE runner_orders
  ADD CONSTRAINT fk_runner_id
  FOREIGN KEY (runner_id)
  REFERENCES runners (runner_id);

INSERT INTO runner_orders
(order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  (1, 1, '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  (2, 1, '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  (3, 1, '2020-01-03 00:12:37', '13.4km', '20 minutes', NULL),
  (4, 2, '2020-01-04 13:53:03', '23.4km', '40 minutes', NULL),
  (5, 3, '2020-01-08 21:10:57', '10km', '15 minutes', NULL),
  (6, 3, 'null', 'null', 'null', 'Restaurant Cancellation'),
  (7, 2, '2020-01-08 21:30:45', '25km', '25minutes', 'null'),
  (8, 2, '2020-01-10 00:15:02', '23.4km', '15 minutes', 'null'),
  (9, 2, 'null', 'null', 'null', 'Customer Cancellation'),
  (10, 1, '2020-01-11 18:50:20', '10km', '10minutes', 'null');

SELECT *
FROM runner_orders;

DROP TABLE IF EXISTS runner_orders_temp;

CREATE TEMPORARY TABLE runner_orders_temp AS
SELECT order_id, runner_id, CASE
WHEN pickup_time LIKE 'null' THEN NULL
ELSE pickup_time END AS pickup_time,
CASE
WHEN distance LIKE 'null' THEN NULL
ELSE CAST(regexp_replace(distance, '[a-z]+', '') AS FLOAT)
END AS distance,
CASE
WHEN duration LIKE 'null' THEN NULL
ELSE CAST(regexp_replace(duration, '[a-z]+', '') AS FLOAT)
END AS duration, CASE
WHEN cancellation LIKE '' THEN NULL
WHEN cancellation LIKE 'null' THEN NULL
ELSE cancellation
END AS cancellation
FROM runner_orders;

SELECT *
FROM runner_orders_temp;

DROP TABLE IF EXISTS pizza_names;

-- CREATE TABLE PIZZA_NAMES
CREATE TABLE pizza_names 
(pizza_id INTEGER,
pizza_name TEXT,
CONSTRAINT
pk_pizza_id PRIMARY KEY (pizza_id));

INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');
  
SELECT *
FROM pizza_names;

DROP TABLE IF EXISTS pizza_recipes;

CREATE TABLE pizza_recipes 
(pizza_id INTEGER,
toppings TEXT);

ALTER TABLE pizza_recipes
ADD CONSTRAINT fk_pizza_id
FOREIGN KEY (pizza_id)
REFERENCES pizza_names (pizza_id);

INSERT INTO pizza_recipes
(pizza_id, toppings)
VALUES
(1, '1, 2, 3, 4, 5, 6, 8, 10'),
(2, '4, 6, 7, 9, 11, 12');

SELECT *
FROM pizza_recipes;

DROP TABLE IF EXISTS pizza_recipes_temp;

CREATE TEMPORARY TABLE pizza_recipes_temp
(pizza_id int, topping int);

SELECT *
FROM pizza_recipes_temp;

DROP TABLE IF EXISTS pizza_toppings;

CREATE TABLE pizza_toppings 
(topping_id INTEGER PRIMARY KEY,
topping_name TEXT);

INSERT INTO pizza_toppings
(topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
SELECT *
FROM pizza_toppings;

-- The exclusions and extras columns in the pizza_recipes table are comma separated strings.

SELECT t.order_id, t.customer_id, t.pizza_id,
trim(j1.exclusions) AS exclusions,
trim(j2.extras) AS extras,
t.order_time
FROM customer_orders_temp t
INNER JOIN json_table(trim(replace(json_array(t.exclusions), ',', '","')), '$[*]' columns (exclusions varchar(50) PATH '$')) j1
INNER JOIN json_table(trim(replace(json_array(t.extras), ',', '","')), '$[*]' columns (extras varchar(50) PATH '$')) j2 ;
 
-- How many pizzas were ordered
SELECT COUNT(*) AS total_pizzas_ordered
FROM customer_orders;

-- How many unique customer orders were made
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders;

-- How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(*) AS pizzas_with_changes
FROM customer_orders
WHERE exclusions IS NOT NULL AND extras IS NOT NULL;

-- -- What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration) - MIN(duration) AS difference
FROM runner_orders_temp;

-- Or

SELECT MIN(duration) minimum_duration,
       MAX(duration) AS maximum_duration,
       MAX(duration) - MIN(duration) AS maximum_difference
FROM runner_orders_temp;

-- GROUP BY AND ORDER BY
-- What was the maximum number of pizzas delivered in a single order?
SELECT customer_id, order_id, count(order_id) AS pizza_count
FROM customer_orders_temp
GROUP BY order_id, customer_id
ORDER BY pizza_count DESC
LIMIT 1;

-- How many successful orders were delivered by each runner
SELECT runner_id, COUNT(*) AS successful_orders_delivered
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- What was the volume of orders for each day of the week?
SELECT dayname(order_time) AS 'Day Of Week', count(order_id) AS 'Number of pizzas ordered',
round(100*count(order_id) /sum(count(order_id)) over(), 2) AS 'Volume of pizzas ordered'
FROM pizza_runner.customer_orders_temp
GROUP BY 1
ORDER BY 2 DESC;

-- How many runners signed up for each 1-week period? (i.e. week starts 2021-01-01)
SELECT week(registration_date) as 'Week of registration',
count(runner_id) as 'Number of runners'
FROM pizza_runner.runners
GROUP BY 1;

-- What was the average distance travelled for each runner? check 
SELECT runner_id, ROUND(AVG(distance), 2) AS avg_distance
FROM runner_orders_temp
GROUP BY runner_id
ORDER BY runner_id;

-- What was the average speed for each runner for each delivery 
-- and do you notice any trend for these values? check 
SELECT runner_id,
distance AS distance_km,
round(duration/60, 2) AS duration_hr,
round(distance*60/duration, 2) AS average_speed
FROM runner_orders_temp
WHERE cancellation IS NULL
ORDER BY runner_id;

-- What is the successful delivery percentage for each runner?
SELECT runner_id, COUNT(pickup_time) AS delivered_orders, COUNT(*) AS total_orders,
ROUND(100 * COUNT(pickup_time) / COUNT(*)) AS delivery_success_percentage
FROM runner_orders_temp
GROUP BY runner_id
ORDER BY runner_id

-- JOINS
-- How many of each type of pizza was delivered?
SELECT pizza_name, COUNT(*) AS total_delivered
FROM customer_orders co
INNER JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, 
SUM(CASE WHEN pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meatlovers_ordered,
SUM(CASE WHEN pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian_ordered
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY customer_id;

-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and 
-- there were no charges for changes - 
-- how much money has Pizza Runner made so far if there are no delivery fees?

SELECT CONCAT('$', SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END)) AS total_revenue
FROM customer_orders_temp
INNER JOIN pizza_names USING (pizza_id)
INNER JOIN runner_orders_temp USING (order_id)
WHERE cancellation IS NULL;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT co.customer_id,
SUM(CASE WHEN co.exclusions IS NOT NULL OR co.extras IS NOT NULL THEN 1 ELSE 0 END) AS pizzas_with_changes,
SUM(CASE WHEN co.exclusions IS NULL AND co.extras IS NULL THEN 1 ELSE 0 END) AS pizzas_no_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.customer_id;

-- creating an order view
USE pizza_runner;

SELECT *
FROM pizza_runner.customer_orders_temp;

CREATE VIEW vw_orderinfo
AS
SELECT order_id, order_time
FROM customer_orders;

-- How many unique customer orders were made
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM vw_orderinfo;

-- What is the combined dataset of customer orders and runner assignments, 
-- and how does it help in understanding the order fulfillment process?"

CREATE VIEW combined_orders_view AS
SELECT co.order_id,
co.customer_id,
co.pizza_id,
co.exclusions,
co.extras,
co.order_time,
ro.runner_id,
ro.pickup_time,
ro.distance,
ro.duration,
ro.cancellation
FROM customer_orders co
LEFT JOIN runner_orders ro 
ON co.order_id = ro.order_id;

SELECT *
FROM combined_orders_view;

-- SUBQUERY EXAMPLE
-- What was the maximum number of pizzas delivered in a single order?
SELECT MAX(total_pizzas) AS max_pizzas_in_order
FROM 
(SELECT order_id, COUNT(*) AS total_pizzas
FROM customer_orders
GROUP BY order_id) AS order_pizzas;

-- to retrieve and return the toppings for a given pizza ID.
-- STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE GetPizzaToppings (IN pizzaID INT)
BEGIN
    SELECT GROUP_CONCAT(topping_name SEPARATOR ', ') AS Toppings
    FROM pizza_toppings
    WHERE FIND_IN_SET(topping_id, (SELECT toppings FROM pizza_recipes WHERE pizza_id = pizzaID));
END//
DELIMITER ;

CALL GetPizzaToppings(2);

-- trigger ensures that whenever a new order is inserted into the customer_orders table, 
-- a corresponding entry is automatically added to the customer_order_log table to keep track of the order details 
-- and the action performed.

-- TRIGGER
DELIMITER //
CREATE TRIGGER after_order_insert
AFTER INSERT ON customer_orders
FOR EACH ROW
BEGIN
    INSERT INTO customer_order_log (order_id, customer_id, order_time, action)
    VALUES (NEW.order_id, NEW.customer_id, NEW.order_time, 'inserted');
END //

DELIMITER ;



-- the count of orders made by a specific customer
-- STORED FUNCTION
DELIMITER //
CREATE FUNCTION GetCustomerCountInCustomer_Orders(customer_ID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE orderCount INT;
    SELECT COUNT(*) INTO orderCount FROM customer_orders WHERE customer_id = customer_ID;
    RETURN orderCount;
END //
DELIMITER ;

SELECT * FROM pizza_runner.customer_orders_temp;