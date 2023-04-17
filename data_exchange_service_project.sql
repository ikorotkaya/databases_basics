select rolname from pg_roles where rolsuper is true;

select * from pg_roles;

select current_role;

-- create a login role named abc_open_data without superuser permissions
create role abc_open_data with nosuperuser;

-- create a non-superuser group role named publishers and include abc_open_data as a member
create role publishers with nosuperuser role abc_open_data;

-- grant USAGE on analytics schema to publishers
GRANT USAGE on schema analytics TO publishers;

-- grant publishers the ability to SELECT on all existing tables in analytics
GRANT SELECT ON ALL TABLES IN schema analytics TO publishers;

-- query the information schema table table_privileges to check whether abc_open_data has SELECT on analytics.downloads
SELECT * 
FROM information_schema.table_privileges 
where grantee = 'publishers';

set role abc_open_data;
SELECT * FROM analytics.downloads limit 10;

set role ccuser;
select * from directory.datasets limit 10;

GRANT USAGE on schema directory TO publishers;

-- implement a type of column-level security, we can do this by being more specific in a GRANT statement
GRANT SELECT (id, create_date, hosting_path, publisher, src_size) on directory.datasets TO publishers;

set role abc_open_data;
SELECT id, publisher, hosting_path 
FROM directory.datasets;

set role ccuser;

select * from analytics.downloads limit 10;

-- create and enable policy that says that the current_user must be the publisher of the dataset to SELECT
create policy policy on analytics.downloads for select to publishers using (owner = current_user);

alter table analytics.downloads enable row level security;

select * from analytics.downloads limit 10;

set role abc_open_data;

select * from analytics.downloads limit 10;
