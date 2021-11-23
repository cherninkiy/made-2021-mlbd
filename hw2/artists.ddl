CREATE DATABASE test;

USE test;

DROP TABLE IF EXISTS artists;

CREATE EXTERNAL TABLE artists (
    mbid             STRING,
    artist_mb        STRING,
    artist_lastfm    STRING,
    country_mb       STRING,
    country_lastfm   STRING,
    tags_mb          STRING,
    tags_lastfm      STRING,
    listeners_lastfm BIGINT,
    scrobbles_lastfm BIGINT,
    ambiguous_artist STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    WITH SERDEPROPERTIES ('separatorChar'=',', 'quoteChar'='\"' ) 
STORED AS TEXTFILE 
LOCATION 'hdfs:///user/data/'
TBLPROPERTIES ('skip.header.line.count'='1');

