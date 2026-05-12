#!/bin/sh

set -e

echo "[1/4] Dropbear"
sed -i 's/channel=.*/channel="debug"/g' /etc/init.d/dropbear
/etc/init.d/dropbear restart

echo "[2/4] WiFi country + features"

uci set wireless.wifi0.country='FR'
uci set wireless.wifi1.country='FR'

uci set wireless.@wifi-iface[0].bss_transition='1'
uci set wireless.@wifi-iface[0].ieee80211k='1'
uci set wireless.@wifi-iface[0].ieee80211v='1'

uci set wireless.@wifi-iface[1].bss_transition='1'
uci set wireless.@wifi-iface[1].ieee80211k='1'
uci set wireless.@wifi-iface[1].ieee80211v='1'

uci commit wireless

echo "[3/4] TX power script"

cat > /etc/init.d/wifi-tx-reg <<'EOF'
#!/bin/sh /etc/rc.common
START=99

REGDOM="FR"
TXPOWER_WL0=23
TXPOWER_WL1=20

start() {
    iw reg set "$REGDOM"

    wifi reload
    sleep 10

    iwconfig wl0 txpower "$TXPOWER_WL0"
    iwconfig wl1 txpower "$TXPOWER_WL1"
}
EOF

chmod +x /etc/init.d/wifi-tx-reg
/etc/init.d/wifi-tx-reg enable

echo "[4/4] start service + reboot"
 /etc/init.d/wifi-tx-reg start

sleep 20
reboot
