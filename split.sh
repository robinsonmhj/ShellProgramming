


env=$1

env=${env^^} #convert to uppercase


targetDir='/gemfire-store/data'
sourceDir=/gemfire-logs/data/*.sql
declare -i random
declare -i serverNo
declare -i sizethreshold

sizeThreshold=6000000
middle="RHGEMFIREV"

#color
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

#ssh log level
logLevel="-o LogLevel=Error"



client="6007"
threadNo=20

#make sure the target directory exist
if [ ! -d $targetDir ];then

	mkdir $targetDir

fi
#clean the target folder
rm -frv "$targetDir"/*



#different environemnt has different server count
if [ $env == "DEV" ]; then
	serverNo=6
elif [ $env == "SBX" ]; then
	serverNo=3
	env=SB
elif [ $env == "SIT" ]; then
	serverNo=12
fi



#create one folder for each server
for i in $(seq $serverNo)
do
	mkdir $targetDir"/server"$i
done

#split the file based on the file size, if file size is greater than 6M, then split it, else just copy the file to 
#one of servers by random

for f in $sourceDir
do
	fileSize=$(stat -c%s $f)
	echo "Processing " $f
	if [ $fileSize -gt $sizeThreshold ]; then
		fileName=${f##*/}
		#printf "%s,%s\n" $fileName "great"
		awk -v serverNo="$serverNo" -v targetDir="$targetDir" -v fileName="$fileName" '
		{
		        reminder=FNR%serverNo;
		        server=targetDir "/server"
		        for (i=0;i<serverNo;i++){
		                if(reminder==i){
		                        file=server reminder+1 "/" fileName
		                        #print file
		                        print >  file
		                }
		        }
		}' $f

	else
		random=$((RANDOM%$serverNo+1))
		target=$targetDir"/server"$random"/"
		cp $f $target
	fi
done

#testing call shell command in awk 
#file="/gemfire-logs/data/POS_CODE_6007.sql"
#echo | awk  -v file=$file '{ print file;target="/tmp/data/"; system("cp " file " " target) }'


#compress the files


cd $targetDir
for i in $(seq $serverNo)
do
	folder="server"$i
	targetServer=$env$middle$i
	tarFile=$folder".tar.gz"
	rm -fv $tarFile
	cd $folder
	tar zcvfP $tarFile *
	rm -frv $file
	printf "${GREEN}$targetServer${NC}\n"
	ssh $logLevel $targetServer "rm -fr /tmp/data/*"
	scp $logLevel $tarFile $targetServer:/tmp/data/""
	cd ..
	#uncompress the tar in /tmp/data;remove the tar;start loading application
	ssh $logLevel $targetServer "cd /tmp/data;tar zxvf $tarFile;rm -fv $tarFile;cd /home/user/populateData/toDB;sh startLoad.sh $client $threadNo" &
done




