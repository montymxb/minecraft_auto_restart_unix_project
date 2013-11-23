#!/bin/sh
cd "$(dirname "$0")"

#Main launch program, executes java server under the given name
#sets up the server inside a created daemon Screen
#starts background Master Process to oversee server management
#sets Minecraft screen as current screen

while true; do

	screen -dmS mineBumbs java -Xmx1G -Xms1G -jar minecraft_server.jar nogui

	/bin/bash anotherThing.sh &

	screen -r mineBumbs

	sleep 14460

done