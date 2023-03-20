package voiture;

import oracle.kv.KVStore;
import java.util.List;
import java.util.Iterator;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.FaultException;
import oracle.kv.StatementResult;
import oracle.kv.table.TableAPI;
import oracle.kv.table.Table;
import oracle.kv.table.Row;
import oracle.kv.table.PrimaryKey;
import oracle.kv.ConsistencyException;
import oracle.kv.RequestTimeoutException;
import oracle.kv.table.TableIterator;
import oracle.kv.table.EnumValue;
import java.io.File;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import java.util.StringTokenizer;
import java.util.ArrayList;

public class Catalogue {
    private final KVStore store;
    private final String tabCatalogue = "CATALOGUE";
    private final String pathToCSVFile = "/home/vagrant/Projet_Big_Data/Catalogue.csv";
    private int catalogueID = 1;

    /**
     * Runs the DDL command line program.
     */
    public static void main(String args[]) {
        try {
            Catalogue catalogue = new Catalogue(args);
            catalogue.initCatalogueTablesAndData(catalogue);
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    /**
     * Parses command line args and opens the KVStore.
     */
    Catalogue(String[] argv) {
        String storeName = "kvstore";
        String hostName = "localhost";
        String hostPort = "5000";
        final int nArgs = argv.length;
        int argc = 0;
        store = KVStoreFactory.getStore
                (new KVStoreConfig(storeName, hostName + ":" + hostPort));
    }

    /**
     * Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)
     */
    private void displayResult(StatementResult result, String statement) {
        System.out.println("===========================");
        if (result.isSuccessful()) {
            System.out.println("Statement was successful:\n\t" +
                    statement);
            System.out.println("Results:\n\t" + result.getInfo());
        } else if (result.isCancelled()) {
            System.out.println("Statement was cancelled:\n\t" +
                    statement);
        } else {
            /*
             * statement was not successful: may be in error, or may still
             * be in progress.
             */
            if (result.isDone()) {
                System.out.println("Statement failed:\n\t" + statement);
                System.out.println("Problem:\n\t" +
                        result.getErrorMessage());
            } else {
                System.out.println("Statement in progress:\n\t" +
                        statement);
                System.out.println("Status:\n\t" + result.getInfo());
            }
        }
    }

    /*
        La méthode initCatalogueTablesAndData permet :
        - de supprimer les tables si elles existent
        - de créer des tables
        - de charger les données des Catalogues
    **/
    public void initCatalogueTablesAndData(Catalogue catalogue) {
        catalogue.dropTableCatalogue();
        catalogue.createTableCatalogue();
        catalogue.loadCatalogueDataFromFile(pathToCSVFile);
    }

    /**
     * public void dropTableCatalogue()
     * M&thode de suppression de la table Catalogue.
     */
    public void dropTableCatalogue() {
        String statement = null;

        statement = "drop table " + tabCatalogue;
        executeDDL(statement);
    }

    /**
     * public void createTableCatalogue()
     * M&thode de création de la table Catalogue.
     */
    public void createTableCatalogue() {
        String statement = null;
        statement = "Create table " + tabCatalogue + " ("
                + "CATALOGUEID INTEGER,"
                + "MARQUE STRING,"
                + "NOM STRING,"
                + "PUISSANCE STRING,"
				+ "LONGUEUR STRING,"
                + "NBPLACES STRING,"
                + "NBPORTES STRING,"
                + "COULEUR STRING,"
				+ "OCCASION STRING,"
				+ "PRIX STRING,"
                + "PRIMARY KEY (CATALOGUEID))";
        executeDDL(statement);
    }

    /**
     * public void executeDDL(String statement)
     * méthode générique pour executer les commandes DDL
     */
    public void executeDDL(String statement) {
        TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;

        System.out.println("****** Dans : executeDDL ********");
        try {
            /*
             * Add a table to the database.
             * Execute this statement asynchronously.
             */
            result = store.executeSync(statement);
            displayResult(result, statement);
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    private void insertACatalogueRow(String marque, String nom, String puissance, String longueur, String nbPlaces, String nbPortes, String couleur, String occasion, String prix) {
        //TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;
        String statement = null;
        System.out.println("********************************** Dans : insertACatalogueRow *********************************");

        try {
            TableAPI tableH = store.getTableAPI();
            // The name you give to getTable() must be identical
            // to the name that you gave the table when you created
            // the table using the CREATE TABLE DDL statement.
            Table CatalogueTable = tableH.getTable(tabCatalogue);
            // Get a Row instance
            Row CatalogueRow = CatalogueTable.createRow();
            // Now put all of the cells in the row.
            // This does NOT actually write the data to
            // the store.

            // Create one row 
            CatalogueRow.put("catalogueID", catalogueID);
            CatalogueRow.put("marque", marque);
            CatalogueRow.put("nom", nom);
            CatalogueRow.put("puissance", puissance);
            CatalogueRow.put("longueur", longueur);
            CatalogueRow.put("nbPlaces", nbPlaces);
			CatalogueRow.put("nbPortes", nbPortes);
			CatalogueRow.put("couleur", couleur);
            CatalogueRow.put("occasion", occasion);
			CatalogueRow.put("prix", prix);
            // Now write the table to the store.
            // "item" is the row's primary key. If we had not set that value,
            // this operation will throw an IllegalArgumentException.
            tableH.put(CatalogueRow, null, null);
            catalogueID++;

        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    /**
     * void loadCatalogueDataFromFile(String CatalogueDataFileName)
     * cette methodes permet de charger les Catalogues depuis le fichier
     * appelé Catalogue.csv.
     * Pour chaque Catalogue chargée, la
     * méthode insertACatalogueRow sera appélée
     */
    void loadCatalogueDataFromFile(String CatalogueDataFileName) {
        InputStreamReader ipsr;
        BufferedReader br = null;
        InputStream ips;
        // Variables pour stocker les données lues d'un fichier. 
        String ligne;
        System.out.println("********************************** Dans : loadCatalogueDataFromFile *********************************");
        /* parcourir les lignes du fichier texte et découper chaque ligne */
        try {
            ips = new FileInputStream(CatalogueDataFileName);
            ipsr = new InputStreamReader(ips);
            br = new BufferedReader(ipsr);
            /* open text file to read data */
            //parcourir le fichier ligne par ligne et découper chaque ligne en 
            //morceau séparés par le symbole ;
            while ((ligne = br.readLine()) != null) {
                //int situationFamiliale, 2eme voiture, nbPortes, prix; 
                //String Catalogue, age, sexe,  nbEnfantsAcharge,  couleur, occasion, ;
                ArrayList<String> CatalogueRecord = new ArrayList<String>();
                StringTokenizer val = new StringTokenizer(ligne, ",");
                while (val.hasMoreTokens()) {
                    CatalogueRecord.add(val.nextToken().toString());
                }
                String marque = CatalogueRecord.get(0);
                String nom = CatalogueRecord.get(1);
                String puissance = CatalogueRecord.get(2);
                String longueur = CatalogueRecord.get(3);
                String nbPlaces = CatalogueRecord.get(4);
                String nbPortes = CatalogueRecord.get(5);
				String couleur = CatalogueRecord.get(6);
                String occasion = CatalogueRecord.get(7);
                String prix = CatalogueRecord.get(8);
                // Add the Catalogue in the KVStore
                this.insertACatalogueRow(marque,nom,puissance,longueur,nbPlaces,nbPortes,couleur,occasion,prix);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}