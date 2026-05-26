-- ================================================
-- PROJECT 2: Netflix Movies Analysis
-- Author:    Ngatia Thumari
-- Date:      May 2026
-- Dataset:   Netflix Movies Dataset (Kaggle)
-- Tool:      MySQL Workbench
-- GitHub:    github.com/NgatiaThumari/sql-portfolio
-- ================================================


-- ================================================
-- LEVEL 1: BEGINNER QUERIES
-- ================================================

-- Q1: Top 20 most popular titles on Netflix
SELECT title, genre, popularity 
FROM mymoviedb
ORDER BY popularity DESC
LIMIT 20;


-- Q2: English language titles sorted by highest vote average
SELECT title, release_date, vote_average 
FROM mymoviedb
WHERE original_language = 'en'
ORDER BY vote_average DESC;


-- ================================================
-- LEVEL 2: INTERMEDIATE QUERIES
-- ================================================

-- Q3: Top 10 languages by number of titles available
SELECT original_language, COUNT(title) AS total_titles 
FROM mymoviedb
GROUP BY original_language
ORDER BY total_titles DESC
LIMIT 10;


-- Q4: Genre performance summary — average vote, popularity and title count
SELECT 
  genre,
  ROUND(AVG(vote_average), 2)  AS average_vote,
  ROUND(AVG(popularity), 2)    AS average_popularity,
  COUNT(title)                 AS total_titles
FROM mymoviedb
GROUP BY 1
ORDER BY 2 DESC;


-- Q5: Overall popularity statistics across the entire dataset
SELECT 
  ROUND(MAX(popularity), 2) AS highest_popularity,
  ROUND(MIN(popularity), 2) AS lowest_popularity,
  ROUND(AVG(popularity), 2) AS average_popularity
FROM mymoviedb;


-- ================================================
-- LEVEL 3: UPPER INTERMEDIATE QUERIES
-- ================================================

-- Q6: Genres with more than 50 titles — filtering grouped results with HAVING
SELECT genre, COUNT(title) AS total_titles 
FROM mymoviedb
GROUP BY genre
HAVING COUNT(title) > 50
ORDER BY total_titles DESC;


-- Q7: Classifying titles into rating categories using CASE WHEN
SELECT title, vote_average,
  CASE
    WHEN vote_average >= 8 THEN 'Excellent'
    WHEN vote_average >= 6 THEN 'Good'
    WHEN vote_average >= 4 THEN 'Average'
    ELSE 'Poor'
  END AS rating_category
FROM mymoviedb;


-- ================================================
-- LEVEL 4: ADVANCED QUERIES
-- ================================================

-- Q8: Titles more popular than the average popularity of English titles
-- Uses a subquery scoped specifically to English language titles
SELECT title, original_language, popularity 
FROM mymoviedb
WHERE popularity > (
  SELECT AVG(popularity) 
  FROM mymoviedb 
  WHERE original_language = 'en'
)
ORDER BY popularity DESC;


-- Q9: Classifying genres as Popular or Niche vs average genre size
-- Uses a CTE (Common Table Expression) for clean, readable structure
WITH genrecounts AS (
  SELECT genre, COUNT(title) AS title_count
  FROM mymoviedb
  GROUP BY genre
)
SELECT genre, title_count,
  CASE
    WHEN title_count > (SELECT AVG(title_count) FROM genrecounts) THEN 'Popular Genre'
    ELSE 'Niche Genre'
  END AS genre_label
FROM genrecounts
ORDER BY title_count DESC;


-- ================================================
-- LEVEL 5: INTERVIEW LEVEL QUERIES
-- ================================================

-- Q10: Yearly release trend with performance label
-- Uses a CTE to pre-aggregate by year, then applies CASE WHEN on top
WITH mrelease AS (
  SELECT 
    YEAR(release_date)         AS release_year,
    COUNT(title)               AS titles_released,
    ROUND(AVG(popularity), 2)  AS average_popularity
  FROM mymoviedb
  GROUP BY 1
)
SELECT release_year, titles_released, average_popularity,
  CASE
    WHEN titles_released > 500 THEN 'Peak Year'
    ELSE 'Regular Year'
  END AS performance
FROM mrelease
ORDER BY release_year ASC; -- ASC = chronological order (oldest to newest)


-- ================================================
-- BONUS: PORTFOLIO SHOWPIECE QUERY
-- Top 5 genres combining aggregation, CASE WHEN, ORDER BY and LIMIT
-- ================================================

-- Top 5 genres by average popularity with watchability label
SELECT 
  genre,
  ROUND(AVG(popularity), 2)    AS average_popularity,
  ROUND(AVG(vote_average), 2)  AS average_vote,
  COUNT(title)                 AS total_titles,
  CASE
    WHEN AVG(vote_average) > 7 THEN 'Binge Worthy'
    ELSE 'Casual Watch'
  END AS watchability
FROM mymoviedb
GROUP BY genre
ORDER BY average_popularity DESC
LIMIT 5;