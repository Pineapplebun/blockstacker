# Set the working dir, where all compiled Verilog goes.
vlib testload

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)

vlog -timescale 1ns/1ns load.v

# Load simulation using alureg as the top level simulation module.
vsim load

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Apply reset
force {reset_load} 0 0, 1 2 -r 200

######
# Apply clk
force {clk} 0 0, 1 1 -r 2
force {colour_erase_enable} 0 0, 1 3 -r 4

force {colour_in[2:0]} 111 0

force {ld_x} 0 0, 1 20 -r 40
force {ld_y} 0 0, 1 20 -r 40

force {curr_level[5:0]} 10#1 0
force {curr_level[5:0]} 10#2 40
force {curr_level[5:0]} 10#3 80
force {curr_level[5:0]} 10#4 120 


# Run simulation for a few ns.
run 200ns
