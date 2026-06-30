FIRMWARE_URL := https://cdn.cnbj1.fds.api.mi-img.com/xiaoqiang/rom/rd23/miwifi_rd23_all_cea07_1.0.97_INT.bin
FIRMWARE := miwifi_rd23_all_cea07_1.0.97_INT.bin

TARGET := $(FIRMWARE)_SSH.bin

all: $(TARGET)

orig-firmwares/$(FIRMWARE).bin:
	mkdir -p orig-firmwares
	curl -L "$(FIRMWARE_URL)" -o $@

$(FIRMWARE)_SSH.bin: orig-firmwares/$(FIRMWARE).bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$(FIRMWARE).bin

	# UBI INFO (AVANT extraction)
	ubireader_display_info $<

	ubireader_extract_images -w $<

	fakeroot -- ./repack-squashfs.sh \
		ubifs-root/$(FIRMWARE).bin/img-*_vol-rootfs.ubifs \
		cuong.ga \
		1234567890

	./ubinize.sh \
		ubifs-root/$(FIRMWARE).bin/img-*_vol-kernel.ubifs \
		ubifs-root/$(FIRMWARE).bin/img-*_vol-rootfs.ubifs.new

	mv r3600-raw-img.bin $@
