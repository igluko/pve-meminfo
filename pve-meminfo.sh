#!/bin/bash

function getColumnNumber() {
# $1 table
# $2 col name
echo "`echo "$1"  | awk -v name="$2" '{for (i=1;i<=NF;i++) if ($i==name) print i; exit}'`"
}

function  getCell() {
#$1 table
#$2 col name
#$3 row name
columnNumber=$(getColumnNumber "$1" "$2")
echo "$1" |  awk "\$1 == \"$3\" {print \$$columnNumber}" 
}

#cat /proc/meminfo | grep  'MemTotal\|MemFree\|MemAvailable'
#awk '$3=="kB"{$2=$2/1024^2;$3="GB";} 1' /proc/meminfo | column -t
#awk '/MemFree/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo

function getServerStats(){
qm list | grep running | awk '{print $4}' | paste -sd+ | awk '{printf "scale=1;(%s)/1024\n", ($1) }' | bc | awk '{print "#Running VM Reserved: " $1 " GB"}'
echo "#"
awk '{printf "#%s  %.0f GB \n" , $1 , $2=$2/1024^2}' /proc/meminfo | grep -v "0"
echo "#"
awk '$1=="size" {printf "#ARC SIZE = %.f GB \n", $3/1024/1024/1024 }' /proc/spl/kstat/zfs/arcstats
echo "#"
}
getServerStats>"/etc/pve/local/config"
