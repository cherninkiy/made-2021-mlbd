-- Наиболее популярные исполнители по топ 10 стран по аткивных пользователей


WITH top_countries AS (
  SELECT country_lastfm, MAX(listeners_lastfm) AS cnt
  FROM artists
  WHERE country_lastfm <> ''
  GROUP BY country_lastfm
  ORDER BY cnt DESC
  LIMIT 10
),
top_atrists AS (
  SELECT artist_lastfm, country_lastfm,
    RANK() OVER (PARTITION BY country_lastfm ORDER BY listeners_lastfm DESC) AS rnk
  FROM artists
  WHERE artist_lastfm <> ''
    AND country_lastfm IN (SELECT country_lastfm FROM top_countries)
)
SELECT DISTINCT artist_lastfm, country_lastfm
FROM top_atrists 
WHERE rnk = 1;


-----------------------
------- RESULTS -------
-----------------------

-- artist_lastfm	        country_lastfm
-- Coldplay	                United Kingdom
-- Daft Punk	            France
-- Drake	                Canada
-- Franz Ferdinand      	Scotland; United Kingdom
-- R.E.M.	                Georgia; United States
-- Red Hot Chili Peppers	United States
-- Rihanna	                United States
-- Snow Patrol	            Ireland; Scotland; United Kingdom
-- System of a Down	        Armenia; United States
-- U2   	                Ireland