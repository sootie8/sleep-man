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
		echo "$(date -u) no times in log" | tee -a /var/log/sleep-man.log;
		last_resume_time=0;
	fi
	if [ $last_resume_time -gt $(date '+%s' -d '5 minutes ago') ]
	then	
		echo "$(date -u) timeout from resume" | tee -a /var/log/sleep-man.log;
		continue;
	fi
	uptime=$(awk '{print $1}' /proc/uptime | cut -d '.' -f 1);	
	if [ $uptime -lt 300 ]
	then
		echo "$(date -u) timeout from uptime" | tee -a /var/log/sleep-man.log;
		continue;
	fi 
	#check for ssh users. 
	users_logged_in=$(who | grep "pts" | wc -l);
	if [ $users_logged_in -gt 0 ]
	then
		echo "$(date -u) ssh user logged in" | tee -a /var/log/sleep-man.log;
		continue;
	fi
	#check jellyfin API, see if recently playing within time limit is seen.
	active_len=$(curl -s "localhost:8096/Sessions?api_key=$jelly_api_key&activeWithinSeconds=$jelly_timeout" | jq 'length');	
	active_len=$(expr $active_len + 0);
	if [ $active_len -gt 0 ]
	then
		echo "$(date -u) jellyfin users active" | tee -a /var/log/sleep-man.log;
		continue;
	fi
	#check m3u8 stuff, and other stuff if needed.		
	echo "suspend" | tee -a /var/log/sleep-man.log;
	systemctl suspend;
done
