#!/usr/bin/env python3
import os
import json
import subprocess
import getpass
from typing import Dict, List

# Colores para output
COLOR = {
    "blue": "\033[1;34m",
    "green": "\033[1;32m",
    "red": "\033[1;31m",
    "yellow": "\033[1;33m",
    "reset": "\033[0m"
}

def load_config() -> Dict:
    """Carga la configuración desde packages.json"""
    try:
        with open("packages.json", "r") as f:
            return json.load(f)
    except Exception as e:
        error_exit(f"No se pudo leer packages.json → {e}")

def run_cmd(command: str, desc: str, exit_on_fail: bool = False) -> bool:
    """Ejecuta comandos con manejo de errores"""
    print(f"{COLOR['blue']}» {desc}...{COLOR['reset']}")
    try:
        subprocess.run(
            command,
            shell=True,
            check=True,
            executable="/bin/bash"
        )
        print(f"{COLOR['green']}✓ {desc}{COLOR['reset']}")
        return True
    except subprocess.CalledProcessError:
        print(f"{COLOR['red']}✗ Error en: {desc}{COLOR['reset']}")
        if exit_on_fail:
            error_exit(f"Comando fallido: {command}")
        return False

def error_exit(message: str):
    print(f"{COLOR['red']}❌ {message}{COLOR['reset']}")
    exit(1)

# -----------------------------
# INSTALACIÓN DE PAQUETES
# -----------------------------
def install_system_packages(packages: List[str]):
    """Instala paquetes del sistema vía apt"""
    if not packages:
        return
    
    packages.append("linux-headers-$(uname -r)")
    
    run_cmd(
        f"sudo apt update && sudo apt install -y {' '.join(packages)}",
        "Instalando paquetes del sistema",
        exit_on_fail=True
    )

# -----------------------------
# APPS NATIVAS (repos externos)
# -----------------------------
def install_native_apps(apps: Dict):
    for app, config in apps.items():

        # VSCode
        if app == "vscode":
            run_cmd(
                f"wget -qO- {config['repo_url']}/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg >/dev/null && "
                f"echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] {config['repo_url']} stable main' | sudo tee /etc/apt/sources.list.d/vscode.list && "
                "sudo apt update && sudo apt install -y code",
                f"Instalando {config['description']}"
            )

        # Google Chrome
        elif app == "chrome":
            run_cmd(
                f"wget {config['deb_url']} -O /tmp/chrome.deb && sudo apt install -y /tmp/chrome.deb && rm /tmp/chrome.deb",
                f"Instalando {config['description']}"
            )

        # Postman
        elif app == "postman":
            run_cmd(
                f"wget {config['download_url']} -O /tmp/postman.tar.gz && "
                "sudo tar -xzf /tmp/postman.tar.gz -C /opt && "
                "rm /tmp/postman.tar.gz && "
                "sudo ln -sf /opt/Postman/Postman /usr/bin/postman",
                f"Instalando {config['description']}"
            )

        # Spotify
        elif app == "spotify":
            run_cmd(
                "curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | "
                "sudo gpg --dearmor -o /usr/share/keyrings/spotify.gpg && "
                f"echo 'deb [signed-by=/usr/share/keyrings/spotify.gpg] {config['repo_url']} stable non-free' | "
                "sudo tee /etc/apt/sources.list.d/spotify.list && "
                "sudo apt update && sudo apt install -y spotify-client",
                f"Instalando {config['description']}"
            )

        # WineHQ
        elif app == "wine":
            run_cmd(
                "sudo dpkg --add-architecture i386 && "
                "sudo mkdir -pm755 /etc/apt/keyrings && "
                f"wget -nc {config['repo_url']}/winehq.key -O /etc/apt/keyrings/winehq.gpg && "
                f"echo 'deb [signed-by=/etc/apt/keyrings/winehq.gpg] {config['repo_url']} $(lsb_release -cs) main' | "
                "sudo tee /etc/apt/sources.list.d/winehq.list && "
                "sudo apt update && sudo apt install -y --install-recommends winehq-stable",
                "Instalando WineHQ"
            )

# -----------------------------
# DOCKER
# -----------------------------
def setup_docker(docker_config: Dict):
    run_cmd(
        f"curl -fsSL {docker_config['repo_url']}/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg && "
        f"echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] {docker_config['repo_url']} $(lsb_release -cs) stable' | "
        "sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && "
        "sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io",
        "Instalando Docker Engine"
    )

    run_cmd(
        "sudo curl -L 'https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)' "
        "-o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose",
        "Instalando Docker Compose"
    )

# -----------------------------
# NODE (NVM) & PNPM
# -----------------------------
def setup_node_tools(devtools: Dict):

    # NVM
    run_cmd(
        f"curl -o- {devtools['nvm']['install_script']} | bash",
        "Instalando NVM"
    )

    # Cargar NVM en la sesión actual
    nvm_init = "source ~/.nvm/nvm.sh"

    # Node LTS
    run_cmd(
        f"{nvm_init} && nvm install --lts",
        "Instalando Node LTS"
    )

    # PNPM
    run_cmd(
        f"curl -fsSL {devtools['pnpm']['install_script']} | sh -",
        "Instalando PNPM"
    )

# -----------------------------
# ZSH + OH MY ZSH
# -----------------------------
def setup_zsh(zsh_config: Dict):
    run_cmd(
        f"sh -c \"$(curl -fsSL {zsh_config['oh_my_zsh_install']})\" \"\"",
        "Instalando Oh My Zsh"
    )

    # Plugins
    for plugin in zsh_config["plugins"]:
        run_cmd(
            f"git clone https://github.com/zsh-users/{plugin} $HOME/.oh-my-zsh/custom/plugins/{plugin}",
            f"Instalando plugin {plugin}"
        )

    # Escribir configuración
    zshrc_content = f"""
# Configuración automática
ZSH_THEME="{zsh_config['theme']}"
plugins=({' '.join(zsh_config['plugins'])})

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
"""
    with open(os.path.expanduser("~/.zshrc"), "a") as f:
        f.write(zshrc_content)

# -----------------------------
# POST-INSTALL
# -----------------------------
def execute_post_install(commands: List[str]):
    for cmd in commands:
        run_cmd(
            os.path.expandvars(cmd),
            f"Ejecutando: {cmd}"
        )

# -----------------------------
# MAIN
# -----------------------------
def main():
    print(f"{COLOR['yellow']}\n=== Instalador completo para Ubuntu ==={COLOR['reset']}")

    config = load_config()

    install_system_packages(config["system_packages"])
    install_native_apps(config["native_apps"])
    setup_docker(config["development_tools"]["docker"])
    setup_node_tools(config["development_tools"])
    setup_zsh(config["zsh_config"])
    execute_post_install(config["post_install_commands"])

    print(f"{COLOR['green']}✅ Instalación completada con éxito{COLOR['reset']}")
    print(f"{COLOR['yellow']}Ejecuta 'exec zsh' para cargar ZSH ahora.{COLOR['reset']}")

if __name__ == "__main__":
    main()
