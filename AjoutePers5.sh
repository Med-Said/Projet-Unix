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

	echo "ou voulez vous sauvegarder vos secours"
	select rep in "le même fichier (/tmp.personnes)" "autre fichier"
	do
		if [[ $rep = "le même fichier (/tmp.personnes)" ]]; then # sauvegarde dans le meme fichier 
			cp ./Personnes /tmp # sauvegarde d'une copie du fichier Personnes dans le repertoire /tmp.
			rm existe.txt; break # apres cette histoire on supprime le ficher existe.txt car il n'est plus util
		elif [[ $rep = "autre fichier" ]]; then # sauvegarde dans fichier autre que Personnes
			read -p "Saisissez le nom du ficher : " fileName # lecture du nom du fichier
			for file in $(ls); do # dans cette boucle for  on cherche le nome du fichier dans le repertoire courant (pour etre puls generale on peux chercher le nom le nom du ficher saisi dans tous les fichiers !!!)
				if [[ $file = $fileName ]]; then
					read -p "confirmez ? (o/n) : " con # si le nom saisi est trouve on demande la confirmation 
					if [[ $con = "o" ]]; then
						echo $newPersonne >> $fileName # si l'utilisateur confirme on effectue le copie 
					fi
				fi
			done
			rm existe.txt; break
		fi
	done
fi

#question 5

awk 'END {printf "population total : %d\n",NR}' Personnes # le nombre de population total 

awk -F";" '$1 == "M" { n++; print n }' Personnes | awk 'END {printf "population masculine : %d \n", NR}' #le nombre de la population masculine
awk -F";" '$1 == "Mlle" || $1 == "Mdm" {m++; print m}' Personnes | awk 'END {printf "populatin feminine : %d \n", NR}' # le nombre de la populatin feminine

awk -F";" '$5 ~ /^C/ { n++; print n}' Personnes| awk 'END {printf "population Célibataire : %d \n", NR}' #le nombre de population Célibataires
awk -F";" '$5 ~ /^C/ && $1 == "M" { n++; print n}' Personnes | awk 'END {printf "\thommes : %d\t", NR}'
awk -F";" '$5 ~ /^C/ && ($1 == "Mlle" || $1 == "Mdm") { n++; print n}' Personnes | awk 'END {printf "femmes : %d\n", NR}' #repartition par sexe

awk -F";" '$5 ~ /^D/ { n++; print n}' Personnes| awk 'END {printf "population Divorcé : %d \n", NR}' #le nombre de population Divorcé
awk -F";" '$5 ~ /^D/ && $1 == "M" { n++; print n}' Personnes | awk 'END {printf "\thommes : %d\t", NR}'
awk -F";" '$5 ~ /^D/ && ($1 == "Mlle" || $1 == "Mdm") { n++; print n}' Personnes | awk 'END {printf "femmes : %d\n", NR}' #repartition par sexe

awk -F";" '$5 ~ /^M/ { n++; print n}' Personnes| awk 'END {printf "population Marié : %d \n", NR}' #le nombre de population Marié
awk -F";" '$5 ~ /^M/ && $1 == "M" { n++; print n}' Personnes | awk 'END {printf "\thommes : %d\t", NR}'
awk -F";" '$5 ~ /^M/ && ($1 == "Mlle" || $1 == "Mdm") { n++; print n}' Personnes | awk 'END {printf "femmes : %d\n", NR}' #repartition par sexe

awk -F";" '$5 ~ /^P/ { n++; print n}' Personnes| awk 'END {printf "population Pacsé : %d \n", NR}' #le nombre de population Pacsé
awk -F";" '$5 ~ /^P/ && $1 == "M" { n++; print n}' Personnes | awk 'END {printf "\thommes : %d\t", NR}'
awk -F";" '$5 ~ /^P/ && ($1 == "Mlle" || $1 == "Mdm") { n++; print n}' Personnes | awk 'END {printf "femmes : %d\n", NR}' #repartition par sexe

#la moyenne d'age
function moyenne(){ # la fonction moyenne donne la moyenne d'une population donnee en parametre
	cetteAnnee=$(date | cut -d" " -f4 | cut -d"," -f1) # la premier cut pour recuperee l'annee courant , et la deuxieme cut est pour supprimer la virgule ','
	cut -d";" -f4 < $1 | cut -d"/" -f3 > anneesPersonnes.txt # la premier cut est pour recuperee le champ contenant la date, et la deuxieme cut est pour recuperee l'annee (seul) de la personne , puis le tous est enregestree dans le fichier anneesPersonnes.txt

	awk -F" " -v ane=$cetteAnnee '{printf "%d\n", (ane  - $1 )}' anneesPersonnes.txt > listeAges.txt # ici on calcule l'ages de chaque Personne (ane-$1) l'annee courant mois l'annee de la naissance

	moyennes=$(awk -F" " '{som += $1; print som/NR}' listeAges.txt) # la moyenne ce trouve a la dernier position precedee par autre valeurs 

	echo $moyennes > fichierDeMoyennes.txt # on transfer le contenu de la variable dans un fichier pour faciliter la manipilation 

	awk -F" " '{printf " : %d\n", $NF}' fichierDeMoyennes.txt # on affiche la moyenne qui se trouve a la dernier champ du fichier 	
	rm fichierDeMoyennes.txt anneesPersonnes.txt listeAges.txt; unset cetteAnnee #suppression des donees inutile
}

# maintenant on va cree duex fichier contenants la population masculine et feminine (persoonesM & personnesF)

function creePopulation(){
	awk -F";" '$1 == "M" {print $0}' $1 > $2 # la population masculine
	awk -F";" '$1 == "Mdm" || $1 == "Mlle" {print $0}' $1 > $3 # la population feminine
}

creePopulation Personnes PersonnesM.txt PersonnesF.txt # creation des deux population (M & F) a fin de calculer leur moyennes


echo -n "moyenne total"; moyenne Personnes # apel de la fonction moyenne() ,(parametre : Personnes)
echo -ne "\t hommes"; moyenne PersonnesM.txt
echo -ne "\t femmes"; moyenne PersonnesF.txt