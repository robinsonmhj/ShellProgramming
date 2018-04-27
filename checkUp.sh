#env=$1
env="prod"
NC='\033[0m' # No Color
GREEN='\033[0;32m'


middle="rhgemfirev"
locatorMiddle="rhlocatorv"
sshLog="-o LogLevel=Error"


if [ $env == "sbx" ]; then
        env="sb"
        servermax=3
        locatormax=1
elif [ $env == "dev" ]; then
        servermax=6
        locatormax=1
elif [ $env == "sit" ]; then
        servermax=12
        locatormax=2
elif [ $env == "uat" ]; then
        servermax=19
        locatormax=2
elif [ $env == "prod" ]; then
        servermax=21
        locatormax=2
        middle="rhgfxdv"

fi

command="ps aux|grep gfxd|grep java|wc -l"
from="GFXD-PROD@xxxx.com"
to="itxmen@xxx.com"
subject=" seems to be down, please check"
smtp="smtprelay.xxxx.com:25"

for i in $(seq 1  $servermax)
do
        hostName=$env$middle$i
        count=$(ssh $sshLog $hostName $command)
        #ssh $sshLog $hostName $command
        #echo $hostName $count
        if [ $i -eq 1 ]; then
                #echo server$i
                if [ $count -lt 3 ]; then
                        #echo "hello"$count
                        echo ""|mailx -v -r "$from" -s "$hostName$subject" -S smtp="$smtp" "$to"
                        #echo "I am after mail"
                fi
                #echo "I am out of if"
        else
                #echo server$i
                if [ $count -lt 2 ]; then
                        echo ""|mailx -v -r "$from" -s $hostName"$subject" -S smtp="$smtp" "$to"
                fi
        fi
done

for i in $(seq 1 $locatormax)
do

        hostName=$env$locatorMiddle$i
        count=$(ssh $sshLog $hostName $command)
        if [ $count -lt 1 ]; then
                 mailx -v -r "$from" -s $hostName"$subject" -S smtp="$smtp" "$to"
        fi

done
