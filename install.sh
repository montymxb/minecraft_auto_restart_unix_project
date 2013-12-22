#!/bin/bash


echo "Packages to be installed: ruby, openjdk-7-jre-headless, screen"
echo -n "Install required packages? (y/n): "
read choice
	if [ $choice ] && [ $choice = "n" ]; then 
		exit
	fi

		sudo apt-get install ruby openjdk-7-jre-headless screen

#wget -N 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/server.rb'
curl -O https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/server.rb
chmod a+x server.rb

if [ -e 'properties.cfg' ]; then
	echo -n 'properties.cfg already exists. Replace with default? (y/n): '
	read choice
	if [ $choice ] && [ $choice = "y" ]; then 
	
		#wget -N 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg'
		curl -O https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg
	fi
else

	#wget 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg'
	curl -O https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg
fi	

echo -n "Download latest minecraft_server.jar? (y/n): "
read choice
if [ $choice ] && [ $choice = "y" ]; then 

	##wget -Nq https://s3.amazonaws.com/Minecraft.Download/versions/versions.json
	curl -O https://s3.amazonaws.com/Minecraft.Download/versions/versions.json
	
	version=$(grep '"release": ".*"' versions.json | sed 's/"release"\: "//' | sed 's/"//' | sed -e 's/^[ \t]*//')
	version="1.7.2"
	
	#wget -O minecraft_server.jar "https://s3.amazonaws.com/Minecraft.Download/versions/${version}/minecraft_server.${version}.jar"
	curl -o minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/${version}/minecraft_server.${version}.jar
	
	rm versions.json
fi

echo -n "Install server files (do not run unless you have a clean minecraft_server.jar)? (y/n): "
read choice
if [ $choice ] && [ $choice = "y" ]; then 
		##boot up server using daemon screen (NOTE: there are issues with a dangling server after this)
		screen -dmS minecraftServer java -Xmx1024m -Xms1024m -jar minecraft_server.jar nogui
		##Upping wait time to 30 seconds, 20 seconds too fast for mac
		for i in {1..30}
		do
			c=$((30-i))
			echo -ne "Wait $c seconds, please! \r"
			sleep 1
		done 
		echo -ne '\n'
		screen -S minecraftServer -X stuff "stop"
		screen -S minecraftServer -X eval "stuff \015"
		screen -ls | grep "minecraftServer" | awk '{print $1}' | xargs -r -i -n1 screen -X -S {} quit
fi
echo
echo "Done! Run ./server.rb to run your server! Don't forget to set up your server.properties and properties.cfg files :).

	NOTE: If you attempt to start your minecraft server and it tells you there might be a server running on another port you have a dangling minecraft server from this test. If you are comfortable stop the proper java process using the Activity Monitor (Mac) or equivalent. Otherwise you should restart your computer in order to clear the problem."