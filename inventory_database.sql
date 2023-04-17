select * from parts limit 10;

-- alter the code column so that each value inserted into this field is unique and not empty
alter table parts
alter column code set not null;

alter table parts
add unique(code);

-- alter the table so that all rows have a value for description
update parts
set description = 'None Available'
where description is null;

CREATE TABLE part_descriptions (
  id int PRIMARY KEY, 
  description text
);

INSERT INTO part_descriptions VALUES (1, '5V resistor'), (2, '3V resistor');

UPDATE parts
SET description = part_descriptions.description
from part_descriptions
where part_descriptions.id = parts.id
and parts.description IS NULL;

-- alter the table if you wanted to fill in missing description fields with different values for each part
select * from parts limit 10;
select count(*) from parts;

-- add a constraint on parts that ensures that all values in description are filled and non-empty
alter table parts
alter column description set not null;

-- test the constraint 
insert into parts (id, description, code, manufacturer_id) values (54, 'needs description', 'V1-009', 9);

-- check that price_usd and quantity are both NOT NULL
alter table reorder_options
alter column quantity set not null;

alter table reorder_options
alter column price_usd set not null;

-- check that price_usd and quantity are both positive
alter table reorder_options
add check (price_usd > 0 and quantity > 0);

-- add a constraint to reorder_options that limits price per unit to within the range
alter table reorder_options
add check (price_usd/quantity > 0.02 and price_usd/quantity < 25.00);

-- form a relationship between parts and reorder_options that ensures all parts in reorder_options refer to parts tracked in parts
alter table parts
add primary key (id);

alter table reorder_options
add foreign key (part_id) references parts (id);

-- add a constraint that ensures that each value in qty is greater than 0
alter table locations
add check (qty > 0);

-- ensure that locations records only one row for each combination of location and part
alter table locations 
add unique (part_id, location);

-- constraint that forms the relationship between two tables and ensures only valid parts are entered into locations
alter table locations
add foreign key (part_id) references parts (id);

-- constraint that forms a relationship between parts and manufacturers that ensures that all parts have a valid manufacturer
alter table parts
add foreign key (manufacturer_id) references manufacturers (id);

-- create a new manufacturer in manufacturers with an id=11
insert into manufacturers (id, name) values (11, 'Pip-NNC Industrial');

select * from manufacturers;
-- update the old manufacturers’ parts in 'parts' to reference the new company you’ve just added to 'manufacturers'
update parts
set manufacturer_id = 11
where manufacturer_id in (1, 2);
-- or

-- UPDATE parts
-- SET manufacturer_id = 11
-- WHERE manufacturer_id = 1 OR manufacturer_id = 2;
