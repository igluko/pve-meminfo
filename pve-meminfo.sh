#!/bin/bash

function getServerStats(){
/usr/sbin/qm list | grep running | awk '{print $4}' | paste -sd+ | awk '{printf "scale=1;(%s)/1024\n", ($1) }' | bc | awk '{print "#Running VM Reserved: " $1 " GB"}'
echo "#"
awk '{printf "#%s  %.0f GB \n" , $1 , $2=$2/1024^2}' /proc/meminfo | grep -v "0"
echo "#"
awk '$1=="size" {printf "#ARC SIZE = %.f GB \n", $3/1024/1024/1024 }' /proc/spl/kstat/zfs/arcstats
echo "#"
}
getServerStats>"/etc/pve/local/config"
