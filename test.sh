#!/bin/bash
cycles=4
hour=3600
period=$(($cycles*hour))
while [ "$cycles" -gt 1 ]; do
	currentHour=$((period/3600+1-cycles))
	echo "$currentHour hours"
	echo $cycles
	cycles=$(($cycles-1))
done