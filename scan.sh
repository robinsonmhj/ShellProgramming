currentHour=`date "+%Y/%m/%d %H"`
minute=`date +%M`
#the if is used to cut the leading 0 from the minute
if [[ $minute = "0"* ]]; then
        #minute="${minute:1}"
        oneTenth=5
        currentHour=`date -d '1 hour ago' "+%Y/%m/%d %H"`
        suffix=`date -d '1 hour ago' "+%Y%m%d%H"`
else
        minute=$(($minute-10))
        oneTenth=$(($minute/10))
        suffix=`date "+%Y%m%d%H"`
fi

#echo oneTenth=$oneTenth
#echo suffix=$suffix


fileName="hourScan"$suffix"$oneTenth"
level="\[(error|severe) "
msg=$level$currentHour":""$oneTenth"
#echo msg=$msg
#scan in every 10 minutes
interval=10/60
#echo $interval
commandHome="/home/user/script/"
dataDir="/home/user/data/"
absolutePath="$dataDir$fileName"
sh $commandHome"grep.sh" "$msg" "$interval" > "$absolutePath"
hostCount=23
count=$(wc -l < "$absolutePath")
#echo $count
subject="Errors in GemfireXD Production"
if [ "$count" -gt "$hostCount" ] ; then
        cat "$absolutePath" | mailx -v -r "GFXD-Production@xxxxx.com" -s "$subject" -S smtp="smtprelay.xxxxx.com:25" username@xxxxx.com
fi
