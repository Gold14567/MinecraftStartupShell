#!/bin/bash

cd "$( dirname "$0" )"

echo "======================================================"
echo ">> Script for creating a Minecraft server in OS X and linux"
echo ">> Version 0.5 - 30/07/2014"
echo ">> Licenced under The Unlicense"
echo ">> If you need help, type ./start_server.sh -h "
echo "======================================================"
sleep 2
clear

curl https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/437/downloads/paper-1.16.5-437.jar -o server.jar
echo -e ">> I'm done downloading the server .jar . \a"
#This function checks for an update, comparing the version numbers of to files.
function check_update(){
	echo ">> I am now going to check for an update..."
	curl https://raw.githubusercontent.com/007N/Minecraft-Startup-Script/master/update.txt -o update.txt
	update_version=cat update.txt
	version=cat version.txt
	if [version < update_version ]; then
		read -p ">> Version $update_version is avaible. Would you like to update ? ( y/n )" choice
		while [ -z $choice ] || [ $choice != 'y' ] || [ $choice != 'n']; do
			case $choice in
				"y")
					echo ">> I will now stop the script, update, and reload the script !"
					#Need to make the upate script.
					# Update the version.txt file, delete the file, download the new one, re-run it.
					;;
				"n")
					echo ">> You will miss an update,possibly with security fixes, and be asked next time you start the server."
					;;
				*)
					echo ">> Please entre a valid choice : y or n ."
					;;
			esac
		done

	else
		echo ">> You have the last availaible update !"
	fi
}

#This function runs to check if the directory has everything the server needs.
function first_run() {
	if [[ -d Backups/ ]] && [[ -e "minecraft_server.jar" ]] && [[ -e "server-icon.png" ]]; then
		echo ">> Everything seems okay to run the server !"
		clear
	else
		echo -e ">> I will now create a directory for backups, the jar for the server and an icon for your server. \a"
		mkdir Backups/
		echo -e ">> I'm done making the backup directory. \a"
		clear
	fi
}

#This function runs the server.
function run_server() {
	check_update
	first_run
	echo ">> I'm removing the old backup"
	rm -r Backups/Backup.tar.gz
	clear
	echo ">> I'm removing the old logs.."
	rm -r logs
	clear
	echo ">> I'm saving the world to a new backup"
	tar -zcf Backups/Backup.tar.gz world/
	clear
	echo ">> I've finished saving the world, I will now start the server !"
	clear
	echo ">> Lancement du serveur Minecraft en cours..."
	clear
	java -Xms2G -Xmx2G -jar server.jar -o --nogui
	echo ">> Server shutdown finished. "
}

#This is really easy to understand.
function show_help() {
	echo ">> Welcome to the server installation script."
	echo ">> This script supports one option:"
	echo ">> -h or --help	Show this help page."
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	show_help
	read -p "Press [Enter] to continue..."
elif [ "$1" == "-k" ]; then
	echo ""
else
	echo ">> Before starting the script, you need to know a few things:"
	echo ">> * You will need to provide your server icon."
	echo ">> * You will need to accept the EULA for the server to run."
	echo ">> * The script deletes the logs and the backups made on the previous run, for space."
	echo ">> * The first time, you will encounter errors. Once the EULA are accepted, run the script again, it should fix most of them."
	echo ">> * You can skip this part as of now by strating the script with the -k argument."
	read -p "Press [Enter] key to start the script..."
fi

run_server
