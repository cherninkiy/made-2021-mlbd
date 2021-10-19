-- Самый популярный тэг на ластфм

WITH t AS (
  SELECT artist_lastfm, tag
  FROM artists
  LATERAL VIEW explode(split(tags_lastfm, "; ")) tags AS tag
)
SELECT tag, COUNT(DISTINCT artist_lastfm) AS cnt
FROM t
WHERE tag <> ''
GROUP BY tag
ORDER BY cnt DESC
LIMIT 1;

-----------------------
------- RESULTS -------
-----------------------

-- tag	        cnt
-- seen live	83673