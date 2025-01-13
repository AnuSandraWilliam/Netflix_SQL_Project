--Netflix Project
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(110),
	director VARCHAR(210),
	casts VARCHAR(1000),
	country	VARCHAR(200),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(250),
	description VARCHAR(500)
)
SELECT COUNT(*) AS total_content
FROM netflix;
SELECT DISTINCT type 
FROM netflix;
SELECT * FROM netflix;

--15 Business Problems


--1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*) AS Total_Content
FROM netflix
GROUP BY type;

--2. Find the most common rating for movies and Tv shows


SELECT
	type,
	rating  
FROM
(SELECT
	type,
	rating,
	COUNT(*) AS frequency_of_rating,
	ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC)AS ranking
FROM netflix
GROUP BY type, rating) AS t1
WHERE ranking = 1

--3. List all movies released in a specific year(e.g., 2020)

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

--4. Find the top 5 countries with the most content on Netflix


SELECT TOP 5
    TRIM(value) AS new_country,
    COUNT(DISTINCT n.show_id) AS total_content
FROM netflix AS n
CROSS APPLY STRING_SPLIT(n.country, ',')
GROUP BY TRIM(value)
ORDER BY total_content DESC;

--5. Identify the longest movie


SELECT TOP 1
    title,
    CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) AS movie_length
FROM netflix
WHERE type = 'Movie'
ORDER BY movie_length DESC;

--6. Find content added in the last 5 years

SELECT 
    title,
    date_added
FROM netflix
WHERE date_added >= DATEADD(YEAR, -5, GETDATE())
ORDER BY date_added DESC;


--7. Find all movies / Tv shows by director 'Rajiv Chilaka'

SELECT 
	title,
	type
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 season

SELECT 
    title,
    duration
FROM netflix
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;

--9. Count the number of content items in each genre

SELECT 
    value AS genre,
    COUNT(show_id) AS number_of_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY value
ORDER BY number_of_content DESC;

--10. Find each year and the average numbers of content release in India on netflix.

SELECT 
    YEAR(date_added) AS date_added_year,
    COUNT(*) AS no_of_content,
    ROUND(
        CAST(COUNT(*) AS FLOAT) / (SELECT CAST(COUNT(*) AS FLOAT) FROM netflix WHERE country LIKE '%India%') * 100, 2
    ) AS average_content
FROM netflix
WHERE country LIKE '%India%'
GROUP BY YEAR(date_added);


--11. List all the movies that are documentaries

SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%';

--12. Find all content without a director

SELECT *
FROM netflix
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years.

SELECT 
    COUNT(*) AS no_of_movies_actor_appeared
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT TOP 10
value AS actor,
COUNT(DISTINCT show_id) AS no_of_times_actor_appeared 
FROM netflix
CROSS APPLY STRING_SPLIT(casts,',')
WHERE country LIKE '%India%'
GROUP BY value
ORDER BY no_of_times_actor_appeared DESC;

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in
--the description field. Label content contatining these keywords as 'Not Kid Friendly' and all other 
--content as 'Kid Friendly'. Count how many items fall into each category.


WITH new_table AS
(SELECT 
    *,
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'not_kid_friendly'
        ELSE 'kid_friendly'
    END AS category
FROM netflix)
SELECT 
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY category;

