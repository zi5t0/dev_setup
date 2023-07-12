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

# Git, Unzip, Neofetch, Htop, Curl, Wget, Feh, Mpv, Vlc Python3-Pip
sudo apt install -y git unzip neofetch htop curl wget feh mpv vlc python3-pip

# Vim & config
sudo apt install -y vim
echo ':syntax on' >> $HOMEDIR/.vimrc
echo ':set number' >> $HOMEDIR/.vimrc
sudo cp $HOMEDIR/.vimrc /root/.vimrc

# Evince, Libreoffice, Thunderbird
sudo apt install -y evince libreoffice thunderbird 

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update && sudo apt install -y docker-ce docker-compose
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

# Visual Studio Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update && sudo apt install -y code

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
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt -y install spotify-client

# Zsh
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

# Configure OhMyZsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended --skip-chsh"

# Node, NPM
sudo apt install -y nodejs npm

# Pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Angular
npm install -g @angular/cli

# Forticlient VPN
wget https://links.fortinet.com/forticlient/deb/vpnagent forticlient.deb
sudo dpkg -i forticlient.deb

# Slack
sudo snap install slack

# Teams
wget https://mirror.slackware.hr/sources/teams/teams_1.5.00.23861_amd64.deb
sudo dpkg -i teams_1.5.00.23861_amd64.deb

# Remove residual packages and script
sudo rm google-chrome-stable_current_amd64.deb linux64 setup.sh forticlient.deb slack.deb