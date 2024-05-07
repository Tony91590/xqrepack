FIRMWARES:=$(shell cd orig-firmwares;curl -O https://cdn.awsde0-fusion.fds.api.mi-img.com/xiaoqiang/rom/r3600/miwifi_r3600_all_6510e_3.0.22_INT.bin; ls *.bin | sed 's/\.bin$$//')

TARGETS_SSH:=$(patsubst %,%_SSH.bin,$(FIRMWARES))
TARGETS:=$(shell echo $(TARGETS_SSH) | sed 's/ /\n/g' | sort)

all: $(TARGETS)

%_SSH.bin: orig-firmwares/%.bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	ubireader_extract_images -w orig-firmwares/$*.bin
	fakeroot -- ./repack-squashfs.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	mv r3600-raw-img.bin $@
