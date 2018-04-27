homeDir="/opt/Admin/gfxd/"
rootDir="/mnt/autofs/dbbackup2/"
#incrementalDir=$rootDir"incrementalbackup/"
#baseDir=$rootDir"initial_gfxd_production_backup_2018-02-10/"
#echo $baseDir
date=`date "+%Y-%m-%d-%H-%M-%S"`
#target=$incrementalDir""$date
#if [ -d $target ]; then
#       rm -fv $target
#fi
#mkdir $target
log="$homeDir""logs/gfxdbackup."$date".log"
#chown -R gfxd $target >> $log
cd $homeDir
date=`date "+%Y-%m-%d-%H-%M-%S"`
echo $date "I am going to compact disk stores" >>$log
gfxd compact-all-disk-stores &> $log
#inital back up
#gfxd backup $rootDir >>$log
date=`date "+%Y-%m-%d-%H-%M-%S"`
echo $date "I am going to backup disk stores" >>$log
weekNo=`date +"%Y%U"`
dayOfWeek=`date +"%A"`
echo $weekNo >>$log
echo $dayOfWeek >>$log
target=$rootDir$weekNo
if [ $dayOfWeek = "Sunday" ]; then
        if [ -d $target ]; then
                rm -frv $target
        fi
        gfxd backup $target >>$log
        find $rootDir -maxdepth 1 -mtime +7 -type d -exec rm -frv {} +
else
        gfxd backup -baseline=$target $target >>$log
fi
#gfxd backup -baseline=$rootDir $rootDir &>$log
date=`date "+%Y-%m-%d-%H-%M-%S"`
echo $date "I have finished backuped disk stores" >>$log

#remove the logs generated more than 7 days ago
find $homeDir -name "*.log" -mtime +7 -exec rm -fv {} +

