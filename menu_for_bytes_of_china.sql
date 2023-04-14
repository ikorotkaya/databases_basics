create table restaurant (
  id integer PRIMARY KEY,
  name varchar(20),
  description varchar(100),
  telephone char(10),
  hours varchar(100),
  rating decimal
);

create table address (
  id integer PRIMARY KEY,
  street_number varchar(10),
  street_name varchar(20),
  city varchar(20),
  state varchar(15),
  google_map_link varchar(50)
);

select constraint_name, table_name, column_name
from information_schema.key_column_usage
where table_name = 'restaurant';

select constraint_name, table_name, column_name
from information_schema.key_column_usage
where table_name = 'address';

create table category (
  id char(2) PRIMARY KEY,
  name varchar(20),
  description varchar(200)
);

select constraint_name, table_name, column_name
from information_schema.key_column_usage
where table_name = 'category';