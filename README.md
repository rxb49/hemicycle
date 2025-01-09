# hemicycle

Ce projet permet de scanner les QR Code des députés de l'assemblé nationale lors de leur entré dans l'hémicycle grâce à son téléphone et de voir la liste des entrées dans l'hémicycle

Utilisation d'une base de données mysql alimentée par le csv deputes-active.csv disponible par l'API suivante https://www.data.gouv.fr/fr/datasets/deputes-actifs-de-lassemblee-nationale-informations-et-statistiques/

La bdd sert a vérifier l'appartenance du QR Code par un député de l'assemblé nationale et a sauvegarder la date d'entré d'un député.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Installation

`git clone git@github.com:rxb49/hemicycle.git`

1. Mettre son téléphone en mode développeur et activer l'installation par USB

2. Connecter son téléphone à l'ordinateur avec un cable USB

3. Installer les dépendances 
    * mobile_scanner: ^6.0.2 pour le scan des QR Code
    * mysql_client: ^0.0.27 pour les requêtes à la bdd

4. Lancer le projet avec le fichier lib/main.dart et séléctionner son téléphone

5. Autoriser l'installation de l'application

6. Se connecter au réseaux de Chevrollier grâce à openVPN

7. Vous pouvez maintenant scanner les QR Code des députés de l'assemblé nationale et voir la liste des entrées


