#!/bin/sh

# script to convert any file (understandeable by VLC) to DIVX

VLC=/Applications/VLC.app/Contents/MacOS/VLC

#$VLC -Idummy $1 --sout \
#    "#duplicate{dst=display,dst=\"transcode{vcodec=div3,acodec=vorb}:\
#                 standard{access=file,dst='$outfile',mux=ogg}\""

if [ -e $1 ]; then

name=$(basename $1)

$VLC -I dummy -vvv "$1" --sout \
    "#transcode{vcodec=div3,acodec=vorb}:standard{access=file,dst='$name.divx',mux=ogg}"vlc://quit

fi