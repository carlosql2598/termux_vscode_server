# ⚡ VS Code en Termux con Ubuntu — setup rápido

Este repo instala y configura **Visual Studio Code vía code-server** en **Termux** usando **Ubuntu con proot-distro**. Resultado: VS Code corriendo en tu Android, accesible desde el navegador.

> Base técnica tomadas de la guía de [Andromux](https://www.andromux.org/posts/vscode-termux/)

## 🚀 Qué hace este proyecto

- Provisiona **Ubuntu** dentro de Termux con `proot-distro`.
- Instala **code-server** (VS Code) para **ARM64**.
- Configura **contraseña** y deja un **launcher** simple para iniciarlo.

## 📂 Archivos

- `ubuntu_installer.sh` — instala dependencias en Termux, provisiona Ubuntu y deja un acceso rápido para entrar a ese Ubuntu.  
- `code_server_installer.sh` — detecta la **última versión** de code-server en GitHub, descarga el **tar.gz ARM64**, genera/establece **CODE_SERVER_PASSWORD** y enlaza un **start_code-server** listo para correr.

## ✅ Requisitos

- Android con **Termux** (descárgalo desde **F-Droid**, no Play Store).  
- Conexión a Internet.  
- Dispositivo **ARM64** (la mayoría de teléfonos Android modernos). Si usas x86/x86_64 en emulador, ajusta el nombre del artefacto al de tu arquitectura.

---

## 🔧 Instalación

### 1) Preparar Termux + Ubuntu

1. Abre Termux y otorga permisos de almacenamiento cuando lo pida. 📱
2. Corre el script:

```bash
chmod +x ubuntu_installer.sh
./ubuntu_installer.sh
```

Este script: actualiza Termux, instala `wget`, `openssl-tool`, `proot`, `proot-distro`, instala **Ubuntu**, crea un comando `ubuntu` para entrar directo y prepara `wget` dentro del Ubuntu.

> Si te sale algún prompt, acepta. 👍

### 2) Instalar code-server (dentro de Ubuntu)

1. Entra a Ubuntu (si aún no lo estás):

```bash
ubuntu
```

2. Dentro de Ubuntu, ejecuta:

```bash
chmod +x code_server_installer.sh
./code_server_installer.sh
```

- El script detecta la **última versión** desde GitHub y descarga `code-server-<versión>-linux-arm64.tar.gz`, lo extrae y te deja un **launcher** `./start_code-server`.  
- Si no defines `CODE_SERVER_PASSWORD` de antemano, te pedirá una o te generará una aleatoria y la exportará en `~/.bashrc`. También intenta sincronizarla con `/root/.config/code-server/config.yaml`.

### 3) Ejecutar VS Code

Sigue dentro de Ubuntu y lanza:

```bash
./start_code-server
```

Ahora abre tu navegador en Android y visita: 🌐

```
http://localhost:8080
```

Introduce la contraseña que configuraste (o la que te imprimió el script). 🔑

> Nota: `config.yaml` se encuentra en `/root/.config/code-server/config.yaml`. Ahí va la `password` y, si necesitas, más ajustes (puerto, bind, etc.).

---

## 🔄 Actualizar code-server

Vuelve a ejecutar:

```bash
./code_server_installer.sh
```

Descargará la versión más reciente disponible y actualizará el launcher. ⬆️

---

## 🔒 Configuración útil (seguridad y red)

### Cambiar puerto, bind y auth

Edita `/root/.config/code-server/config.yaml` y agrega/ajusta:

```yaml
bind-addr: 127.0.0.1:8080
auth: password
password: TU_PASSWORD
```

- **Sólo local**: deja `127.0.0.1` (recomendado).  
- **LAN** (no recomendado sin proxy/autenticación adicional): usa `0.0.0.0:8080`.  
- Documentación oficial de instalación y FAQ: https://coder.com/docs/code-server

---

## 🛠️ Troubleshooting

1. **“Incorrect password” al entrar**  
   - Edita el `config.yaml` en `/root/.config/code-server/`.  
   - Reinicia code-server tras cambiar la contraseña. 🔄

2. **No encuentro el `config.yaml`**  
   - code-server lo crea al primer arranque; lánzalo una vez y revisa `/root/.config/code-server/`.  

3. **Puerto 8080 en uso**  
   - Cambia `bind-addr` a otro puerto en `config.yaml` y reinicia. ⚠️

4. **Arquitectura incorrecta**  
   - Si no eres ARM64, cambia el archivo a descargar por tu arquitectura (`linux-x64`, etc.). Ver página de releases de code-server. 🖥️

---

## 🙌 Créditos y recursos

- **Guía base**: *Visual Studio Code en Android Termux 2025* ([Andromux ORG](https://www.andromux.org/posts/vscode-termux/)).  
- **Docs oficiales code-server**: https://coder.com/docs/code-server  
- **proot-distro** (Termux).
