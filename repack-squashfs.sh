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

# make sure our backdoors are always enabled by default
sed -i '/ssh_en/d;' "$FSDIR/usr/share/xiaoqiang/xiaoqiang-reserved.txt"
sed -i '/ssh_en=/d; /uart_en=/d; /boot_wait=/d;' "$FSDIR/usr/share/xiaoqiang/xiaoqiang-defaults.txt"
cat <<XQDEF >> "$FSDIR/usr/share/xiaoqiang/xiaoqiang-defaults.txt"
uart_en=1
ssh_en=1
boot_wait=on
XQDEF

# always reset our access nvram variables
grep -q -w enable_dev_access "$FSDIR/lib/preinit/31_restore_nvram" || \
 cat <<NVRAM >> "$FSDIR/lib/preinit/31_restore_nvram"
enable_dev_access() {
	nvram set uart_en=1
	nvram set ssh_en=1
	nvram set boot_wait=on
	nvram commit
}

boot_hook_add preinit_main enable_dev_access
NVRAM

# apply patch from xqrepack repository
find patches -type f -exec bash -c "(cd "$FSDIR" && patch -p1) < {}" \;
find patches -type f -name \*.orig -delete

rm -f $FSDIR/lib/wifi/qcawificfg80211.sh.orig
rm -f $FSDIR/usr/lib/lua/luci/view/web/apsetting/wifi.htm.orig
rm -f $FSDIR/usr/lib/lua/luci/view/web/inc/wifi.html.orig
rm -f $FSDIR/usr/lib/lua/luci/view/web/setting/wifi.htm.orig
rm -f $FSDIR/usr/share/xiaoqiang/xiaoqiang_version.orig

>&2 echo "repacking squashfs..."
rm -f "$IMG.new"
mksquashfs "$FSDIR" "$IMG.new" -b 256k -comp xz
