env=$1
time=$2

#the unit of time is hours

if [ $time -gt 0 ]; then
    let time=-$time*60

fi


#hostname=`hostname`
#env=${hostname:0:3}
#if [ $env="SBR" ]; then
#    env=${hostname:0:2}
#fi
#

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'


locatorMiddle="rhlocatorv"
targetDir='/tmp/log/'
sshLog="-o LogLevel=Error"

if [ ! -d $targetDir ]; then

    mkdir $targetDir
fi


rm -fv $targetDir"/*"

if [ $env == "sbx" ]; then
    env="sb"
    middle="regfxdv"
    servermax=3
    locatormax=1 
elif [ $env == "dev" ]; then
    middle="rhgemfirev"
    servermax=6
    locatormax=1
elif [ $env == "sit" ]; then
    middle="rhgemfirev"
    servermax=12
    locatormax=2
elif [ $env == "prod" ]; then
    middle="rhgfxdv"
    servermax=19
    locatormax=2
else
    middle="rhfxdv"
    servermax=3
    locatormax=1
fi

#collect statistics in the data node
for i in $(seq 1  $servermax)
do
     logName="/tmp/gfxdserver"$i"log.tar.gz"
         statisName="/tmp/gfxdserver"$i"statis.tar.gz"
         serverName="$env""$middle"$i
         printf "${GREEN}$serverName${NC}\n"
        #echo $logName
        #echo $statisName
        #echo $serverName
        #echo $targetDir
         ssh $sshLog $serverName "rm -f $logName;find /gemfire-logs/logs/* -name 'gemfirexd-server*' -mmin $time -size +0 -exec tar zcvfP $logName {} \;"
         ssh $sshLog $serverName "rm -f $statisName;find /gemfire-logs/statistics/*  -mmin $time -size +0 -exec tar zcvfP $statisName {} \;"
         scp $sshLog $serverName:$logName $targetDir
         scp $sshLog $serverName:$statisName $targetDir
done


#colloect statistics in the locator
for i in $(seq 1  $llocatormax)
do
         logName="/tmp/gfxdlocator"$i"log.tar.gz"
         statisName="/tmp/gfxdlocator"$i"statis.tar.gz"
         serverName="$env""$locatorMiddle"$i
         printf "${GREEN}$serverName${NC}\n"
        #echo $logName
        #echo $statisName
        #echo $serverName
        #echo $targetDir
         ssh $sshLog $serverName "rm -f $logName;find /gemfire-logs/logs/* -name 'gemfirexd-locator*' -mmin $time -size +0 -exec tar zcvfP $logName {} \;"
         ssh $sshLog $serverName "rm -f $statisName;find /gemfire-logs/statistics/*  -mmin $time -size +0 -exec tar zcvfP $statisName {} \;"
         scp $sshLog $serverName:$logName $targetDir
         scp $sshLog $serverName:$statisName $targetDir
done


