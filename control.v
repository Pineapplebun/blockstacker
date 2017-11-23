module control(
		input clk,
		input resetn,
		input enable_erase,
		input done_plot,
		input stop,
		output reg reset_counter, enable_counter,
		output reg ld_x, ld_y,
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
				UPDATE = 4'd6,
				CHECK = 4'd7;

		// Next state logic aka our state table
    always@(*)
    begin: state_table
        case (current_state)

				// RESET WHEN KEY[0] HAS BEEN PRESSED
        RESET: next_state = !resetn? RESET_WAIT : RESET;
        RESET_WAIT: next_state = !resetn ? RESET_WAIT : PLOT;

				// LOOP FROM PLOT TO ERASE TO UPDATE TO PLOT
        PLOT: next_state = done_plot ? RESET_COUNTER : PLOT;
				RESET_COUNTER : next_state = COUNT;
				// DELAY ERASE USING COUNT
				COUNT: next_state = enable_erase ? CHECK : COUNT;
				// STOP = 1'B1 IF A STOP BUTTON IS PRESSED
				CHECK: next_state = stop ? UPDATE : ERASE;
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
										colour_erase_enable = 1'b0;
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
            current_state <= RESET;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

