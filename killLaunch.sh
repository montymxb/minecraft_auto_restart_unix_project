ps -A | grep "launch.sh" | awk '{print $1}' | xargs -r  kill
ps -A | grep "anotherThing.sh" | awk '{print $1}' | xargs -r kill
screen -ls | grep "mineBumbs.*Detached" | awk '{print $1}' | xargs -n1 -i screen -X -S {} quit
