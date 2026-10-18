#!/bin/sh
set -e

printf 'Введите подсеть LAN (например, 192.168.7.0/24): '
read -r LAN_SUBNET

# Backup firewall configuration
BACKUP_DIR="$(mktemp -d /root/tailscale-lan-backup.XXXXXX)"
cp -p /etc/config/firewall "$BACKUP_DIR/firewall"
echo "Резервная копия: $BACKUP_DIR"

# Allow forwarding from Tailscale to LAN
uci set firewall.tailscale_lan='rule'
uci set firewall.tailscale_lan.name='Allow-Tailscale-to-LAN'
uci set firewall.tailscale_lan.src='tailscale'
uci set firewall.tailscale_lan.dest='lan'
uci set firewall.tailscale_lan.family='ipv4'
uci set firewall.tailscale_lan.proto='all'
uci set firewall.tailscale_lan.dest_ip="$LAN_SUBNET"
uci set firewall.tailscale_lan.target='ACCEPT'
uci commit firewall

# Validate and apply firewall configuration
if ! fw4 check; then
    cp -p "$BACKUP_DIR/firewall" /etc/config/firewall
    echo "Ошибка проверки firewall. Исходный файл восстановлен."
    exit 1
fi

if ! /etc/init.d/firewall reload; then
    cp -p "$BACKUP_DIR/firewall" /etc/config/firewall
    /etc/init.d/firewall reload || true
    echo "Ошибка применения firewall. Исходный файл восстановлен."
    exit 1
fi

# Enable persistent IPv4 forwarding
mkdir -p /etc/sysctl.d
printf 'net.ipv4.ip_forward=1\n' \
    > /etc/sysctl.d/90-tailscale-forwarding.conf
sysctl -p /etc/sysctl.d/90-tailscale-forwarding.conf

# Advertise LAN subnet without source NAT
tailscale set \
    --advertise-routes="$LAN_SUBNET" \
    --snat-subnet-routes=false
