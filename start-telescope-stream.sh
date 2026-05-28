#!/bin/bash

STREAM_DIR="$HOME/mjpg-streamer/mjpg-streamer-experimental"
DEVICE="/dev/video0"
RESOLUTION="640x480"
FPS="30"
PORT="8080"

pause_before_exit() {
    echo ""
    read -p "Press Enter to close this window..."
}

if [ ! -e "$DEVICE" ]; then
    echo "Camera not found at $DEVICE"
    echo "Connect the telescope camera, then run:"
    echo "ls /dev/video*"
    pause_before_exit
    exit 1
fi

echo "Starting telescope camera stream..."
echo "Open this on your phone/PC:"
echo "http://$(hostname -I | awk '{print $1}'):$PORT"
echo ""
echo "To stop the stream, press CTRL + C."
echo ""

cd "$STREAM_DIR" || {
    echo "Could not find mjpg-streamer folder at $STREAM_DIR"
    pause_before_exit
    exit 1
}

./mjpg_streamer \
-i "./input_uvc.so -d $DEVICE -r $RESOLUTION -f $FPS -y -n" \
-o "./output_http.so -p $PORT -w ./www -l 0.0.0.0"

pause_before_exit
