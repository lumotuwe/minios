CROSS_COMPILER ?= arm-none-eabi-
CC := $(CROSS_COMPILER)gcc
AS := $(CROSS_COMPILER)as
GDB := $(CROSS_COMPILER)gdb
OBJCOPY := $(CROSS_COMPILER)objcopy
OBJDYMP := $(CROSS_COMPILER)objdump
#CFLAGS = -march=armv5te -mtune=arm926ej-s 
CFLAGS = -T vmlinux.lds -nostartfiles -nostdlib \
		-Ttext 0x00010000 -g
OBJCOPYFLAGS = -j .text -j .data -j .bss --gap-fill=0xff
TARGET = vmlinux


$(TARGET): head.s main.c
	$(CC) $(CFLAGS) $^ -o vmlinux.elf
	$(OBJCOPY) -Obinary $(OBJCOPYFLAGS) vmlinux.elf $@
	$(OBJDYMP) -S vmlinux.elf > vmlinux.list
	echo "vmlinux is ready"
	

qemu: $(TARGET)
	@qemu-system-arm -serial mon:stdio -M versatilepb -m 128 -nographic -kernel $(TARGET)

gdb: $(TARGET)
	@gnome-terminal --geometry  128x96-0+0 -e "$(GDB)" &
	@qemu-system-arm -s -S -serial mon:stdio -M versatilepb -nographic -kernel $(TARGET)

clean:
	rm -f *.o *.elf *.bin *.list $(TARGET)
