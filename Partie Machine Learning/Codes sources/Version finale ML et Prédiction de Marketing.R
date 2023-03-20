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

##ajouter colonne taux_classe et supprimer colonne taux
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



#-------------------
install.packages("nnet")
library("nnet")

## ---- NNET ----
nnet <- nnet(categories ~., Clients_Immatriculations_traite_EA, size=6, maxit=180, act.fct = "softmax")
nn_class <- predict(nnet, Clients_Immatriculations_traite_ET, type="class")
table(nn_class)
table(Clients_Immatriculations_traite_ET$categories, nn_class)
nn_prob <- predict(nnet, Clients_Immatriculations_traite_ET, type="raw")
nn_auc <-multiclass.roc(Clients_Immatriculations_traite_ET$categories, nn_prob)
print(nn_auc)

#---------
#predict
##nettoyer marketing
## renommer des colonnes
names(Marketing)[1] <- "id"
names(Marketing)[2] <- "age"
names(Marketing)[3] <- "sexe"
names(Marketing)[4] <- "taux"
names(Marketing)[5] <- "situationfamiliale"
names(Marketing)[6] <- "nbenfantsacharge "
names(Marketing)[7] <- "deuxiemevoiture"


## changer les types et suprimer des colonnes qui contient des valeurs nulls
Marketing$age <- as.factor(Marketing$age)
Marketing$sexe <- as.factor(Marketing$sexe)
Marketing$taux <- as.integer(Marketing$taux)
Marketing$situationfamiliale <- as.factor(Marketing$situationfamiliale)
Marketing$nbenfantsacharge <- as.factor(Marketing$nbenfantsacharge)
Marketing$deuxiemevoiture<- as.factor(Marketing$deuxiemevoiture)


Marketing_sans_na <- na.omit(Marketing)
Marketing_sans_na <- droplevels(Marketing_sans_na)

Marketing_traite <- Marketing_sans_na[,-6]

#ajouter colonne taux_classe et supprimer colonne taux
Marketing_traite$taux_classe <- ifelse(Marketing_traite$taux <= 588,"tauxbas",
                                       ifelse(Marketing_traite$taux > 588& Marketing_traite$taux <=899,"tauxmoyen",
                                              ifelse(Marketing_traite$taux > 899& Marketing_traite$taux <=1144,"tauxeleve",
                                                     ifelse(Marketing_traite$taux > 1144,"tauxtreseleve ","Rien"))))

Marketing_traite$taux_classe <- as.factor(Marketing_traite$taux_classe)
Marketing_traite <- Marketing_traite[,-4]
names(Marketing_traite)[7] <- "taux"
# supprimer Marketing id
Marketing_traite <- Marketing_traite[,-1]

Marketing_traite$situationfamiliale <- gsub("C�libataire", "Celibataire", Marketing_traite$situationfamiliale)

#changer les types à factor
Marketing_traite$age <- as.factor(Marketing_traite$age)
Marketing_traite$sexe <- as.factor(Marketing_traite$sexe)
Marketing_traite$nbenfantsacharge <- as.factor(Marketing_traite$nbenfantsacharge)
Marketing_traite$taux <- as.factor(Marketing_traite$taux)
summary(Marketing_traite)

classpred <- predict(nnet, Marketing_traite, type = "class")
##classpred <- predict(nnet, Marketing_traite)
table(classpred)
classpredresultat <- data.frame(Marketing_traite, classpred)

resultat <- data.frame(Marketing_traite, classpred)

View(resultat)
show(resultat)
