

co2mapreduce <- read.csv("C:/MBDS/VM/vagrant-projects-staging/OracleDatabase/21.3.0/Groupe_TPT_6/co2_result.csv", 
                         header = FALSE, sep = "\t", dec = ".")

catalogue <- read.csv("C:/MBDS/VM/vagrant-projects-staging/OracleDatabase/21.3.0/Groupe_TPT_6/Catalogue.csv", 
                      header = TRUE, sep = ",", dec = ".")

View(co2mapreduce)
View(catalogue)

#Modifications des data-frames
colnames(co2mapreduce) <- c("marque","Bonus_Malus","Rejet","Cout_Energie")

co2mapreduce$marque = tolower(co2mapreduce$marque)
catalogue$marque = tolower(catalogue$marque)

#Jointure entre les deux data-frames
catalogue_modifie <- merge(catalogue,co2mapreduce, by= "marque", all = TRUE)



#Moyenne des colonnes pour remplacer les NA
moy_Bonus_Malus <- mean(co2mapreduce$Bonus_Malus)
moy_rejet <- mean(co2mapreduce$Rejet)
moy_cout <- mean(co2mapreduce$Cout_Energie)

#Remplacement des NA dans les colonnes
catalogue_modifie$Bonus_Malus[is.na(catalogue_modifie$`Bonus_Malus`)] <- moy_Bonus_Malus
catalogue_modifie$Rejet[is.na(catalogue_modifie$Rejet)] <- moy_rejet
catalogue_modifie$Cout_Energie[is.na(catalogue_modifie$Cout_Energie)] <- moy_cout


#Enlever les marques pour lequel nous n'avons pas de voiture
catalogue_modifie <- na.omit(catalogue_modifie)


View(catalogue_modifie)

write.table(catalogue_modifie, file = 'C:/MBDS/VM/vagrant-projects-staging/OracleDatabase/21.3.0/Groupe_TPT_6/Catalogue_Modifie.csv', 
            sep=",", dec = ".", row.names = F, quote = F)
