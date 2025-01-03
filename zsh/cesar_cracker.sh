#!bin/zsh

function cesar() {
  while getopts "t:i:r:h" opt; do
    case $opt in
      t) # input type: file or string
        echo "input text: $OPTARG"
        v_type=$OPTARG

        if [ "$v_type" = "file" ]; then
            v_action="cat"
        elif [ "$v_type" = "str" ]; then
            v_action="echo"
        fi
        ;;

      r)
        echo "rot: $OPTARG"
        v_rot=$OPTARG
        ;;

      i)
        echo "input: $OPTARG"
        v_text=$OPTARG
        ;;

      h)
        echo "====help:===="
		echo "-t   type of input: file or string"
        echo "-i   input"
        echo "-r   position rotation"
        echo "-h   show help"
        ;;
      ?)
        echo "Invalid option: -$OPTARG"
        ;;
    esac
  done

  # generate alphabet
  v_alphabet=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  v_alphabet_upp=${v_alphabet:u}

  # store letters in variables
  v_letter="${v_alphabet[$((v_rot + 1))]}"
  v_letter_upp="${v_letter:u}"

  v_letter_after="${v_alphabet[$((v_rot))]}"
  v_letter_upp_after="${v_letter_after:u}"

  # build sentence
  final_command="${v_action} '${v_text}' | tr '[A-Za-z]' '[${v_letter_upp}-ZA-${v_letter_upp_after}${v_letter}-za-${v_letter_after}]'"

  echo $final_command

  # execute sentence
  eval $final_command

}