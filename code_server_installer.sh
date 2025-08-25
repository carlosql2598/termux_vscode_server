#!/usr/bin/env bash

set -euo pipefail

CODE_SERVER_SOURCE="https://github.com/coder/code-server/releases"
CONFIG_FILE="/root/.config/code-server/config.yaml"
VERSION_DEFECTO="4.103.1"
VERSION=$(curl -sL "$CODE_SERVER_SOURCE"\
        | grep -oP '(?<=href="/coder/code-server/releases/tag/v)[0-9]+\.[0-9]+\.[0-9]+'\
        | head -1)

if [ -z "${VERSION:-}"  ]; then
    echo "No se encontró la última versión en $CODE_SERVER_SOURCE. Se usará por defecto la versión $VERSION_DEFECTO"
    if [ -t 0 ]; then
        read -r -p "¿Deseas continuar con la versión por defecto? (s/n): " continuar
        continuar="${continuar:-s}"

        if [ "${continuar,,}" != "s" ]; then
            read -r -p "Ingresa la versión deseada (ej. $VERSION_DEFECTO): " VERSION
        else
            VERSION="$VERSION_DEFECTO"
        fi
    else
        VERSION="$VERSION_DEFECTO"
    fi
fi

CODE_SERVER_FILE="code-server-$VERSION-linux-arm64.tar.gz"

wget "$CODE_SERVER_SOURCE/download/v$VERSION/$CODE_SERVER_FILE"
tar -xvf "$CODE_SERVER_FILE"
rm "$CODE_SERVER_FILE"
ln -sf "code-server-$VERSION-linux-arm64/bin/code-server" "./start_code-server"

if [ -z "${CODE_SERVER_PASSWORD:-}" ]; then
    if [ -t 0 ]; then
        read -r -p "Ingresa la contraseña para el servidor de código: " CODE_SERVER_PASSWORD
    else
        CODE_SERVER_PASSWORD="$(head -c 32 /dev/urandom | base64)"
        echo "La contraseña para el servidor de código es: ${CODE_SERVER_PASSWORD}"
    fi

    if grep -q '^export CODE_SERVER_PASSWORD=' ~/.bashrc 2>/dev/null; then
        sed -i "s|^export CODE_SERVER_PASSWORD=.*|export CODE_SERVER_PASSWORD=${CODE_SERVER_PASSWORD}|" ~/.bashrc
    else
        echo "export CODE_SERVER_PASSWORD=${CODE_SERVER_PASSWORD}" >> ~/.bashrc
    fi

    export CODE_SERVER_PASSWORD
fi

if grep -q "^password:" "$CONFIG_FILE"; then
    sed -i "s/^password:.*/password: ${CODE_SERVER_PASSWORD}/" "$CONFIG_FILE"
else
    echo "Advertencia: No se encontró la línea de 'password' en $FILE"
fi