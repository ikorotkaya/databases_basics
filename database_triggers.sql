select * from customers
order by customer_id;

select * from customers_log;

create trigger customer_log
before update on customers
for each row
execute procedure log_customers_change();

update customers
set first_name = 'Morgenstern'
where first_name = 'Dennis';

select * from customers
order by customer_id;

select * from customers_log;

update customers
set years_old = 10
where years_old = 21;

select * from customers
order by customer_id;

select * from customers_log;

create trigger customer_insert
after insert on customers
for each row
execute procedure log_customers_change();

insert into customers (first_name, last_name, years_old)
values
('Jeffrey','Cook', 66),
('Angelona', 'Jolie', 55),
('Bred', 'Pitt', 56);

select * from customers
order by customer_id;

select * from customers_log;

create trigger customer_min_age
before update on customers
for each row
when (NEW.years_old < 13)
execute procedure override_with_min_age();

update customers
set years_old = 11,
  last_name = 'Damn boy'
where years_old = 56;

update customers
set years_old = 14
where years_old = 10;

select * from customers
order by customer_id;

select * from customers_log;

drop trigger customer_min_age on customers;

select * from customers
order by customer_id;

select * from customers_log;

SELECT * FROM information_schema.triggers;