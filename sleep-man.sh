#!/bin/bash
#deps jellyfin, curl
sleep 300;
while :
do
	sleep 10;
       	#compare last arp time to five mins ago.	
	last_arp_time=$(tail -n 1 /var/log/last-arp-time);
	back=$(date '+%s' --date='5 minutes ago');
	if [ $last_arp_time -gt $back ]
	then	
		echo "$(date -u) arp timeout" | tee -a /var/log/sleep-man.log;
		continue;
	fi
	#check for ssh users. 
	users_logged_in=$(who | grep "pts" | wc -l);
	if [ $users_logged_in -gt 0 ]
	then
		echo "$(date -u) ssh user logged in" | tee -a /var/log/sleep-man.log;
		continue;
	fi
	echo "$(date -u) suspend" | tee -a /var/log/sleep-man.log;
	systemctl suspend;
	sleep 300;
done
