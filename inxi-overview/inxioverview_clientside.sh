#!/bin/bash
## Shellscript for editing Dokuwiki remotely
USERNAME=root
OVERVIEWFILE="/var/www/html/dokuwiki/data/pages/overview.txt"
filename='/var/www/html/dokuwiki/data/pages/hosts.txt'
filelines=`cat $filename`
for HOSTNAME in $filelines ; do
	# Check if Port 22 is open
	if nc -z $HOSTNAME 22 2>/dev/null; then
 
		#Building the Commandline & execute it on remote host
		SCRIPT="cd ~; echo -n '| ' > ${HOSTNAME}.txt; 
		echo -n '${HOSTNAME}' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt; 
		inxi -M --output json --output-file /tmp/bios.json; 
		sed -i 's/010#v/biov/g' /tmp/bios.json; 
		sed -i 's/008#serial/snnumb/g' /tmp/bios.json; 
		sed -i 's/002#product/modell/g' /tmp/bios.json; 
		cat /tmp/bios.json | underscore select '.modell' | tr '\n' ' ' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt; 
		cat /tmp/bios.json | underscore select '.snnumb' | tr '\n' ' ' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt; 
		cat /tmp/bios.json | underscore select '.biov' | tr '\n' ' ' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt; 
		uname -r | tr '\n' ' ' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt; 
		inxi -G --output json --output-file /tmp/gfx.json; 
		sed -i 's/001#Device/1st/g' /tmp/gfx.json; 
		cat /tmp/gfx.json | underscore select '.1st' | tr '\n' ' ' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt; 
		inxi -n --output json --output-file /tmp/net.json; 
		sed -i 's/004#mac/macv/g' /tmp/net.json; 
		cat /tmp/net.json | underscore select '.macv' | tr '\n' ' ' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt; 
		echo -n '[[inxi:${HOSTNAME}|]]' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt" 
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
		./inxifull.sh
	fi
done




