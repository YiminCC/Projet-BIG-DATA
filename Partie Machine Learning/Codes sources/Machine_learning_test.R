#analyse
ggplot(Catalogue_traite, aes(x=puissance))+geom_bar()
Dggplot(Catalogue_traite, aes(x=longueur))+geom_bar()
ggplot(Catalogue_traite, aes(x=nbplaces))+geom_bar()
ggplot(Catalogue_traite, aes(x=nbportes))+geom_bar()
ggplot(Catalogue_traite, aes(x=couleur))+geom_bar()


ggplot(Catalogue_traite, aes(x = nbportes)) +geom_histogram() + facet_wrap(~longueur)

ggplot(Catalogue_traite, aes(x = puissance)) +geom_histogram() + facet_wrap(~longueur)

ggplot(Catalogue_traite, aes(x = nbplaces)) +geom_histogram() + facet_wrap(~longueur)



## ---- créer les catégories ----
Catalogue_traite$categories <- ifelse(Catalogue_traite$longueur=="courte","minicar",
                                      ifelse(Catalogue_traite$longueur=="moyenne","compacte",
                                             ifelse(Catalogue_traite$longueur=="longue" & Catalogue_traite$puissance < 185 & Catalogue_traite$nbplaces == 5 ,"Routiere",
                                                    ifelse(Catalogue_traite$longueur=="longue" & Catalogue_traite$puissance < 185 & Catalogue_traite$nbplaces == 7 ,"suv",
                                                           ifelse(Catalogue_traite$longueur=="longue" | Catalogue_traite$longueur=="tres longue" & Catalogue_traite$puissance >=185 & Catalogue_traite$puissance <250 ,"sportive",
                                                                  ifelse(Catalogue_traite$longueur == "tres longue" & Catalogue_traite$puissance >= 250 , "berline","Rien"))))))
Catalogue_traite$categories <- as.factor(Catalogue_traite$categories)
summary(Catalogue_traite)

Immatriculations_traite$categories <- ifelse(Immatriculations_traite$longueur=="courte","minicar",
                                             ifelse(Immatriculations_traite$longueur=="moyenne","compacte",
                                                    ifelse(Immatriculations_traite$longueur=="longue"& Immatriculations_traite$puissance < 185 & Immatriculations_traite$nbplaces == 5,"Routiere",
                                                           ifelse(Immatriculations_traite$longueur=="longue"& Immatriculations_traite$puissance < 185 & Immatriculations_traite$nbplaces == 7,"suv",
                                                                  ifelse(Immatriculations_traite$longueur=="longue" | Immatriculations_traite$longueur=="tres longue" & Immatriculations_traite$puissance >=185 & Immatriculations_traite$puissance <250,"sportive",
                                                                         ifelse(Immatriculations_traite$longueur == "tres longue" & Immatriculations_traite$puissance >= 250, "berline","Rien")))))) 
Immatriculations_traite$categories <- as.factor(Immatriculations_traite$categories)
summary(Immatriculations_traite)

#-------------------
##situation1: normal

#mix clients et Immaticulations
Clients_Immatriculations <- merge(Immatriculations_traite, Clients_traite, by ="immatriculation")
Clients_Immatriculations <- Clients_Immatriculations[,-1]

Clients_Immatriculations <- subset(Clients_Immatriculations, select = -marque)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nom)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -puissance)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -longueur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbplaces)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbportes)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -couleur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -occasion)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -prix)
summary(Clients_Immatriculations)

Clients_Immatriculations$age <- as.factor(Clients_Immatriculations$age)
Clients_Immatriculations$sexe <- as.factor(Clients_Immatriculations$sexe)
Clients_Immatriculations$taux <- as.factor(Clients_Immatriculations$taux)
Clients_Immatriculations$situationfamiliale <- as.factor(Clients_Immatriculations$situationfamiliale)
Clients_Immatriculations$nbenfantsacharge <- as.factor(Clients_Immatriculations$nbenfantsacharge)
Clients_Immatriculations$deuxiemevoiture <- as.factor(Clients_Immatriculations$deuxiemevoiture)
Clients_Immatriculations$categories <- as.factor(Clients_Immatriculations$categories)
summary(Clients_Immatriculations)

Clients_Immatriculations_traite_EA <- Clients_Immatriculations[1:55114,]
Clients_Immatriculations_traite_ET <- Clients_Immatriculations[55115:78734,]
#-----------------------------------
##situation2: supprimer colonne taux

#mix clients et Immaticulations
Clients_Immatriculations <- merge(Immatriculations_traite, Clients_traite, by ="immatriculation")
Clients_Immatriculations <- Clients_Immatriculations[,-1]

Clients_Immatriculations <- subset(Clients_Immatriculations, select = -marque)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nom)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -puissance)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -longueur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbplaces)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbportes)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -couleur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -occasion)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -prix)
summary(Clients_Immatriculations)

Clients_Immatriculations$age <- as.factor(Clients_Immatriculations$age)
Clients_Immatriculations$sexe <- as.factor(Clients_Immatriculations$sexe)
Clients_Immatriculations$taux <- as.factor(Clients_Immatriculations$taux)
Clients_Immatriculations$situationfamiliale <- as.factor(Clients_Immatriculations$situationfamiliale)
Clients_Immatriculations$nbenfantsacharge <- as.factor(Clients_Immatriculations$nbenfantsacharge)
Clients_Immatriculations$deuxiemevoiture <- as.factor(Clients_Immatriculations$deuxiemevoiture)
Clients_Immatriculations$categories <- as.factor(Clients_Immatriculations$categories)
summary(Clients_Immatriculations)

Clients_Immatriculations_traite_EA <- Clients_Immatriculations[1:55114,]
Clients_Immatriculations_traite_ET <- Clients_Immatriculations[55115:78734,]

Clients_Immatriculations_traite_EA <- subset(Clients_Immatriculations_traite_EA , select = -taux)
Clients_Immatriculations_traite_ET <- subset(Clients_Immatriculations_traite_ET , select = -taux)

#-----------------------------------
##situation3: supprimer colonne taux et colonne age

#mix clients et Immaticulations
Clients_Immatriculations <- merge(Immatriculations_traite, Clients_traite, by ="immatriculation")
Clients_Immatriculations <- Clients_Immatriculations[,-1]

Clients_Immatriculations <- subset(Clients_Immatriculations, select = -marque)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nom)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -puissance)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -longueur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbplaces)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbportes)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -couleur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -occasion)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -prix)
summary(Clients_Immatriculations)

Clients_Immatriculations$age <- as.factor(Clients_Immatriculations$age)
Clients_Immatriculations$sexe <- as.factor(Clients_Immatriculations$sexe)
Clients_Immatriculations$taux <- as.factor(Clients_Immatriculations$taux)
Clients_Immatriculations$situationfamiliale <- as.factor(Clients_Immatriculations$situationfamiliale)
Clients_Immatriculations$nbenfantsacharge <- as.factor(Clients_Immatriculations$nbenfantsacharge)
Clients_Immatriculations$deuxiemevoiture <- as.factor(Clients_Immatriculations$deuxiemevoiture)
Clients_Immatriculations$categories <- as.factor(Clients_Immatriculations$categories)
summary(Clients_Immatriculations)

Clients_Immatriculations_traite_EA <- Clients_Immatriculations[1:55114,]
Clients_Immatriculations_traite_ET <- Clients_Immatriculations[55115:78734,]
Clients_Immatriculations_traite_EA <- subset(Clients_Immatriculations_traite_EA , select = -taux)
Clients_Immatriculations_traite_ET <- subset(Clients_Immatriculations_traite_ET , select = -taux)
Clients_Immatriculations_traite_EA <- subset(Clients_Immatriculations_traite_EA , select = -age)
Clients_Immatriculations_traite_ET <- subset(Clients_Immatriculations_traite_ET , select = -age)

#-----------------------------------
##situation4: #ajouter colonne taux_classe et supprimer colonne taux

#mix clients et Immaticulations
Clients_Immatriculations <- merge(Immatriculations_traite, Clients_traite, by ="immatriculation")
Clients_Immatriculations <- Clients_Immatriculations[,-1]

Clients_Immatriculations <- subset(Clients_Immatriculations, select = -marque)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nom)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -puissance)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -longueur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbplaces)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbportes)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -couleur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -occasion)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -prix)
summary(Clients_Immatriculations)

boxplot(Clients_Immatriculations$taux)
summary(Clients_Immatriculations$taux)
Clients_Immatriculations$taux_classe <- ifelse(Clients_Immatriculations$taux <= 588,"tauxbas",
                                               ifelse(Clients_Immatriculations$taux > 588& Clients_Immatriculations$taux <=899,"tauxmoyen",
                                                      ifelse(Clients_Immatriculations$taux > 899& Clients_Immatriculations$taux <=1144,"tauxeleve",
                                                             ifelse(Clients_Immatriculations$taux > 1144,"tauxtreseleve ","Rien"))))

Clients_Immatriculations$taux_classe <- as.factor(Clients_Immatriculations$taux_classe)

Clients_Immatriculations$age <- as.factor(Clients_Immatriculations$age)
Clients_Immatriculations$sexe <- as.factor(Clients_Immatriculations$sexe)
Clients_Immatriculations$taux <- as.factor(Clients_Immatriculations$taux)
Clients_Immatriculations$situationfamiliale <- as.factor(Clients_Immatriculations$situationfamiliale)
Clients_Immatriculations$nbenfantsacharge <- as.factor(Clients_Immatriculations$nbenfantsacharge)
Clients_Immatriculations$deuxiemevoiture <- as.factor(Clients_Immatriculations$deuxiemevoiture)
Clients_Immatriculations$categories <- as.factor(Clients_Immatriculations$categories)
summary(Clients_Immatriculations)

Clients_Immatriculations_traite <- Clients_Immatriculations 
Clients_Immatriculations_traite <- subset(Clients_Immatriculations_traite , select = -taux)
names(Clients_Immatriculations_traite)[7] <- "taux"
summary(Clients_Immatriculations_traite)

Clients_Immatriculations_traite_EA <- Clients_Immatriculations_traite[1:55114,]
Clients_Immatriculations_traite_ET <- Clients_Immatriculations_traite[55115:78734,]

#----------------------------------
#-----------------------------
##situation5: ajouter colonne taux_classe et colonne age_classe après supprimer colonne taux et colonne âge

#mix clients et Immaticulations
Clients_Immatriculations <- merge(Immatriculations_traite, Clients_traite, by ="immatriculation")
Clients_Immatriculations <- Clients_Immatriculations[,-1]

Clients_Immatriculations <- subset(Clients_Immatriculations, select = -marque)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nom)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -puissance)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -longueur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbplaces)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -nbportes)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -couleur)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -occasion)
Clients_Immatriculations <- subset(Clients_Immatriculations, select = -prix)
summary(Clients_Immatriculations)
  
boxplot(Clients_Immatriculations$age)
summary(Clients_Immatriculations$age)
Clients_Immatriculations$age_classe <- ifelse(Clients_Immatriculations$age <= 27,"jeune",
                                              ifelse(Clients_Immatriculations$age > 27& Clients_Immatriculations$age <=44,"agemoyen",
                                                     ifelse(Clients_Immatriculations$age > 44& Clients_Immatriculations$age <=57,"adulte",
                                                            ifelse(Clients_Immatriculations$age > 57,"Aînés ","Rien"))))

Clients_Immatriculations$age_classe <- as.factor(Clients_Immatriculations$age_classe)
boxplot(Clients_Immatriculations$taux)
summary(Clients_Immatriculations$taux)
Clients_Immatriculations$taux_classe <- ifelse(Clients_Immatriculations$taux <= 588,"tauxbas",
                                               ifelse(Clients_Immatriculations$taux > 588& Clients_Immatriculations$taux <=899,"tauxmoyen",
                                                      ifelse(Clients_Immatriculations$taux > 899& Clients_Immatriculations$taux <=1144,"tauxeleve",
                                                             ifelse(Clients_Immatriculations$taux > 1144,"tauxtreseleve ","Rien"))))

Clients_Immatriculations$taux_classe <- as.factor(Clients_Immatriculations$taux_classe)

Clients_Immatriculations$age <- as.factor(Clients_Immatriculations$age)
Clients_Immatriculations$sexe <- as.factor(Clients_Immatriculations$sexe)
Clients_Immatriculations$taux <- as.factor(Clients_Immatriculations$taux)
Clients_Immatriculations$situationfamiliale <- as.factor(Clients_Immatriculations$situationfamiliale)
Clients_Immatriculations$nbenfantsacharge <- as.factor(Clients_Immatriculations$nbenfantsacharge)
Clients_Immatriculations$deuxiemevoiture <- as.factor(Clients_Immatriculations$deuxiemevoiture)
Clients_Immatriculations$categories <- as.factor(Clients_Immatriculations$categories)
summary(Clients_Immatriculations)

Clients_Immatriculations_traite <- Clients_Immatriculations 
Clients_Immatriculations_traite <- subset(Clients_Immatriculations_traite , select = -age)
Clients_Immatriculations_traite <- subset(Clients_Immatriculations_traite , select = -taux)
names(Clients_Immatriculations_traite)[6] <- "age"
names(Clients_Immatriculations_traite)[7] <- "taux"
summary(Clients_Immatriculations_traite)

Clients_Immatriculations_traite_EA <- Clients_Immatriculations_traite[1:55114,]
Clients_Immatriculations_traite_ET <- Clients_Immatriculations_traite[55115:78734,]



#-------------------
install.packages("C50")
install.packages("pROC")
install.packages("naivebayes")
install.packages("randomForest")
install.packages("nnet")

library("C50")
library("pROC")
library("naivebayes")
library("randomForest")
library("nnet")

## ---- ---- c50 ------------
treec <- C5.0(categories ~., Clients_Immatriculations_traite_EA)
print(treec)

test_treec <- predict(treec, Clients_Immatriculations_traite_ET, type = "class")
table(test_treec)

table(Clients_Immatriculations_traite_ET$categories, test_treec)
c_prob <- predict(treec, Clients_Immatriculations_traite_ET, type = "prob")

c_auc <- multiclass.roc(Clients_Immatriculations_traite_ET$categories, c_prob)
print(c_auc) 
## ---- ---- naivebayes ------------
nb <- naive_bayes(categories~., Clients_Immatriculations_traite_EA)
nb_class <- predict(nb, Clients_Immatriculations_traite_ET, type = "class")
table(nb_class)
table( Clients_Immatriculations_traite_ET$categories, nb_class)
nb_prob <- predict(nb, Clients_Immatriculations_traite_ET, type="prob")
# Installation du package
nb_auc <-multiclass.roc(Clients_Immatriculations_traite_ET$categories, nb_prob)
print(nb_auc)

## ---- Random Forest ----
Clients_Immatriculations_traite_EA3 <- Clients_Immatriculations_traite_EA
Clients_Immatriculations_traite_ET3 <- Clients_Immatriculations_traite_ET

RF <- randomForest(categories ~ ., Clients_Immatriculations_traite_EA3)
result.RF <- predict(RF,Clients_Immatriculations_traite_ET3, type="response")
table(result.RF)
table(Clients_Immatriculations_traite_ET3$categories, result.RF)
rf_prob <- predict(RF, Clients_Immatriculations_traite_ET3, type="prob")
RF_auc <-multiclass.roc(Clients_Immatriculations_traite_ET$categories, rf_prob)
print (RF_auc)
## ---- NNET ----
nnet <- nnet(categories ~., Clients_Immatriculations_traite_EA, size=6, maxit=180, act.fct = "softmax")
nn_class <- predict(nnet, Clients_Immatriculations_traite_ET, type="class")
table(nn_class)
table(Clients_Immatriculations_traite_ET$categories, nn_class)
nn_prob <- predict(nnet, Clients_Immatriculations_traite_ET, type="raw")
nn_auc <-multiclass.roc(Clients_Immatriculations_traite_ET$categories, nn_prob)
print(nn_auc)

## ----  un modèle de régression logistique multinomiale ----
# Entraîner  un modèle de régression logistique multinomiale
model <- multinom(categories ~., data = Clients_Immatriculations_traite_EA)
# Faire des prédictions sur les données de test
predictions <- predict(model, newdata = Clients_Immatriculations_traite_ET)
# Vérifier les performances du modèle
confusion_matrix <- table(predictions, Clients_Immatriculations_traite_ET$categories)
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
print (accuracy)
