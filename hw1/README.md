## Блок 1. Развертывание локального кластера Hadoop

- NameNode
- ResourceManager

## Блок 2. Работа с HDFS

### Флаги “-mkdir” и “-touchz“

1. [2 балла] Создайте папку в корневой HDFS-папке.

        hdfs dfs -mkdir /newfolder

2. [2 балла] Создайте в созданной папке новую вложенную папку.

        hdfs dfs -mkdir -p /newfolder/subfolder

3. [3 балла] Что такое Trash в  распределенной FS? Как сделать так, чтобы файлы удалялись сразу, минуя  “Trash”?

    Папка .Trash в домашнем каталоге пользователя, в которую временно помещаются удаленные файлы.

        hdfs dfs -mkdir -p /newfolder/subfolder

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

### “hdfs fsck”

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
