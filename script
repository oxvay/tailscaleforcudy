#!/bin/sh
set -e

# Backup
BACKUP_DIR="$(mktemp -d /root/tailscale-backup.XXXXXX)"
for CONFIG in network firewall dhcp podkop; do
    cp -p "/etc/config/$CONFIG" "$BACKUP_DIR/$CONFIG"
done
echo "Резервные копии: $BACKUP_DIR"

# Download and verify SHA
wget -O /tmp/tailscale-small.apk \
  'https://github.com/GuNanOvO/openwrt-tailscale/releases/download/v1.104.1/tailscale_1.104.1_aarch64_cortex-a53.apk'

echo 'd665dfdffd935c118bf75555747accc1e75e76097d2aa72fc704a7cc5a752f90  /tmp/tailscale-small.apk' | sha256sum -c -

# Install
apk update
apk add --allow-untrusted /tmp/tailscale-small.apk
rm -f /tmp/tailscale-small.apk

# Disable autostart
/etc/init.d/tailscale disable

# Firewall for Tailscale
uci set firewall.tailscale='zone'
uci set firewall.tailscale.name='tailscale'
uci -q delete firewall.tailscale.device || true
uci add_list firewall.tailscale.device='tailscale0'
uci set firewall.tailscale.input='REJECT'
uci set firewall.tailscale.output='ACCEPT'
uci set firewall.tailscale.forward='REJECT'
# Allow SSH and web interface
uci set firewall.tailscale_admin='rule'
uci set firewall.tailscale_admin.name='Allow-Tailscale-Admin'
uci set firewall.tailscale_admin.src='tailscale'
uci set firewall.tailscale_admin.proto='tcp'
uci set firewall.tailscale_admin.dest_port='22 80 443'
uci set firewall.tailscale_admin.target='ACCEPT'

uci commit firewall

# Check firewall
if ! fw4 check; then
    cp -p "$BACKUP_DIR/firewall" /etc/config/firewall
    echo "Ошибка проверки firewall. Исходный файл восстановлен."
    exit 1
fi
/etc/init.d/firewall reload

# Start Service
/etc/init.d/tailscale start
sleep 3

#Tailscale up
echo "Открой ссылку и авторизуйся"
tailscale up \
  --hostname=cudy-wr3000s \
  --accept-dns=false \
  --accept-routes=false \
  --netfilter-mode=off

echo
echo "Статус Tailscale:"
tailscale status
echo
echo "IP роутера в Tailscale"
tailscale ip -4
