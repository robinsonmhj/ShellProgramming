#env=$1
env="prod"
string=$1
time=$2
color=$3
tmp=$(($time))
#echo time=$time
if [ $tmp -ge 0 ]; then
        time=-$((60*$time))
fi

#echo $string
#echo $time
targetDir='/gemfire-logs/logs/*'

RED='\033[0;31m'
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


for i in $(seq 1  $servermax)
do
        hostName=$env$middle$i
        if [ ! -z "$color" ]; then
                printf "${GREEN}$hostName${NC}\n"
        else
                printf "$hostName\n"
        fi
        ssh $sshLog $hostName "find ${targetDir} -mmin $time|xargs grep -i -E '$string'"

done

for i in $(seq 1 $locatormax)
do

        hostName=$env$locatorMiddle$i
        if [ ! -z "$color" ]; then
                printf "${GREEN}$hostName${NC}\n"
        else
                printf "$hostName\n"
        fi
        ssh $sshLog $hostName "find ${targetDir} -mmin $time|xargs grep -i -E '$string'"



done
