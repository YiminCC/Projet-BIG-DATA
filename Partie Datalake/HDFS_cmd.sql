##HDFS


-- déposer le fichier Immatriculation.csv sur HDFS
hadoop fs -rm -r /Datalake_Immatriculation

hadoop fs -mkdir /Datalake_Immatriculation

hadoop fs -put /home/vagrant/Projet_Big_Data/Immatriculation.csv /Datalake_Immatriculation

hadoop fs -ls /Datalake_Immatriculation

-- lancer hadoop
stop-yarn.sh
stop-dfs.sh

-- déposer le fichier CO2.csv sur HDFS
hadoop fs -rm -r /Datalake_CO2

hadoop fs -mkdir /Datalake_CO2

hadoop fs -put /home/vagrant/Projet_Big_Data/CO2.csv /Datalake_CO2

hadoop fs -ls /Datalake_CO2

--------------------créer deux tables externes sur Hive pour pointer vers HDFS-------------

--lancer hive
nohup hive --service metastore > hive_metastore.log 2>&1 &
nohup hiveserver2 > hive_server.log 2>&1 &
beeline -u jdbc:hive2://localhost:10000 vagrant

--créer une table externe Immatriculation dans Hive qui point vers le fichier Immatriculation.csv sur HDFS
drop table Immatriculation
CREATE EXTERNAL TABLE Immatriculation (
	IMMATRICULATION STRING, 
	MARQUE STRING, 
	NOM STRING, 
	PUISSANCE INT, 
	LONGUEUR STRING, 
	NBPLACES INT, 
	NBPORTES INT, 
	COULEUR STRING, 
	OCCASION BOOLEAN, 
	PRIX INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/Datalake_Immatriculation';

-- vérifier la présence des donnée dans la table externe Immatriculation
select * from Immatriculation;

--créer une table externe CO2 dans Hive qui point vers le fichier Co2.csv sur HDFS
drop table CO2;
CREATE EXTERNAL TABLE CO2 (
    ordre int,
    MARQUEModele string,
    BonusMalus string ,
    RejetsCO2 int,
    Coutenerie string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/Datalake_CO2';

-- vérifier la présence des dans la table CO2
select * from CO2;