#!/bin/bash

function ctrl_c() {
  echo -e "\n Saliendo"
  exit 1
}
trap ctrl_c INT


function helpPanel() {

	echo -e "\n Panel de ayura del archivo $0"
	echo -e "\t -m) Dinero con el que se desea jugar"
	echo -e "\t -t Técnica que se quiere utilizar. Valores: marting/inverselab"
	
	exit 1
}


function fct_pierdes() {
  reward=$(($initial_bet*2))
  money=$(($money-$reward))

  #echo "impar o 0 -> pierdes -$reward y ahora tienes $money"
  initial_bet=$(($initial_bet*2))

  jugadas_malas+="$random_number, "
  let play_counter+=1

}


function fct_ganas() {
  reward=$(($initial_bet*2))
  money=$(($money+$reward))
  
  #echo -e "par -> ganas $reward y ahora tienes $money\n"

  initial_bet=$backup_bet

  jugadas_malas=""
  let play_counter+=1

}


function martingala() {
	echo -e "Dinero inicial: $money"
	echo -n "Introduce el dinero que quieres apostar: " && read initial_bet
	echo -n "A qué deseas apostar contínuamente (par/impar): " && read par_impar

	echo -e "Vas a hacer una apuesta inicial de $initial_bet € y vas a apostar contínuamente a $par_impar.\n"

  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas=""

  while true; do

    money=$(($money-$initial_bet))

    #echo -e "\nAcabas de apostar $initial_bet euros y te quedan $money"

    random_number="$(($RANDOM % 37))"
    if [ $money -gt 0 ]; then

      if [ "$par_impar" == "par" ]; then

        if [ $(($random_number % 2)) -eq 0 ]; then

          fct_ganas

        else

          fct_pierdes

        fi

      elif [ "$par_impar" == "impar" ]; then
        
        if [ $(($random_number % 2)) -eq 0 ]; then # 

          fct_pierdes

        else

          fct_ganas

        fi

      fi
    
    else
      #echo "Te has quedado sin pasta. Se acabó"
      echo "Han habido un total de $(($play_counter-1)) jugadas, de las cuales:" 
      echo -e "\t Jugadas malas consecutivas: [ $jugadas_malas]"

      exit 0
    fi
  #sleep 3

  done
}


while getopts "m:t:h" arg; do
	case $arg in
		m) money=$OPTARG;;
		t) technique=$OPTARG;;
		h) helpPanel;;
	esac
done


if [ $money ] && [ $technique ]; then
	if [ $technique == "marting" ]; then
		martingala
	elif [ $technique == "inverselab" ]; then
		inverseLab
	else
		echo -e "\n [!] Técnica no disponible."
  fi
else
	helpPanel
fi
