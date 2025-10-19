#!/bin/bash

# Скрипт для установки VDI клиента

set -e

INSTALL_DIR="$HOME/basis-vdi-client"
SOURCE_DIR=$(pwd)

echo "Установка VDI клиента в $INSTALL_DIR..."

# 1. Создаем директорию для установки
mkdir -p "$INSTALL_DIR/.config"

# 2. Копируем только те файлы, что нужны для ЗАПУСКА
# (Dockerfile, entrypoint и т.д. уже внутри Docker-образа)
cp "$SOURCE_DIR/docker-compose.yml" "$INSTALL_DIR/"
cp "$SOURCE_DIR/.config/app-config" "$INSTALL_DIR/.config/"
cp "$SOURCE_DIR/basis-vdi-client.svg" "$INSTALL_DIR/"

# 3. Создаем скрипт для запуска
cat > "$INSTALL_DIR/launch.sh" << EOL
#!/bin/sh
cd "\$(dirname "\$0")"
export PROJECT_CONFIG_DIR="\$(pwd)/.config"

(
    echo "0"; echo "Обновление образа... (это может занять время)";
    docker-compose pull > /dev/null 2>&1
    echo "75"; echo "Запуск контейнера...";
    docker-compose up -d > /dev/null 2>&1
    echo "100";
) | zenity --progress --title="Запуск Basis VDI Client" --text="Инициализация..." --auto-close --percentage=0 --width=400

EOL

chmod +x "$INSTALL_DIR/launch.sh"

# 4. Создаем и устанавливаем .desktop файл
DESKTOP_FILE_PATH="$HOME/.local/share/applications/basis-vdi-client.desktop"

cat > "$DESKTOP_FILE_PATH" << EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=Basis VDI Client
Comment=Клиент для удаленного доступа
Exec=$INSTALL_DIR/launch.sh
Icon=$INSTALL_DIR/basis-vdi-client.svg
Categories=Network;RemoteAccess;
Terminal=false
EOL

chmod +x "$DESKTOP_FILE_PATH"

echo ""
echo "Установка завершена!"
echo "Ярлык приложения 'Basis VDI Client' добавлен в ваше меню приложений."