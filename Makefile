all:
	rm -rf *.o main
	nasm -f elf32 -o list.o list.asm
	nasm -f elf32 -o main.o main.asm
	gcc -m32 -o main main.o list.o -nostartfiles
