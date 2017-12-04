# Set the working dir, where all compiled Verilog goes.
vlib testcontrol

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)

vlog -timescale 1ns/1ns control.v

# Load simulation using alureg as the top level simulation module.
vsim control

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Apply reset
force {resetn} 1 0, 0 2

# Apply clk
force {clk} 0 0, 1 1 -r 2
force {stop_true} 0 0
force {start} 0 0, 1 5, 0 10
force {enable_erase} 0 0, 1 30
force {stop_true} 0 0, 1 15, 0 20
force {done_load} 0 0, 1 25
force {done_plot} 0 0, 1 10, 0 30, 1 35

# Run simulation for a few ns.
run 37ns

