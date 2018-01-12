#!/bin/bash
if [ ! "$#" -eq "1" ]; then
echo "1 argument required, $# provided"
exit
fi
pid=$1
kill -15 $pid && sleep 10 && kill -15 $pid && sleep 1 && kill -9 $pid &
echo "kill pid $pid" > ~/logs/kill.log
echo "killed by stop script.." > ~/logs/kill.log
