# VHDL Processor simulation

This projectis a simulation for a single-bus processor.
## Installation
### Requirments:

- Python

- An [HDL](https://en.wikipedia.org/wiki/List_of_HDL_simulators) simulator like ModelSim



## Usage
### Writing code
Write your code in input.txt file inside inputs folder.

There are many samples that you could use in the inputs folder.

To write our assembly code you have to follow the following sample, Please note that extra spaces empty lines would generate an error in the assembler.

Our code is not case-sensitive.

This code generates an array of 3*3, where: Arr[ i, j]= i + j
```assembly
mov #arr,r2
clr r0
clr r1
l1:
inc r0
l2:
inc r1
mov r0,r3
add r1,r3
mov r3,(r2)+
cmp r1,n
bne l2
clr r1
cmp r0,n
bne l1
hlt
define arr 0,0,0,0,0,0,0,0,0
define n 3

```
### Assembling
After writing your code in input.txt, in the main folder type the following python command.

```bash
python run.py
```
### Running simulation
The assembler automatically generates a text file in vhdl-code folder named RAM-DATA.txt, running a simulation will automatically load this file into ram.

Note that you have to set reg_clear to 0xFFFF for one clock then to 0x0000 again to initialize the registers.
The following dofile could be used for intializaton.
```dofile
vsim -gui work.main
add wave sim:/main/*
force -freeze sim:/main/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/main/reg_clear 111111111111111111 0
force -freeze sim:/main/testinput ZZZZZZZZZZZZZZZZ 0
run

force -freeze sim:/main/reg_clear 000000000000000000
run
```
## Parameters
Data segment starts at 0 and ends at 499.

Code segment starts at 500 and ends at the end of the memory.

note that to change code segment starting index, you have to change the  variable in both run.py and the default value in ram vhdl module.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
