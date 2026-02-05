
drop table if exists netflix;
create table netflix (
	show_id	varchar(15),
	type	varchar(25),
	title	varchar(110),
	director	varchar(250),
	casts	varchar(800),
	country	varchar(150),
	date_added	varchar(50),
	release_year	varchar(15),
	rating varchar(30),	
	duration	varchar(20),
	listed_in	varchar(100),
	description varchar(300)

);

select * from netflix;

alter table netflix
alter column release_year type integer
USING release_year::integer;