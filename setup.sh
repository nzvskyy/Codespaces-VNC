#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "must be run as sudo!"
  exit 1
fi

# create new user with sudo access
useradd -m -s /bin/bash codespace
passwd codespace
usermod -aG sudo codespace

su - codespace <<'EOF'

# install packages
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

sudo apt update && sudo apt install -y \
    tigervnc-standalone-server tigervnc-common websockify sddm xfce4 xfce4-goodies xorg xauth firefox google-chrome-stable x11-xserver-utils xfonts-base xfce4-session xfce4-terminal

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

# run vnc server
vncserver -kill :1 2>/dev/null
vncserver :1 -xstartup /usr/bin/startxfce4 -geometry 1280x720 -depth 16 -SecurityTypes None

# download + run noVNC
git clone https://github.com/novnc/noVNC/ /opt/noVNC
cd /opt/noVNC
./utils/novnc_proxy --vnc localhost:5901 --listen 6080

EOF
