# Set the working dir, where all compiled Verilog goes.
vlib testfind

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)

vlog -timescale 1ns/1ns find_intersection.v

# Load simulation using alureg as the top level simulation module.
vsim find_intersection

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Apply reset
force {resetn} 0 0, 1 2 -r 200

###### 
# Apply clk
force {clk} 0 0, 1 1 -r 2
force {stop_true} 0 0, 1 3 -r 4

force {prev_block_start} 00011100 0, 00100100 100
force {prev_block_end} 00100100 0, 00110100 100
force {prev_block_size} 010 0

force {curr_block_start} 00011100 0
force {curr_block_end} 00100100 0
force {curr_block_size} 010 0

# Run simulation for a few ns.
run 200ns

