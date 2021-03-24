# MIPS
Mips-ish processor with 5 stage pipeline.
![alt text](MIPS.png "MIPS")

### TODO:
* Memory with TEXT, STACK, DATA segments.
* DRAM controller
* Address decoder(MMIO)
* Cache L1

### Others modules(not included in main processor)
* MMIO for UART and Ethernet. Something like that:
![alt-text](MMIO.png "MMIO")
* Cache(2 way associative).

### Other stuff to implement, but not include
* Out of order execution(Tomasulo algorithm).
* ALU with faster adder(carry out propagation)

