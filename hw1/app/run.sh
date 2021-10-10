#!/bin/bash

HADOOP_STREAMING_JAR=/opt/hadoop-3.2.1/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar

LOCAL_INPUT=AB_NYC_2019.csv
LOCAL_OUTPUT=result.txt
NUM_REDUCE_TASKS=3
HDFS_INPUT=/${LOCAL_INPUT##*/}
HDFS_OUTPUT=/results

cd /app

# replace number of reducers in mapper.py
sed -i "s/^NUM_REDUCERS=.\+/NUM_REDUCERS=$NUM_REDUCE_TASKS/g" mapper.py

hdfs dfs -rm -r $HDFS_OUTPUT
hdfs dfs -put $LOCAL_INPUT $HDFS_INPUT

yarn jar $HADOOP_STREAMING_JAR \
	-files mapper.py,reducer.py \
	-mapper "python3 mapper.py" \
	-reducer "python3 reducer.py" \
	-numReduceTasks $NUM_REDUCE_TASKS \
	-input $HDFS_INPUT \
	-output $HDFS_OUTPUT

echo ""
echo "Partial results:"
hdfs dfs -cat $HDFS_OUTPUT/*

# run collector script to collect mean and variance
hdfs dfs -cat $HDFS_OUTPUT/* | python3 collector.py > $LOCAL_OUTPUT

echo ""
echo "Cluster computations:"
cat $LOCAL_OUTPUT

echo ""
echo "Direct computations:"
echo ">cat \$LOCAL_INPUT | python3 mapper.py | sort | python3 reducer.py"
cat $LOCAL_INPUT | python3 mapper.py | sort | python3 reducer.py

echo ""