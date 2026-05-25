#!/bin/sh
#
# Xiaomi R3600 firmware patcher
# - unpack squashfs
# - replace miniupnpd package
# - enable dropbear
# - repack squashfs
#

set -e

IMG="root.2.ubi"

NEWIPK="miniupnpd_2.0.20170421-3_aarch64_cortex-a53_neon-vfpv4.ipk"

#
# checks
#

[ -f "$IMG" ] || {
    echo "missing firmware image: $IMG"
    exit 1
}

[ -f "$NEWIPK" ] || {
    echo "missing ipk: $NEWIPK"
    exit 1
}

command -v unsquashfs >/dev/null 2>&1 || {
    echo "install squashfs-tools"
    exit 1
}

command -v mksquashfs >/dev/null 2>&1 || {
    echo "install squashfs-tools"
    exit 1
}

FSDIR=$(mktemp -d /tmp/r3600-rootfs.XXXXXX)
TMPIPK=$(mktemp -d /tmp/r3600-ipk.XXXXXX)

trap 'rm -rf "$FSDIR" "$TMPIPK"' EXIT

#
# verify fakeroot/root
#

mknod "$FSDIR/test" c 0 0 2>/dev/null || {
    echo "run with fakeroot"
    exit 1
}

rm -f "$FSDIR/test"

#
# unpack
#

echo "[+] unpacking squashfs..."
unsquashfs -f -d "$FSDIR" "$IMG"

#
# remove existing miniupnpd
#

echo "[+] removing stock miniupnpd..."

rm -f "$FSDIR/usr/sbin/miniupnpd"
rm -f "$FSDIR/etc/init.d/miniupnpd"
rm -f "$FSDIR/etc/config/upnpd"
rm -f "$FSDIR/usr/lib/opkg/info/miniupnpd"*
rm -rf "$FSDIR/usr/share/miniupnpd"

#
# install replacement ipk
#

echo "[+] installing replacement miniupnpd..."

tar xf "$NEWIPK" -C "$TMPIPK"

DATA=$(find "$TMPIPK" -name "data.tar.*" | head -n1)

[ -n "$DATA" ] || {
    echo "invalid ipk"
    exit 1
}

case "$DATA" in
    *.gz)
        tar xzf "$DATA" -C "$FSDIR"
        ;;
    *.xz)
        tar xJf "$DATA" -C "$FSDIR"
        ;;
    *.zst)
        tar --zstd -xf "$DATA" -C "$FSDIR"
        ;;
    *)
        echo "unsupported ipk compression"
        exit 1
        ;;
esac

#
# permissions
#

[ -f "$FSDIR/usr/sbin/miniupnpd" ] && \
chmod 755 "$FSDIR/usr/sbin/miniupnpd"

[ -f "$FSDIR/etc/init.d/miniupnpd" ] && \
chmod 755 "$FSDIR/etc/init.d/miniupnpd"

#
# enable miniupnpd at boot
#

mkdir -p "$FSDIR/etc/rc.d"

if [ -f "$FSDIR/etc/init.d/miniupnpd" ]; then
    ln -sf ../init.d/miniupnpd \
        "$FSDIR/etc/rc.d/S95miniupnpd"
fi

#
#
# repack
#

echo "[+] rebuilding squashfs..."

rm -f "$IMG.new"

mksquashfs "$FSDIR" "$IMG.new" \
    -noappend \
    -b 256k \
    -comp xz

echo
echo "[+] DONE"
echo "[+] output: $IMG.new"
