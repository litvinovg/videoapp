#! /bin/bash
CAM="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
AUDIOIP=FILL_PULSEAUIO_DEVICE_IP
AUDIOCHANNEL="FILL_PULSEAUDIO_CHANNEL_NAME"
~/scripts/templates/audio.sh $CAM $AUDIOIP $AUDIOCHANNEL &
