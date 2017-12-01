module control(
		output reg [9:0] LEDR,
		input clk,
		input start,
		input resetn,
		input enable_erase,
		input done_plot,
		input stop_true,
		output reg reset_counter, enable_counter,
		output reg ld_x, ld_y,
		output reg writeEn,
		output reg colour_erase_enable,
		output reg reset_load,
		output reg count_x_enable,
		input done_load
		);

    reg [3:0] current_state, next_state;

    localparam
				RESET = 4'd0,
				RESET_WAIT = 4'd1,
				PLOT = 4'd2,
				RESET_COUNTER = 4'd3,
				COUNT = 4'd4,
				ERASE = 4'd5,
				UPDATE = 4'd6,
				CHECK = 4'd7,
				CHECK_WAIT = 4'd8;

		// Next state logic aka our state table
    always@(*)
    begin: state_table
        case (current_state)

				RESET: next_state = start ? RESET_WAIT : RESET;
				RESET_WAIT: next_state = start ? RESET_WAIT : PLOT;

				PLOT: next_state = done_plot ? RESET_COUNTER : PLOT;
				RESET_COUNTER : next_state = COUNT;


				COUNT: next_state = (stop_true || enable_erase) ? CHECK : COUNT;

				CHECK: next_state = stop_true ? CHECK_WAIT : ERASE;

				CHECK_WAIT: next_state = !stop_true ? UPDATE : CHECK_WAIT;

				ERASE: next_state = done_plot ? UPDATE : ERASE;

				UPDATE: next_state = done_load ? PLOT : UPDATE;

        endcase
    end // state_table


    // Output logic aka all of our datapath control signals
    always @(*) // detect when current_state changes
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
			LEDR[9:0] = 10'd0;

        case (current_state)
						RESET:
								begin
								reset_counter = 1'b0;
								reset_load = 1'b0; //only occurs in reset
								LEDR[0] = 1'b1;
								end
						RESET_WAIT:
								begin
								LEDR[1] = 1'b1;
								end
						PLOT:
								begin
								count_x_enable = 1'b1;
								writeEn = 1'b1;
								LEDR[2] = 1'b1;
								end
						RESET_COUNTER:
								begin
								reset_counter = 1'b0;
								LEDR[3] = 1'b1;
								end
						COUNT:
								begin
								enable_counter = 1'b1;
								LEDR[4] = 1'b1;
								end
						CHECK:
								begin
								LEDR[5] = 1'b1;
								end
						CHECK_WAIT:
								begin
								LEDR[6] = 1'b1;
								end
						ERASE:
								begin
								colour_erase_enable = 1'b1;
								count_x_enable = 1'b1;
								writeEn = 1'b1; // this plots it immediately
								LEDR[7] = 1'b1;
								end
						UPDATE:
								begin
								// SET LD_X, LD_Y SO THAT WE START
								// THE LOAD MODULE WHICH UPDATES THE
								// X,Y GOING INTO DATAPATH
								ld_x = 1'b1;
								ld_y = 1'b1;
								LEDR[8] = 1'b1;
								end

        endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn)
            current_state <= RESET;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
