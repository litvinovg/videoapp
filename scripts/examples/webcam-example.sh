#! /bin/bash
YOUTUBEKEY=""
CAMDEV="/dev/v4l/by-id/usb-FILL_DEVICE_ID"
CAM="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
~/scripts/templates/webcam.sh $YOUTUBEKEY $CAM $CAMDEV &
