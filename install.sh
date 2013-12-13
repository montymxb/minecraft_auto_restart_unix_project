#!/bin/bash

echo "Packages to be installed: ruby, openjdk-7-jre-headless, screen"
echo -n "Install required packages? (y/n): "
read choice
	if [ $choice ] && [ $choice = "n" ]; then 
		exit
	fi

		sudo apt-get install ruby openjdk-7-jre-headless screen
		sudo gem install parseconfig

wget -N 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/server.rb'
chmod a+x server.rb

if [ -e 'properties.cfg' ]; then
	echo -n 'properties.cfg already exists. Replace with default? (y/n): '
	read choice
	if [ $choice ] && [ $choice = "y" ]; then 
		wget -N 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg'
	fi
else
	wget 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg'
fi	

echo -n "Download latest minecraft_server.jar? (y/n): "
read choice
if [ $choice ] && [ $choice = "y" ]; then 
	wget -Nq https://s3.amazonaws.com/Minecraft.Download/versions/versions.json
	version=$(grep '"release": ".*"' versions.json | sed 's/"release"\: "//' | sed 's/"//' | sed -e 's/^[ \t]*//')
	version="1.7.2"
	wget -O minecraft_server.jar "https://s3.amazonaws.com/Minecraft.Download/versions/${version}/minecraft_server.${version}.jar"
	rm versions.json
fi

echo -n "Install server files (do not run unless you have a clean minecraft_server.jar)? (y/n): "
read choice
if [ $choice ] && [ $choice = "y" ]; then 
		echo -n "Wait 20 seconds, please!"
		screen -dmS minecraftServer java -Xmx1024m -Xms1024m -jar minecraft_server.jar nogui
		for i in {1..20}
		do
			c=$((20-i))
			echo -ne "Wait $c seconds, please!\r"
			sleep 1
		done 
		echo -ne '\n'
		screen -S minecraftServer -X stuff "stop"
		screen -S minecraftServer -X eval "stuff \015"
		screen -ls | grep "minecraftServer" | awk '{print $1}' | xargs -r -i -n1 screen -X -S {} quit
fi
echo "Done! Run ./server.rb to run your server! Don't forget to set up your server.properties and properties.cfg files :)."