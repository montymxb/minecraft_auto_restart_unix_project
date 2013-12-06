#!/bin/bash
checkInstalled() {
if dpkg-query -l $1 2>/dev/null | grep -q ^.i; then
	package=true
else
	package=false
fi
}

checkInstalled 'openjdk-7-jre-headless'
java=$package

checkInstalled 'screen'
screen=$package

checkInstalled 'ruby'
ruby=$package

if [ $(gem list parseconfig -i) = "true" ]; then
	parseConfig=true
else
	parseConfig=false
fi

if $java; then
	echo "openjdk-7-jre-headless already installed - skipping"
else
	echo "Install openjdk-7-jre-headless? (y/n)"
	read choice
	if [ $choice ] && [ $choice = "y" ]; then 
		sudo apt-get install openjdk-7-jre-headless
	fi
fi

if $screen; then
	echo "screen already installed - skipping"
else
	echo "Install screen? (y/n)"
	read choice
	if [ $choice ] && [ $choice = "y" ]; then 
		sudo apt-get install screen
	fi
fi

if $ruby; then
	echo "ruby already installed - skipping"
else
	echo "Install ruby? (y/n)"
	read choice
	if [ $choice ] && [ $choice = "y" ]; then 
		sudo apt-get install ruby
	fi
fi

if $parseConfig; then
	echo "parseconfig already installed - skipping"
else
	echo "Install parseconfig? (y/n)"
	read choice
	if [ $choice ] && [ $choice = "y" ]; then 
		sudo gem install parseconfig
	fi
fi

wget -N 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/server.rb'
chmod a+x server.rb

if [ -e 'properties.cfg' ]; then
	echo 'properties.cfg already exists. Replace with default? (y/n)'
	read choice
	if [ $choice ] && [ $choice = "y" ]; then 
		wget -N 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg'
	fi
else
	wget 'https://raw.github.com/montymxb/minecraft_auto_restart_unix_project/ruby_ubuntu/properties.cfg'
fi	

echo "Download latest minecraft_server.jar? (y/n)"
read choice
if [ $choice ] && [ $choice = "y" ]; then 
	wget -Nq https://s3.amazonaws.com/Minecraft.Download/versions/versions.json
	version=$(grep '"release": ".*"' versions.json | sed 's/"release"\: "//' | sed 's/"//' | sed -e 's/^[ \t]*//')
	version="1.7.2"
	wget -O minecraft_server.jar "https://s3.amazonaws.com/Minecraft.Download/versions/${version}/minecraft_server.${version}.jar"
	rm versions.json
fi

echo "Install server files (do not run unless you have a clean minecraft_server.jar)? (y/n)"
read choice
if [ $choice ] && [ $choice = "y" ]; then 
		echo "Wait 20 seconds, please!"
		screen -dmS minecraftServer java -Xmx1024m -Xms1024m -jar minecraft_server.jar nogui
		sleep 20
		screen -S minecraftServer -X stuff "stop"
		screen -S minecraftServer -X eval "stuff \015"
		screen -ls | grep "minecraftServer" | awk '{print $1}' | xargs -r -i -n1 screen -X -S {} quit
fi
echo "Done! Run ./server.rb to run your server! Don't forget to set up your server.properties and properties.cfg files :)."