# Set the working dir, where all compiled Verilog goes.
vlib testblocktracker

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)

vlog -timescale 1ns/1ns block_tracker.v

# Load simulation using alureg as the top level simulation module.
vsim block_tracker

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Apply reset
force {resetn} 1 0, 0 25

# Apply clk
force {clk} 0 0, 1 1 -r 2
force {stop_true} 1 0, 0 100
force {intersect_true} 1 0, 0 50, 1 75, 0 75 
force {curr_block_start} 00011100 0, 00110000 75
force {curr_block_end} 00100100 0, 01011000 75
force {curr_block_size} 010 0, 010 0
# Run simulation for a few ns.
run 125ns

