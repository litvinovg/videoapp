#! /bin/bash
CAM="$1"
AUDIOIP="$2"
AUDIOCHANNEL="$3"
DATE=`date +%Y-%m-%d-%H-%M-%S`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#main stream
LCK="/tmp/${CAM}.LCK";
exec 8>$LCK;
if flock -n -x 8; then

if [ -e ~/tmp/$CAM ]
then
  exit 0
fi
touch ~/tmp/$CAM
while [ -e ~/tmp/$CAM ]; do
	if [ `pacmd list-sources | grep $AUDIOCHANNEL | wc -l` -lt 1 ]
	then
	    pacmd load-module module-tunnel-source server=$AUDIOIP source_name=$AUDIOCHANNEL source=$AUDIOCHANNEL
	fi
	/usr/bin/ffmpeg \
            -f pulse -i $AUDIOCHANNEL \
	    -acodec libmp3lame -ar 44100 -threads 3 -b:a 128k -bufsize 512k\
	    -ac 1 \
	-f mp3 "$DIR/../../video/AUDIO-$DATE-$CAM.mp3" >> ~/logs/$CAM-$DATE.log 2>&1 &
	PROCNUM=$!
        echo $PROCNUM > ~/tmp/$CAM
	wait $PROCNUM
done

else
echo "I'm rejected ($$)";
fi
