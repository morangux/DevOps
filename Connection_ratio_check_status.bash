#!/bin/bash

MYSQL_PASSWORD='yP$2W4vLit=B'
echo -n  "Please Enter Host and Port of mysql server : "

read HOST PORT

ssh morangux@$HOST ps -ef | grep mysql | grep $PORT

if [ $? == 0 ]

then

echo "MYSQL instance $HOST $PORT is up and running"

mysql -u ecgo_root -h $HOST -p$MYSQL_PASSWORD -B -e "SHOW GLOBAL STATUS LIKE '%Threads_connected%';"  <<CHECK
CHECK

else

echo "Please connect manually and check $HOST"

fi