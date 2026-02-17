#!/bin/bash

set -e

# ---------------------------------------------------------
#  UTILIDAD: imprimir mensajes bonitos
# ---------------------------------------------------------
info()  { echo -e "\e[34m[INFO]\e[0m $1"; }
ok()    { echo -e "\e[32m[OK]\e[0m $1"; }
warn()  { echo -e "\e[33m[WARN]\e[0m $1"; }
error() { echo -e "\e[31m[ERROR]\e[0m $1"; exit 1; }

# ---------------------------------------------------------
#  DETECCIÓN DEL GESTOR DE PAQUETES
# ---------------------------------------------------------
detect_package_manager() {
    if command -v apt >/dev/null 2>&1; then PM="apt"
    elif command -v dnf >/dev/null 2>&1; then PM="dnf"
    elif command -v zypper >/dev/null 2>&1; then PM="zypper"
    elif command -v pacman >/dev/null 2>&1; then PM="pacman"
    else error "No se encontró un gestor de paquetes compatible."
    fi
    info "Gestor detectado: $PM"
}

# ---------------------------------------------------------
#  ACTUALIZAR SISTEMA
# ---------------------------------------------------------
update_system() {
    info "Actualizando sistema..."
    case "$PM" in
        apt) sudo apt update && sudo apt upgrade -y ;;
        dnf) sudo dnf upgrade -y ;;
        zypper) sudo zypper refresh && sudo zypper update -y ;;
        pacman) sudo pacman -Syu --noconfirm ;;
    esac
}

# ---------------------------------------------------------
#  INSTALAR PAQUETES
# ---------------------------------------------------------
install_packages() {
    info "Instalando paquetes base..."

    case "$PM" in
        apt)
            sudo apt install -y \
                build-essential linux-headers-$(uname -r) \
                gcc g++ make git unzip curl wget feh mpv vlc \
                python3-pip zsh filezilla qbittorrent neofetch \
                htop ca-certificates software-properties-common \
                apt-transport-https
            ;;
        dnf)
            sudo dnf install -y \
                @development-tools kernel-headers kernel-devel \
                gcc-c++ make git unzip curl wget feh mpv vlc \
                python3-pip zsh filezilla qbittorrent neofetch \
                htop
            ;;
        zypper)
            sudo zypper install -y \
                -t pattern devel_basis \
                kernel-devel gcc gcc-c++ make git unzip curl wget \
                feh mpv vlc python3-pip zsh filezilla qbittorrent \
                neofetch htop
            ;;
        pacman)
            sudo pacman -S --noconfirm \
                base-devel linux-headers gcc make git unzip curl wget \
                feh mpv vlc python-pip zsh filezilla qbittorrent \
                neofetch htop
            ;;
    esac
    ok "Paquetes base instalados."
}

# ---------------------------------------------------------
#  DOCKER
# ---------------------------------------------------------
install_docker() {
    info "Instalando Docker..."
    curl -fsSL https://get.docker.com | sudo bash
    sudo usermod -aG docker "$USER"
    ok "Docker instalado."
}

# ---------------------------------------------------------
#  CHROME
# ---------------------------------------------------------
install_chrome() {
    info "Instalando Google Chrome..."
    case "$PM" in
        apt)
            wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo apt install -y ./chrome.deb
            rm chrome.deb
            ;;
        dnf|zypper)
            sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
            sudo tee /etc/yum.repos.d/google-chrome.repo <<EOF >/dev/null
[google-chrome]
name=Google Chrome Repository
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
            sudo $PM install -y google-chrome-stable
            ;;
        pacman)
            info "Instalando Chrome desde AUR (requiere yay)."
            if ! command -v yay >/dev/null 2>&1; then
                warn "Instalando yay..."
                git clone https://aur.archlinux.org/yay.git
                cd yay && makepkg -si --noconfirm && cd ..
            fi
            yay -S --noconfirm google-chrome
            ;;
    esac
}

# ---------------------------------------------------------
#  OH-MY-ZSH
# ---------------------------------------------------------
install_ohmyzsh() {
    info "Instalando Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        RUNZSH=no CHSH=yes sh -c \
            "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

# ---------------------------------------------------------
#  H Y P R L A N D
# ---------------------------------------------------------
install_hyprland() {
    info "Instalando Hyprland (Wayland)..."

    case "$PM" in
        pacman)
            sudo pacman -S --noconfirm hyprland hyprpaper hyprcursor foot waybar
            ;;
        dnf)
            sudo dnf copr enable solopasha/hyprland -y
            sudo dnf install -y hyprland
            ;;
        zypper)
            sudo zypper install -y hyprland
            ;;
        apt)
            sudo add-apt-repository ppa:hyprland-dev/hyprland -y
            sudo apt update
            sudo apt install -y hyprland
            ;;
    esac

    ok "Hyprland instalado."
}

# ---------------------------------------------------------
#  NVM + PNPM
# ---------------------------------------------------------
install_nvm_pnpm() {
    info "Instalando NVM + PNPM..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
    nvm install --lts
    npm install -g pnpm
}

# ---------------------------------------------------------
#  VIRTUALBOX
# ---------------------------------------------------------
install_virtualbox() {
    info "Instalando VirtualBox..."
    case "$PM" in
        apt) sudo apt install -y virtualbox ;;
        dnf) sudo dnf install -y VirtualBox ;;
        zypper) sudo zypper install -y virtualbox ;;
        pacman) sudo pacman -S --noconfirm virtualbox ;;
    esac
}

# ---------------------------------------------------------
# EJECUCIÓN
# ---------------------------------------------------------
main() {
    detect_package_manager
    update_system
    install_packages
    install_docker
    install_chrome
    install_ohmyzsh
    install_hyprland
    install_nvm_pnpm
    install_virtualbox
    ok "¡Instalación completada!"
    echo "Reinicia para aplicar todos los cambios."
}

main "$@"
