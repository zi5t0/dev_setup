# Ubuntu Dev Setup

Este repositorio contiene un instalador completo para configurar un entorno de desarrollo en **Ubuntu 22.04 / 24.04**, incluyendo:

- Paquetes básicos de desarrollo
- Google Chrome, Visual Studio Code, Postman, Spotify
- Docker + Docker Compose
- Node.js LTS + NVM + PNPM + Angular CLI
- Oh-My-Zsh con plugins
- WineHQ
- Fuentes y temas

---

## Archivos

- `setup.py` → Script principal de instalación (Python)
- `packages.json` → Configuración de paquetes y aplicaciones

---

## Uso

1. Clonar el repositorio:
```bash
git clone https://github.com/tu_usuario/dev_setup.git
cd dev_setup
```

2. Dar permisos al script:
```bash
chmod +x setup.py
```

3. Ejecutar el instalador:
```bash
./setup.py
```

> El script pedirá permisos de sudo cuando sea necesario.

4. Reinicia tu terminal o ejecuta:
```bash
exec zsh
```

---

## One-liner (ejecución directa desde Internet)

```bash
curl -s https://raw.githubusercontent.com/tu_usuario/dev_setup/main/setup.py | python3
```

> ⚠️ Asegúrate de revisar el script antes de ejecutar directamente desde internet.

---

## Personalización

- Modifica `packages.json` para añadir o quitar paquetes, aplicaciones o comandos post-instalación.
- Cambia `zsh_config` para ajustar el tema y plugins.
- Puedes añadir más herramientas en `development_tools`.

---
