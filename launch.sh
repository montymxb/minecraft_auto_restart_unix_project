#!/bin/sh
cd "$(dirname "$0")"

#Main launch program, executes java server under the given name
#sets up the server inside a created daemon Screen
#starts background Master Process to oversee server management
#sets Minecraft screen as current screen

serverSession() {

	#restart every 4 hours?? 14400 sleep time total required

	#cycles = total hours between restarts
	cycles=4
	hour=3600
	period=$((cycles*hour))

	sleep 80

	screen -S mineBumbs -X stuff "say Welcome to Le Spice World"
	screen -S mineBumbs -X eval "stuff \015"

	sleep 10

	screen -S mineBumbs -X stuff "say Current Texture Pack is Jolicraft!"
	screen -S mineBumbs -X eval "stuff \015"

	sleep 10

	screen -S mineBumbs -X stuff "say compliments from Superkelp and mxb..."
	screen -S mineBumbs -X eval "stuff \015"
	

	sleep $((period-100-600))

#	####Future feauture: ping each hour
#	while [ "$cycles" -gt 1 ]; do
#	currentHour=$((period/3600+1-cycles))
#	screen -S mineBumbs -X stuff "say Server uptime of $currentHour hour..."
#	screen -S mineBumbs -X eval "stuff \015"
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

	screen -S mineBumbs -X stuff "say Server will be restarting in 10 minutes..."
	screen -S mineBumbs -X eval "stuff \015"

	sleep 300

	screen -S mineBumbs -X stuff "say Server will be restarting in 5 minutes..."
	screen -S mineBumbs -X eval "stuff \015"

	sleep 240

	screen -S mineBumbs -X stuff "say Server Will Be Restarting in 1 minute..."
	screen -S mineBumbs -X eval "stuff \015"

	sleep 50

	screen -S mineBumbs -X stuff "say Server Is Restarting Now"
	screen -S mineBumbs -X eval "stuff \015"

	sleep 10

	screen -S mineBumbs -X stuff "stop"
	screen -S mineBumbs -X eval "stuff \015"

	sleep 30

	##### screen kill OSX Style
	#Kill the screen
	screen -S mineBumbs -X stuff "exit"
	screen -S mineBumbs -X eval "stuff \015"
	####
}

while true; do

	serverSession &
	
	screen -S mineBumbs java -Xmx1024m -Xms1024m -jar minecraft_server.jar nogui	

	screen -ls | grep "mineBumbs" | awk '{print $1}' | xargs -r -i -n1 screen -X -S {} quit
	
	sleep 10

done
