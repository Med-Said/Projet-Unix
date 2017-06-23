#!/bin/bash

read -p "Saisissez votre civilité : " civilite
read -p "Saisissez votre nom : " nom
read -p "Saisissez votre prénom : " prenom
read -p "Saisissez votre date de naissance (jj/mm/aa) : " j m a #j: jour, m; mois, a: annee
read -p "Saisissez votre situation familiale : " situFami
read -p "Saisissez le nombre d'enfants dont vous avez à charge : " nbrEnfEnCharg
read -p "Saisissez votre nationalité : " nationalite
read -p "Saisissez votre profession : " profession

case $situFami in
	[cC]) situFami="Célibataire";;
	[dD]) situFami="Divorcé(e)";;
	[mM]) situFami="Marié(e)";;
	[pP]) situFami="Pacsé(e)";;
	*) #situFami=" ";;
esac

touch Personnes #creation du fichier Personnes

newPersonne="$civilite;$nom;$prenom;$j/$m/$a;$situFami;$nbrEnfEnCharg;$nationalite;$profession"

grep "$newPersonne" Personnes > existe.txt # on cherche si la nouvelle personne est dans la liste , si oui elle sera ajouter dans le fichier existe.txt sinon le fihcie est toujours vide

nbrlignes=$(wc -l existe.txt | cut -d" " -f1) #ici on recupere le nobmre des linges du fichier existe.txt dans la variable nbrlignes

if [ $nbrlignes -eq 0 ]; then #cette if verifie si le nombre des lignes est egal a 0 , si oui alors newPersonne n'existe pas et donc on lui ajoute dans le ficher Personnes
	echo "$newPersonne" >> Personnes # ajoue de la personne dans le fichier Personnes
cp Personnes peopels # creation d'une copie intermediaire pour effectuer le tri
sort -f peopels > Personnes; rm peopels
cp ./Personnes /tmp # sauvegarde d'une copie du fichier Personnes dans le repertoire /tmp.
rm existe.txt # apres cette histoire on supprime le ficher existe.txt car il n'est plus util
fi