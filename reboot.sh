#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "must be run as sudo!"
  exit 1
fi

su - codespace <<'EOF'

# stop existing vnc
vncserver -kill :1 2>/dev/null

# restart vnc
vncserver :1 -xstartup /usr/bin/startxfce4 -geometry 1280x720 -depth 16 -SecurityTypes None

# kill websockify
pkill -f "websockify"

# restart noVNC
cd /opt/noVNC
./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

EOF
