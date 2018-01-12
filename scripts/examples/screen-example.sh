#! /bin/bash
YOUTUBEKEY="FILL_YOUTUBE_KEY"
CAM="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
~/scripts/templates/screencam.sh $YOUTUBEKEY $CAM
