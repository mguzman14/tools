# cesar.sh
# Description: function to decode strings or files encoded using based-on Caesar algorithm
# Example: cesar -t str -r 13 -i 'text to decode'

function cesar() {
  while getopts "t:i:r:h" opt; do
    case $opt in
      t) # input type: file or string
        v_type=$OPTARG

        if [ "$v_type" = "file" ]; then
            v_action="cat"
        elif [ "$v_type" = "str" ]; then
            v_action="echo"
        fi
        ;;

      r)
        v_rot=$OPTARG
        ;;

      i)
        v_text=$OPTARG
        ;;

      h)
        echo "====help:===="
        echo "-i   input text"
        echo "-r   position rotation"
        echo "-h   show help"
        ;;
      ?)
        echo "Opción no válida: -$OPTARG"
        ;;
    esac
  done

  # generate alphabet
  v_alphabet=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  v_alphabet_upp=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

  # store letters in variables
  v_letter="${v_alphabet[$((v_rot))]}"
  v_letter_upp="${v_alphabet_upp[$((v_rot))]}"

  v_letter_after="${v_alphabet[$((v_rot - 1))]}"
  v_letter_upp_after="${v_alphabet_upp[$((v_rot - 1))]}"

  # build sentence
  final_command="${v_action} '${v_text}' | tr '[A-Za-z]' '[${v_letter_upp}-ZA-${v_letter_upp_after}${v_letter}-za-${v_letter_after}]'"

  eval $final_command

}