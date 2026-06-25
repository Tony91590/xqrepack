#!/usr/bin/env bash
#
# sysupgrade-mt7981-clt-r30b1-112M (clean squash format)
#

set -e

KERNEL=$1
ROOTFS=$2

# ⚠️ NE PAS CHANGER le nom de sortie (comme demandé)
OUTPUT="r3600-raw-img.bin"

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# --- checks ---
[ -f "$KERNEL" ] || { echo "kernel missing"; exit 1; }
[ -f "$ROOTFS" ] || { echo "rootfs missing"; exit 1; }

# squashfs magic check (hsqs = 0x68737173)
MAGIC=$(hexdump -n 4 -e '4/1 "%02x"' "$ROOTFS")
[ "$MAGIC" = "68737173" ] || { echo "not squashfs rootfs"; exit 1; }

echo "[*] Creating metadata..."

KERNEL_SIZE=$(stat -c%s "$KERNEL")
ROOTFS_SIZE=$(stat -c%s "$ROOTFS")

KERNEL_HASH=$(sha256sum "$KERNEL" | awk '{print $1}')
ROOTFS_HASH=$(sha256sum "$ROOTFS" | awk '{print $1}')

# --- CONTROL file (outside image) ---
cat > "$TMPDIR/CONTROL" <<EOF
format=sysupgrade-squash
kernel_size=$KERNEL_SIZE
rootfs_size=$ROOTFS_SIZE
EOF

# --- SQHASH file (outside image) ---
cat > "$TMPDIR/SQHASH" <<EOF
kernel_sha256=$KERNEL_HASH
rootfs_sha256=$ROOTFS_HASH
EOF

echo "[*] CONTROL:"
cat "$TMPDIR/CONTROL"

echo "[*] SQHASH:"
cat "$TMPDIR/SQHASH"

# --- build image (STANDARD ONLY) ---
echo "[*] Building sysupgrade image..."

rm -f "$OUTPUT"

cat "$KERNEL" > "$OUTPUT"
cat "$ROOTFS" >> "$OUTPUT"

echo "[*] Done -> $OUTPUT"
echo "[*] Size: $(stat -c%s "$OUTPUT") bytes"
