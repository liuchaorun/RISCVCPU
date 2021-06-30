./riscv32-unknown-elf-gcc -E Fibonacci.c -o Fibonacci.i
./riscv32-unknown-elf-gcc -S Fibonacci.i -o Fibonacci.s
./riscv32-unknown-elf-gcc -c Fibonacci.s -o Fibonacci.o
./riscv32-unknown-elf-gcc -static Fibonacci.o -o Fibonacci.out
./riscv32-unknown-elf-objdump -S Fibonacci.out > Fibonacci.txt

./riscv32-unknown-elf-gcc -E BubbleSort.c -o BubbleSort.i
./riscv32-unknown-elf-gcc -S BubbleSort.i -o BubbleSort.s
./riscv32-unknown-elf-gcc -c BubbleSort.s -o BubbleSort.o
./riscv32-unknown-elf-gcc -static BubbleSort.o -o BubbleSort.out
./riscv32-unknown-elf-objdump -S BubbleSort.out > BubbleSort.txt