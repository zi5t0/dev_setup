#!/usr/bin/env python3
import os
import json
import subprocess
import getpass
from typing import Dict, List

# Configuración de colores
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
        with open('packages.json', 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        error_exit("No se encontró packages.json")
    except json.JSONDecodeError:
        error_exit("El archivo packages.json está mal formado")

def run_cmd(command: str, desc: str, exit_on_fail: bool = False) -> bool:
    """Ejecuta un comando con manejo de errores"""
    print(f"{COLOR['blue']}» {desc}...{COLOR['reset']}")
    try:
        subprocess.run(
            command,
            shell=True,
            check=True,
            executable="/bin/bash",
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print(f"{COLOR['green']}✓ {desc} completado{COLOR['reset']}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"{COLOR['red']}✗ Error en: {desc}{COLOR['reset']}")
        if exit_on_fail:
            error_exit(f"Comando fallido: {command}")
        return False

def error_exit(message: str):
    """Muestra un mensaje de error y termina el script"""
    print(f"{COLOR['red']}❌ {message}{COLOR['reset']}")
    exit(1)

def install_system_packages(packages: List[str]):
    """Instala paquetes del sistema via apt"""
    if not packages:
        return
        
    # Añade los headers del kernel dinámicamente
    if "linux-headers-$(uname -r)" not in packages:
        packages.append("linux-headers-$(uname -r)")
    
    run_cmd(
        f"sudo apt update && sudo apt install -y {' '.join(packages)}",
        "Instalando paquetes del sistema",
        exit_on_fail=True
    )

def install_native_apps(apps: Dict):
    """Instala aplicaciones nativas desde repositorios externos"""
    for app, config in apps.items():
        if app == "vscode":
            run_cmd(
                f"wget -qO- {config['repo_url']}/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg >/dev/null && "
                f"echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] {config['repo_url']} stable main' | sudo tee /etc/apt/sources.list.d/vscode.list && "
                "sudo apt update && sudo apt install -y code",
                f"Instalando {config['description']}"
            )
        
        elif app == "chrome":
            run_cmd(
                f"wget {config['deb_url']} -O /tmp/chrome.deb && "
                "sudo apt install -y /tmp/chrome.deb && "
                "rm /tmp/chrome.deb",
                f"Instalando {config['description']}"
            )
        
        elif app == "postman":
            run_cmd(
                f"wget {config['download_url']} -O /tmp/postman.tar.gz && "
                "sudo tar -xzf /tmp/postman.tar.gz -C /opt && "
                "rm /tmp/postman.tar.gz && "
                "sudo ln -s /opt/Postman/Postman /usr/bin/postman",
                f"Instalando {config['description']}"
            )

def setup_docker(docker_config: Dict):
    """Configura Docker y Docker Compose"""
    run_cmd(
        f"curl -fsSL {docker_config['repo_url']}/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && "
        f"echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] {docker_config['repo_url']} $(lsb_release -cs) stable' | "
        "sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && "
        "sudo apt update && "
        "sudo apt install -y docker-ce docker-ce-cli containerd.io",
        "Instalando Docker"
    )
    
    run_cmd(
        "sudo curl -L 'https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose && "
        "sudo chmod +x /usr/local/bin/docker-compose",
        "Instalando Docker Compose"
    )

def setup_zsh(zsh_config: Dict):
    """Configura oh-my-zsh con plugins"""
    run_cmd(
        f'sh -c "$(curl -fsSL {zsh_config["oh_my_zsh_install"]})" ""',
        "Instalando Oh My Zsh"
    )
    
    for plugin in zsh_config["plugins"]:
        run_cmd(
            f"git clone https://github.com/zsh-users/{plugin} $HOME/.oh-my-zsh/custom/plugins/{plugin}",
            f"Instalando plugin {plugin}"
        )
    
    # Configuración del tema y plugins
    zshrc_content = f"""
# Configuración generada automáticamente
ZSH_THEME="{zsh_config['theme']}"
plugins=({' '.join(zsh_config['plugins'])})
    """
    with open(f"{os.path.expanduser('~')}/.zshrc", "a") as f:
        f.write(zshrc_content)

def execute_post_install(commands: List[str]):
    """Ejecuta comandos post-instalación"""
    for cmd in commands:
        expanded_cmd = os.path.expandvars(cmd)
        run_cmd(
            expanded_cmd,
            f"Ejecutando: {expanded_cmd}"
        )

def main():
    print(f"{COLOR['yellow']}\n=== Configurador Automático para Ubuntu/Debian ==={COLOR['reset']}")
    
    # Cargar configuración
    config = load_config()
    user = getpass.getuser()
    
    # 1. Instalar paquetes del sistema
    install_system_packages(config["system_packages"])
    
    # 2. Instalar aplicaciones nativas
    install_native_apps(config["native_apps"])
    
    # 3. Configurar Docker
    setup_docker(config["development_tools"]["docker"])
    
    # 4. Configurar ZSH
    setup_zsh(config["zsh_config"])
    
    # 5. Comandos post-instalación
    execute_post_install(config["post_install_commands"])
    
    print(f"\n{COLOR['green']}✅ ¡Configuración completada con éxito!{COLOR['reset']}")
    print(f"{COLOR['yellow']}Reinicia tu terminal o ejecuta: exec zsh{COLOR['reset']}")

if __name__ == "__main__":
    main()