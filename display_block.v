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

	// DECLARE THE LEVEL UP WIRE
	// THIS WIRE NEEDS TO BE MODIFIED BY ANOTHER FSM
	wire vertical;

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
				.colour_out(colour)
				.done_plot(done_plot)
				);

  // FSM CONTROL OF DRAWING
	control c0(
			.clk(CLOCK_50),
			.resetn(resetn),
			.enable_erase(enable_erase),
			.done_plot(done_plot),
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
	wire [2:0] block_colour = 3'b111

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

module control(
    input clk,
    input resetn,
		input enable_erase,
		input done_plot,

    output reg ld_x, ld_y, ld_colour,
		output reg writeEn,
		output reg colour_erase_enable,
		output reg reset_load,
		output reg count_x_enable
    );

    reg [2:0] current_state, next_state;

    localparam
				RESET = 4'd0,
				RESET_WAIT = 4'd1,
				PLOT = 4'd2,
				RESET_COUNTER = 4'd3,
				COUNT = 4'd4,
				ERASE = 4'd5,
				UPDATE = 4'd6;

		// Next state logic aka our state table
    always@(*)
    begin: state_table
        case (current_state)

				// RESET WHEN KEY[1] HAS BEEN PRESSED
        RESET: next_state = go ? RESET_WAIT : RESET;
        RESET_WAIT: next_state = go ? RESET_WAIT : PLOT;

				// LOOP FROM PLOT TO ERASE TO UPDATE TO PLOT
        PLOT: next_state = done_plot ? RESET_COUNTER : PLOT;
				RESET_COUNTER : next_state = COUNT;
				// DELAY ERASE USING COUNT
				COUNT: next_state = enable_erase ? ERASE : COUNT;
        ERASE: next_state = done_plot ? UPDATE : ERASE;
				UPDATE: next_state = PLOT;

        default: next_state = RESET;
        endcase
    end // state_table


    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
				ld_x = 1'b0;
				ld_y = 1'b0;
				writeEn = 1'b0;
				reset_counter = 1'b1;
				reset_load = 1'b1;
				enable_counter = 1'b0;
				colour_erase_enable = 1'b0;
				count_x_enable = 1'b0;

        case (current_state)
						RESET:
								begin
										reset_counter = 1'b0;
										reset_load = 1'b0;
								end
						PLOT:
								begin
										count_x_enable = 1'b1;
										writeEn = 1'b1;
								end
						RESET_COUNTER:
								reset_counter = 1'b0;
						COUNT:
								enable_counter = 1'b1;
						ERASE:
								begin
										colour_erase_enable = 1'b1;
										count_x_enable = 1'b1;
										writeEn = 1'b1;
								end
						UPDATE:
								begin
										// SET LD_X, LD_Y SO THAT WE START
										// THE LOAD MODULE WHICH UPDATES THE
										// X,Y GOING INTO DATAPATH
										ld_x = 1'b1;
										ld_y = 1'b1;
								end
        endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_X;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module delay_counter(enable, clk, resetn, enable_frame);
	  input enable, clk, resetn;
      output enable_frame;
	  reg [22:0] counter;

	  assign enable_frame = (counter == 0) ? 1 : 0;

	  always @(posedge clk)
	  begin
	       if (!resetn)
			      counter <= 833332;
			  else if (enable == 1'b1)
			  begin
					if (counter == 22'd0)
						counter <= 833332;
					else
						counter <= counter - 1'b1;
				end
	  end
endmodule

module frame_counter(enable, clk, resetn, enable_out);
		input enable, clk, resetn;
		output enable_out;

		reg [3:0] frames;

		// When 15 frames reached, set enable_out to be 1
		// So that we start erasing
		assign enable_out= (frames == 4'b1111) ? 1 : 0;

		always @ (posedge clk)
				begin
						if (!resetn)
							frames <= 0;
						else if (enable == 1'b1)
						begin
							if (frames == 4'b1111)
								frames <= 0;
							else
							frames <= frames + 1;
						end
				end
endmodule

// LOADS THE NEW X,Y COORDINATES TO THE DATAPATH
module load(clk, reset, colour_in, colour_erase_enable, ld_x, ld_y, vertical, x, y, colour);
		input clk, reset;
		input [2:0] colour_in;
		input colour_erase_enable;
		input ld_x, ld_y, vertical;
		output reg [7:0] x;
		output reg [6:0] y;
		output reg [2:0] colour;

		reg horizontal;

		always @ (posedge clk)
				begin
	      if (!reset)
						begin
			        	x <= 8'd0;
			        	y <= 115;
								vertical <= 1'b0; // down
								horizontal <= 1'b1; // right
	        	end
	      else
						begin
	        	if (ld_x)
								begin
								if (horizontal)
										begin
										if (x == 156)
												begin
												horizontal <= 1'b0;
												x <= x - 4;
												end
										else
												x <= x + 4;
										end
								else
										begin
										if (x == 0)
												begin
												horizontal <= 1'b1;
												x <= x + 4;
												end
										else
												x <= x - 4;
										end
								end
	          if (ld_y) begin
								// ONLY CHANGE Y IF LEVEL HAS COMPLETED
	              if (vertical) begin
										y <= y - 4;
										vertical <= 1'b0
								end
	         	end
	  		end

		always @(*)
				begin
						if (colour_erase_enable)
							colour = 3'b000;
						else
							colour = colour_in;
				end
endmodule

module datapath(
    input clk,
    input resetn,
		input count_x_enable,
		input [7:0] x,
    input [6:0] y,
    input [2:0] colour,
    output [7:0] x_out,
    output [6:0] y_out,
    output [2:0] colour_out,
		output reg done_plot
    );

    // input registers
    reg [7:0] x;
		reg[6:0] y;
		reg[2:0] colour;

    reg [1:0] count_x, count_y;

		wire enable_y;

		// counter for x
		always @(posedge clk) begin
			if (!resetn)
				count_x <= 2'b00;
			else if (count_x_enable)
				count_x <= count_x + 1'b1;
		end

		// enable y to increase 1 after 4 increases in count_x
		assign enable_y = (count_x == 2'b11) ? 1 : 0;

		// counter for y
		always @(posedge clk) begin
			if (!resetn)
				count_y <= 2'b00;
			else if (enable_y)
				count_y <= count_y + 1'b1;
		end

		// SET PLOT TO BE DONE AFTER COUNTING ALL
		// THE PIXELS OF THE SQUARE
		always @(*)
		begin
		if (count_x == 2'b11 && count_y == 2'b11)
			done_plot = 1'b1;
		else
			done_plot = 1'b0;
		end

		assign x_out = x + count_x;
		assign y_out = y + count_y;
		assign colour_out = colour;

endmodule
