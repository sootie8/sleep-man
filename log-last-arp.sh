#!/bin/bash
#log the unix timestamp of current time
while :
do 
	tcpdump 'arp and dst 192.168.0.102 and src not 192.168.0.1' -l -p | while read line ; do date '+%s' >> /var/log/log-last-arp.log; done ;
done
