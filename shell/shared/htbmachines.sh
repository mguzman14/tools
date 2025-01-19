#!/bin/bash


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# Variables
declare -i parameter_counter=0
declare -r main_url="https://htbmachines.github.io/bundle.js"
declare -i chivato_difficulty=0
declare -i chivato_os=0

# Functions
function ctrl_c(){
  echo -e "\n\n[!] Saliendo...\n"
  exit 1
}

function helpPanel() {
  echo -e "\n${yellowColour}[+]${endColour} Uso:"

  echo -e "\t${purpleColour}m)${endColour} Buscar por un nombre de máquina"
  echo -e "\t${purpleColour}h)${endColour} Mostrar panel de ayuda"
  echo -e "\t${purpleColour}u)${endColour} Descargar o actualizar archivos necesarios"
  echo -e "\t${purpleColour}i)${endColour} Buscar por dirección IP"
  echo -e "\t${purpleColour}s)${endColour} Buscar por skills"
  echo -e "\t${purpleColour}i)${endColour} Buscar por dificultad. Valores esperados:"
  echo -e "\t\t Fácil"
  echo -e "\t\t Media"
  echo -e "\t\t Difícil"
  echo -e "\t\t Insane"
  echo -e "\t${purpleColour}o)${endColour} Buscar por sistema operativo. Valores esperados:"
  echo -e "\t\t Windows"
  echo -e "\t\t Linux"

}

function searchMachine() {
  machineName="$1"

  machineExists="$(cat bundle.js | grep \"$machineName\")"

  if [ "$machineExists" ]; then
     echo -e "${greenColour}[+]${endColour} Listando propiedades de la máquina ${machineName}\n"

     cat bundle.js | awk "/name: \"${machineName}\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | sed 's/^ *//' | tr -d '"' | tr -d ','

  else
    echo -e "${redColour}[!]${endColour} La máquina especificada no existe"

  fi

}

function updateFiles() {
  if [ ! -f bundle.js ]; then
    echo -e "${yellowColour}[-]${endColour} Descargando archivos necesarios..."

    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
  
    echo -e "${greenColour}[+]${endColour} Archivos descargados"

  else

    echo -e "${redColour}[!]${endColour} El archivo ya existe"

    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js

    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5_temp_value" == "$md5_original_value" ]; then

      echo -e "${yellowColour}[-]${endColour} No hay actualizaciones"
      rm bundle_temp.js
    else
      echo -e "${yellowColour}[-]${endColour} Actualizando..."
      rm bundle.js
      mv bundle_temp.js bundle.js
      echo -e "${greenColour}[+]${endColour} Archivos actualizados"


    fi

  fi

}

function searchIp() {

  ipAddress="$1"

  existsIp="$(cat bundle.js | grep \"$ipAddress\")"

  if [ "$existsIp" ]; then

    machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name:" | awk '{print $2}' | tr -d '"' | tr -d ',')"

    echo -e "${greenColour}[+]${endColour} La máquina correspondiente es ${machineName}\n"

    searchMachine $machineName

  else
    echo -e "${redColour}[!]${endColour} La IP proporcionada no corresponde a ninguna máquina"
  fi

}

function searchDifficulty() {
  difficulty="$1"

  existsDifficulty="$(cat bundle.js | grep \"$difficulty\")"


  if [ "$existsDifficulty" ]; then

    echo -e "${greenColour}[+]${endColour} Listando máquinas con dificultad ${difficulty}:"

    cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk '{print $2}' | tr -d '"' | tr -d ',' | column  

  else
    echo -e "${redColour}[!]${endColour} No hay máquinas con esa dificultad. Consulta el help (-h) para ver los valores esperados"
  fi
}

function searchOpSystem() {
  opSystem="$1"

  existsOpSystem="$(cat bundle.js | grep \"$opSystem\")"


  if [ "$existsOpSystem" ]; then

    echo -e "${greenColour}[+]${endColour} Listando máquinas con sistema operativo ${opSystem}:"

    cat bundle.js | grep "so: \"$opSystem\"" -B 5 | grep name | awk '{print $2}' | tr -d '"' | tr -d ',' | column

  else
    echo -e "${redColour}[!]${endColour} No hay máquinas con ese sistema operativo. Consulta el help (-h) para ver los valores esperados"
  fi

}

function searchOsDifficulty() {
  difficulty=$1
  opSystem=$2

  check_results="$(cat bundle.js | grep "so: \"$opSystem\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: "  |awk '{print $2}' | tr -d '"' | tr -d ',' | column)"
  

  if [ "$check_results" ]; then
  
    echo -e "${greenColour}[+]${endColour} Máquinas con sistema operativo $opSystem de dificultad $difficulty:"

    cat bundle.js | grep "so: \"$opSystem\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: "  |awk '{print $2}' | tr -d '"' | tr -d ',' | column
 
  else

    echo -e "${redColour}[!]${endColour} No se han encontrado máquinas $opSystem de dificultad $difficulty"

  fi

}


function searchSkill() {
  skill="$1"

  existsSkill="$(cat bundle.js | grep "skills" -B 6 | grep "$skill")"

  if [ "$existsSkill" ]; then
    echo -e "[+] Listando máquinas que usen la skill $skill:"

    cat bundle.js | grep "skills" -B 6 | grep "$skill" -i -B 6 | grep "name" | awk '{print $2}' | tr -d '"' | tr -d ',' | column
  
  else
    echo -e "[!] No hay máquinas que usen la skill $skill"

  fi

}



# Ctrl+C
trap ctrl_c INT

# set counter and execute functions
#
while getopts "m:ui:d:o:s:h" arg; do
  case $arg in
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress=$OPTARG; let parameter_counter+=3;;
    d) difficulty=$OPTARG; chivato_difficulty=1; let parameter_counter+=4;;
    o) opSystem=$OPTARG; chivato_os=1; let parameter_counter+=5;;
    s) skill=$OPTARG; let parameter_counter+=6;;
    h) helpPanel;;
  esac
done


if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIp $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  searchDifficulty $difficulty
elif [ $parameter_counter -eq 5 ]; then
  searchOpSystem $opSystem
elif [ $parameter_counter -eq 6 ]; then
    searchSkill "$skill"
elif [ $chivato_os -eq 1 ] && [ $chivato_difficulty -eq 1 ]; then
  searchOsDifficulty $difficulty $opSystem
 # helpPanel
fi



