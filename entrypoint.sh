#!/bin/sh

# 1. Запускаем pcscd демон
pcscd
sleep 1

# 2. Определяем опции для Zenity
ZENITY_OPTS="--width=400 --height=150 --window-icon=/usr/share/icons/basis-vdi-client.svg"

# 3. Запускаем цикл запроса PIN-кода
while true; do
    PIN=$(zenity --password --title="Введите ПИН от Рутокен" --text="Введите ПИН от Рутокен" $ZENITY_OPTS)
    
    if [ $? -ne 0 ]; then
        zenity --error --text="Ввод отменен пользователем." $ZENITY_OPTS
        exit 1
    fi

    CERT_LIST=$(pkcs11-tool --module /usr/lib/librtpkcs11ecp.so --slot 0 --login --list-objects --pin "$PIN" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        ID=$(echo "$CERT_LIST" | awk '/Certificate Object/{f=1} f && /ID:/{print $2; exit}')
        
        if [ -n "$ID" ]; then
            export VPN_CERT_ID=$ID
            export VPN_PASSWORD=$PIN
            zenity --info --text="ПИН принят." $ZENITY_OPTS
            break
        else
            zenity --error --text="Не удалось найти ID сертификата на токене. Попробуйте еще раз." $ZENITY_OPTS
        fi
    else
        zenity --error --text="Неверный ПИН-код или ошибка чтения токена. Попробуйте еще раз." $ZENITY_OPTS
    fi
done

# 4. Запускаем VPN с проверкой
LOG_FILE=/tmp/snx.log
/opt/snx-rs/snx-rs \
  -m standalone \
  -o vpn_Certificate_VTB \
  -s cvpn.vtb.ru \
  --cert-type pkcs11 \
  --cert-path /usr/lib/librtpkcs11ecp.so \
  --cert-id "$VPN_CERT_ID" \
  -X true \
  -x "$VPN_PASSWORD" \
  -t false > "$LOG_FILE" 2>&1 &

SNX_PID=$!

# Ждем несколько секунд, чтобы дать VPN время на подключение
sleep 10

# Проверяем лог на наличие ошибки
if grep -q "Error: Request failed, error code: 503" "$LOG_FILE"; then
  kill $SNX_PID
  zenity --error --text="Не удалось подключиться к VPN (ошибка 503).\nПожалуйста, попробуйте позднее." $ZENITY_OPTS
  exit 1
fi

# 5. Запускаем VDI клиент
pkill -f /opt/vdi-client/bin/desktop-client
exec /usr/bin/xrdp-run &
exec /opt/vdi-client/bin/desktop-client