#!/usr/bin/env bash
#
# unpack, modify and re-pack the Xiaomi R3600 firmware
# removes checks for release channel before starting dropbear
#
# 2020.07.20  darell tan
# 

set -e

IMG=$1

[ -e "$IMG" ] || { echo "rootfs img not found $IMG"; exit 1; }

# verify programs exist
command -v unsquashfs &>/dev/null || { echo "install unsquashfs"; exit 1; }
mksquashfs -version >/dev/null || { echo "install mksquashfs"; exit 1; }

FSDIR=`mktemp -d /tmp/resquash-rootfs.XXXXX`
trap "rm -rf $FSDIR" EXIT

# test mknod privileges
mknod "$FSDIR/foo" c 0 0 2>/dev/null || { echo "need to be run with fakeroot"; exit 1; }
rm -f "$FSDIR/foo"

>&2 echo "unpacking squashfs..."
unsquashfs -f -d "$FSDIR" "$IMG"

>&2 echo "patching squashfs..."

cat > "$FSDIR/etc/hotplug.d/iface/99-country-sync" <<'EOF'
#!/bin/sh

[ -z "$ACTION" ] && ACTION="manual"

case "$ACTION" in
    ifup|ifdown|reload|start|stop|manual) ;;
    *) exit 0 ;;
esac

ccode="$(nvram get CountryCode 2>/dev/null)"
[ -z "$ccode" ] && exit 0

logger -t country-sync "apply country=$ccode event=$ACTION"

WIRELESS="/etc/config/wireless"

# Vérifie si le fichier existe
[ -f "$WIRELESS" ] || exit 0

# Vérifie si changement réel nécessaire (évite rewrite inutile)
current="$(grep -m1 "option country" "$WIRELESS" 2>/dev/null | awk -F"'" '{print $2}')"

[ "$current" = "$ccode" ] && exit 0

# Applique le changement
sed -i "s/^[[:space:]]*option country .*/\toption country '$ccode'/" "$WIRELESS"

# Anti-loop simple : évite reload si déjà en cours
LOCK="/tmp/country-sync.lock"

if [ -f "$LOCK" ]; then
    exit 0
fi

touch "$LOCK"

# petit délai pour éviter cascades hotplug
sleep 2

/sbin/wifi reload

sleep 3
rm -f "$LOCK"

exit 0
EOF

chmod +x "$FSDIR/etc/hotplug.d/iface/99-country-sync"

# apply patch from xqrepack repository
find patches -type f -exec bash -c "(cd "$FSDIR" && patch -p1) < {}" \;
find patches -type f -name \*.orig -delete

rm -f $FSDIR/etc/init.d/dropbear.orig
rm -f $FSDIR/usr/bin/uci2dat.orig
rm -f $FSDIR/sbin/wifi.orig

>&2 echo "repacking squashfs..."
rm -f "$IMG.new"
mksquashfs "$FSDIR" "$IMG.new" -comp xz -b 256K -no-xattrs
