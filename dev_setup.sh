#!/bin/bash
set -e

# ---------- VARIABLES ----------
USR="$(whoami)"
HOMEDIR="/home/$USR"

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
  build-essential \
  linux-headers-$(uname -r) \
  gcc g++ make \
  apt-transport-https \
  ca-certificates \
  software-properties-common

# ---------- SOFTWARE GENERAL ----------
sudo apt install -y \
  git unzip neofetch htop curl wget feh mpv vlc \
  python3-pip zsh filezilla qbittorrent vim

# ---------- CONFIG VIM ----------
echo ':syntax on' >> "$HOMEDIR/.vimrc"
echo ':set number' >> "$HOMEDIR/.vimrc"
sudo cp "$HOMEDIR/.vimrc" /root/.vimrc

# ---------- OH MY ZSH (correcto) ----------
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  --unattended --skip-chsh

# ---------- GOOGLE CHROME ----------
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt -f install -y

# ---------- DOCKER ----------
echo "Instalando Docker..."

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
   https://download.docker.com/linux/ubuntu \
   $(. /etc/os-release && echo ${VERSION_CODENAME}) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-compose
sudo usermod -aG docker "$USR"

# ---------- VISUAL STUDIO CODE ----------
echo "Instalando VSCode..."

wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor > packages.microsoft.gpg

sudo install -D -o root -g root -m 644 packages.microsoft.gpg \
  /etc/apt/keyrings/packages.microsoft.gpg

echo \
"deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
 https://packages.microsoft.com/repos/code stable main" \
 | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

rm packages.microsoft.gpg
sudo apt update && sudo apt install -y code

# ---------- POSTMAN ----------
echo "Instalando Postman..."

wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
sudo tar -xvf postman.tar.gz -C /opt/
sudo ln -sf /opt/Postman/Postman /usr/bin/postman

cat <<EOF | sudo tee /usr/share/applications/Postman.desktop > /dev/null
[Desktop Entry]
Name=Postman
Exec=/usr/bin/postman
Terminal=false
Type=Application
Icon=/opt/Postman/app/resources/app/assets/icon.png
EOF

rm postman.tar.gz

# ---------- SPOTIFY ----------
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg \
 | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

echo "deb https://repository.spotify.com stable non-free" \
 | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update
sudo apt install -y spotify-client

# ---------- NVM + NODE 18 ----------
echo "Instalando NVM + Node 18..."

wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh -O nvm_install.sh
bash nvm_install.sh
rm nvm_install.sh

export NVM_DIR="$HOMEDIR/.nvm"
source "$NVM_DIR/nvm.sh"

nvm install 18
nvm use 18
nvm alias default 18

# ---------- LOGITECH DRIVERS (logiops) ----------
echo "Instalando logiops..."

sudo apt install -y cmake pkg-config libevdev-dev libudev-dev libconfig++-dev libglib2.0-dev

cd "$HOMEDIR"
git clone https://github.com/PixlOne/logiops.git
cd logiops && mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
sudo systemctl enable logid

cd "$HOMEDIR"
rm -rf logiops

# ---------- PNPM ----------
curl -fsSL https://get.pnpm.io/install.sh | sh -

# ---------- ANGULAR ----------
pnpm install -g @angular/cli@20

# ---------- ICON THEME ----------
echo "Instalando arc-icon-theme..."
git clone https://github.com/horst3180/arc-icon-theme --depth=1
sudo cp -R arc-icon-theme/Arc /usr/share/icons/
rm -rf arc-icon-theme

# ---------- FIREFOX FIX ----------
sudo apt install -y --reinstall firefox

# ---------- WINE ----------
sudo dpkg --add-architecture i386
sudo apt update

sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key \
  https://dl.winehq.org/wine-builds/winehq.key

wget -NP /etc/apt/sources.list.d/ \
  https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources

sudo apt update
sudo apt install -y --install-recommends winehq-stable

# ---------- LIMPIEZA ----------
sudo rm -f google-chrome-stable_current_amd64.deb

echo "-------------------------------------------------------"
echo " INSTALACIÓN COMPLETA — Ubuntu Dev Setup finalizado"
echo "-------------------------------------------------------"
