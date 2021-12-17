#!/bin/bash

hero=0                  # nom du hero
hp_hero=0				# HP du hero
str_hero=0				# Force du hero
enemi=0					# Nom de l'ennemi
hp_enemi=0				# HP de l'ennemi
str_enemi=0				# Force de l'ennemi

function_reintialise_enemi(){ # Permet de recreer un ennemi et le faire des variables *enemi des variable temporaire.
	enemi=0
	hp_enemi=0
	str_enemi=0
}

function_select_player() { # Permet de selectionner son personnage de depart.
	first=0
	echo "====================================="
	echo "Choisis ton avatar:"
	while IFS="," read -r id name hp mp str int def res spd luck race class rarity ; do
		if [[ $first -gt 0 ]]; then
			echo $id":" $name"." "Ce personnage possede "$hp "points de vie et" $str "de force."
		else
			first=1
		fi
	done <players.csv
	read -p 'Je choisis le personnage numero ' choix
	first=0
	while IFS="," read -r id name hp mp str int def res spd luck race class rarity ; do
		if [[ $first -ne 0 ]]; then
			if [[ "$choix" -eq "$id" ]]; then
				hero=$name
				hp_hero=$hp
				str_hero=$str
			fi
		else
			first=1
		fi
	done < players.csv
	echo "Bienvenue "$hero "!"
}

function_select_ennemi() {
    first=0
    	while IFS="," read -r id name hp mp str int def res spd luck race class rarity ; do
		if [[ $first -ne 0 ]]; then
			if [[ "$name" ==  "Bokoblin" ]]; then
				ennemi=$name
				hp_ennemi=$hp
				str_ennemi=$str
			fi
		else
			first=1
		fi
	done < ennemis.csv
	echo $ennemi
}


function_select_boss() {
    first=0
    	while IFS="," read -r id name hp mp str int def res spd luck race class rarity ; do
		if [[ $first -ne 0 ]]; then
			if [[ "$name" ==  "Ganon" ]]; then
				boss=$name
				hp_boss=$hp
				str_boss=$str
			fi
		else
			first=1
		fi
	done < bosses.csv
	echo $boss
}

status(){					#Verifie les points de vies des combattants
	if [[ "$hp_hero" -le 0 ]]; then
		echo "Vous avez perdu la vie."
	fi
	echo "Vous avez $hp_hero points de vie."
	if [[ "$hp_ennemi" -le 0 ]]; then
		echo "$ennemi a perdu la vie."
	fi
	echo "$ennemi a $hp_ennemi points de vie."
}

heal(){  # Regenere les points de vie du joueur
	montant=$(((hp_hero_max/2)-1))
	if [[ "$hp_hero" -gt "$montant" ]]; then
		hp_hero="$hp_hero_max"
	else
		hp_hero=$((hp_hero+montant))
	fi
	echo "Vous vous etes soigner de $montant".
}

attack_enemy(){
	hp_hero=$((hp_hero-str_enemi))
	echo "L'ennemi vous inflige $str_enemi de degats." 
}

attack_hero(){
	hp_enemi=$((hp_enemi-str_hero))
	echo "Vous infligez $str_hero de degats."
}


#function_fight() {
   # status{}
  #  while [[ $hp_hero -gt 0 || $hp_enemi -gt 0 ]]; do
	
   # attack_enemy{}
   # attack_hero{}}
    
    
    

#function_attack() { }

function_battle(){ # Permet de creer des combats entre le joueur et l'ennemi

    	function_select_player players.csv{}

    tour=1
    while [[ tour -lt 11 ]]; do


	if [[ $tour -lt 10 ]]; then
	    echo "========== FIGHT $tour =========="

	    function_select_ennemi ennemis.csv{}
	    
	    
	    #status{}
	    
	    #function_fight()
	
	elif [[ $tour -eq 10 ]]; then
	    echo "========== FIGHT $tour =========="
	  

	    function_select_boss bosses.csv{}
	fi
	    
	tour=$(($tour+1))
    done

    
}
    

    
 function_battle {}



