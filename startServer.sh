#!/bin/bash


if [ "$#" -lt 4 ]
then

        echo "usage: env,commenad[start|stop|restart],startServerSequence,endServerSequence"
else

        env=$1
        command=$2
        start=$3
        end=$4

        sshLog="-o LogLevel=Error"
        NC='\033[0m' # No Color
        GREEN='\033[0;32m'

        middle="rhgemfirev"
        locatorMiddle="rhlocatorv"

        if [ $env == "sbx" ]; then
          env="sb"
                max=3
                locatorNo=1
        elif [ $env == "dev" ]; then
                max=6
                locatorNo=2
        elif [ $env == "sit" ]; then
                max=12
                locatorNo=2
        elif [ $env == "uat" ]; then
                max=19
                locatorNo=2
        elif [ $env == "prod" ]; then
                max=19
                locatorNo=2
                middle="rhgfxdv"
        fi



        #for i in $(seq 1  $locatorNo)
        #do
        #       serverName=$env$locatorMiddle$i
               #printf "${GREEN}"Restarting "$serverName${NC}\n"
                #ssh $sshLog $serverName "sudo service gemfire-locator "$command
        #done
        space=" "
        for i in $(seq $start $end)
        do
                serverName=$env$middle$i
                printf "${GREEN}$command$space$serverName${NC}\n"
                ssh -t $sshLog $serverName "sudo service gemfire-server "$command
                /bin/sleep 300
        done

fi

