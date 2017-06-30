#!/bin/bash

read -p "Saisissez votre civilité : " civilite
read -p "Saisissez votre nom : " nom
read -p "Saisissez votre prénom : " prenom
read -p "Saisissez votre date de naissance (jj/mm/aa) : " j m a #j: jour, m; mois, a: annee
read -p "Saisissez votre situation familiale : " situFami
read -p "Saisissez le nombre d'enfants dont vous avez à charge : " nbrEnfEnCharg
read -p "Saisissez votre nationalité : " nationalite
read -p "Saisissez votre profession : " profession

touch Personnes # on creation du fichier Personnes
echo "$civilite;$nom;$prenom;$j/$m/$a;$situFami;$nbrEnfEnCharg;$nationalite;$profession" >> Personnes # ajoue de l'information dans le fichier Personnes
cp Personnes peopels # creation d'une copie intermediaire pour effectuer le tri
sort peopels > Personnes; rm peopels	
cp ./Personnes /tmp # sauvegarde d'une copie du fichier Personnes dans le repertoire /tmp.