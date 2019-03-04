#!/bin/bash
## Configfile for the Inxifull.sh and inxioverview.sh script (also used for hosts.sh)
## USERNAME: The Username used for the ssh connection
## PORT: The port used for the ssh connection
## OVERVIEWFILE: The File, that contains the basic table used for showing the inxi overview
## HOSTFILE: File of hosts, which gonna be visited by the scripts
## INXIPATH: Folder, which will contain the full inxi information of all the hosts
USERNAME=root
PORT=22
OVERVIEWFILE="/var/www/html/dokuwiki/data/pages/overview.txt"
HOSTFILE='/var/www/html/dokuwiki/data/pages/hosts.txt'
INXIPATH="/var/www/html/dokuwiki/data/pages/inxi"
