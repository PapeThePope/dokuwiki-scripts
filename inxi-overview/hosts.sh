#!/bin/bash

source config.sh

for i in `seq 1 255`;
do
	HOSTNAME="192.168.10.$i"
	echo $HOSTNAME
    	if nc -z $HOSTNAME 22 2>/dev/null; then

		dig +short -x $HOSTNAME >> $HOSTFILE
	fi
done  
