#!/usr/bin/env bash
set -e

# =========================
# INPUTS
# =========================
KERNEL="$1"
ROOTFS="$2"
OUTPUT="${3:-r3600-raw-img.bin}"

# =========================
# CHECKS
# =========================
[ -f "$KERNEL" ] || { echo "kernel introuvable"; exit 1; }
[ -f "$ROOTFS" ] || { echo "rootfs introuvable"; exit 1; }

# squashfs check ("hsqs")
ROOTFS_SIG=$(hexdump -n 4 -e '"%_p"' "$ROOTFS")
[ "$ROOTFS_SIG" = "hsqs" ] || { echo "rootfs pas squashfs"; exit 1; }

# kernel check ("d00dfeed")
KERNEL_SIG=$(hexdump -n 4 -e '1/1 "%02x"' "$KERNEL")
[ "$KERNEL_SIG" = "d00dfeed" ] || { echo "kernel invalide"; exit 1; }

# =========================
# CREATE UBI IMAGE
# =========================
UBICFG=$(mktemp)
trap "rm -f $UBICFG" EXIT

cat > "$UBICFG" <<EOF
[kernel]
mode=ubi
image=$KERNEL
vol_id=0
vol_type=dynamic
vol_name=kernel

[rootfs]
mode=ubi
image=$ROOTFS
vol_id=1
vol_type=dynamic
vol_name=ubi_rootfs
EOF

RAW_UBI="$(mktemp)"
trap "rm -f $UBICFG $RAW_UBI" EXIT

ubinize -m 2048 -p 128KiB -o "$RAW_UBI" "$UBICFG"

# =========================
# MINI mkxqimage (integré)
# =========================

write_value() {
    printf "$(eval printf "$(printf '\\\\x%%02x%.0s' $(seq 1 $3))" \
    $(printf '$(($2>>%d&0xff)) ' $(seq 0 8 $(($3*8-8)))))" | \
    dd of="$1" bs=1 count=$3 seek=${4:-0} conv=notrunc 2>/dev/null
}

MODEL=24   # R3600

HDR_SIZE=48
[ "$HDR_SIZE" -lt 48 ] && HDR_SIZE=48
HDR_SIZE=$((HDR_SIZE/4*4))

SEG_OFF=16
CUR_OFF=$HDR_SIZE

# =========================
# BUILD FINAL IMAGE
# =========================
OUT_TMP=$(mktemp)
trap "rm -f $UBICFG $RAW_UBI $OUT_TMP" EXIT

# header
printf "HDR1" > "$OUT_TMP"
dd if=/dev/zero bs=$((HDR_SIZE - 4)) count=1 >> "$OUT_TMP" 2>/dev/null

# model
write_value "$OUT_TMP" "$MODEL" 2 14

# segment table (1 seul segment: UBI image)
SEG_NAME="r3600-ubi"
write_value "$OUT_TMP" "$CUR_OFF" 4 "$SEG_OFF"

printf "\xbe\xba\x00\x00\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\x00\x00" >> "$OUT_TMP"
printf "$SEG_NAME" >> "$OUT_TMP"
dd if=/dev/zero bs=1 count=$((32-${#SEG_NAME})) >> "$OUT_TMP" 2>/dev/null

dd if="$RAW_UBI" >> "$OUT_TMP"

write_value "$OUT_TMP" "$(stat -c%s "$RAW_UBI")" 4 $(($CUR_OFF+8))

CUR_OFF=$(stat -c%s "$OUT_TMP")
[ $((CUR_OFF % 4)) -ne 0 ] && dd if=/dev/zero bs=1 count=$((4-(CUR_OFF%4))) >> "$OUT_TMP" 2>/dev/null

CUR_OFF=$(stat -c%s "$OUT_TMP")

# end marker
write_value "$OUT_TMP" "$CUR_OFF" 4 4

# fake signature area (comme script original)
printf '\x00%.0s' $(seq 1 272) >> "$OUT_TMP"

# CRC placeholder (comme original)
write_value "$OUT_TMP" 0 4 8

mv "$OUT_TMP" "$OUTPUT"

echo "OK: firmware généré -> $OUTPUT"
