module vertical_modifier(
    input clk,
    input resetn,
    input next_signal,
	 output reg speed,
	 output reg num_blocks
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
        // By default make all our signals 1
			speed = 1 num_blocks = 1
        case (current_state)
        LEVEL1: begin speed = 1 num_blocks = 1 //
        LEVEL2: begin speed = 2 num_blocks = 1 //
        LEVEL3: begin speed = 3 num_blocks = 1 //
        LEVEL4: begin speed = 4 num_blocks = 1 //
        LEVEL5: begin speed = 5 num_blocks = 1 //
        LEVEL6: begin speed = 6 num_blocks = 1 //
        LEVEL7: begin speed = 7 num_blocks = 1 //
        LEVEL8: begin speed = 8 num_blocks = 1 //
        LEVEL9: begin speed = 9 num_blocks = 1 //
        LEVEL10: begin speed = 10 num_blocks = 1 //
        LEVEL11: begin speed = 11 num_blocks = 1 //
        LEVEL12: begin speed = 12 num_blocks = 1 //
        LEVEL13: begin speed = 13 num_blocks = 1 //
        LEVEL14: begin speed = 14 num_blocks = 1 //
        LEVEL15: begin speed = 15 num_blocks = 1 //
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
