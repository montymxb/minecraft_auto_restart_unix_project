##Kills launch.sh
ps -A | grep "launch.sh" | awk '{print $1}' | xargs -r  kill

##Kills All Server Sessions (ideally)
screen -ls | grep "mineBumbs.*Detached" | awk '{print $1}' | xargs -n1 -i screen -X -S {} quit

##Kills vestigial servers
ps -A | grep "java" | awk '{print $1}' | xargs -r  kill
