#!/usr/bin/env bash
#
# sysupgrade MT7981 CLT-R30B1 112M (TAR format)
#

set -e

KERNEL=$1
ROOTFS=$2

OUTPUT="r3600-raw-img.bin"

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# --- checks ---
[ -f "$KERNEL" ] || { echo "kernel missing"; exit 1; }
[ -f "$ROOTFS" ] || { echo "rootfs missing"; exit 1; }

# squashfs check
MAGIC=$(hexdump -n 4 -e '4/1 "%02x"' "$ROOTFS")
[ "$MAGIC" = "68737173" ] || { echo "not squashfs rootfs"; exit 1; }

echo "[*] Building sysupgrade tar..."

# structure OpenWrt-like
mkdir -p "$TMPDIR/sysupgrade-mt7981-clt-r30b1-112M"

cp "$KERNEL" "$TMPDIR/sysupgrade-mt7981-clt-r30b1-112M/kernel"
cp "$ROOTFS" "$TMPDIR/sysupgrade-mt7981-clt-r30b1-112M/rootfs"

# optional metadata (standard style)
cat > "$TMPDIR/sysupgrade-mt7981-clt-r30b1-112M/CONTROL" <<EOF
board=mt7981-clt-r30b1-112M
format=sysupgrade-tar
EOF

# build tar (IMPORTANT: -H gnu pour compatibilité OpenWrt)
tar -C "$TMPDIR" -cf "$OUTPUT" --format=gnu sysupgrade

echo "[*] Done -> $OUTPUT"
echo "[*] Size: $(stat -c%s "$OUTPUT") bytes"
