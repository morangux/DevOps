#!/bin/bash

echo -n  "Please Enter Host : "

read HOST

ssh morangux@$HOST df -hl

if [ $? == 0 ]

then

echo "***END OF MYSQL DISK STATE***"

else

echo "Please check if $HOST is power on"

fi
