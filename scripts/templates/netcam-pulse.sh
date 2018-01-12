#! /bin/bash
IP=$1
KEY=$2
CAM=$3
AUDIOIP="$4"
AUDIOCHANNEL="$5"
ITSOFFSET=$6
CAMUSER=$7
CAMPASSWORD=$8
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"
BACKUP_URL="rtmp://b.rtmp.youtube.com/live2?backup=1"
SOURCE="rtsp://$CAMUSER:$CAMPASSWORD@$IP/0"
DATE=`date +%Y-%m-%d-%H-%M-%S`
HOMEDIR=~
LCK="/tmp/${CAM}.LCK";
exec 8>$LCK;
if flock -n -x 8; then

if [ -e $HOMEDIR/tmp/$CAM ]
then
  exit 0
fi
touch $HOMEDIR/tmp/$CAM
while [ -e $HOMEDIR/tmp/$CAM ]; do
	if [ `ps aux | grep pulseaudio | wc -l` -lt 2 ]
	then
	    pulseaudio -D --realtime=true
	fi
	if [ `pacmd list-sources | grep $AUDIOCHANNEL | wc -l` -lt 1 ]
	then
	    pacmd load-module module-tunnel-source server=$AUDIOIP source_name=$AUDIOCHANNEL source=$AUDIOCHANNEL
	fi

	/usr/bin/ffmpeg \
	    -rtsp_transport tcp \
	    -i "$SOURCE" \
	    -itsoffset $ITSOFFSET \
            -f pulse -i $AUDIOCHANNEL \
	    -map 0:v -map 1:a \
	    -vcodec copy \
	    -acodec libmp3lame -ar 44100 -threads 3 -b:a 128k -bufsize 512k\
	    -ac 1 \
	    -af aresample=async=1000 \
	-f tee "[f=flv]$YOUTUBE_URL/$KEY|[f=flv]$BACKUP_URL/$KEY|[f=flv]$HOMEDIR/video/$DATE-$CAM.flv" >> $HOMEDIR/logs/$CAM-$DATE.log 2>&1 &
	PROCNUM=$!
        echo $PROCNUM > $HOMEDIR/tmp/$CAM
	wait $PROCNUM
	TESTNUM=''
	if [ -f $HOMEDIR/tmp/$CAM ]; then
	    TESTNUM=`cat $HOMEDIR/tmp/$CAM`
	fi
	if [ "$PROCNUM" != "$TESTNUM" ]
        then
	   echo "$PROCNUM not equal $TESTNUM. Exiting."
           exit 0
        fi
done

else
echo "I'm rejected ($$)";
fi
