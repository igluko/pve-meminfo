#!/bin/bash

function getServerStats(){
running_vm=`/usr/sbin/qm list | grep running`
running_mem=0
if [ -n "$running_vm" ]; then
  running_mem=`echo "$running_vm" | awk '{print $4}' | paste -sd+ | awk '{printf "scale=0;(%s)/1024\n", ($1) }' | bc`
fi

free_mem=`cat /proc/meminfo | awk '$1=="MemFree:" {printf "%.f", $2/1024/1024 }'`
arc_mem=`cat /proc/spl/kstat/zfs/arcstats | awk '$1=="size" {printf "%.f", $3/1024/1024/1024 }'`
possible_free_mem=$(( $free_mem + $arc_mem ))

echo "#Possible Free mem: **$possible_free_mem GB**  "
echo "#"
echo "#Running VM Reserved: **$running_mem GB**  "
echo "#"
awk '{printf "#%s  %.0f GB  \n" , $1 , $2=$2/1024^2}' /proc/meminfo | grep -v "0"
echo "#"
awk '$1=="size" {printf "#ARC SIZE = **%.f GB** \n", $3/1024/1024/1024 }' /proc/spl/kstat/zfs/arcstats
echo "#"
}
getServerStats>"/etc/pve/local/config"
