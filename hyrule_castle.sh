#!/bin/bash


hero=0                  # nom du hero
hp_hero=0				# HP du hero
str_hero=0				# Force du hero
enemi=0			# Nom de l'ennemi
hp_enemi=0				# HP de l'ennemi
str_enemi=0			# Force de l'ennemi
hp_hero_max=0			# Stocke les HP maximum du 

function_intialise_enemi(){ # Permet de creer un ennemi et le faire des variables *enemi des variable temporaire.
	first=0
	while IFS="," read -r id name hp mp str int def res spd luck race class rarity ; do
		if [[ "$first" -ne 0 ]]; then
			if [[ "$name" == "Bokoblin" ]]; then
				enemi=$name
				hp_enemi=$hp
				str_enemi=$str
			fi
		else
			first=1
		fi
	done < enemies.csv
}


function_select_player() { # Permet de selectionner son personnage de depart.
	first=0
	echo "====================================="
	echo "Choisis ton personnage:"
	while IFS="," read -r id name hp mp str int def res spd luck race class rarity ; do
		if [[ $first -gt 0 ]]; then
			echo $id":" "$name""." "Ce personnage possede "$hp "points de vie et" $str "de force."
		else
			first=1
		fi
	done <$1
	read -p 'Je choisis le personnage numero ' choix
	while [[ "$choix" -eq 0 || "$choix" -gt 5 ]]; do
		read -p 'Je choisis le personnage numero ' choix
	done
	first=0
	while IFS="," read -r id name hp mp str int def res spd luck race class rarity ; do
		if [[ $first -ne 0 ]]; then
			if [[ "$choix" -eq "$id" ]]; then
				hero=$name
				hp_hero=$hp
				str_hero=$str
				hp_hero_max=$hp
			fi
		else
			first=1
		fi
	done <$1
	echo "Bienvenue $hero ! " 
}

status(){					#Verifie les points de vies des combattants
	if [[ "$hp_hero" -le 0 ]]; then
		echo "Vous avez perdu la vie."
	else
		echo "Vous avez $hp_hero points de vie."

	fi
	if [[ "$hp_enemi" -le 0 ]]; then
		echo "$enemi a perdu la vie."
	else
		echo "$enemi a $hp_enemi points de vie."
	fi
}

heal(){  # Regenere les points de vie du joueur
	montant=$((hp_hero_max/2))
	if [[ "$hp_hero" -gt "$montant" ]]; then
		hp_hero="$hp_hero_max"
	else
		hp_hero=$((hp_hero+montant))
	fi
	echo "Vous vous etes soigner de $montant".
}

attack_enemy(){
	hp_hero=$((hp_hero-str_enemi))
	echo "L'ennemi vous inflige $str_enemi de degats.

	"

}

attack_hero(){
	hp_enemi=$((hp_enemi-str_hero))
	echo "Vous infligez $str_hero de degats."
}

battle(){		# La bagarre
	function_intialise_enemi		
	echo "Vous affrontez un $enemi !" 
	tour=1

		while [[ "$hp_hero" -gt 0 && "$hp_enemi" -gt 0 ]]; do
		
			#echo "Tour $((tour/2)) :"
			if [[ "$tour"%2 -eq 1 ]]; then
				echo "1. Attaque			2. Soin"
				read -p '' choix2
					if [[ "$choix2" -eq 1 ]]; then
				attack_hero 
			else
				heal 
			fi
		else
			attack_enemy 
		fi
		tour=$((tour+1))
		status
	done

	if [[ "$hp_hero" -gt 0 ]]; then
		echo "======= Felicitations ! ======="
	else
		echo "Dommage ! Tu l'auras la prochaine fois ..."
	fi
}

initialise_boss(){
	first=0
	while  IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
		if [[ "$first" -ne 0 ]]; then
			if [[ "$name" == "Ganon" ]]; then
				echo "ATTENTION ! BOSS FINAL EN APPROCHE !"
				enemi="$name"
				hp_enemi="$hp" 
				str_enemi="$str"  
			fi
		else
			first=1
		fi
	done < bosses.csv
}

battle_boss(){		# La bagarre du boss
	initialise_boss
	echo "Vous affrontez $enemi !" 
	tour=1
		while [[ "$hp_hero" -gt 0 && "$hp_enemi" -gt 0 ]]; do
		
			#echo "Tour $((tour/2)) :"
			if [[ "$tour"%2 -eq 1 ]]; then
				echo "1. Attaque			2. Soin"
				read -p '' choix2
					if [[ "$choix2" -eq 1 ]]; then
				attack_hero 
			else
				heal 
			fi
		else
			attack_enemy 
		fi
		tour=$((tour+1))
		status
	done

	if [[ "$hp_hero" -gt 0 ]]; then
		echo "======= Felicitations ! Vous avez conqueri le Chateau d'Hyrule ! ======="
	else
		echo "Dommage ! Retourne t'entrainer et reviens plus fort."
	fi
}





Hyrule_Castle(){
	function_intialise_enemi $1
	echo " /\*Prennez garde ! Vous entrez dans le Chateau d'Hyrule...*/\ "
	etage=1
	while [[ "$etage" -lt 10 ]]; do
		etage=$((etage+1))
		battle 
		function_intialise_enemi $1
	done
	echo "Boss battle 
	"
	initialise_boss
	battle_boss
}

function_select_player $1
Hyrule_Castle $1