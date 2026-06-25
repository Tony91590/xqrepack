#!/usr/bin/env bash
#
# Build sysupgrade image (MT7981 CLT-R30B1 112M)
# no UBI, bootloader simple compatible
#

set -e

KERNEL=$1
ROOTFS=$2
BOARD="mt7981-clt-r30b1-112M"

OUT="sysupgrade-${BOARD}.bin"
TMPDIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

# --- checks ---
[ -f "$KERNEL" ] || { echo "kernel missing"; exit 1; }
[ -f "$ROOTFS" ] || { echo "rootfs missing"; exit 1; }

ROOTFS_SIG=$(hexdump -n 4 -e '"%_p"' "$ROOTFS")
[ "$ROOTFS_SIG" = "hsqs" ] || { echo "not squashfs rootfs"; exit 1; }

echo "[*] Creating CONTROL..."

cat > "$TMPDIR/CONTROL" <<EOF
board=$BOARD
kernel_size=$(stat -c%s "$KERNEL")
rootfs_size=$(stat -c%s "$ROOTFS")
format=sysupgrade-simple
EOF

echo "[*] CONTROL:"
cat "$TMPDIR/CONTROL"

# --- build image ---
echo "[*] Building sysupgrade image..."

rm -f "$OUT"

# magic header (simple identifier)
echo "OWRT-SIMPLE-IMG" > "$OUT"

# CONTROL
cat "$TMPDIR/CONTROL" >> "$OUT"
echo -e "\n---" >> "$OUT"

# kernel
cat "$KERNEL" >> "$OUT"
echo -e "\n---" >> "$OUT"

# rootfs
cat "$ROOTFS" >> "$OUT"

echo "[*] Done -> $OUT"
echo "[*] Size: $(stat -c%s "$OUT") bytes"
