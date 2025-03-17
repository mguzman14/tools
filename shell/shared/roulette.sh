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


function inverselab() {

  echo -e "Dinero inicial: $money"
  echo -n "A qué deseas apostar contínuamente (par/impar): " && read par_impar

  declare -a mySeq=(1 2 3 4)

  echo -e "\n[+] Empezamos con la secuencia [${mySeq[@]}]"

  bet=$((${mySeq[0]} + ${mySeq[-1]}))
  #money=$(($money - $bet))

  mySeq=(${mySeq[@]})

  #echo -e"\n[+] Invertimos $bet pavos, tenemos $money y la secuencia se queda en [${mySeq[@]}]"

  jugadas_totales=0
  bet_to_renew=$(($money+50)) # dinero que, una vez alcanzado, hará que renovemos la secuencia del 1 2 3 4

  echo -e "El tope para actualizar la secuencia es a partir de $bet_to_renew pavos"

  while [ ! $(($money-$bet)) -lt 0 ]; do

    if [ $money -gt $bet_to_renew ]; then

      echo -e "[!] Has superado el límite de dinero ($bet_to_renew pavos) para renovar la secuencia"

      let bet_to_renew+=50

      echo -e "El tope se ha actualizado a $bet_to_renew"

      mySeq=(1 2 3 4)
      bet=$((${mySeq[0]} + ${mySeq[-1]}))

      echo -e "La secuencia se ha reestablecido a: [${mySeq[@]}]"

    fi
    
    let jugadas_totales+=1
    money=$(($money - $bet))
 
    echo -e "\n[+] Invertimos $bet y nos quedamos con $money la secuencia para esta tirada es [${mySeq[@]}]"

    random_number=$(($RANDOM % 37))



    #echo -e "Ha salido el $random_number"


    if [ "$par_impar" == "par" ]; then

      if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then

        echo "ha salido el $random_number -> par -> ganas"

        reward=$(($bet*2))
        let money+=$reward

        echo "habias apostado $bet y, al ganar, ahora tienes $money pavos"

        if [ $money -gt $bet_to_renew ]; then

          echo -e "[!] Has superado el límite de dinero ($bet_to_renew pavos) para renovar la secuencia"

          let bet_to_renew+=50

          echo -e "El tope se ha actualizado a $bet_to_renew"

          mySeq=(1 2 3 4)
          bet=$((${mySeq[0]} + ${mySeq[-1]}))

          echo -e "La secuencia se ha reestablecido a: [${mySeq[@]}]"

        elif [ $money -lt $(($bet_to_renew-100)) ]; then
          
          let bet_to_renew-=50 
          echo -e "Se ha llegado al mínimo crítico -> reajustamos el tope a $bet_to_renew"
          
          mySeq+=($bet)
          mySeq=(${mySeq[@]})

          echo -e "Nuestra nueva secuencia es ${mySeq[@]}"

          if [ "${#mySeq[@]}" -ne 1 ] && [ "${#mySeq[@]}" -ne 0 ]; then
            bet=$((${mySeq[0]} + ${mySeq[-1]}))
          elif [ "${#mySeq[@]}" -eq 1 ]; then # cuando haya un único elemento en mySeq
            bet=${mySeq[0]}
          else
            echo "[!] La secuencia se ha quedado sin valores"
            mySeq=(1 2 3 4)
            echo -e "Reestablecemos la secuencia en [${mySeq}]"
            bet=$((${mySeq[0]} + ${mySeq[-1]}))

          fi


        else
          
          mySeq+=($bet)
          mySeq=(${mySeq[@]})

          echo -e "Nuestra nueva secuencia es ${mySeq[@]}"

          if [ "${#mySeq[@]}" -ne 1 ] && [ "${#mySeq[@]}" -ne 0 ]; then
            bet=$((${mySeq[0]} + ${mySeq[-1]}))
          elif [ "${#mySeq[@]}" -eq 1 ]; then # cuando haya un único elemento en mySeq
            bet=${mySeq[0]}
          else
            echo "[!] La secuencia se ha quedado sin valores"
            mySeq=(1 2 3 4)
            echo -e "Reestablecemos la secuencia en [${mySeq}]"
            bet=$((${mySeq[0]} + ${mySeq[-1]}))

          fi

        fi


        # set new values
        mySeq+=($bet)
        mySeq=(${mySeq[@]})

        # echo -e "La nueva secuencia es [${mySeq[@]}]"

        if [ "${#mySeq[@]}" -ne 1 ] && [ "${#mySeq[@]}" -ne 0 ]; then
          bet=$((${mySeq[0]} + ${mySeq[-1]}))
        elif [ "${#mySeq[@]}" -eq 1 ]; then # cuando haya un único elemento en mySeq
          bet=${mySeq[0]}
        else
          echo "[!] La secuencia se ha quedado sin valores"
          mySeq=(1 2 3 4)
          echo -e "Reestablecemos la secuencia en [${mySeq}]"
          bet=$((${mySeq[0]} + ${mySeq[-1]}))

        fi

      elif [ "$random_number" -eq 0 ]; then

        echo -e "Ha salido el $random_number -> pierdes"

      elif [ "$((random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ]; then

        if [ "$((random_number % 2))" -eq 1 ]; then
          echo -e "El numero es impar -> pierdes"

        else
          echo -e "El numero es 0 -> pierdes"

        fi

        echo "Ha salido el $random_number -> impar -> pierdes"

        unset mySeq[0]
        unset mySeq[-1] 2>/dev/null # si el array tiene 1 elemento, esto generará un error -> lo redirigimos al dev/null
        mySeq=(${mySeq[@]})


        echo -e "La secuencia que nos queda es: [${mySeq[@]}]"

        if [ "${#mySeq[@]}" -ne 1 ] && [ "${#mySeq[@]}" -ne 0 ]; then
          bet=$((${mySeq[0]} + ${mySeq[-1]}))
        elif [ "${#mySeq[@]}" -eq 1 ]; then # cuando haya un único elemento en mySeq
          bet=${mySeq[0]}
        else
          echo "[!] La secuencia se ha quedado sin valores"
          mySeq=(1 2 3 4)
          echo -e "Reestablecemos la secuencia en [${mySeq[@]}]"
          bet=$((${mySeq[0]} + ${mySeq[-1]}))

        fi




        #bet=$((${mySeq[0]} + ${mySeq[-1]}))

      fi

    fi
  #sleep 1
  done

  if [ "$money" -lt 0 ]; then

    echo "Te has quedado sin pasta. Se acabó"
    echo -e "\nEn total, han habido $jugadas_totales jugadas totales"
    exit 1
  fi


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
		inverselab
	else
		echo -e "\n [!] Técnica no disponible."
  fi
else
	helpPanel
fi
