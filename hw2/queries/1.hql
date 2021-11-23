-- Исполнитель с максимальным числом скробблов

SELECT artist_lastfm
FROM artists
WHERE scrobbles_lastfm IN (
  SELECT MAX(scrobbles_lastfm)
  FROM artists
);

-----------------------
------- RESULTS -------
-----------------------

-- tb.artist_lastfm
-- The Beatles