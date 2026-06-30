#!/usr/bin/env bash

set -e

KERNEL=$1
ROOTFS=$2
OUTPUT=${3:-ubi-repack.bin}

ubinize -V >/dev/null || { echo "need ubinize (mtd-utils)"; exit 1; }

[ -f "$KERNEL" ] || { echo "kernel image missing"; exit 1; }
[ -f "$ROOTFS" ] || { echo "rootfs image missing"; exit 1; }

UBICFG=$(mktemp /tmp/ubicfg.XXXXX)
trap "rm -f $UBICFG" EXIT

cat <<EOF > $UBICFG
[kernel]
mode=ubi
image=$KERNEL
vol_id=0
vol_type=dynamic
vol_name=kernel
vol_alignment=1

[rootfs]
mode=ubi
image=$ROOTFS
vol_id=1
vol_type=dynamic
vol_name=rootfs
vol_alignment=1
EOF

ubinize \
    -m 2048 \
    -p 128KiB \
    -o "$OUTPUT" \
    "$UBICFG"

echo "done -> $OUTPUT"
