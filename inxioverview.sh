#!/bin/bash
## Shellscript for creating a table of multiple linux based computers using inxi and simple shell tools
## Tools needed on Host:
## - underscore (npm) (Tested with Version 0.2.19)
## Tools needed on Client:
## - inxi (min. version 3.0.28 - tty flag introduced in this version) 
USERNAME=root
OVERVIEWFILE="/var/www/html/dokuwiki/data/pages/overview.txt"
filename='/var/www/html/dokuwiki/data/pages/hosts.txt'
filelines=`cat $filename`
for HOSTNAME in $filelines ; do
	# Check if Port 22 is open
	if nc -z $HOSTNAME 22 2>/dev/null; then
 
		# Setting up first things of the txt (eg. Kernel-Version) and executing inxi 
		SCRIPT="cd /tmp; echo -n '| ' > ${HOSTNAME}.txt; 
		echo -n '${HOSTNAME}' >> ${HOSTNAME}.txt; 
		echo -n '| ' >> ${HOSTNAME}.txt;
		uname -r | tr '\n' ' ' >> ${HOSTNAME}.txt;
		echo -n '| ' >> ${HOSTNAME}.txt; 
		inxi --tty -Z -M --output json --output-file /tmp/bios.json; 
		inxi --tty -Z -G --output json --output-file /tmp/gfx.json; 
 		inxi --tty -Z -n --output json --output-file /tmp/net.json"
		ssh -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"

		# Copy all the JSON Files and the temporary txt file
		scp ${USERNAME}@${HOSTNAME}:/tmp/bios.json /tmp/bios.json
		scp ${USERNAME}@${HOSTNAME}:/tmp/gfx.json /tmp/gfx.json
		scp ${USERNAME}@${HOSTNAME}:/tmp/net.json /tmp/net.json
		scp ${USERNAME}@${HOSTNAME}:/tmp/${HOSTNAME}.txt /tmp/${HOSTNAMe}.txt	


		# Edit the JSON File to be able to extract data with underscore
		sed -i 's/010#v/biov/g' /tmp/bios.json; 
		sed -i 's/008#serial/snnumb/g' /tmp/bios.json; 
		sed -i 's/002#product/modell/g' /tmp/bios.json; 
		sed -i 's/001#Device/1st/g' /tmp/gfx.json; 
		sed -i 's/004#mac/macv/g' /tmp/net.json; 

		#Finishing the txt file with underscore
		cat /tmp/bios.json | underscore select '.modell' | tr '\n' ' ' >> /tmp/${HOSTNAME}.txt; 
		echo -n '| ' >> /tmp/${HOSTNAME}.txt; 
		cat /tmp/bios.json | underscore select '.snnumb' | tr '\n' ' ' >> /tmp/${HOSTNAME}.txt; 
		echo -n '| ' >> /tmp/${HOSTNAME}.txt; 
		cat /tmp/bios.json | underscore select '.biov' | tr '\n' ' ' >> /tmp/${HOSTNAME}.txt; 
		echo -n '| ' >> /tmp/${HOSTNAME}.txt; 
		cat /tmp/gfx.json | underscore select '.1st' | tr '\n' ' ' >> /tmp/${HOSTNAME}.txt; 
		echo -n '| ' >> /tmp/${HOSTNAME}.txt; 
		cat /tmp/net.json | underscore select '.macv' | tr '\n' ' ' >> /tmp/${HOSTNAME}.txt; 
		echo -n '| ' >> /tmp/${HOSTNAME}.txt; 
		echo -n "[[inxi:${HOSTNAME}|]]" >> /tmp/${HOSTNAME}.txt; 
		echo -n '| ' >> /tmp/${HOSTNAME}.txt 


		# Checking for existing entry
		SEDC="/${HOSTNAME}/d"
		sed -i ${SEDC} $OVERVIEWFILE
		sed -i '/^$/d' $OVERVIEWFILE
		cat /tmp/${HOSTNAME}.txt >> $OVERVIEWFILE
		echo '' >> $OVERVIEWFILE

		# Deleting temporary Filed
		rm -f /tmp/bios.json
		rm -f /tmp/gfx.json
		rm -f /tmp/net.json
		rm -f /tmp/${HOSTNAMe}.txt
		

	fi
done

# Executing the Full Inxi script which is linked in the table
./inxifull.sh


