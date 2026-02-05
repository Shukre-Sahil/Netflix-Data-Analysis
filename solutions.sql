-- Business Problems and their solutions on Netflix Dataset.

-- 1. Count the number of Movies vs TV Shows

SELECT 
	type as Type,
	count(*) as Total_count
from netflix
group by type;




-- 2. Find the most common rating for movies and TV shows

select 
	type,
	mode() within group (order by rating) as Common_rating	
from netflix
group by type;


-- 3. List all movies released in a specific year (e.g., 2020)


select 	
	title as movies,
	release_year as released_in
from netflix
where type = 'Movie' and release_year IN('2020');



-- 4. Find the top 5 countries with the most content on Netflix

select 
	country,
	count(show_id) as total_content
	
from netflix
group by country
order by total_content desc
limit 5; 




-- 5. Identify the longest movie

select 
	title,
	max(duration) as duration
from netflix
where type = 'Movie'
group by title
order by duration desc;


-- 6. Find content added in the last 5 years

select 
	*
from netflix
where 
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select
	*
from netflix
where director like '%Rajiv Chilaka%';

	

-- 8. List all TV shows with more than 5 seasons

select 
	*
	-- split_part(duration, ' ', 1) as seasons
from netflix
where 
	type = 'TV Show' and
	split_part(duration, ' ', 1):: numeric > 5;




-- 9. Count the number of content items in each genre

select
	unnest(string_to_array(listed_in, ',')) as genre,
	count(title) as total_content_items
from netflix
group by genre;


-- 10.Find each year and the average numbers of content release in India on netflix and return top 5 year with highest avg content release!


select  
	release_year,
	count(show_id) as content_released,
	(count(*)::numeric / (select count(*) from netflix where country = 'India') )::numeric * 100 as average_number_of_content
from netflix
where country = 'India'
group by release_year
order by count(show_id) desc
limit 5;


-- 11. List all movies that are documentaries

select 
	*
from netflix
where type = 'Movie' and listed_in ilike '%documentaries%';


-- 12. Find all content without a director

select 
	*
from netflix
where director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select
	*
from netflix
where 
	casts ilike '%Salman Khan%' and
	release_year > extract(year from current_date) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
	unnest(string_to_array(casts, ',')) as actors,
	count(*) as total_content
from netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10;



/*
 15.
 Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
 the description field. Label content containing these keywords as 'Bad' and all other 
 content as 'Good'. Count how many items fall into each category.
*/

with new_table as
(
select
	title,
	case 
		when description like '%kill%' or description like '%violence%' then 'Bad'
		else 'Good'
	end as category
from netflix
) 

select 
	category,
	count(*)
from new_table
group by category;


