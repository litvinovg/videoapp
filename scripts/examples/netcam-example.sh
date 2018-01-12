#! /bin/bash
IP="FILL_NETCAM_IP"
YOUTUBEKEY="FILL_YOUTUBE_KEY"
CAM="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
CAMUSER="FILL_CAM_USER"
CAMPASSWORD="FILL_CAM_PASS"
~/scripts/templates/netcam-pulse.sh $IP $YOUTUBEKEY $CAM $CAMUSER $CAMPASSWORD &
