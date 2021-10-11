realpath=`realpath $0`
dirpath=`dirname $realpath`
scriptpath="$dirpath/pve-meminfo.sh"
echo "script path is: $scriptpath"
cronrecord="* * * * * $scriptpath"
echo "cron record is: $cronrecord"

# write out current crontab
crontab -l > mycron

# echo new cron into cron file
# m h  dom mon dow   command
echo "$cronrecord" >> mycron 

# install new cron file
crontab mycron
rm mycron
