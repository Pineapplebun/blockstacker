// Part 2 skeleton

module display_block
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
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
			.resetn(resetn),
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
	assign resetn = KEY[0];

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
				.done_plot(done_plot)
				);
	
	// STOP WIRE IS UPDATED BY MODULE CHECK_STOP_BUTTON
	wire stop;
  // FSM CONTROL OF DRAWING
	control c0(
			.clk(CLOCK_50),
			.resetn(resetn),
			.enable_erase(enable_erase),
			.done_plot(done_plot),
			.stop(stop),
			.ld_x(ld_x),
			.ld_y(ld_y),
			.reset_counter(reset_counter),
			.enable_counter(enable_counter),
			.writeEn(writeEn),
			.colour_erase_enable(colour_erase_enable),
			.reset_load(reset_load),
			.count_x_enable(count_x_enable)
			);

	// HARD SET THE COLOUR
	wire [2:0] block_colour = 3'b111;
	// DECLARE THE LEVEL UP WIRE
	// THIS WIRE NEEDS TO BE MODIFIED BY ANOTHER FSM
	wire vertical;
	// MODIFIES THE X,Y COORDINATES
	load l0(
			.clk(CLOCK_50),
			.reset(reset_load),
			.colour_in(block_colour),
			.colour_erase_enable(colour_erase_enable),
			.ld_x(ld_x),
			.ld_y(ld_y),
			.vertical(vertical),
			.x(x_load),
			.y(y_load),
			.colour(colour_load)
			);

	// COUNTS HOW LONG TO WAIT BEFORE A FRAME
	delay_counter dc(
			.enable(enable_counter),
			.clk(CLOCK_50),
			.resetn(reset_counter),
			.enable_frame(enable_frame)
			);

	// COUNTS HOW MANY FRAMES BEFORE ERASING
	frame_counter f0(
			.enable(enable_frame),
			.clk(CLOCK_50),
			.resetn(reset_counter),
			.enable_out(enable_erase)
			);

endmodule