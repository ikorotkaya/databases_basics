select * from customers limit 10;
select * from orders limit 10;
select * from books limit 10;

select * from pg_indexes where schemaname = 'cc_user';

explain analyze select customer_id, quantity 
from orders where quantity > 18;

-- build an index to improve the search time for the specific query
create index orders_customer_id_quantity_idx on orders (customer_id, quantity) where quantity > 18;

explain analyze select customer_id, quantity 
from orders where quantity > 18;

explain analyze select *
from customers where customer_id < 100;

-- create primary key on the table
alter table customers
add constraint customers_pkey
primary key (customer_id);

explain analyze select *
from customers where customer_id < 100;

-- use  new primary key to fix so the system is ordered in the database physically by customer_id
cluster customers_pkey on customers;

select * from customers limit 10;

-- create new index for customer_id and book_id but then drop the index and create new because we need to add quantity as well
create index orders_customer_id_book_id_idx on orders (customer_id, book_id);

drop index orders_customer_id_book_id_idx;
select * from pg_indexes where schemaname = 'cc_user';

explain analyze select customer_id, book_id, quantity 
from orders where quantity > 18;

create index orders_customer_id_book_id_quantity_idx on orders (customer_id, book_id, quantity);

explain analyze select customer_id, book_id, quantity 
from orders where quantity > 18;

explain analyze select author, title 
from books;

-- Combining Indexes
create index books_author_title_idx on books (author, title);

explain analyze select author, title 
from books;

-- look for all the information on all orders where the total price > 100
explain analyze select * from orders where (quantity * price_base) > 100;

-- create an index to speed this query up
create index orders_quantity_price_base_idx on orders (quantity, price_base) where (quantity * price_base) > 100;

explain analyze select * from orders where (quantity * price_base) > 100;

-- check what indexes exist
SELECT *
FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;

-- clear the indexes:
DROP INDEX IF EXISTS books_author_idx;

DROP INDEX IF EXISTS orders_customer_id_quantity_idx;

CREATE INDEX customers_last_name_first_name_email_address ON customers (last_name, first_name, email_address);

SELECT *
FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;