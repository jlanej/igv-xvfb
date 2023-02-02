#!/bin/bash

Xvfb :99 -ac -screen 0 "1024x768x16" -nolisten tcp $XVFB_ARGS &
XVFB_PROC=$!
sleep 1
export DISPLAY=:99
/igv/IGV_Linux_2.10.3/igv.sh "$@"
kill $XVFB_PROC
