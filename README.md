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
