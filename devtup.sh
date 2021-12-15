#!/bin/bash

# Install xfce4
sudo apt install -y xfce4

# Update system
sudo apt update

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
sudo apt install -y feh sakura thunar rofi code vlc mousepad firefox qbittorrent neofetch filezilla docker-ce

# Setup docker
sudo usermod -aG docker $USER

# Setup chrome
sudo apt install -y libappindicator1
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Setup vim config
echo ':syntax on' /home/vizhork/.vimrc
echo ':set number' /home/vizhork/.vimrc

# Setup zsh
sudo apt install -y zsh zshsudo
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# Wallpaper
wget https://img-blog.csdnimg.cn/20200822171906778.png
mv 20200822171906778.png /home/vizhork/Pictures/kwllp.png
echo '#!/bin/bash' > /home/vizhork/.bash_profile
echo 'feh --bg-scale /home/vizhork/Pictures/kwllp.png' >> /home/vizhork/.bash_profile
# Reboot
/sbin/reboot
