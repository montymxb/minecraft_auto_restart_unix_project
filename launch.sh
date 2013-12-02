#!/bin/bash
cd "$(dirname "$0")"
. properties.cfg

#Main launch program, executes java server under the given name
#sets up the server inside a created daemon Screen
#starts background Master Process to oversee server management
#sets @restart==trueMinecraft screen as current screen

initialize() {
	##Checks for an installation of screen
	screenInstall=$(dpkg -l | awk '{print $2}' | grep "^screen$")
	if [ ! $screenInstall ]; then
		echo ""
		echo "ERROR: Screen is not installed."
		echo "Run this in your terminal: sudo apt-get install screen"
		echo ""
	fi

	##Should check for sudo apt-get install openjdk-7-jre-headless
	##Gems: parseconfig

	##Checks for backups directory, and creates it if it doesn't exist
	if [ ! -d "backups" ]; then
  		mkdir "backups"
	fi
}

backUp() {
	##Counts current number of backups
	numBackups=$(ls -1 backups | grep ".*\.tar.gz" | wc -l)

	##Deletes the oldest backup until there is room for the new one
	while [ $numBackups -ge $maxBackups ]; do
		rm "backups/$(ls -tr1 backups/ | grep ".*\.tar.gz" | sed -n 1p)"
		numBackups=$(ls -1 backups | grep ".*\.tar.gz" | wc -l)
	done

	##Creates a new backup
	timeStamp=$(date +"%d-%b-%y %H:%M")
	tar -zcvf "backups/$timeStamp.tar.gz" world
}

serverSession() {

	#cycles = total hours between restarts

	##Defines the total cycle period
	hour=3600
	period=$((cycles*hour))

	sleep 80

	screen -S minecraftServer -X stuff "$firstText"
	screen -S minecraftServer -X eval "stuff \015"

	sleep 10

	screen -S minecraftServer -X stuff "$secondText"
	screen -S minecraftServer -X eval "stuff \015"

	sleep 10

	screen -S minecraftServer -X stuff "$thirdText"
	screen -S minecraftServer -X eval "stuff \015"
	

	sleep $((period-100-600))

#	####Future feauture: ping each hour
#	while [ "$cycles" -gt 1 ]; do
#	currentHour=$((period/3600+1-cycles))
#	screen -S minecraftServer -X stuff "say Server uptime of $currentHour hour..."
#	screen -S minecraftServer -X eval "stuff \015"
#
#	cycles=$(($cycles-1))
#	if [ "$cycles" -gt 2 ]
#		then
#		sleep 3600
#		else
#		sleep 3500
#	fi
#
#	done

	screen -S minecraftServer -X stuff "say Server will be restarting in 10 minutes..."
	screen -S minecraftServer -X eval "stuff \015"

	sleep 300

	screen -S minecraftServer -X stuff "say Server will be restarting in 5 minutes..."
	screen -S minecraftServer -X eval "stuff \015"

	sleep 240

	screen -S minecraftServer -X stuff "say Server Will Be Restarting in 1 minute..."
	screen -S minecraftServer -X eval "stuff \015"

	sleep 50

	screen -S minecraftServer -X stuff "say Server Is Restarting Now"
	screen -S minecraftServer -X eval "stuff \015"

	sleep 10

	##Stops the server (ideally)
	screen -S minecraftServer -X stuff "stop"
	screen -S minecraftServer -X eval "stuff \015"

	sleep 30

	##### screen kill OSX Style
	#Kill the screen
	screen 	-S minecraftServer -X stuff "exit"
	screen -S minecraftServer -X eval "stuff \015"
	####
}

while true; do

	##Makes sure all assets are present
	initialize

	##Backs up the server, deletes old backups
	backUp

	sleep 10

	##Starts up the server script which . '$' makes it run in the background
	serverSession &
	
	##Starts up a server.
	screen -S minecraftServer java -Xmx1024m -Xms1024m -jar $minecraftJarName nogui	

	##Cleans up any rougue server instances
	screen -ls | grep "minecraftServer" | awk '{print $1}' | xargs -r -i -n1 screen -X -S {} quit
	
	sleep 10

done
