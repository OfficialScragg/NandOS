main:
	nasm NandOS.asm -f bin -o ./bin/NandOS.iso

run: main
	qemu-system-x86_64 ./bin/NandOS.iso