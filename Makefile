FIRMWARES:=$(shell cd orig-firmwares; ls *.bin | sed 's/\.bin$$//')

TARGETS_SSH:=$(patsubst %,%_SSH.bin,$(FIRMWARES))
TARGETS:=$(shell echo $(TARGETS_SSH) | sed 's/ /\n/g' | sort)

all: $(TARGETS)
	./ubinize.sh ubifs-root/kernel.1.ubi ubifs-root/root.2.ubi
	mv r3600-raw-img.bin
