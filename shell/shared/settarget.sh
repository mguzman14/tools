# settarget.zsh
# Description: writes the input text into file "target"
# Example: settarget 10.10.0.1 Mantis

function settarget(){
	ip_address=$1
	machine_name=$2
	echo "$ip_address $machine_name" > /home/user_name/.config/bin/target
}