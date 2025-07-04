-- Script SQL génération données synthétiques assurance vie

use assurance_vie;
DROP TABLE IF EXISTS sinistres;
DROP TABLE IF EXISTS beneficiaires;
DROP TABLE IF EXISTS valeurs_contrat;
DROP TABLE IF EXISTS operations;
DROP TABLE IF EXISTS contrats;
DROP TABLE IF EXISTS intermediaires;
DROP TABLE IF EXISTS produits;
DROP TABLE IF EXISTS clients;

-- table clients

CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    date_naissance DATE,
    revenu_annuel DECIMAL(10,2),
    adresse VARCHAR(100),
    ville VARCHAR(50),
    code_postal VARCHAR(10)
);

-- table produits

CREATE TABLE produits (
    produit_id INT PRIMARY KEY AUTO_INCREMENT,
    nom_produit VARCHAR(100),
    type_produit VARCHAR(50),
    description TEXT,
    taux_interet_annuel DECIMAL(4,2)
);
-- table intermediaires

CREATE TABLE intermediaires (
    intermediaire_id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    telephone VARCHAR(20),
    email VARCHAR(50)
);
-- tables contrats

CREATE TABLE contrats (
    contrat_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    produit_id INT,
    intermediaire_id INT,
    date_signature DATE,
    date_cloture DATE NULL,
    capital_initial DECIMAL(12,2),
    statut ENUM('actif', 'cloture'),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id),
    FOREIGN KEY (intermediaire_id) REFERENCES intermediaires(intermediaire_id)
);

-- table operations

CREATE TABLE operations (
    operation_id INT PRIMARY KEY AUTO_INCREMENT,
    contrat_id INT,
    date_operation DATE,
    type_operation ENUM('versement', 'rachat'),
    montant DECIMAL(12,2),
    FOREIGN KEY (contrat_id) REFERENCES contrats(contrat_id)
);

-- table valeurs_contrats

CREATE TABLE valeurs_contrat (
    valeur_id INT PRIMARY KEY AUTO_INCREMENT,
    contrat_id INT,
    date_valeur DATE,
    valeur DECIMAL(12,2),
    FOREIGN KEY (contrat_id) REFERENCES contrats(contrat_id)
);

-- table beneficiaires

CREATE TABLE beneficiaires (
    beneficiaire_id INT PRIMARY KEY AUTO_INCREMENT,
    contrat_id INT,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    lien VARCHAR(50),
    pourcentage DECIMAL(5,2),
    FOREIGN KEY (contrat_id) REFERENCES contrats(contrat_id)
);

-- table sinistres

CREATE TABLE sinistres (
    sinistre_id INT PRIMARY KEY AUTO_INCREMENT,
    contrat_id INT,
    date_sinistre DATE,
    type_sinistre ENUM('deces', 'versement'),
    montant DECIMAL(12,2),
    description TEXT,
    FOREIGN KEY (contrat_id) REFERENCES contrats(contrat_id)
);
-- tables alertes_clients

CREATE TABLE IF NOT EXISTS alertes_clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    age INT,
    contrat_id INT,
    date_alerte DATE,
    message TEXT,
    statut VARCHAR(20) DEFAULT 'nouvelle'
);
