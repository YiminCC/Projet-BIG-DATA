#connect entre hive et RStudio après récupérer les données
library(RJDBC)
hive_jdbc_jar <- "c:/vagrant-projects/OracleDatabase/21.3.0/hive-jdbc-3.1.3-standalone.jar"
hive_driver <- "org.apache.hive.jdbc.HiveDriver"
hive_url <- "jdbc:hive2://localhost:10000"
drv <- JDBC(hive_driver, hive_jdbc_jar)
conn <- dbConnect(drv, hive_url, "vagrant", "")
show_tables <- dbGetQuery(conn, "show tables")
print(show_tables);

Catalogue <- dbGetQuery(conn, "select * from Catalogue")
summary(Catalogue)

Clients <- dbGetQuery(conn, "select * from Client")
summary(Clients)

Immatriculations <- dbGetQuery(conn, "select * from Immatriculation")
summary(Immatriculations)

Marketing <- dbGetQuery(conn, "select * from Marketing")
summary(Marketing)

Co2 <- dbGetQuery(conn, "select * from Co2")
summary(Co2)

#------------nettoyer Clients----------

## renommer des colonnes

names(Clients)[1] <- "age"
names(Clients)[2] <- "sexe"
names(Clients)[3] <- "taux"
names(Clients)[4] <- "situationfamiliale"
names(Clients)[5] <- "nbenfantsacharge"
names(Clients)[6] <- "deuxiemevoiture"
names(Clients)[7] <- "immatriculation"


## suprimer des colonnes qui contient des valeurs nulls et changer les types

Clients_sans_na <- na.omit(Clients)
Clients_sans_na <- droplevels(Clients_sans_na)
Clients_sans_na$sexe <- as.factor(Clients_sans_na$sexe)
Clients_sans_na$situationfamiliale <- as.factor(Clients_sans_na$situationfamiliale)
Clients_sans_na$deuxiemevoiture <- as.logical(Clients_sans_na$deuxiemevoiture)
summary(Clients_sans_na)


##garder des clients qui ont plus de 18 ans
Clients_traite1 <- subset(Clients_sans_na, age >= 18 )

library(ggplot2)                   
ggplot(Clients_traite1, aes(x=sexe))+geom_bar()

## reamplacer masculin/Homme par M et Femme/Féminin par F
Clients_traite1$sexe <- gsub("Masculin", "M", Clients_traite1$sexe)
Clients_traite1$sexe <- gsub("Homme", "M", Clients_traite1$sexe)
Clients_traite1$sexe <- gsub("Femme", "F", Clients_traite1$sexe)
Clients_traite1$sexe <- gsub("F�minin", "F", Clients_traite1$sexe)
Clients_traite1 <- subset(Clients_traite1, Clients_traite1$sexe!="N/D"&Clients_traite1$sexe!="?"&Clients_traite1$sexe!="")
Clients_traite1$sexe <- as.factor(Clients_traite1$sexe) 
ggplot(Clients_traite1, aes(x=sexe))+geom_bar()


# taux >= 544
Clients_traite1 <- subset(Clients_traite1, taux >= 544 )

#situationfamiliale
ggplot(Clients_traite1, aes(x=situationfamiliale))+geom_bar()

Clients_traite1 <- subset(Clients_traite1, Clients_traite1$situationfamiliale!="N/D" & Clients_traite1$situationfamiliale!="?" & Clients_traite1$situationfamiliale!="")
Clients_traite1$situationfamiliale <- gsub("C�libataire", "Celibataire", Clients_traite1$situationfamiliale)
Clients_traite1$situationfamiliale <- gsub("Divorc�e", "Divorce", Clients_traite1$situationfamiliale)
Clients_traite1$situationfamiliale <- gsub("Mari�", "Marie", Clients_traite1$situationfamiliale)
Clients_traite1$situationfamiliale <- as.factor(Clients_traite1$situationfamiliale)
ggplot(Clients_traite1, aes(x=situationfamiliale))+geom_bar()

#nbenfantsacharge >=0
Clients_traite1 <- subset(Clients_traite1, nbenfantsacharge >= 0 )

#garder que des lignes en format 9999 AA 99 dans la colonne immatriculation
Clients_traite<- Clients_traite1[grep("^\\d{4} [A-Z]{2} \\d{2}$", Clients_traite1$immatriculation), ] 

summary(Clients_traite)
#immatriculation double?
doublons <- which(duplicated(Clients_traite$immatriculation))
Clients_traite <- Clients_traite[-doublons,]
summary(Clients_traite)

#------------nettoyer Catalogue----------
## renommer des colonnes
names(Catalogue)[1] <- "id"
names(Catalogue)[2] <- "marque"
names(Catalogue)[3] <- "nom"
names(Catalogue)[4] <- "puissance"
names(Catalogue)[5] <- "longueur"
names(Catalogue)[6] <- "nbplaces"
names(Catalogue)[7] <- "nbportes"
names(Catalogue)[8] <- "couleur"
names(Catalogue)[9] <- "occasion"
names(Catalogue)[10] <- "prix"


## changer les types et suprimer des colonnes qui contient des valeurs nulls
Catalogue$marque <- as.factor(Catalogue$marque)
Catalogue$nom <- as.factor(Catalogue$nom)
Catalogue$longueur <- as.factor(Catalogue$longueur)
Catalogue$couleur <- as.factor(Catalogue$couleur)
Catalogue$occasion <- as.logical(Catalogue$occasion)
Catalogue$puissance<- as.integer(Catalogue$puissance)
Catalogue$nbplaces<- as.integer(Catalogue$nbplaces)
Catalogue$prix<- as.integer(Catalogue$prix)
Catalogue$nbportes<- as.integer(Catalogue$nbportes)

Catalogue_sans_na <- na.omit(Catalogue)
Catalogue_sans_na <- droplevels(Catalogue_sans_na)

summary(Catalogue_sans_na)
Catalogue_sans_na$longueur <- gsub("tr�s longue", "tres longue", Catalogue_sans_na$longueur)
Catalogue_sans_na$longueur <- as.factor(Catalogue_sans_na$longueur)
Catalogue_traite <- Catalogue_sans_na
summary(Catalogue_traite)

#------------nettoyer Immatriculations----------

## renommer des colonnes
names(Immatriculations)[1] <- "immatriculation "
names(Immatriculations)[2] <- "marque"
names(Immatriculations)[3] <- "nom"
names(Immatriculations)[4] <- "puissance"
names(Immatriculations)[5] <- "longueur"
names(Immatriculations)[6] <- "nbplaces"
names(Immatriculations)[7] <- "nbportes"
names(Immatriculations)[8] <- "couleur"
names(Immatriculations)[9] <- "occasion"
names(Immatriculations)[10] <- "prix"


## changer les types et suprimer des colonnes qui contient des valeurs nulls 
Immatriculations$immatriculation <- as.factor(Immatriculations$immatriculation)
Immatriculations$marque <- as.factor(Immatriculations$marque)
Immatriculations$nom <- as.factor(Immatriculations$nom)
Immatriculations$longueur <- as.factor(Immatriculations$longueur)
Immatriculations$couleur <- as.factor(Immatriculations$couleur)
Immatriculations$occasion <- as.logical(Immatriculations$occasion)

Immatriculations_sans_na <- na.omit(Immatriculations)
Immatriculations_sans_na <- droplevels(Immatriculations_sans_na)

summary(Immatriculations_sans_na)
Immatriculations_sans_na <- Immatriculations_sans_na[,-1]
Immatriculations_traite <- Immatriculations_sans_na

#garder que des lignes en format 9999 AA 99 dans la colonne immatriculation
Immatriculations_traite<- Immatriculations_traite[grep("^\\d{4} [A-Z]{2} \\d{2}$", Immatriculations_traite$immatriculation), ]
#immatriculation double?
doublons <- which(duplicated(Immatriculations_traite$immatriculation))
Immatriculations_traite <- Immatriculations_traite[-doublons,]

Immatriculations_traite$longueur <- gsub("tr�s longue", "tres longue", Immatriculations_traite$longueur)
Immatriculations_traite$longueur <- as.factor(Immatriculations_traite$longueur)

summary(Immatriculations_traite)
