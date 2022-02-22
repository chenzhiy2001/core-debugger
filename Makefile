TOOLCHAIN_NAME:=riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14

GDB:=$(TOOLCHAIN_NAME)/bin/riscv64-unknown-elf-gdb

CORE_NAME := rCore-Tutorial-v3

TARGET := riscv64gc-unknown-none-elf
MODE := release
SYMBOL_BIN := $(CORE_NAME)/os/target/$(TARGET)/$(MODE)/os
KERNEL_BIN := $(SYMBOL_BIN).bin
FS_IMG := $(CORE_NAME)/user/target/$(TARGET)/$(MODE)/fs.img

fast_github:
	@git config --global url."https://hub.fastgit.xyz/".insteadOf "https://github.com/"
	@git config protocol.https.allow always

fast_github_client:
	@git config --global http.proxy http://127.0.0.1:38457
	@git config --global https.proxy http://127.0.0.1:38457
	@./fastgithub_linux-x64/fastgithub & 

unzip_toolchain:
#   no need. docker extracted tar.gz archive when building image
#	@tar -xvf $(TOOLCHAIN_NAME).tar.gz


build_run_rcore_tutorial:
	@cd $(CORE_NAME)/os && make build
	@qemu-system-riscv64 \
		-machine virt \
		-nographic \
		-bios $(CORE_NAME)/bootloader/rustsbi-qemu.bin \
		-device loader,file=$(KERNEL_BIN),addr=0x80200000 \
		-drive file=$(FS_IMG),if=none,format=raw,id=x0 \
        -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0\
		-s -S &


run_gdbgui:
	@python3 -m gdbgui -r --gdb-cmd $(GDB)






