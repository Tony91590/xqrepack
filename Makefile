FIRMWARES:=$(shell cd orig-firmwares; ls *.bin | sed 's/\.bin$$//')

TARGETS_SSH:=$(patsubst %,%_SSH.bin,$(FIRMWARES))
TARGETS:=$(shell echo $(TARGETS_SSH) | sed 's/ /\n/g' | sort)

all: $(TARGETS)

%_SSH.bin: orig-firmwares/%.bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	unsquashfs -f -d orig-firmwares/$*.bin
	fakeroot -- ./repack-squashfs.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	mv r3600-raw-img.bin $@
