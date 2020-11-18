//lab 5

iverilog -o test cpu_testbench.v
vvp test
gtkwave e16388_cpu_wavedata.vcd