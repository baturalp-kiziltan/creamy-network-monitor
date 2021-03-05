#!/bin/bash

if ! dpkg-query -W -f='${Status}' net-tools | grep -q "ok installed";
then
	printf "Package \"net-tools\" is not installed.\nType \"sudo apt install net-tools\" to install it..."
	exit
fi

typeset -i range=$(ifconfig | grep "RX" | awk '{print $5}' | awk 'END{print NR}')

trap 'tput cnorm; echo' EXIT
trap 'exit 127' HUP INT TERM

tput civis
#tput sc

while :
do
	typeset -i received_0=0
	typeset -i received_1=0

	for ((i = 1; i < $range; i += 2))
	do
		received_0+=$(ifconfig | grep "RX" | awk '{print $5}' | sed -n "$i"p)
	done

	sleep 1

	for ((i = 1; i < $range; i += 2))
	do
		received_1+=$(ifconfig | grep "RX" | awk '{print $5}' | sed -n "$i"p)
	done
    
	received_total=$((received_1-received_0))
	
    #for ((i = 0; i < ${#received_total}; i += 1))
    #do
    #	tput rc
    #done
    
    clear
	
	printf "***********************************************************"
	printf "\n*\n* $(tput bold)$(tput setaf 6)-- CREAMY NETWORK USAGE MONITOR --$(tput sgr0)"
	printf "\n*\n* Author: BATURALP KIZILTAN [github: @baturalp-kiziltan]\n"
	printf "***********************************************************\n\n"
	echo "$(tput bold)Current Network Usage ==>"
	echo "-------------------------"
	printf "\n  * Received (Download): "
	printf "$(tput setaf 9)$((received_total/1000)) kB/s$(tput sgr0) \n\n\nPress Ctrl+C to exit"
done
