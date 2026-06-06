#!/usr/bin/env bash
#
# unpack, modify and re-pack the Xiaomi R3600 firmware
# removes checks for release channel before starting dropbear
#
# 2020.07.20  darell tan
# 

set -e

IMG=$1
NEWIPK="miniupnpd_2.0.20170421-3_aarch64_cortex-a53_neon-vfpv4.ipk"

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
        "$FSDIR/etc/rc.d/S94miniupnpd"
fi


>&2 echo "repacking squashfs..."
rm -f "$IMG.new"
mksquashfs "$FSDIR" "$IMG.new" -comp xz -b 256K -no-xattrs
