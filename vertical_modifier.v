module vertical_modifier(
    input clk,
    input resetn,
	input enable_erase,
	input done_plot,
    input next_signal,

    output reg ld_x, ld_y, ld_colour,
		output reg writeEn,
		output reg colour_erase_enable,
		output reg reset_load,
		output reg count_x_enable
    );

    reg [3:0] current_state, next_state;

    localparam
				LEVEL1 = 4'd0,
				LEVEL2 = 4'd1,
				LEVEL3 = 4'd2,
				LEVEL4 = 4'd3,
				LEVEL5 = 4'd4,
				LEVEL6 = 4'd5,
				LEVEL7 = 4'd6;
                LEVEL8 = 4'd7;
                LEVEL9 = 4'd8;
                LEVEL10 = 4'd9;
                LEVEL11 = 4'd10;
                LEVEL12 = 4'd11;
                LEVEL13 = 4'd12;
                LEVEL14 = 4'd13;
                LEVEL15 = 4'd14;

    always@(*)
    begin: level_table
        case (current_state)
        LEVEL1: next_state = next_signal ? LEVEL2 : LEVEL1;
        LEVEL2: next_state = next_signal ? LEVEL3 : LEVEL1;
        LEVEL3: next_state = next_signal ? LEVEL4 : LEVEL1;
        LEVEL4: next_state = next_signal ? LEVEL5 : LEVEL1;
        LEVEL5: next_state = next_signal ? LEVEL6 : LEVEL1;
        LEVEL6: next_state = next_signal ? LEVEL7 : LEVEL1;
        LEVEL7: next_state = next_signal ? LEVEL8 : LEVEL1;
        LEVEL8: next_state = next_signal ? LEVEL9 : LEVEL1;
        LEVEL9: next_state = next_signal ? LEVEL10 : LEVEL1;
        LEVEL10: next_state = next_signal ? LEVEL11 : LEVEL1;
        LEVEL11: next_state = next_signal ? LEVEL12 : LEVEL1;
        LEVEL12: next_state = next_signal ? LEVEL13 : LEVEL1;
        LEVEL13: next_state = next_signal ? LEVEL14 : LEVEL1;
        LEVEL14: next_state = next_signal ? LEVEL15 : LEVEL1;
        LEVEL15: next_state = LEVEL1; //level15 is the max level. after that the game restarts
        default: next_state = LEVEL1
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
        LEVEL1: //
        LEVEL2: //
        LEVEL3: //
        LEVEL4: //
        LEVEL5: //
        LEVEL6://
        LEVEL7: //
        LEVEL8: //
        LEVEL9://
        LEVEL10://
        LEVEL11: //
        LEVEL12://
        LEVEL13: //
        LEVEL14: //
        LEVEL15://
        endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= LEVEL1;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
