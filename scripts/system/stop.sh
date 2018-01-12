#!/bin/bash
if [ ! "$#" -eq "1" ]; then
echo "1 argument required, $# provided"
exit
fi
procname=$1
pid=`ps ax | grep $procname.[f]lv | cut -f 1 -d " "`
rm -f ~/tmp/$procname
kill $pid 
echo "kill pid $pid" procname $procname > ~/logs/kill.log
echo "killed by stop script.." > ~/logs/kill.log
