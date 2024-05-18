FIRMWARES:=$(shell cd orig-firmwares; ls *.bin | sed 's/\.bin$$//')

TARGETS_SSH:=$(patsubst %,%_SSH.bin,$(FIRMWARES))
TARGETS:=$(shell echo $(TARGETS_SSH) | sed 's/ /\n/g' | sort)

all: $(TARGETS)

%_SSH.bin: orig-firmwares/%.bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	fakeroot -- ./repack-squashfs.sh ubifs-root/$*.bin/kernel.1.ubi
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/root.2.ubi
	mv r3600-raw-img.bin $@
