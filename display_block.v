// Part 2 skeleton

module display_block
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		  LEDR,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	output   [9:0]   LEDR;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour_load;
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(~resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION = "160x120";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "black.mif";

	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

	// SET RESET BUTTON
	wire resetn;
	assign resetn = ~KEY[0];

	// SET START BUTTON
	wire start;
	assign start = ~KEY[1];

	// STOP_TRUE
	wire stop_true;
	assign stop_true = ~KEY[2];

	// DECLARE X,Y WIRES
	wire [7:0] x_load;
	wire [6:0] y_load;
	wire ld_x, ld_y;

	// DECLARE WIRES FOR DRAW/ERASE
	wire enable_frame, enable_erase, enable_counter, colour_erase_enable, count_x_enable;
	wire done_plot;

	wire reset_counter, reset_load;

	// DATAPATH OF SENDING LOCATION TO VGA
	// NOTE THAT COLOUR NEEDS TO BE LOADED
	// DEPENDING ON DRAW OR ERASE SO WE MAKE
	// A WIRE COLOUR_LOAD THAT IS MODIFIED BY MODULE LOAD
	datapath d0(
				.clk(CLOCK_50),
				.resetn(resetn),
				.count_x_enable(count_x_enable),
				.x(x_load),
				.y(y_load),
				.colour(colour_load),
				.x_out(x),
				.y_out(y),
				.colour_out(colour),
				.done_plot(done_plot),
				.out_block_start(curr_block_start),
				.out_block_end(curr_block_end)
				);


   // FSM CONTROL OF DRAWING
	control c0(
			.LEDR(LEDR[9:0]),
			.clk(CLOCK_50),
			.start(start),
			.resetn(resetn),
			.enable_erase(enable_erase),
			.done_plot(done_plot),
			.stop_true(stop_true),
			.ld_x(ld_x),
			.ld_y(ld_y),
			.reset_counter(reset_counter),
			.enable_counter(enable_counter),
			.writeEn(writeEn),
			.colour_erase_enable(colour_erase_enable),
			.reset_load(reset_load),
			.count_x_enable(count_x_enable),
			.done_load(done_load)
			);

	// HARD SET THE COLOUR
	wire [2:0] block_colour = 3'b111;
	// LOAD MODIFIES THE X,Y COORDINATES
	// THE CLOCK IS THE POINT WHEN ENABLE
	// ERASE IS HIGH SINCE WE WANT TO MOVE
	// THE X,Y COORDS AFTER AN ERASURE
	// IE. IF ENABLE_ERASE OCCURS 1 PER 60 FRAMES
	// DRAW A BLACK BOX AT CURRENT X,Y TO ERASE
	// AND CHANGE X,Y TO BE SOMEWHERE ELSE
	load l0(
			.clk(enable_erase),
			.reset_load(reset_load),
			.colour_in(block_colour),
			.colour_erase_enable(colour_erase_enable),
			.ld_x(ld_x),
			.ld_y(ld_y),
			.curr_level(curr_level),
			.x(x_load),
			.y(y_load),
			.colour(colour_load),
			.done_load(done_load)
			);

  wire done_load;

	// COUNTS HOW LONG TO WAIT BEFORE A FRAME
	// SPEED CHANGES THIS DELAY
	// ENABLE_FRAME IS OUTPUT 60 TIMES PER SECOND
	// SO THAT WE HAVE 60 FPS
	wire [31:0] fps_count = 833332;
	delay_counter dc(
			.enable(enable_counter),
			.clk(CLOCK_50),
			.reset_delay_counter(reset_counter),
			.enable_frame(enable_frame),
			.fps_count(fps_count)
			);

	// COUNTS HOW MANY FRAMES BEFORE ERASING
	// ENABLE_ERASE IS OUTPUT 60/SPEED_COUNT TIMES PER SECOND
	//
	// LEVEL 1
	// WE NEED 1 ERASE/60 FRAMES : 60 FRAMES TO DRAW
	// A WHITE BOX, 1 FRAME TO ERASE A WHITE BOX
	// SET SPEED_COUNT = 60
	//
	// LEVEL 2
	// 1 ERASE / 30 FRAMES
	// SET SPEED_COUNT = 30
	frame_counter f0(
			.enable(enable_frame),
			.clk(CLOCK_50),
			.reset_frame_counter(reset_counter),
			.enable_out(enable_erase),
			.speed_count(speed_count)
			);

	// wire for speed and num_blocks
	// OUTPUT LEVEL NUMBER TO LOAD MODULE
	// VIA CURR_LEVEL WIRE
	wire [10:0] speed_count;
	wire [5:0] curr_level;
	vertical_modifier v0(
			.clk(CLOCK_50),
			.go(stop_true),
			.resetn(resetn),
			.next_signal(level_up_true),
			.speed_count(speed_count),
			.num_blocks(num_blocks),
			.curr_level(curr_level)
			);

	// UPDATES THE PREV BLOCK WHEN STOP IS PRESSED

	block_tracker bt(
			.clk(CLOCK_50),
			.resetn(resetn),
			.stop_true(stop_true),
			.prev_block_start(prev_block_start),
			.prev_block_end(prev_block_end),
			.curr_block_start(curr_block_start),
			.curr_block_end(curr_block_end),
			.prev_block_size(prev_num_blocks),
			.curr_block_size(num_blocks),
			.intersect_true(level_up_true)
			);

	wire [3:0] prev_num_blocks;
	wire [8:0] prev_block_start;
	wire [8:0] prev_block_end;
	wire [3:0] num_blocks;
	wire [8:0] curr_block_start;
	wire [8:0] curr_block_end;
	wire level_up_true;
	// This module outputs the next_signal for the vertical modifier
	// when the player has pressed the stop button
	find_intersection fi(
			.clk(CLOCK_50),
			.resetn(resetn),
			.stop_true(stop_true),
			.prev_block_start(prev_block_start),
			.prev_block_end(prev_block_end),
			.curr_block_start(curr_block_start),
			.curr_block_end(curr_block_end),
			.prev_block_size(prev_num_blocks),
			.curr_block_size(num_blocks),
			.intersect_true(level_up_true)
			);


endmodule
