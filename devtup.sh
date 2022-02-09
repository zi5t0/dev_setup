#!/bin/bash

# Update system
sudo apt update

# Set global var
USR=$(whoami)
HOMEDIR=/home$USR

# Dev libraries
sudo apt install -y build-essential linux-headers-$(uname -r) gcc g++ make

# Software libraries
sudo apt install -y apt-transport-https ca-certificates software-properties-common

# Php,unzip & composer
sudo apt install -y php php-cli php-curl php-xml php-zip php-mbstring unzip
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Git, Neofetch, Htop, Curl, Wget, Uzip, Feh, Mpv, Python3-Pip
sudo apt install -y git neofetch htop curl wget feh mpv python3-pip

# Vim & config
sudo apt install -y vim
echo ':syntax on' >> $HOMEDIR/.vimrc
echo ':set number' >> $HOMEDIR/.vimrc
sudo cp $HOMEDIR/.vimrc /root/.vimrc

# Fix FenviT919 drivers problem
sudo add-apt-repository ppa:kelebek333/kablosuz
sudo apt-get update
sudo apt install bcmwl-kernel-source

# Evince, Libreoffice, Thunderbird, Filezilla
sudo apt install -y evince libreoffice thunderbird filezilla 

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update && sudo apt install -y docker-ce
sudo usermod -aG docker $USR

# Qemu, virt-manager
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser $USR libvirt
sudo adduser $USR kvm
sudo systemctl enable --now libvirtd
sudo apt install -y virt-manager

# Qbittorrent
sudo apt install -y qbittorrent

# Anydesk
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
sudo echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk.list
sudo apt update && sudo apt install -y anydesk

# Teamviewer
wget -O - https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc | sudo apt-key add -
sudo apt-add-repository "deb http://linux.teamviewer.com/deb stable main"
sudo apt update && sudo apt install -y teamviewer

# Visual Studio Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update && sudo apt install -y code

# Pycharm
mkdir pycharm
wget https://download.jetbrains.com/python/pycharm-community-2021.3.1.tar.gz
tar -xf pycharm-community-*.tar.gz -C pycharm --strip=1
sudo mv pycharm /opt/
echo '[Desktop Entry]                          
Version=1.0
Name=PyCharm
GenericName=PyCharm
Comment=Python IDE
Exec=/opt/pycharm/bin/./pycharm.sh
Icon=/opt/pycharm/bin/pycharm.png
Terminal=false
Type=Application' > Pycharm.desktop
sudo mv Pycharm.desktop /usr/share/applications/

# Postman
wget https://dl.pstmn.io/download/latest/linux64
sudo tar -xvf linux64 -C /usr/bin
echo 'export PATH="$PATH:/usr/bin/Postman"' >> ~/.bashrc
echo '[Desktop Entry]
Name=Postman API Tool
GenericName=Postman
Comment=Testing API
Exec=/usr/bin/Postman/Postman
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=/usr/bin/Postman/app/resources/app/assets/icon.png
StartupWMClass=Postman
StartupNotify=true' > Postman.desktop
sudo mv Postman.desktop /usr/share/applications/Postman.desktop

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

# Vlc
sudo apt install -y vlc

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt -y install spotify-client

# Zoom
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install -y ./zoom_amd64.deb

# Discord
wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
sudo apt install -y ./discord.deb

# Zsh, OhMyZsh
sudo apt install -y zsh

# Upgrade system
sudo apt -y upgrade

# Fix installs 
sudo apt install -y -f

# Set wallpaper
wget https://wallpapercave.com/wp/wp6164840.png -O $HOMEDIR/Imágenes/kali_wp.png

# Uninstall games and other software
sudo apt remove -y parole gimp pidgin transmission* *sudoku* xfburn ristretto gnome-mines/focal
sudo apt autoremove -y

# Remove residual packages and script
sudo rm discord.deb zoom_amd64.deb pycharm-community-2021.3.1.tar.gz google-chrome-stable_current_amd64.deb linux64 setup.sh

# Configure OhMyZsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended --skip-chsh"
