#!/bin/bash
for i in `seq 1 255`;
do
	HOSTNAME="192.168.10.$i"
	echo $HOSTNAME
    	if nc -z $HOSTNAME 22 2>/dev/null; then

		dig +short -x $HOSTNAME >> /var/www/html/dokuwiki/data/pages/hosts.txt
	fi
done  
