boot:
	arm-none-eabi-gcc -mcpu=cortex-a7 -fpic -ffreestanding -c boot.S -o boot.o  
kernel:  
	arm-none-eabi-gcc -mcpu=cortex-a7 -fpic -ffreestanding -std=gnu99 -c kernel.c -o kernel.o -O2 -Wall -Wextra  
os: boot|kernel  
	arm-none-eabi-gcc -T linker.ld -o myos.elf -ffreestanding -O2 -nostdlib boot.o kernel.o
emu:os  
	qemu-system-arm -m 256 -M raspi2 -serial stdio -kernel myos.elf
clean:  
	rm *.o  
	rm *.elf