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

cat > $FSDIR/etc/uci-defaults/enable_force_https.sh << EOF
#!/bin/sh
# for BSI certification, force https for all web access by default in UK region
if [ "$(bdata get CountryCode)" = "UK" ]; then
	uci set nginx.main.force_https=1
	uci commit nginx
fi
EOF

cat $FSDIR/etc/uci-defaults/enable_force_https.sh

# apply patch from xqrepack repository
find patches -type f -exec bash -c "(cd "$FSDIR" && patch -p1) < {}" \;
find patches -type f -name \*.orig -delete

rm -f $FSDIR/etc/init.d/dropbear.orig
rm -f $FSDIR/usr/bin/uci2dat.orig
rm -f $FSDIR/sbin/wifi.orig
rm -f $FSDIR/lib/preinit/31_restore_nvram.orig
rm -f $FSDIR/usr/sbin/wifi_update.orig

>&2 echo "repacking squashfs..."
rm -f "$IMG.new"
mksquashfs "$FSDIR" "$IMG.new" -comp xz -b 256K -no-xattrs
