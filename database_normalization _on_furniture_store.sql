select * from store limit 10;

SELECT COUNT(DISTINCT(order_id)) 
FROM store;

select count(distinct(customer_id)) from store;

select customer_id, customer_email, customer_phone
from store where customer_id = 1;

select item_1_id, item_1_name, item_1_price 
from store
where item_1_id = 4;

-- create the customers table described in the schema by querying the original store table for the relevant columns
create table customers as 
select distinct customer_id, customer_phone, customer_email
from store;

-- designate the customer_id column as the primary key of your new customers table
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- create the items table
create table items as
select distinct item_1_id as item_id, item_1_name as name, item_1_price as price
from store
union
select distinct item_2_id as item_id, item_2_name as name, item_2_price as price
from store
where item_2_id is not null
union
select distinct item_3_id as item_id, item_3_name as name, item_3_price as price
from store
where item_3_id is not null;

-- designate the item_id column as a primary key
ALTER TABLE items
ADD PRIMARY KEY (item_id);

-- create the orders_items table
create table orders_items as 
select order_id, item_1_id as item_id
from store
union all
select order_id, item_2_id as item_id
from store
where item_2_id is not null
union all
select order_id, item_3_id as item_id
from store
where item_3_id is not null;

-- create the orders table
create table orders as
select order_id, order_date, customer_id
from store;

-- designate the order_id column as a primary key
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- designate the customer_id column of the orders table as a foreign key referencing the customer_id column of the customers table
ALTER TABLE orders
ADD FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (item_id) 
REFERENCES items(item_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (order_id) 
REFERENCES orders(order_id);

-- exercise 1
select customer_email
from store 
where order_date > '2019-07-25'
order by customer_email asc
limit 5;

-- or the same query another way

select customers.customer_email
from customers, orders
where customers.customer_id = orders.customer_id and  order_date > '2019-07-25' order by customer_email asc limit 5;

-- exercise 2 (return the number of orders containing each unique item (for example, two orders contain item 1, two orders contain item 2, four orders contain item 3, etc.))
WITH all_items AS (
SELECT item_1_id as item_id 
FROM store
UNION ALL
SELECT item_2_id as item_id
FROM store
WHERE item_2_id IS NOT NULL
UNION ALL
SELECT item_3_id as item_id
FROM store
WHERE item_3_id IS NOT NULL
)
SELECT item_id, COUNT(*)
FROM all_items
GROUP BY item_id;

-- or the same query another way
select item_id, count(*)
from orders_items
group by 1;