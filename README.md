# Fractaski
This project implements a manycore design based on BRISKI RISC-V to display fractals on Basys3 fpga board through a VGA port with minimalistic framebuffer resources.

# Run demo
First in software folder run:
make compile_link_c

Then run:
make c_hex_gen

Type
make compile_basys3

You now obtained the bitstream!
Connect the board and program the fpga
Type vivado
Go [Open HW Monitor]