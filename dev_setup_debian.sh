#!/bin/bash
set -e

USR="$(whoami)"
HOMEDIR="/home/$USR"

sudo apt update && sudo apt upgrade -y

# 1. WAYLAND + HYPERLAND
sudo apt install -y \
  xserver-xorg \
  xwayland \
  seatd \
  dbus-user-session \
  mesa-utils \
  mesa-vulkan-drivers \
  hyperland \
  wofi \
  waybar \
  swaybg \
  swaylock \
  wl-clipboard \
  grim \
  slurp \
  mako-notifier \
  xdg-desktop-portal \
  xdg-desktop-portal-wlr

sudo systemctl enable --now seatd

echo "exec hyperland" > "$HOMEDIR/.xinitrc"
sudo chown "$USR":"$USR" "$HOMEDIR/.xinitrc"

sudo apt install -y build-essential linux-headers-$(uname -r) gcc g++ make
sudo apt install -y apt-transport-https ca-certificates software-properties-common
sudo apt install -y \
  git unzip neofetch htop curl wget feh mpv vlc \
  python3-pip zsh filezilla qbittorrent

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo apt install -y -f
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended --skip-chsh

sudo apt install -y vim
echo ':syntax on' >> "$HOMEDIR/.vimrc"
echo ':set number' >> "$HOMEDIR/.vimrc"
sudo cp "$HOMEDIR/.vimrc" /root/.vimrc

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] \
   https://download.docker.com/linux/debian \
   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
sudo apt install -y docker-ce docker-compose
sudo usermod -aG docker "$USR"

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm microsoft.gpg

echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
 https://packages.microsoft.com/repos/vscode stable main" \
 | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt update && sudo apt install -y code

wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
sudo tar -xvf postman.tar.gz -C /opt/
sudo ln -sf /opt/Postman/Postman /usr/bin/postman

cat <<EOF > Postman.desktop
[Desktop Entry]
Name=Postman
Exec=/usr/bin/postman
Terminal=false
Type=Application
Icon=/opt/Postman/app/resources/app/assets/icon.png
EOF

sudo mv Postman.desktop /usr/share/applications/Postman.desktop

sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt -f install -y

curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg \
 | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

echo "deb http://repository.spotify.com stable non-free" \
 | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update
sudo apt install -y spotify-client

wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh -O nvm_install.sh
bash nvm_install.sh
rm nvm_install.sh

export NVM_DIR="$HOMEDIR/.nvm"
source "$NVM_DIR/nvm.sh"

nvm install 18
nvm use 18
nvm alias default 18

sudo apt install -y build-essential cmake pkg-config libevdev-dev libudev-dev libconfig++-dev libglib2.0-dev

git clone https://github.com/PixlOne/logiops.git
cd logiops && mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
cd ~
rm -rf logiops
sudo systemctl enable logid

curl -fsSL https://get.pnpm.io/install.sh | sh -

pnpm install -g @angular/cli@20

git clone https://github.com/horst3180/arc-icon-theme --depth 1
sudo cp -R arc-icon-theme/Arc /usr/share/icons/
rm -rf arc-icon-theme

sudo apt -y install --reinstall firefox

sudo rm -f google-chrome-stable_current_amd64.deb

sudo dpkg --add-architecture i386
sudo apt update -y
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ \
 https://dl.winehq.org/wine-builds/debian/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources

sudo apt update -y
sudo apt install -y --install-recommends winehq-stable

echo "INSTALACIÓN COMPLETA."
