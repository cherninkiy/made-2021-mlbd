-- Самые популярные исполнители 10 самых популярных тегов ластфм 

WITH t AS (
  SELECT tag_lastfm AS tag, artist_lastfm, listeners_lastfm
  FROM artists
  LATERAL VIEW explode(split(tags_lastfm, ';')) tags AS tag_lastfm
  WHERE tags_lastfm != ''
),
t_cnt AS (
  SELECT tag, COUNT(*) AS cnt
  FROM t
  GROUP BY tag
  ORDER BY cnt DESC
  LIMIT 10
),
t_top AS (
  SELECT t.tag AS tag, cnt, artist_lastfm, listeners_lastfm
  FROM t
  INNER JOIN t_cnt ON t.tag = t_cnt.tag
),
t_max AS (
  SELECT artist_lastfm, tag, listeners_lastfm, cnt,
    MAX(listeners_lastfm) OVER(PARTITION BY tag) AS listeners_max
  FROM t_top
)
SELECT artist_lastfm, tag, cnt
FROM t_max
WHERE listeners_lastfm = listeners_max
ORDER BY cnt DESC;


-----------------------
------- RESULTS -------
-----------------------

-- artist_lastfm	      tag	                  cnt
-- Coldplay	            seen live	            81278
-- Radiohead	          rock	                64902
-- Coldplay	            electronic	          58163
-- Jason Derülo	        All	                  48631
-- Diddy - Dirty Money	under 2000 listeners	48301
-- Coldplay	            alternative	          42067
-- Coldplay	            pop	                  41557
-- Coldplay	            indie	                39333
-- Radiohead	          experimental	        37665
-- Rihanna	female      vocalists	            33097

