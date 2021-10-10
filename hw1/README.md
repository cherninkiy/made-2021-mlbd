## Блок 1. Развертывание локального кластера Hadoop

- NameNode

    ![NameNode](https://github.com/cherninkiy/made-2021-mlbd/blob/main/hw1/NN.png)

- ResourceManager

    ![ResourceManager](https://github.com/cherninkiy/made-2021-mlbd/blob/main/hw1/RM.png)

## Блок 2. Работа с HDFS

### Флаги “-mkdir” и “-touchz“

1. [2 балла] Создайте папку в корневой HDFS-папке.

        hdfs dfs -mkdir /newfolder

2. [2 балла] Создайте в созданной папке новую вложенную папку.

        hdfs dfs -mkdir -p /newfolder/subfolder

3. [3 балла] Что такое Trash в  распределенной FS? Как сделать так, чтобы файлы удалялись сразу, минуя  “Trash”?

    Папка .Trash в домашнем каталоге пользователя, в которую временно помещаются удаленные файлы.

        hdfs dfs -rm -r -skipTrash /newfolder/subfolder

4. [2 балла] Создайте пустой файл в подпапке из пункта 2.

        hdfs dfs -touchz /newfolder/subfolder/file

5. [2 балла] Удалите  созданный файл.

        hdfs dfs -rm /newfolder/subfolder/file

6. [2 балла] Удалите  созданные папки.

        hdfs dfs -rm -r /newfolder

### Флаги “-put”, “-cat”, “-tail”, “-cp”

1. [3 балла] Скопируйте любой в новую папку на HDFS.

        hdfs dfs -mkdir /data
        hdfs dfs -put AB_NYC_2019.csv /data

2. [3 балла] Выведите содержимое  HDFS-файла на экран.

        hdfs dfs -cat /data/AB_NYC_2019.csv

3. [3 балла] Выведите  содержимое нескольких последних строчек HDFS-файла на экран.

        hdfs dfs -tail /data/AB_NYC_2019.csv

4. [3 балла] Выведите  содержимое нескольких первых строчек HDFS-файла на экран.

        hdfs dfs -head /data/AB_NYC_2019.csv

5. [3 балла] Переместите копию  файла в HDFS на новую локацию.

        hdfs dfs -mv /data/AB_NYC_2019.csv /

### Флаги “-setrep”

2. [4  баллов]  Изменить    replication  factor  для  файла.  Как  долго  занимает  время  на  увеличение / уменьшение числа реплик для файла?

        hdfs dfs -setrep -w 1 /AB_NYC_2019.csv
        
    Увеличение / уменьшение числа реплик занимает некоторое время, которое зависил от размера файла и количества реплик.

        WARNING: the waiting time may be long for DECREASING the number of replications.

### Команда “hdfs fsck”

3. [4 баллов] Найдите  информацию по файлу, блокам и их расположениям с помощью “hdfs fsck”

        root@02dd61a87b2c:/# hdfs fsck /AB_NYC_2019.csv -files -blocks -locations

        Connecting to namenode via http://namenode:9870/fsck?ugi=root&files=1&blocks=1&locations=1&path=%2FAB_NYC_2019.csv
        FSCK started by root (auth:SIMPLE) from /172.18.0.4 for path /AB_NYC_2019.csv at Sat Oct 09 23:35:10 UTC 2021
        /AB_NYC_2019.csv 7077973 bytes, replicated: replication=3, 1 block(s):  OK
        0. BP-438692746-172.18.0.6-1633818150297:blk_1073741835_1011 len=7077973 Live_repl=3  [DatanodeInfoWithStorage[172.18.0.8:9866,DS-fc89d60c-ae3b-4412-97e5-440cbf2a3cb3,DISK], DatanodeInfoWithStorage[172.18.0.5:9866,DS-c5435957-41f2-4b44-a84f-f7b529f6e43f,DISK], DatanodeInfoWithStorage[172.18.0.7:9866,DS-11e97f33-6e4c-4b61-88e9-cb3aeffb23b2,DISK]]


        Status: HEALTHY
        Number of data-nodes:	3
        Number of racks:		1
        Total dirs:			0
        Total symlinks:		0

        Replicated Blocks:
        Total size:	7077973 B
        Total files:	1
        Total blocks (validated):	1 (avg. block size 7077973 B)
        Minimally replicated blocks:	1 (100.0 %)
        Over-replicated blocks:	0 (0.0 %)
        Under-replicated blocks:	0 (0.0 %)
        Mis-replicated blocks:		0 (0.0 %)
        Default replication factor:	3
        Average block replication:	3.0
        Missing blocks:		0
        Corrupt blocks:		0
        Missing replicas:		0 (0.0 %)

        Erasure Coded Block Groups:
        Total size:	0 B
        Total files:	0
        Total block groups (validated):	0
        Minimally erasure-coded block groups:	0
        Over-erasure-coded block groups:	0
        Under-erasure-coded block groups:	0
        Unsatisfactory placement block groups:	0
        Average block group size:	0.0
        Missing block groups:		0
        Corrupt block groups:		0
        Missing internal blocks:	0
        FSCK ended at Sat Oct 09 23:35:10 UTC 2021 in 2 milliseconds


        The filesystem under path '/AB_NYC_2019.csv' is HEALTHY

4. [4  баллов]  Получите    информацию  по  любому  блоку  из  п.2  с  помощью  "hdfs  fsck  -blockId”.

        root@02dd61a87b2c:/# hdfs fsck /AB_NYC_2019.csv -blockId blk_1073741835     

        Connecting to namenode via http://namenode:9870/fsck?ugi=root&blockId=blk_1073741835+&path=%2FAB_NYC_2019.csv
        FSCK started by root (auth:SIMPLE) from /172.18.0.4 at Sat Oct 09 23:49:03 UTC 2021

        Block Id: blk_1073741835
        Block belongs to: /AB_NYC_2019.csv
        No. of Expected Replica: 3
        No. of live Replica: 3
        No. of excess Replica: 0
        No. of stale Replica: 0
        No. of decommissioned Replica: 0
        No. of decommissioning Replica: 0
        No. of corrupted Replica: 0
        Block replica on datanode/rack: b05ee907375d/default-rack is HEALTHY
        Block replica on datanode/rack: 7bb86c4161ac/default-rack is HEALTHY
        Block replica on datanode/rack: 04bd66251a9a/default-rack is HEALTHY

    Обратите внимание на Generation Stamp (GS number).

    - consistency guarantee: All replicas should draw back to a consistence state to have the same on-disk data and generation stamp.

## Блок 3. Работа с HDFS

- mapper.py - выводит в stdout тройку (key, price, price**2), где key  - используется для распределения данных по редьюсерам

        key = num_line % num_reducers
        
- reducer.py - считает среднее и дисперсию для своего входного потока данных (сплита)

- collector.py - считает среднее и дисперсию по всем сплитам (по извествным формулам)

        root@02dd61a87b2c:/app# ./run.sh                      
        packageJobJar: [/tmp/hadoop-unjar8928419900424367720/] [] /tmp/streamjob8235711970311130848.jar tmpDir=null
        2021-10-10 16:09:25,438 INFO client.RMProxy: Connecting to ResourceManager at resourcemanager/172.18.0.2:8032
        2021-10-10 16:09:25,606 INFO client.AHSProxy: Connecting to Application History server at historyserver/172.18.0.3:10200
        2021-10-10 16:09:25,633 INFO client.RMProxy: Connecting to ResourceManager at resourcemanager/172.18.0.2:8032
        2021-10-10 16:09:25,634 INFO client.AHSProxy: Connecting to Application History server at historyserver/172.18.0.3:10200
        2021-10-10 16:09:25,824 INFO mapreduce.JobResourceUploader: Disabling Erasure Coding for path: /tmp/hadoop-yarn/staging/root/.staging/job_1633820438974_0039
        2021-10-10 16:09:26,163 INFO mapred.FileInputFormat: Total input files to process : 1
        2021-10-10 16:09:26,233 INFO mapreduce.JobSubmitter: number of splits:2
        2021-10-10 16:09:26,353 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1633820438974_0039
        2021-10-10 16:09:26,353 INFO mapreduce.JobSubmitter: Executing with tokens: []
        2021-10-10 16:09:26,505 INFO conf.Configuration: resource-types.xml not found
        2021-10-10 16:09:26,505 INFO resource.ResourceUtils: Unable to find 'resource-types.xml'.
        2021-10-10 16:09:26,764 INFO impl.YarnClientImpl: Submitted application application_1633820438974_0039
        2021-10-10 16:09:26,799 INFO mapreduce.Job: The url to track the job: http://resourcemanager:8088/proxy/application_1633820438974_0039/
        2021-10-10 16:09:26,801 INFO mapreduce.Job: Running job: job_1633820438974_0039
        2021-10-10 16:09:32,882 INFO mapreduce.Job: Job job_1633820438974_0039 running in uber mode : false
        2021-10-10 16:09:32,884 INFO mapreduce.Job:  map 0% reduce 0%
        2021-10-10 16:09:37,958 INFO mapreduce.Job:  map 50% reduce 0%
        2021-10-10 16:09:38,968 INFO mapreduce.Job:  map 100% reduce 0%
        2021-10-10 16:09:43,001 INFO mapreduce.Job:  map 100% reduce 33%
        2021-10-10 16:09:46,021 INFO mapreduce.Job:  map 100% reduce 67%
        2021-10-10 16:09:49,042 INFO mapreduce.Job:  map 100% reduce 100%
        2021-10-10 16:09:49,056 INFO mapreduce.Job: Job job_1633820438974_0039 completed successfully
        2021-10-10 16:09:49,152 INFO mapreduce.Job: Counters: 54
                File System Counters
                        FILE: Number of bytes read=117204
                        FILE: Number of bytes written=1401468
                        FILE: Number of read operations=0
                        FILE: Number of large read operations=0
                        FILE: Number of write operations=0
                        HDFS: Number of bytes read=7078004
                        HDFS: Number of bytes written=128
                        HDFS: Number of read operations=21
                        HDFS: Number of large read operations=0
                        HDFS: Number of write operations=6
                        HDFS: Number of bytes read erasure-coded=0
                Job Counters 
                        Launched map tasks=2
                        Launched reduce tasks=3
                        Rack-local map tasks=2
                        Total time spent by all maps in occupied slots (ms)=18628
                        Total time spent by all reduces in occupied slots (ms)=53056
                        Total time spent by all map tasks (ms)=4657
                        Total time spent by all reduce tasks (ms)=6632
                        Total vcore-milliseconds taken by all map tasks=4657
                        Total vcore-milliseconds taken by all reduce tasks=6632
                        Total megabyte-milliseconds taken by all map tasks=19075072
                        Total megabyte-milliseconds taken by all reduce tasks=54329344
                Map-Reduce Framework
                        Map input records=49080
                        Map output records=48895
                        Map output bytes=741692
                        Map output materialized bytes=119538
                        Input split bytes=176
                        Combine input records=0
                        Combine output records=0
                        Reduce input groups=3
                        Reduce shuffle bytes=119538
                        Reduce input records=48895
                        Reduce output records=3
                        Spilled Records=97790
                        Shuffled Maps =6
                        Failed Shuffles=0
                        Merged Map outputs=6
                        GC time elapsed (ms)=193
                        CPU time spent (ms)=6790
                        Physical memory (bytes) snapshot=1243234304
                        Virtual memory (bytes) snapshot=35732307968
                        Total committed heap usage (bytes)=1249378304
                        Peak Map Physical memory (bytes)=299728896
                        Peak Map Virtual memory (bytes)=5138829312
                        Peak Reduce Physical memory (bytes)=242671616
                        Peak Reduce Virtual memory (bytes)=8486821888
                Shuffle Errors
                        BAD_ID=0
                        CONNECTION=0
                        IO_ERROR=0
                        WRONG_LENGTH=0
                        WRONG_MAP=0
                        WRONG_REDUCE=0
                File Input Format Counters 
                        Bytes Read=7077828
                File Output Format Counters 
                        Bytes Written=128
        2021-10-10 16:09:49,152 INFO streaming.StreamJob: Output directory: /results

        Partial results:
        16297	154.70865803522122	57277.42582735173
        16299	150.8598073501442	52888.639711626165
        16299	152.59384011289035	62844.9925284709

        Cluster computations:
        48895	152.7206871868289	57672.845698433586

        Direct computations:
        >cat $LOCAL_INPUT | python3 mapper.py | sort | python3 reducer.py
        48895	152.7206871868289	57672.8456984336
