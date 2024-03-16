#!/usr/bin/env bash
#
# unpack, modify and re-pack the Xiaomi R3600 firmware
# removes checks for release channel before starting dropbear
#
# 2020.07.20  darell tan
# 

FSDIR=/mnt/rootfs/ubi

# apply patch from xqrepack repository
find patches -type f -exec bash -c "(cd "$FSDIR" && patch -p1) < {}" \;
find patches -type f -name \*.orig -delete

rm -f $FSDIR/lib/wifi/qcawificfg80211.sh.orig
rm -f $FSDIR/usr/lib/lua/luci/view/web/inc/wifi.html.orig
rm -f $FSDIR/usr/lib/lua/luci/view/web/setting/wifi.htm.orig
rm -f $FSDIR/etc/init.d/dropbear.orig
rm -f $FSDIR/etc/shadow.orig

cp -R usr/* "$FSDIR/usr/"
