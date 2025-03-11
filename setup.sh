#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "must be run as sudo!"
  exit 1
fi

# create new user with sudo access
passwd codespace
usermod -aG sudo codespace

su - codespace <<'EOF'

# install packages
sudo apt update && sudo apt install -y \
    tigervnc-standalone-server tigervnc-common websockify sddm xfce4 xfce4-goodies xorg xauth firefox x11-xserver-utils xfonts-base xfce4-session xfce4-terminal

sudo apt clean

# create vnc directory
mkdir -p ~/.vnc

# make xfce start with the vnc
echo -e "#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# create xauthority
touch ~/.Xauthority
xauth generate :1 . trusted
xauth add ${DISPLAY} . $(mcookie)

# download noVNC
git clone https://github.com/novnc/noVNC/ /opt/noVNC

chmod +x reboot.sh
sudo ./reboot.sh

EOF
