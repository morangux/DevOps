#!/bin/bash
#This script use for checking the status of the MYSQL slave. it checks if slave lag exist and if yes , if there is a backup procedure in the background.

MYSQL_PASSWORD='yP$2W4vLit=B'
echo -n  "Please Enter Host and Port of mysql server : "

read HOST PORT

ssh morangux@$HOST ps -ef | grep mysql | grep $PORT

if [ $? == 0 ]

then

echo "MYSQL instance $HOST $PORT is up and running"

mysql -u ecgo_root -h $HOST -p$MYSQL_PASSWORD -B -e "SHOW SLAVE STATUS\G;" <<CHECK
CHECK


else

echo "Please connect manually and check $HOST"

fi