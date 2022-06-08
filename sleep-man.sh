#!/bin/bash
#deps jellyfin, curl
jelly_timeout=300;
jelly_api_key='b0b04c5950554a06bf191c073f30dfa1';
while :
do
	sleep 10;
	#check current time since last awake, if shorter than x, sleep for y seconds.
	last_resume_time=$(tail -n 1 /var/log/last-resume-time.log);
	if [ $? -ne 0 ]
	then
		echo "no times in log";
		last_resume_time=0;
	fi
	if [ $last_resume_time -gt $(date '+%s' -d '5 minutes ago') ]
	then	
		echo "timeout from resume";
		continue;
	fi
	uptime=$(awk '{print $1}' /proc/uptime | cut -d '.' -f 1);	
	if [ $uptime -lt 300 ]
	then
		echo "timeout from uptime";
		continue;
	fi 
	#check for ssh users. 
	users_logged_in=$(who | grep "pts" | wc -l);
	if [ $users_logged_in -gt 0 ]
	then
		echo "ssh user logged in";
		continue;
	fi
	#check jellyfin API, see if recently playing within time limit is seen.
	active_len=$(curl -s "192.168.0.102:8096/Sessions?api_key=$jelly_api_key&activeWithinSeconds=$jelly_timeout" | jq 'length');	
	active_len=$(expr $active_len + 0);
	if [ $active_len -gt 0 ]
	then
		echo "jellyfin users active";
		continue;
	fi
	#check m3u8 stuff, and other stuff if needed.		
	echo "suspend";
	#systemctl suspend;
done
