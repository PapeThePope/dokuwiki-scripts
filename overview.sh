#!/bin/bash
## Shellscript for editing Dokuwiki remotely
USERNAME=tpape
OVERVIEWFILE="/var/www/html/dokuwiki/data/pages/overview.txt"
filename='/var/www/html/dokuwiki/data/pages/hosts.txt'
filelines=`cat $filename`
for HOSTNAME in $filelines ; do
	# Check if Port 22 is open
	if nc -z $HOSTNAME 22 2>/dev/null; then
 
		#Building the Commandline & execute it on remote host
		SCRIPT="cd ~; echo -n '| ' > ${HOSTNAME}.txt;echo -n '${HOSTNAME}' >> ${HOSTNAME}.txt; echo -n '| ' >> ${HOSTNAME}.txt; uname -a | tr '\n' ' ' >> ${HOSTNAME}.txt ; echo -n '| ' >> ${HOSTNAME}.txt" 
		ssh -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
		
		#Check for temp File & delete it if necessary
		if [ -f /tmp/${HOSTNAME}.txt ]; then
			rm -f /tmp/${HOSTNAME}.txt
		fi

		#Copy files, Merging & Cleanup
		scp ${USERNAME}@${HOSTNAME}:~/${HOSTNAME}.txt /tmp/${HOSTNAME}.txt
		SEDC="/${HOSTNAME}/d"
		sed -i ${SEDC} $OVERVIEWFILE
		sed -i '/^$/d' $OVERVIEWFILE
		cat /tmp/${HOSTNAME}.txt >> $OVERVIEWFILE
		echo '' >> $OVERVIEWFILE
		rm -f /tmp/${HOSTNAME}.txt
	fi
done




