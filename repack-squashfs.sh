#!/bin/sh
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

# apply patch from xqrepack repository
find patches -type f -exec bash -c "(cd "$FSDIR" && patch -p1) < {}" \;
find patches -type f -name \*.orig -delete

rm -f $FSDIR/etc/init.d/dropbear.orig
rm -f $FSDIR/etc/shadow.orig
rm -f $FSDIR/usr/share/xiaoqiang/xiaoqiang_version.orig

>&2 echo "repacking squashfs..."
rm -f "$IMG.new"
mksquashfs "$FSDIR" "$IMG.new" -b 256k -comp xz
