##Oracle NoSQL

--------------------importer le fichier Catalogue.csv sur Oracle NoSQL-------------

--exporter le chemin
export MYPROJECTHOME=/home/vagrant/Projet_Big_Data/
--compliler le fichier Catalogue.java
javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ $MYPROJECTHOME/voiture/Catalogue.java
--executer le class Catalogue.class 
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ voiture.Catalogue

--Start KVStore using KVLite utility
nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &
--Ping KVStore
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar ping -host localhost -port 5000
--Start KVStoreAdminClient
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar runadmin -host localhost -port 5000

--connecter sur kvstore
kv-> connect store -name kvstore

--vérifier la présence des données sur Oracle NoSQL
kv-> get table -name CATALOGUE



--------------------importer le fichier Marketing.csv sur Oracle NoSQL-------------

--exporter le chemin
export MYPROJECTHOME=/home/vagrant/Projet_Big_Data/
--compliler le fichier Marketing.java
javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ $MYPROJECTHOME/voiture/Marketing.java
--executer le class Marketing.class 
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ voiture.Marketing

--Start KVStore using KVLite utility
nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &
--Ping KVStore
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar ping -host localhost -port 5000
--Start KVStoreAdminClient
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar runadmin -host localhost -port 5000

--connecter sur kvstore
kv-> connect store -name kvstore

--vérifier la présence des données sur Oracle NoSQL
kv-> get table -name MARKETING



--------------------créer table externe Catalogue_ext sur Hive qui pointe vers la table CATALOGUE dans Oracle NoSQL--------------

--se connecter sur hive
beeline -u jdbc:hive2://localhost:10000 vagrant

--supprimet d'abord la table Catalogue_ext s'il existe déjà sur Hive
drop table Catalogue_ext;

CREATE EXTERNAL TABLE Catalogue_ext(
CATALOGUEID INT,
MARQUE STRING,
NOM STRING,
PUISSANCE STRING,
LONGUEUR STRING,
NBPLACES STRING,
NBPORTES STRING,
COULEUR STRING,
OCCASION STRING,
PRIX STRING)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
    "oracle.kv.kvstore" = "kvstore",
    "oracle.kv.hosts" = "localhost:5000",
    "oracle.kv.tableName" = "CATALOGUE"
);

-- Vérification du contenu de la table externe Catalogue_ext dans HIVE
select * from Catalogue_ext;



--------------------créer table externe Marketing_ext sur Hive qui pointe vers la table MARKETING Oracle NoSQL--------------

--se connecter sur Hive
beeline -u jdbc:hive2://localhost:10000 vagrant

--supprimet d'abord la table Marketing_ext s'il existe déjà sur Hive
drop table Marketing_ext;

CREATE EXTERNAL TABLE Marketing_ext(
CLIENTMARKETINGID INT,
AGE STRING,
SEXE STRING,
TAUX STRING,
SITUATIONFAMILIALE STRING,
NBENFANTSACHARGE STRING,
DEUXIEMEVOITURE STRING)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
    "oracle.kv.kvstore" = "kvstore",
    "oracle.kv.hosts" = "localhost:5000",
    "oracle.kv.tableName" = "MARKETING"
);

-- Vérification du contenu de la table externe Marketing_ext dans HIVE
select * from Marketing_ext;




--------------créer une table interne Catalogue à partir d'une requette de la table externe Catalogue_ext sur hive------------

CREATE TABLE Catalogue
AS
SELECT CATALOGUEID, MARQUE, NOM, PUISSANCE, LONGUEUR, NBPLACES, NBPORTES,COULEUR,OCCASION,PRIX
FROM Catalogue_ext;

-- Vérification du contenu de la table interne Catalogue dans HIVE
select * from Catalogue;



--------------créer une table interne Marketing à partir d'une requette de la table externe Marketing_ext sur hive------------

CREATE TABLE Marketing
AS
SELECT CLIENTMARKETINGID, AGE, SITUATIONFAMILIALE, NBENFANTSACHARGE, DEUXIEMEVOITURE
FROM Marketing_ext

-- Vérification du contenu de la table interne Catalogue dans HIVE
select * from Marketing;