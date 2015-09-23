#!/usr/bin/env bash
# Script to convert 3gp to mp4(and rotate it 90 degree clockwise)
#
# Tested with ffmpeg-2.5.3(on Slackware 14.1)
#
# Whenever I shoot a video from my firefox phone, it is recorded in
# 3gp with 90 degree anti-clockwise. This is the fastest way I can
# think of..
#
# Usage: bash 3gp2mp4.sh VIDEO_001.3gp
# The output will be 'video_001.mp4'

# Cut off the extension and lowercase the filename
file_name=$(echo ${1} | cut -d '.' -f 1 | tr '[:upper:]' '[:lower:]')

# 3gp to mp4
ffmpeg -i ${1} -strict -2 -q:a 0 -ab 64k -ar 44100 test.mp4
sleep 1	# May be not needed

# Rotate 90clockwise. Rotating + converting 3gp to mp4 at once failed.
ffmpeg -i test.mp4 -strict -2 -vf "transpose=1" ${file_name}.mp4
sleep 1	 # not needed

# Clean up
rm -i test.mp4

