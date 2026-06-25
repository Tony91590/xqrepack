KERNEL_URL := https://github.com/Tony91590/openwrt-EDUP-RT2980/raw/refs/heads/main/firmware-backup/software%20mtd/ubi_kernel.bin
ROOTFS_URL := https://github.com/Tony91590/openwrt-EDUP-RT2980/raw/refs/heads/main/firmware-backup/software%20mtd/ubi_rootfs.bin

TARGET := RT2980_SSH.bin

all: $(TARGET)

$(TARGET): repack-squashfs.sh ubinize.sh
	rm -f $@
	rm -f ubi_kernel.bin ubi_rootfs.bin ubi_rootfs.bin.new
	rm -f r3600-raw-img.bin

	wget -O ubi_kernel.bin "$(KERNEL_URL)"
	wget -O ubi_rootfs.bin "$(ROOTFS_URL)"

	fakeroot -- ./repack-squashfs.sh \
		ubi_rootfs.bin \
		cuong.ga \
		1234567890

	./ubinize.sh ubi_kernel.bin ubi_rootfs.bin.new

	mv r3600-raw-img.bin $@

clean:
	rm -f RT2980_SSH.bin
	rm -f ubi_kernel.bin ubi_rootfs.bin ubi_rootfs.bin.new
	rm -f r3600-raw-img.bin
