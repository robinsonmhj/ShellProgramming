dataDir="/home/"

find  $dataDir -type f -mtime +14 -exec rm -f {} +
#find  $dataDir -type f -mtime +14 -exec ls -lht {} +
echo "I just vacuum the files which are created 14 days ago"
