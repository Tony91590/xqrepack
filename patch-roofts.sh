#!/usr/bin/env bash
#
# unpack, modify and re-pack the Xiaomi R3600 firmware
# removes checks for release channel before starting dropbear
#
# 2020.07.20  darell tan
# 

FSDIR=/mnt/rootfs/ubi

# create /opt dir
#mkdir "$FSDIR/opt"
#chmod 755 "$FSDIR/opt"

# stop resetting root password
sed -i 's/flg_init_pwd=.*/flg_init_pwd=0/' "$FSDIR/etc/init.d/boot_check"

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

# stop phone-home in web UI
#cat <<JS >> "$FSDIR/www/js/miwifi-monitor.js"
#(function(){ if (typeof window.MIWIFI_MONITOR !== "undefined") window.MIWIFI_MONITOR.log = function(a,b) {}; })();
#JS

# dont start crap services
#for SVC in stat_points statisticsservice \
#		datacenter \
#		xq_info_sync_mqtt \
#		xiaoqiang_sync \
#		plugincenter plugin_start_script.sh cp_preinstall_plugins.sh; do
#	rm -f $FSDIR/etc/rc.d/[SK]*$SVC
#done

# prevent stats phone home & auto-update
#for f in StatPoints mtd_crash_log logupload.lua otapredownload; do > $FSDIR/usr/sbin/$f; done

#sed -i '/start_service(/a return 0' $FSDIR/etc/init.d/messagingagent.sh

# cron jobs are mostly non-OpenWRT stuff
#for f in $FSDIR/etc/crontabs/*; do
#	sed -i 's/^/#/' $f
#done

# as a last-ditch effort, change the *.miwifi.com hostnames to localhost
#sed -i 's@\w\+.miwifi.com@localhost@g' $FSDIR/etc/config/miwifi

# apply patch from xqrepack repository
find patches -type f -exec bash -c "(cd "$FSDIR" && patch -p1) < {}" \;
find patches -type f -name \*.orig -delete

rm -f $FSDIR/lib/wifi/qcawificfg80211.sh.orig
rm -f $FSDIR/usr/lib/lua/luci/view/web/inc/wifi.html.orig
rm -f $FSDIR/usr/lib/lua/luci/view/web/setting/wifi.htm.orig
rm -f $FSDIR/etc/init.d/dropbear.orig
rm -f $FSDIR/etc/shadow.orig

cp -R usr/* "$FSDIR/usr/"
