#!/bin/sh

set -e

echo "[1/4] Dropbear"
sed -i 's/channel=.*/channel="debug"/g' /etc/init.d/dropbear || true
/etc/init.d/dropbear restart || true

echo "[2/4] WiFi country + features"

uci set wireless.radio0.country='FR'
uci set wireless.radio1.country='FR'

uci set wireless.@wifi-iface[0].bss_transition='1'
uci set wireless.@wifi-iface[0].ieee80211k='1'
uci set wireless.@wifi-iface[0].ieee80211v='1'

uci set wireless.@wifi-iface[1].bss_transition='1'
uci set wireless.@wifi-iface[1].ieee80211k='1'
uci set wireless.@wifi-iface[1].ieee80211v='1'

uci commit wireless
wifi reload
sleep 10

echo "[3/4] TX power script"

cat > /etc/init.d/wifi-tx-reg <<'EOF'
#!/bin/sh /etc/rc.common
START=99

REGDOM="FR"

start() {
    iw reg set "$REGDOM"
    sleep 5

    iwconfig wl0 txpower 23 2>/dev/null || true
    iwconfig wl1 txpower 20 2>/dev/null || true
}
EOF

chmod +x /etc/init.d/wifi-tx-reg
/etc/init.d/wifi-tx-reg enable

echo "[4/4] start service + reboot"
 /etc/init.d/wifi-tx-reg start || true

sleep 20
reboot
