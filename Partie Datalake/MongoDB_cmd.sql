##MongoDB

----------------------importer le fichier Client_5.csv et Client_13.csv sur MongoDB-------------

--start MongoDB
importer le fichier Catalogue.csv sur Oracle NoSQL

--Connect with MongoDB client
mongo

--Créer un database concessionnaire
use concessionnaire

--afficher les databases sur MongoDB
show dbs

--créer une collection Client
db.createCollection("client")

--afficher toutes les collections
show collections

--importer le fichier Client_5.csv et Client13.csv dans la collection client
mongoimport -d concessionnaire -c clients --type csv --file "/home/vagrant/Projet_Big_Data/Clients_5.csv" --headerline
mongoimport -d concessionnaire -c clients --type csv --file "/home/vagrant/Projet_Big_Data/Clients_13.csv" --headerline

--exporter la collection client vers un fichier client.csv
mongoexport --db=concessionnaire --collection=client --type=csv --fields=age,sexe,taux,situationFamiliale,nbEnfantsAcharge,2emevoiture,imatriculation --out=./Clientsmongodb.csv

--déposer le fichier Clientsmongodb.csv sur HDFS
hadoop fs -mkdir /Client

hadoop fs -put ./Clientsmongodb.csv /Client

hadoop fs -ls /Client

--connecter sur hive
beeline -u jdbc:hive2://localhost:10000 vagrant

--créer une table interne client 
CREATE TABLE if not exists client(age INT, sexe STRING, taux INT, situationFamiliale STRING, nbEnfantsAcharge INT, 2emevoiture STRING, immatriculation STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Pour importer le fichier clientmondb.csv dans la table interne client sur Hive
load data inpath '/Client/Clientsmongodb.csv' overwrite into table client;

--Vérification du contenu de la table interne client dans HIVE
select * from client;