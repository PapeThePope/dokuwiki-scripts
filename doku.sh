#!/bin/bash
## Shellscript for editing Dokuwiki remotely
USERNAME=root
HOSTS="localhost papentum.de"
for HOSTNAME in ${HOSTS} ; do
    SCRIPT="cd ~; inxi -pluFxxrm -c 0 -Z > ${HOSTNAME}.txt; sed -i 's/System:  /System:\n/g' ${HOSTNAME}.txt; sed -i 's/Machine: /Machine:\n/g' ${HOSTNAME}.txt; sed -i '0,/Memory:/s/Memory:/Memory:\n/' ${HOSTNAME}.txt; sed -i 's/CPU:  /CPU:\n/g' ${HOSTNAME}.txt; sed -i 's/Graphics:/Graphics:\n/g' ${HOSTNAME}.txt; sed -i 's/Audio:  /Audio:\n/g' ${HOSTNAME}.txt; sed -i 's/Network: /Network:\n/g' ${HOSTNAME}.txt; sed -i 's/Drives:  /Drives:\n/g' ${HOSTNAME}.txt; sed -i 's/RAID:  /RAID:\n/g' ${HOSTNAME}.txt; sed -i 's/Sensors: /Sensors:\n/g' ${HOSTNAME}.txt; sed -i 's/Repos: /Repos:\n/g' ${HOSTNAME}.txt; sed -i 's/Processes:  /Processes:\n/g' ${HOSTNAME}.txt; sed -i 's/Info:  /Info:\n/g' ${HOSTNAME}.txt"
    ssh -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
    scp ${USERNAME}@${HOSTNAME}:~/${HOSTNAME}.txt /var/www/html/dokuwiki/data/pages/inxi/${HOSTNAME}.txt
done
