FIRMWARE_URL:=http://cdn.cnbj1.fds.api.mi-img.com/xiaoqiang/rom/r3600/miwifi_r3600_firmware_79ecc_1.1.25.bin

FIRMWARE_FILE:=$(notdir $(FIRMWARE_URL))

FIRMWARES:=$(shell cd orig-firmwares 2>/dev/null; ls *.bin 2>/dev/null | sed 's/\.bin$$//')

TARGETS_SSH:=$(patsubst %,%_SSH.bin,$(FIRMWARES))
TARGETS:=$(shell echo $(TARGETS_SSH) | sed 's/ /\n/g' | sort)

all: download $(TARGETS)

download:
	mkdir -p orig-firmwares
	wget -N -O orig-firmwares/$(FIRMWARE_FILE) $(FIRMWARE_URL)

%_SSH.bin: orig-firmwares/%.bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	ubireader_extract_images -w orig-firmwares/$*.bin
	fakeroot -- ./repack-squashfs.sh \
		ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs \
		cuong.ga 1234567890
	./ubinize.sh \
		ubifs-root/$*.bin/img-*_vol-kernel.ubifs \
		ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	mv r3600-raw-img.bin $@
