#!/bin/bash

env=$1

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
        max=21
        locatorNo=2
        middle="rhgfxdv"
fi

#dir=`pwd`
#echo $dir

if [ ! -f "gemfire-server" ]; then
	echo "There is no such file named gemfire-server"
else

	for i in $(seq 1  $max)
	do
		echo $env$middle$i
		scp "gemfire-server" $env$middle$i":/etc/init.d/gemfire-server"
		#scp "Pivotal_GemFireXD_14111_4e1aad3_Linux.tar.gz" $env$middle$i":/tmp/"
	done
fi

if [ ! -f "gemfire-locator" ]; then
	echo "There is no file named gemfire-locator "
else
	for i in $(seq 1  $locatorNo)
	do
		echo $env$locatorMiddle$i
		scp "gemfire-locator" $env$locatorMiddle$i":/etc/init.d/gemfire-locator"
		#scp "Pivotal_GemFireXD_14111_4e1aad3_Linux.tar.gz" $env$middle$i":/tmp/"
	done
fi

