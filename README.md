# Netflix Movies and Tv Shows : Data Analysis using SQL
![netflix_logo](https://github.com/AnuSandraWilliam/Netflix_SQL_Project/blob/main/logo.png?raw=true)
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- **Analyze the distribution of content types**: Movies vs TV shows.
- **Identify the most common ratings**: Understand the most frequent ratings for movies and TV shows.
- **List and analyze content**: Group content by release years, countries, and durations.
- **Explore and categorize content**: Use specific criteria and keywords to classify content.

## Dataset
The data for this project is sourced from the Kaggle dataset:
- Dataset Link : [Movie Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
## Schema
```sql
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
```
## Business Problems and Solutions
  ### 1. Count the Number of Movies vs TV Shows
  ```sql
SELECT 
	type,
	COUNT(*) AS Total_Content
FROM netflix
GROUP BY type;
```
#### Objective: Determine the distribution of content types on Netflix.
### 2. Find the most common rating for movies and Tv shows

```sql
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
```
#### Objective: Identify the most frequently occurring rating for each type of content.
### 3. List all movies released in a specific year(e.g., 2020)

```sql
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020
```
#### Objective: Retrieve all movies released in a specific year.

### 4. Find the top 5 countries with the most content on Netflix

```sql
SELECT TOP 5
    TRIM(value) AS new_country,
    COUNT(DISTINCT n.show_id) AS total_content
FROM netflix AS n
CROSS APPLY STRING_SPLIT(n.country, ',')
GROUP BY TRIM(value)
ORDER BY total_content DESC;
```
#### Objective: Identify the top 5 countries with the highest number of content items.
### 5. Identify the longest movie

```sql
SELECT TOP 1
    title,
    CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) AS movie_length
FROM netflix
WHERE type = 'Movie'
ORDER BY movie_length DESC;
```
#### Objective: Find the movie with the longest duration.

### 6. Find content added in the last 5 years
```sql
SELECT 
    title,
    date_added
FROM netflix
WHERE date_added >= DATEADD(YEAR, -5, GETDATE())
ORDER BY date_added DESC;
```
#### Objective: Retrieve content added to Netflix in the last 5 years.


### 7. Find all movies / Tv shows by director 'Rajiv Chilaka'
```sql 
SELECT 
	title,
	type
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';
```
#### Objective: List all content directed by 'Rajiv Chilaka'.

### 8. List all TV shows with more than 5 season
```sql
SELECT 
    title,
    duration
FROM netflix
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;
```
#### Objective: Identify TV shows with more than 5 seasons.

### 9. Count the number of content items in each genre
```sql
SELECT 
    value AS genre,
    COUNT(show_id) AS number_of_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY value
ORDER BY number_of_content DESC;
```
#### Objective: Count the number of content items in each genre.

### 10. Find each year and the average numbers of content release in India on netflix.
```sql
SELECT 
    YEAR(date_added) AS date_added_year,
    COUNT(*) AS no_of_content,
    ROUND(
        CAST(COUNT(*) AS FLOAT) / (SELECT CAST(COUNT(*) AS FLOAT) FROM netflix WHERE country LIKE '%India%') * 100, 2
    ) AS average_content
FROM netflix
WHERE country LIKE '%India%'
GROUP BY YEAR(date_added);
```
#### Objective: Calculate and rank years by the average number of content releases by India.

### 11. List all the movies that are documentaries
```sql
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%';
```
#### Objective: Retrieve all movies classified as documentaries.

### 12. Find all content without a director
```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```
#### Objective: List content that does not have a director.

### 13. Find how many movies actor 'Salman Khan' appeared in last 10 years.
```sql
SELECT 
    COUNT(*) AS no_of_movies_actor_appeared
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > YEAR(GETDATE()) - 10;
```
#### Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
```sql
SELECT TOP 10
value AS actor,
COUNT(DISTINCT show_id) AS no_of_times_actor_appeared 
FROM netflix
CROSS APPLY STRING_SPLIT(casts,',')
WHERE country LIKE '%India%'
GROUP BY value
ORDER BY no_of_times_actor_appeared DESC;
```
#### Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content contatining these keywords as 'Not Kid Friendly' and all other content as 'Kid Friendly'. Count how many items fall into each category.

```sql
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
```
#### Objective: Categorize content as 'not_kid_friendly' if it contains 'kill' or 'violence' and 'kid_friendly' otherwise. Count the number of items in each category.
## Findings and Conclusion
- Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
- Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.


This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## 📞 Contact Details

- **Email**: [anusandrawilliam@gmail.com](mailto:anusandrawilliam@gmail.com)
- **LinkedIn**: [Anu Sandra William](https://www.linkedin.com/in/anu-sandra-william-713567333/)


