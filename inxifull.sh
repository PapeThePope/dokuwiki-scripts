#!/bin/bash
## Tools needed on Client:
## - inxi 
source config.sh

filelines=`cat $HOSTFILE`
for HOSTNAME in $filelines ; do
	# Check if Port 22 is open
	if nc -z $HOSTNAME $PORT 2>/dev/null; then
	    #Building the script for inxi and formatting the output for dokuwiki
	    SCRIPT="cd ~; 
		inxi -pluFxxrm -c 0 -Z > ${HOSTNAME}.txt; 
		sed -i 's/Partition:  /Partition:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/System:  /System:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Machine: /Machine:\n/g' ${HOSTNAME}.txt; 
		sed -i '0,/Memory:/s/Memory:/Memory:\n/' ${HOSTNAME}.txt; 
		sed -i 's/CPU:  /CPU:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Graphics:/Graphics:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Audio:  /Audio:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Network: /Network:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Drives:  /Drives:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/RAID:  /RAID:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Sensors: /Sensors:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Repos: /Repos:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Processes:  /Processes:\n/g' ${HOSTNAME}.txt; 
		sed -i 's/Info:  /Info:\n/g' ${HOSTNAME}.txt"
	    ssh -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
	    scp ${USERNAME}@${HOSTNAME}:~/${HOSTNAME}.txt ${INXIPATH}/${HOSTNAME}.txt
	fi
done
