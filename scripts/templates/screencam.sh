#! /bin/bash
KEY=$1
CAM=$2
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"
BACKUP_URL="rtmp://b.rtmp.youtube.com/live2?backup=1"
DATE=`date +%Y-%m-%d-%H-%M-%S`
LCK="/tmp/${CAM}.LCK";
exec 8>$LCK;
if flock -n -x 8; then
  touch ~/tmp/$CAM
  while [ -e ~/tmp/$CAM ]; do
	ssh -o ConnectTimeout=10 $CAM "\
	export XAUTHORITY=\`ps axu | grep \"\-auth\" | sed 's/.*-auth //' | sed 's/ .*//' | head -1\` &&
	export RESOLUTION=\`xrandr -d :0 | head -1 | cut -d \" \" -f 8-10 | sed s'/[\ ,]//g'\` &&
	pulseaudio -D;
	ffmpeg \
	-video_size \$RESOLUTION -framerate 25 -f x11grab -i :0.0+0,0 \
	-f pulse -i default -vcodec libx264 -g 25 -preset ultrafast \
	-acodec libmp3lame -ar 44100 -threads 3 -b:a 128k \
	-f flv $YOUTUBE_URL/$KEY " > ~/logs/$CAM-$DATE.log 2>&1 &
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
