#!/bin/bash

hdfs dfsadmin -safemode leave

hdfs dfs -rm /user/data
hdfs dfs -mkdir -p /user/data
hdfs dfs -put /user/artists.csv /user/data/

hive -f /user/artists.ddl

tail -f /dev/null