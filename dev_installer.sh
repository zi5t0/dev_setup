#!/bin/bash

USERNAME=$(whoami)
# Setup sudo user
su -c "apt install -y sudo"
su -c "/usr/sbin/usermod -aG sudo $USERNAME"
newgrp zhork

# Install basic programs
sudo apt install -y build-essential linux-headers-$(uname -r) vim xorg xserver-xorg i3 git libx11-dev libxft-dev libxinerama-dev lxterminal

# Set vim config
echo ":syntax on">> /home/$USERNAME/.vimrc
echo ":set number">> /home/$USERNAME/.vimrc
sudo cp /home/$USERNAME/.vimrc /root/

# Set keyboard layout
setxkbmap es

# Set screen res
echo "xrandr --output Virtual1 --mode 3840x2160 --rate 59.97 --scale 0.5x0.5" >> ~/.profile

# Install display manager
sudo apt install -y slim
sudo systemctl enable slim
sudo reboot
