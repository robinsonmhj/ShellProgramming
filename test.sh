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

#command="netstat -an|grep -i 'time_'|wc -l"
command="sudo service gemfire-server status"

for i in $(seq 1  $servermax)
do
        hostName=$env$middle$i
        echo $hostName
        #count=$(ssh $sshLog $hostName $command)
        ssh -t $sshLog $hostName $command
        #echo $count
done


#for i in $(seq 1 $locatormax)
#do

        #hostName=$env$locatorMiddle$i
        #echo $hostName
        #count=$(ssh $sshLog $hostName $command)
        #echo $count

#done


