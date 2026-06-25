#!/usr/bin/env bash
#
# sysupgrade MT7981 CLT-R30B1 112M - TAR CLEAN
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

# squashfs magic check
MAGIC=$(hexdump -n 4 -e '4/1 "%02x"' "$ROOTFS")
[ "$MAGIC" = "68737173" ] || { echo "not squashfs rootfs"; exit 1; }

echo "[*] Preparing sysupgrade files..."

# IMPORTANT: pas de dossier sysupgrade dans le tar
mkdir -p "$TMPDIR/root"

cp "$KERNEL" "$TMPDIR/root/kernel"
cp "$ROOTFS" "$TMPDIR/root/rootfs"

# CONTROL minimal (optionnel mais utile)
cat > "$TMPDIR/root/CONTROL" <<EOF
board=mt7981-clt-r30b1-112M
format=sysupgrade-tar
EOF

echo "[*] Building TAR..."

# IMPORTANT FIX:
# on archive le CONTENU du dossier, pas le dossier lui-même
tar --format=gnu -cf "$OUTPUT" -C "$TMPDIR/root" .

echo "[*] Done -> $OUTPUT"
echo "[*] Size: $(stat -c%s "$OUTPUT") bytes"
echo "[*] Test archive:"
tar -tf "$OUTPUT" || echo "WARNING: tar invalid"
