#!/bin/bash



DIR="/home/hamdi-emad/Desktop/System_Reports"
REP="$DIR/System_Report_$(date +%d":"%m":"%Y___%H":"%M":"%S).txt"

:<<'COMMENT'
(1)Check if the directory exist and
delete the previous reports and
if not, create a new one
COMMENT

if [[ -d $DIR ]]; then
    rm -rf $DIR/*
else
    mkdir -p "$DIR"
fi

touch $REP

# CPU info
printf "System Report\n======================\n\n" >> "$REP"
echo "(1) CPU :" >> "$REP"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Load: " $2+$4 "%"}' >> "$REP"

# Memory info
printf "\n\n(2) Memory : " >> "$REP"
free -h >> "$REP"
egrep --color 'Mem|Cache|Swap' /proc/meminfo >> "$REP"

# Disk info
printf "\n\n(3) Disk : \n" >> "$REP"
df -h >> "$REP"

# Network
printf "\n\n(4) Network status : \n" >> "$REP"
ip -brief address >> "$REP"

# Pending software updates
printf "\n\n(5) Pending software updates : \n" >> "$REP"
UPD=$(apt list --upgradable 2>/dev/null | grep -v Listing)
if [[ -z "$UPD" ]]; then
    echo "System is up-to-date" >> "$REP"
else 
    echo "There are pending updates:" >> "$REP"
    echo "$UPD" >> "$REP"
fi 


#uncomment this command and change the user mail to send the report via gmail.
#msmtp usermail@gmail.com < /home/hamdi-emad/Desktop/System_Reports/*

#This script is automated to run every minute.
