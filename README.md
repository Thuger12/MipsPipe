# MIPS
Mips-ish processor with 5 stage pipeline.
![alt text](MIPS.png "MIPS")

### Others modules(not included in main processor)
* Make MMIO for UART and Ethernet. Something like that:
![alt-text](MMIO.png "MMIO")
* Out of order execution(Tomasulo algorithm).
* Memory with TEXT, STACK, DATA segments.
* Cache(2 way associative).
* ALU with faster adder(carry out propagation)