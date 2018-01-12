#! /bin/bash
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"
BACKUP_URL="rtmp://b.rtmp.youtube.com/live2?backup=1"
KEY=$1
DATE=`date +%Y-%m-%d-%H-%M-%S`
CAM=$2
CAMDEV=$3
LCK="/tmp/${CAM}.LCK";
exec 8>$LCK;
if flock -n -x 8; then
  touch ~/tmp/$CAM
  while [ -e ~/tmp/$CAM ]; do
	ssh $CAM ffmpeg \
	-video_size 1920x1080 -input_format h264 -framerate 25 -f video4linux2 -i $CAMDEV \
	-f alsa -ac 2 -ar 44100 -i hw:CARD=C920 -vcodec copy \
	-acodec libmp3lame -ar 44100 -threads 3 -b:a 128k \
	-f flv $YOUTUBE_URL/$KEY > ~/logs/$CAM-$DATE.log 2>&1 &
	PROCNUM=$!
        echo $PROCNUM > ~/tmp/$CAM
        sleep 3
        TESTNUM=`cat ~/tmp/$CAM`
        if [ "$PROCNUM" -ne "$TESTNUM" ]
        then
           kill $PROCNUM
           exit
        fi
        wait $PROCNUM
  done
else
  echo "I'm rejected ($$)";
fi
