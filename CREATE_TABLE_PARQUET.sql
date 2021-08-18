https://github.com/codingtony/docker-impala


docker run  -it --name impala -p 9000:9000 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 21000:21000 -p 21050:21050 -p 25000:25000 -p 25010:25010 -p 25020:25020 -v D:/docker/AgnosticIT/impala:/local_data codingtony/impala /start-bash.sh


impala-shell -i localhost

impala-shell -i localhost -f query.sql -B --print_header --output_delimiter="|" -o query_result.csv

--------------------------------
------------SUBQUERY------------
--------------------------------

SELECT *
 FROM ( SELECT * 
          FROM awardnomination 
         WHERE Winner LIKE 'True') tabla 
WHERE ID > 579342;


--------------------------------
---CREATE TABLE AND LOAD DATA---
--------------------------------

DROP TABLE IF EXISTS Copy_AwardNomination;
CREATE TABLE
    Copy_AwardNomination
    (
        ID INT,
        IDAwardType STRING,
        Winner STRING,
        Category STRING
    )
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|';

LOAD DATA INPATH '/tmp/AwardNomination.csv' into table AwardNomination ;



---------------------------
---CREATE EXTERNAL TABLE---
---------------------------

CREATE TABLE AwardNomination 
    (ID INT, IDAwardType INT, Winner STRING, Category STRING) 
PARTITIONED BY (dt STRING) 
STORED AS PARQUET;


ALTER TABLE AwardNomination 
ADD PARTITION (dt='2021-08-14') 
LOCATION '/tmp/AwardNomination_2020_08_13.parquet';


hdfs dfs -put /local_data/AwardNomination_2020_08_13.parquet /tmp/AwardNomination_2020_08_13.parquet

hdfs dfs -put /local_data/AwardNomination_2020_08_13.parquet /user/impala/AwardNomination/dt=2020-08-13

hdfs dfs -cp "/tmp/AwardNomination_2020_08_13.parquet" "/user/impala/AwardNomination/dt=2020-08-13"



CREATE TABLE AwardNomination (
    `ID` INT,
    `IDAwardType` INT,
    `Winner` STRING,
    `Category` STRING)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY "|"
  LOCATION "hdfs:///tmp/hive/warehouse/AwardNomination/";



  hdfs dfs -put /local_data/AwardNomination.csv /tmp/hive/warehouse/AwardNomination/



  select count(ID) from AwardNomination;


  --DOWNLOAD FILE
  http://localhost:50075/webhdfs/v1/tmp/AwardNomination.csv?op=OPEN&namenoderpcaddress=172.17.0.2:9000&offset=0

  --DOWNLOAD TABLE
  http://localhost:50075/webhdfs/v1/user/hive/warehouse/awardnomination/AwardNomination.csv?op=OPEN&namenoderpcaddress=172.17.0.2:9000&offset=0
