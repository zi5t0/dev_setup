#!/bin/bash

# Debloat ubuntu - remove gnome
sudo apt remove --purge -y gnome*

# Install i3wm and DM
sudo apt install -y i3 slim

# Update system
sudo apt update

# Get user
USER=$(whoami)

# Install utilities
sudo apt install -y vim htop build-essential linux-headers-$(uname -r) ca-certificates software-properties-common apt-transport-https wget curl

# Adding repos
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
#sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
# Install programs
sudo apt update
sudo apt install -y sakura thunar rofi code vlc mousepad firefox qbittorrent neofetch filezilla docker-ce

# Setup docker
sudo usermod -aG docker $USER

# Setup chrome
sudo apt install -y libappindicator1
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Setup vim config
mv .vimrc /home/$USER/.vimrc

# TODO: Change i3 by i3gaps, config polybar
# i3wm config
xrandr --dpi 220
# Wallpaper
echo '#!/bin/bash' > /home/$USER/.bash_profile
echo 'feh --bg-scale /home/$USER/Pictures/kwllp.png' >> /home/$USER/.bash_profile
# Cursor config
echo 'Xcursor.size: 48' >> /home/$USER/.Xresources
# Reboot
/sbin/reboot
#xrdb /home/$USER/.Xresources
