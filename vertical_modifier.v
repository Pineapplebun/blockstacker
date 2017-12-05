module vertical_modifier(
    input clk,
	 input go,
    input resetn,
    input next_signal,
	 output reg [10:0] speed_count,
	 output reg [3:0] num_blocks,
	 output reg [5:0] curr_level
    );

    reg [6:0] current_state, next_state;

    localparam
	   LEVEL1_WAIT = 6'd0,
		LEVEL1a = 6'd1,
		LEVEL1 = 6'd2,
		LEVEL2_WAIT = 6'd3,
		LEVEL2a = 6'd4,
		LEVEL2 = 6'd5,
		LEVEL3_WAIT = 6'd6,
		LEVEL3a = 6'd7,
		LEVEL3 = 6'd8,
		LEVEL4_WAIT = 6'd9,
		LEVEL4a = 6'd10,
		LEVEL4 = 6'd11,
		LEVEL5_WAIT = 6'd12,
		LEVEL5a = 6'd13,
		LEVEL5 = 6'd14,
		LEVEL6_WAIT = 6'd15,
		LEVEL6a = 6'd16,
		LEVEL6 = 6'd17,
		LEVEL7_WAIT = 6'd18,
		LEVEL7a = 6'd19,
		LEVEL7 = 6'd20,
		LEVEL8_WAIT = 6'd21,
		 LEVEL8a = 6'd22,
		 LEVEL8 = 6'd23,
		 LEVEL9_WAIT = 6'd24,
		 LEVEL9a = 6'd25,
		 LEVEL9 = 6'd26,
		 LEVEL10_WAIT = 6'd27,
		 LEVEL10a = 6'd28,
		 LEVEL10 = 6'd30,
		 LEVEL11_WAIT = 6'd31,
		 LEVEL11a = 6'd32,
		 LEVEL11 = 6'd33,
		 LEVEL12_WAIT = 6'd34,
		 LEVEL12a = 6'd35,
		 LEVEL12 = 6'd36,
		 LEVEL13_WAIT = 6'd37,
		 LEVEL13a = 6'd38,
		 LEVEL13 = 6'd39,
		 LEVEL14_WAIT = 6'D40,
		 LEVEL14a = 6'd41,
		 LEVEL14 = 6'd42,
		 LEVEL15_WAIT = 6'd43,
		 LEVEL15a = 6'd44,
		 LEVEL15 = 6'd45;

    always@(*)
    begin: level_table
        case (current_state)
		  LEVEL1_WAIT: next_state = go ? LEVEL1 : LEVEL1_WAIT;
		  LEVEL1a: next_state = go ? LEVEL1a : LEVEL1;
        LEVEL1: next_state = next_signal ? LEVEL2_WAIT : LEVEL1_WAIT;

		  LEVEL2_WAIT: next_state = go ? LEVEL2 : LEVEL2_WAIT;
		  LEVEL2a: next_state = go ? LEVEL2a : LEVEL2;
        LEVEL2: next_state = next_signal ? LEVEL3_WAIT : LEVEL1_WAIT;

		  LEVEL3_WAIT: next_state = go ? LEVEL4 : LEVEL3_WAIT;
		  LEVEL3a: next_state = go ? LEVEL3a : LEVEL3;
        LEVEL3: next_state = next_signal ? LEVEL4_WAIT : LEVEL1_WAIT;

		  LEVEL4_WAIT: next_state = go ? LEVEL5 : LEVEL4_WAIT;
		  LEVEL4a: next_state = go ? LEVEL4a : LEVEL4;
        LEVEL4: next_state = next_signal ? LEVEL5_WAIT : LEVEL1_WAIT;

		  LEVEL5_WAIT: next_state = go ? LEVEL6 : LEVEL5_WAIT;
		  LEVEL5a: next_state = go ? LEVEL5a : LEVEL5;
        LEVEL5: next_state = next_signal ? LEVEL6_WAIT : LEVEL1_WAIT;

		  LEVEL6_WAIT: next_state = go ? LEVEL6 : LEVEL6_WAIT;
		  LEVEL6a: next_state = go ? LEVEL6a : LEVEL6;
        LEVEL6: next_state = next_signal ? LEVEL7_WAIT : LEVEL1_WAIT;

		  LEVEL7_WAIT: next_state = go ? LEVEL7 : LEVEL7_WAIT;
		  LEVEL7a: next_state = go ? LEVEL7a : LEVEL7;
        LEVEL7: next_state = next_signal ? LEVEL8_WAIT : LEVEL1_WAIT;

		  LEVEL8_WAIT: next_state = go ? LEVEL8 : LEVEL8_WAIT;
		  LEVEL8a: next_state = go ? LEVEL8a : LEVEL8;
        LEVEL8: next_state = next_signal ? LEVEL9_WAIT : LEVEL1_WAIT;

		  LEVEL9_WAIT: next_state = go ? LEVEL9 : LEVEL9_WAIT;
		  LEVEL9a: next_state = go ? LEVEL9a : LEVEL9;
        LEVEL9: next_state = next_signal ? LEVEL10_WAIT : LEVEL1_WAIT;

		  LEVEL10_WAIT: next_state = go ? LEVEL10 : LEVEL10_WAIT;
		  LEVEL10a: next_state = go ? LEVEL10a : LEVEL10;
        LEVEL10: next_state = next_signal ? LEVEL11_WAIT : LEVEL1_WAIT;

		  LEVEL11_WAIT: next_state = go ? LEVEL11 : LEVEL11_WAIT;
		  LEVEL11a: next_state = go ? LEVEL11a : LEVEL11;
        LEVEL11: next_state = next_signal ? LEVEL12_WAIT : LEVEL1_WAIT;

		  LEVEL12_WAIT: next_state = go ? LEVEL12 : LEVEL12_WAIT;
		  LEVEL12a: next_state = go ? LEVEL12a : LEVEL12;
        LEVEL12: next_state = next_signal ? LEVEL13_WAIT : LEVEL1_WAIT;

		  LEVEL13_WAIT: next_state = go ? LEVEL13 : LEVEL13_WAIT;
		  LEVEL13a: next_state = go ? LEVEL13a : LEVEL13;
        LEVEL13: next_state = next_signal ? LEVEL14_WAIT : LEVEL1_WAIT;

		  LEVEL14_WAIT: next_state = go ? LEVEL14 : LEVEL14_WAIT;
		  LEVEL14a: next_state = go ? LEVEL14a : LEVEL14;
        LEVEL14: next_state = next_signal ? LEVEL15_WAIT : LEVEL1_WAIT;

		  LEVEL15_WAIT: next_state = go ? LEVEL15 : LEVEL15_WAIT;
		  LEVEL15a: next_state = go ? LEVEL15a : LEVEL15;
        LEVEL15: next_state = LEVEL1_WAIT;//level15 is the max level. after that the game restarts
        default: next_state = LEVEL1_WAIT;
        endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 1
			speed_count = 11'd60;
			num_blocks = 4'b0001;
		   curr_level = 6'd1;
        case (current_state)

        LEVEL1_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd1; end// 1 FRAME PER SECOND
        LEVEL2_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd2;end// 2 FRAME PER SECOND
        LEVEL3_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd3;end//
        LEVEL4_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd4;end//
        LEVEL5_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd5;end//
        LEVEL6_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd6;end//
        LEVEL7_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd7;end//
        LEVEL8_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd8;end//
        LEVEL9_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd9;end//
        LEVEL10_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd10;end//
        LEVEL11_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd11;end//
        LEVEL12_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd12;end//
        LEVEL13_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd13;end//
        LEVEL14_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd14;end//
        LEVEL15_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd15;end//

	LEVEL1: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd1;end// 1 FRAME PER SECOND
        LEVEL2: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd2;end// 2 FRAME PER SECOND
        LEVEL3 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd3;end//
        LEVEL4 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd4;end//
        LEVEL5 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd5;end//
        LEVEL6 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd6;end//
        LEVEL7 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd7;end//
        LEVEL8 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd8;end//
        LEVEL9 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd9;end//
        LEVEL10 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd10;end//
        LEVEL11 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd11;end//
        LEVEL12 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd12;end//
        LEVEL13 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd13;end//
        LEVEL14 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd14;end//
        LEVEL15 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd15;end//
        
        LEVEL1a: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 1;end// 1 FRAME PER SECOND
        LEVEL2a: begin speed_count = 11'd30; num_blocks = 4'b0001; curr_level = 2;end// 2 FRAME PER SECOND
        LEVEL3a : begin speed_count = 11'd3; num_blocks = 4'b0001; curr_level = 3;end//
        LEVEL4a : begin speed_count = 11'd4; num_blocks = 4'b0001; curr_level = 4;end//
        LEVEL5a : begin speed_count = 11'd5; num_blocks = 4'b0001; curr_level = 5;end//
        LEVEL6a : begin speed_count = 11'd6; num_blocks = 4'b0001; curr_level = 6;end//
        LEVEL7a : begin speed_count = 11'd7; num_blocks = 4'b0001; curr_level = 7;end//
        LEVEL8a : begin speed_count = 11'd8; num_blocks = 4'b0001; curr_level = 8;end//
        LEVEL9a : begin speed_count = 11'd9; num_blocks = 4'b0001; curr_level = 9;end//
        LEVEL10a : begin speed_count = 11'd10; num_blocks = 4'b0001; curr_level = 10;end//
        LEVEL11a : begin speed_count = 11'd11; num_blocks = 4'b0001; curr_level = 11;end//
        LEVEL12a : begin speed_count = 11'd12; num_blocks = 4'b0001; curr_level = 12;end//
        LEVEL13a : begin speed_count = 11'd13; num_blocks = 4'b0001; curr_level = 13;end//
        LEVEL14a : begin speed_count = 11'd14; num_blocks = 4'b0001; curr_level = 14;end//
        LEVEL15a : begin speed_count = 11'd15; num_blocks = 4'b0001; curr_level = 15;end//
        endcase        
        endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn)
            current_state <= LEVEL1_WAIT;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

