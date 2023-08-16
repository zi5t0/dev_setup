#!/bin/bash

# Update system
sudo apt update

# Set global var
USR=$(whoami)
HOMEDIR=/home/$USR

# Download debs: chrome, forticlient
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &
wget https://links.fortinet.com/forticlient/deb/vpnagent -O forticlient.deb &

# Dev libraries
sudo apt install -y build-essential linux-headers-$(uname -r) gcc g++ make

# Software libraries
sudo apt install -y apt-transport-https ca-certificates software-properties-common

# Git, Unzip, Neofetch, Htop, Curl, Wget, Feh, Mpv, Vlc Python3-Pip, zsh, filezilla qbittorrent
sudo apt install -y git unzip neofetch htop curl wget feh mpv vlc python3-pip zsh filezilla qbittorrent

# Fix installs 
sudo apt install -y -f

# Configure OhMyZsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended --skip-chsh"

# Vim & config
sudo apt install -y vim
echo ':syntax on' >> $HOMEDIR/.vimrc && echo ':set number' >> $HOMEDIR/.vimrc
sudo cp $HOMEDIR/.vimrc /root/.vimrc

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update && sudo apt install -y docker-ce docker-compose
sudo usermod -aG docker $USR

# Visual Studio Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
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
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt -y install spotify-client && sudo apt -f install

# NVM
wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh
bash install.sh && rm install.sh
source ~/.bashrc

# NodeJS V18
nvm install v18
nvm use 18
nvm alias default 18

# Optional: Logitech drivers and config
sudo apt install -y build-essential cmake pkg-config libevdev-dev libudev-dev libconfig++-dev libglib2.0-dev
git clone https://github.com/PixlOne/logiops.git
cd logiops && mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && make && sudo make install && rm -r logiops
sudo systemctl enable logid

# Pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -
source /home/zhork/.bashrc

# Angular (v13)
pnpm install -g @angular/cli@13

# Forticlient VPN (app y complemento para gnome-network)
sudo dpkg -i forticlient.deb
sudo apt install -y network-manager-fortisslvpn-gnome
sudo apt -y --fix-broken install

# Slack
sudo snap install slack

# Customization (themes) arc-icon-theme
git clone https://github.com/horst3180/arc-icon-theme --depth 1 && sudo mv arc-icon-them/Arc /usr/share/icons/arc
# TODO: Falta hacer que se setee el tema de iconos por defecto

# Fix firefox
sudo apt -y install --reinstall firefox

# Remove residual packages and script
sudo rm google-chrome-stable_current_amd64.deb forticlient.deb

# Docker Group
newgrp docker && exit
