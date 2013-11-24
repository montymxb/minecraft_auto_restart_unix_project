############screen -x mineBumbs

#restart every 4 hours?? 14400 sleep time total required

sleep 20

screen -S mineBumbs -X stuff "say Welcome to Le Spice World"
screen -S mineBumbs -X eval "stuff \015"

sleep 10

screen -S mineBumbs -X stuff "say Current Texture Pack is Jolicraft!"
screen -S mineBumbs -X eval "stuff \015"

sleep 10

screen -S mineBumbs -X stuff "say compliments from Superkelp and mxb..."
screen -S mineBumbs -X eval "stuff \015"

sleep 3560

screen -S mineBumbs -X stuff "say Server uptime of 1 hour..."
screen -S mineBumbs -X eval "stuff \015"

sleep 3600

screen -S mineBumbs -X stuff "say Server uptime of 2 hours..."
screen -S mineBumbs -X eval "stuff \015"

sleep 3600

screen -S mineBumbs -X stuff "say Server uptime of 3 hours..."
screen -S mineBumbs -X eval "stuff \015"

sleep 3000

screen -S mineBumbs -X stuff "say Server will be restarting in 10 minutes..."
screen -S mineBumbs -X eval "stuff \015"

sleep 300

screen -S mineBumbs -X stuff "say Server will be restarting in 5 minutes..."
screen -S mineBumbs -X eval "stuff \015"

sleep 240

screen -S mineBumbs -X stuff "say Server Will Be Restarting in 1 Minute..."
screen -S mineBumbs -X eval "stuff \015"

sleep 50 #was 50

screen -S mineBumbs -X stuff "say Server Is Restarting Now"
screen -S mineBumbs -X eval "stuff \015"

sleep 10

screen -S mineBumbs -X stuff "stop"
screen -S mineBumbs -X eval "stuff \015"

sleep 30

######screen -wipe

#Kill the screen
screen -S mineBumbs -X stuff "exit"
screen -S mineBumbs -X eval "stuff \015"